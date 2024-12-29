function road = update_lane(lane, lane_index, road, road_length, emergency_flag)
    probslow=0.15; % 随机减速的概率
    safelen=20; % 后车的安全距离 需要加上当前车的长度
    car_gap = 0;
    % disp(lane)
    fn_temp = fieldnames(lane); %结构体的字段名，每个都一样的先随便取一个 为什么road{1}(1)就不行
 
    if isempty(lane)
        updated_lane = lane;
        return;
    end
    %disp(["land_id:",lane(1).lane,"lane_index:",lane_index])
    
    %% 按位置排序车辆
    [~, idx] = sort([lane.position]);
    lane = lane(idx);

    car_num = length(lane);
    % 更新每辆车的状态
    i = 1;  % 使用索引循环，以便在循环过程中移除车辆
    while i <= car_num
        % disp(i);disp(length(lane));disp(car_num);
        if i == car_num
            front_vehicle = [];
        else
            front_vehicle = lane(i+1); % 当前车道的前车
        end

        %disp(lane(i))
        % 防撞减速
        if all(~isempty(front_vehicle)) && all(front_vehicle.position - lane(i).position < lane(i).speed + lane(i).length + car_gap) %80是现实的条件
            lane(i).speed = max(1, front_vehicle.position - lane(i).position - lane(i).length);   
            % 减速了看看能不能变道 未满足期望最大速度 就考虑是否变道
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
                if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length + car_gap) && all(lane(i).position - back_otherlane >= safelen)
                    lane(i).lane = lane(i).lane + 1; 
                    % 结构体赋值
                    index = length(road{lane_index+1})+1;
                    for p = 1 : length(fn_temp)
                        eval(['road{lane_index+1}(', num2str(index), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
                    end
                    %road{lane_index+1}(end+1) = lane(i);
                    disp("change lane!!");
                    % 重新排序
                    [~, idx] = sort([road{lane_index+1}.position]);
                    road{lane_index+1} = road{lane_index+1}(idx);
                    lane(i) = [];
                    car_num = car_num-1;
                    if i>car_num
                        break;
                    else
                        continue; 
                    end

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
                if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length + car_gap ) && all(lane(i).position - back_otherlane >= safelen)
                    lane(i).lane = lane(i).lane - 1; 
                    % 结构体赋值
                    index = length(road{lane_index-1})+1;
                    for p = 1 : length(fn_temp)
                        eval(['road{lane_index-1}(', num2str(index), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
                    end
                    %road{lane_index-1}(end+1) = lane(i);
                    disp("change lane!!");
                    % 重新排序
                    [~, idx] = sort([road{lane_index-1}.position]);
                    road{lane_index-1} = road{lane_index-1}(idx);
                    lane(i) = [];
                    car_num = car_num-1;
                    if i>car_num
                        break;
                    else
                        continue; 
                    end
                else % 不能变道就再跟前车
                    lane(i).speed = front_vehicle.speed; 
                end
            end
        % 不撞就看能不能加速
        elseif isempty(front_vehicle) || front_vehicle.position - lane(i).position >= lane(i).speed + lane(i).length + car_gap
            %% 加速度设置
            lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
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
        % 现在是枚举遍历，比较机械和慢速，后面有空再改吧，现在先跑通再说
        %% 
        if emergency_flag==1
            %% 
            if lane(i).speed~=lane(i).max_speed
                % 第二道
                if lane(i).lane == 2 % 有的地方可能更改lane了但是当前没有清除就导致识别有问题
                    % 右道中前后车的位置
                  if ~isempty(road{lane_index+1}) %不是空的
                        position_list = [road{lane_index+1}.position];
                        front_otherlane = min(position_list(position_list > lane(i).position));
                        back_otherlane = max(position_list(position_list < lane(i).position));
                    
                        % 判断能否变道
                        if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length + car_gap) && all(lane(i).position - back_otherlane >= safelen)
                            lane(i).lane = lane(i).lane + 1; 
                            index = length(road{lane_index+1})+1;
                            for p = 1 : length(fn_temp)
                                eval(['road{lane_index+1}(', num2str(index), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
                            end
                            % road{lane_index+1}(end+1) = lane(i);
                            % 重新排序
                            [~, idx] = sort([road{lane_index+1}.position]);
                            road{lane_index+1} = road{lane_index+1}(idx);
                            lane(i) = [];
                            car_num = car_num-1;
                            continue; 
                        end
                  else %是空的直接变
                        lane(i).lane = lane(i).lane + 1; 
                        for p = 1 : length(fn_temp)
                            eval(['road{lane_index+1}(', num2str(1), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
                        end
                        % road{lane_index+1}(end+1) = lane(i);
                        % 重新排序
                        [~, idx] = sort([road{lane_index+1}.position]);
                        road{lane_index+1} = road{lane_index+1}(idx);
                        lane(i) = [];
                        car_num = car_num-1;
                        continue; 
                   end
                % 第三道
                elseif lane(i).lane == 3
                    if lane(i).speed~=lane(i).max_speed
                        % 左道中前后车的位置
                        position_list = [road{lane_index-1}.position];
                        front_otherlane = min(position_list(position_list > lane(i).position));
                        back_otherlane = max(position_list(position_list < lane(i).position));
                        % 判断能否变道
                        % 如果左道更宽敞
                        if i<length(lane) %如果当前前面非空
                            if front_otherlane >= lane(i+1).position + lane(i).length  
                                if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length + car_gap) && all(lane(i).position - back_otherlane >= safelen)
                                    lane(i).lane = lane(i).lane - 1; 
                                    index = length(road{lane_index-1})+1;
                                    for p = 1 : length(fn_temp)
                                        eval(['road{lane_index-1}(', num2str(index), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
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
                end
            end
        else
            if lane(i).lane == 3
                % 向左变道
                % 左道中前后车的位置
                position_list = [road{lane_index-1}.position];
                front_otherlane = min(position_list(position_list > lane(i).position));
                back_otherlane = max(position_list(position_list < lane(i).position));
                % 只要左边安全距离满足就变道 因为车道已经关闭了
                if all(front_otherlane - lane(i).position >= lane(i).speed + lane(i).length + car_gap) && all(lane(i).position - back_otherlane >= safelen)
                    lane(i).lane = lane(i).lane - 1; 
                    index = length(road{lane_index-1})+1;
                    for p = 1 : length(fn_temp)
                        eval(['road{lane_index-1}(', num2str(index), ').', fn_temp{p}, ' = lane(i).', fn_temp{p}, ';']);
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
    road{lane_index} = updated_lane;
end
