function updated_lane = update_lane(lane, lane_index, road, road_length, emergency_flag)
    probslow=0.3; % 随机减速的概率
    probchange=0.2; % 随机变道
    safelen=10; % 后车的安全距离 需要加上当前车的长度
    % disp(lane)
    fn_temp = fieldnames(lane); %结构体的字段名，每个都一样的先随便取一个 为什么road{1}(1)就不行
 
    if isempty(lane)
        updated_lane = lane;
        return;
    end
    %disp(["land_id:",lane(1).lane,"lane_index:",lane_index])

    car_num = length(lane);
    % 更新每辆车的状态
    i = 1;  % 使用索引循环，以便在循环过程中移除车辆
    while i <= car_num
        % disp(i);disp(length(lane));disp(car_num);
        if i == 1 || i == car_num
            front_vehicle = [];
        else
            front_vehicle = lane(i+1); % 当前车道的前车
        end

        % 防撞减速
        if front_vehicle.position - lane(i).position < lane(i).speed + lane(i).length
            lane(i).speed = min(lane(i).speed, front_vehicle.position - lane(i).position - lane(i).length);   
        % 不撞就看能不能加速
        elseif isempty(front_vehicle) || front_vehicle.position - lane(i).position >= lane(i).speed + lane(i).length
            lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
        % 不能加速就变道 未满足期望最大速度 就考虑是否变道
        elseif lane(i).speed~=lane(i).max_speed
            % 第一道
            if lane(i).lane == 1
                % 右道中前后车的位置
                position_list = [road{lane_index+1}.position];
                front_otherlane = min(position_list(position_list > lane(i).position));
                back_otherlane = max(position_list(position_list < lane(i).position));
    %             disp("now position:");disp(lane(i).position);
    %             disp("other lane position: ");disp([road{lane_index+1}.position]);
    %             disp("other lane front position: ");disp(front_otherlane);
    %             disp("other lane back position: ");disp(back_otherlane);
                
                % 判断能否变道
%                 disp("position info :")
%                 disp(front_otherlane - lane(i).position)
%                 disp(lane(i).speed + 5)
                if front_otherlane - lane(i).position >= lane(i).speed + lane(i).length && lane(i).position - back_otherlane >= safelen
                    lane(i).lane = lane(i).lane + 1; 
                    lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                    road{lane_index+1}(end+1) = lane(i);
                    % 重新排序
                    [~, idx] = sort([road{lane_index+1}.position]);
                    road{lane_index+1} = road{lane_index+1}(idx);
                    lane(i) = [];
                    car_num = car_num-1;
                    continue; 
                else % 不能变道就再跟前车
                    lane(i).speed = front_vehicle.speed; 
                end
            % 第二道
            elseif lane(i).lane == 2
                % 左道中前后车的位置
                position_list = [road{lane_index-1}.position];
                front_otherlane = min(position_list(position_list > lane(i).position));
                back_otherlane = max(position_list(position_list < lane(i).position));
                % 能变道
                if front_otherlane - lane(i).position >= lane(i).speed + lane(i).length && lane(i).position - back_otherlane >= safelen
                    lane(i).lane = lane(i).lane - 1; 
                    lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                    road{lane_index-1}(end+1) = lane(i);
                    % 重新排序
                    [~, idx] = sort([road{lane_index-1}.position]);
                    road{lane_index-1} = road{lane_index-1}(idx);
                    lane(i) = [];
                    car_num = car_num-1;
                    continue; 
                else % 不能变道就再跟前车
                    lane(i).speed = front_vehicle.speed; 
                end
            end
        % 其他情况就跟车
        else
            lane(i).speed = front_vehicle.speed; 
        end

        % 根据每秒的密度和流量调整慢化概率
        % probslow = min(1, density_data(i) / 100);  % 拥堵时慢化概率高
        % 随机减速
        if rand < probslow
            lane(i).speed=max(lane(i).speed-1,0);
        end

        %% 开启第3车道后  未满足期望最大速度 就考虑是否变道
        if emergency_flag==1
            if lane(i).speed~=lane(i).max_speed
                % 第二道
            if all(lane(i).lane == 2) && all(lane_index == 2) % 有的地方可能更改lane了但是当前没有清除就导致识别有问题
                % 左道中前后车的位置
%                 disp("error");
%                 disp(lane_index);disp(lane(i));
                position_list_left = [road{lane_index-1}.position];
                front_otherlane_left = min(position_list_left(position_list_left > lane(i).position));
                back_otherlane_left = max(position_list_left(position_list_left < lane(i).position));
                if emergency_flag==1 % 现在是枚举遍历，比较机械和慢速，后面有空再改吧，现在先跑通再说
                    % 如果右侧有车在这样算 如果没车就直接转
                    if ~isempty(road{lane_index+1})
                        % 右道中前后车的位置
                        position_list_right = [road{lane_index+1}.position];
                        front_otherlane_right = min(position_list_right(position_list_right > lane(i).position));
                        back_otherlane_right = max(position_list_right(position_list_right < lane(i).position));
                        % 先看安全条件
                        % 安全条件都满足，选择换哪一边
                        if all(lane(i).position - back_otherlane_left >= safelen) && all(lane(i).position - back_otherlane_right >= safelen)
                            % 右边空位大去右道
                            if front_otherlane_right > front_otherlane_left
                                % 满足速度要求
                                if front_otherlane_right - lane(i).position >= lane(i).speed + lane(i).length
                                    lane(i).lane = lane(i).lane + 1; 
                                    lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                                    % 结构体赋值
                                    for i = 1 : length(fn_temp)
                                        eval(['road{lane_index+1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                                    end
                                    %disp(["id: ",lane(i).id,"changed lane!!"]);
                                    % road{lane_index+1}(end+1) = lane(i);
                                    % 重新排序
                                    [~, idx] = sort([road{lane_index+1}.position]);
                                    road{lane_index+1} = road{lane_index+1}(idx);
                                    lane(i) = [];
                                    car_num = car_num-1;
                                    continue; 
                                end
                            %左边空位大去左道   
                            elseif front_otherlane_right < front_otherlane_left
                                % 满足速度要求
                                if front_otherlane_left - lane(i).position >= lane(i).speed + lane(i).length
                                    lane(i).lane = lane(i).lane - 1; 
                                    lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                                    % 结构体赋值
                                    for i = 1 : length(fn_temp)
                                        eval(['road{lane_index-1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                                    end
                                    %disp(["id: ",lane(i).id,"changed lane!!!"]);
                                    % road{lane_index-1}(end+1) = lane(i);
                                    % 重新排序
                                    [~, idx] = sort([road{lane_index-1}.position]);
                                    road{lane_index-1} = road{lane_index-1}(idx);
                                    lane(i) = [];
                                    car_num = car_num-1;
                                    continue; 
                                end
                            end
                        % 左车道满足安全条件
                        elseif lane(i).position - back_otherlane_left >= safelen
                            % 满足速度要求
                            if front_otherlane_left - lane(i).position >= lane(i).speed + lane(i).length
                                lane(i).lane = lane(i).lane - 1; 
                                lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                                % 结构体赋值
                                for i = 1 : length(fn_temp)
                                    eval(['road{lane_index-1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                                end
                                %disp(["id: ",lane(i).id,"changed lane!!!!"]);
                                % road{lane_index-1}(end+1) = lane(i);
                                % 重新排序
                                [~, idx] = sort([road{lane_index-1}.position]);
                                road{lane_index-1} = road{lane_index-1}(idx);
                                lane(i) = [];
                                car_num = car_num-1;
                                continue; 
                            end
                        % 右车道满足安全条件
                        elseif lane(i).position - back_otherlane_right >= safelen
                            % 满足速度要求
                            if front_otherlane_right - lane(i).position >= lane(i).speed + lane(i).length
                                lane(i).lane = lane(i).lane + 1; 
                                lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                                % 结构体赋值
                                for i = 1 : length(fn_temp)
                                    eval(['road{lane_index+1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                                end
                                %disp(["id: ",lane(i).id,"changed lane!!!!!"]);
                                % road{lane_index+1}(end+1) = lane(i);
                                % 重新排序
                                [~, idx] = sort([road{lane_index+1}.position]);
                                road{lane_index+1} = road{lane_index+1}(idx);
                                lane(i) = [];
                                car_num = car_num-1;
                                continue; 
                            end
                        end
                    % 直接向右换道
                    else
                        lane(i).lane = lane(i).lane + 1; 
                        lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                        % 结构体赋值
                        for i = 1 : length(fn_temp)
                            eval(['road{lane_index+1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                        end
                        %disp(["id: ",lane(i).id,"changed lane!!!!!!"]);
                        % 重新排序
                        [~, idx] = sort([road{lane_index+1}.position]);
                        road{lane_index+1} = road{lane_index+1}(idx);
                        lane(i) = [];
                        car_num = car_num-1;
                        continue; 
                    end
                % 应急车道没开，只能向左道
                else
                    % 能变道
                    if all(front_otherlane_left - lane(i).position >= lane(i).speed + lane(i).length) && all(lane(i).position - back_otherlane_left >= safelen)
                        lane(i).lane = lane(i).lane - 1; 
                        lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                        % 结构体赋值
                        for i = 1 : length(fn_temp)
                            eval(['road{lane_index-1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                        end
                        %disp(["id: ",lane(i).id,"changed lane!!!!!!!"]);
                        % road{lane_index-1}(end+1) = lane(i);
                        % 重新排序
                        [~, idx] = sort([road{lane_index-1}.position]);
                        road{lane_index-1} = road{lane_index-1}(idx);
                        lane(i) = [];
                        car_num = car_num-1;
                        continue; 
                    end
                end
            % 第三道
            elseif all(lane(i).lane == 3) && all(lane_index == 3)
                % 需加判断：emergency_flag一直开启 则根据实际可走左道 如果关闭了此时还有车 就尽量驱逐赶紧回左道 但驱逐好像也没办法 也得看能不能过去
                % 左道中前后车的位置
                position_list = [road{lane_index-1}.position];
                front_otherlane = min(position_list(position_list > lane(i).position));
                back_otherlane = max(position_list(position_list < lane(i).position));
                % 判断能否变道
                if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length) && all(lane(i).position - back_otherlane >= safelen)
                    lane(i).lane = lane(i).lane - 1; 
                    lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
                    % 结构体赋值
                    for i = 1 : length(fn_temp)
                        eval(['road{lane_index-1}(end+1).', fn_temp{i}, ' = lane(i).', fn_temp{i}, ';']);
                    end
                    %disp(["id: ",lane(i).id,"changed lane!!!!!!!!"]);
                    % road{lane_index-1}(end+1) = lane(i);
                    % 重新排序
                    [~, idx] = sort([road{lane_index-1}.position]);
                    road{lane_index-1} = road{lane_index-1}(idx);
                    lane(i) = [];
                    car_num = car_num-1;
                    continue; 
                end
            end


            end
        end
        
            

        % 更新位置
        lane(i).position = lane(i).position + lane(i).speed;

        % 移除超出范围的车辆
        if lane(i).position > road_length
            lane(i) = [];
            car_num = car_num-1;
        else
            i = i + 1;  % 仅当车辆未被移除时才增加索引
        end
    end
    
    updated_lane = lane;
end
