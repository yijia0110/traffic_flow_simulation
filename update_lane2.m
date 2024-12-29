function updated_lane = update_lane2(lane, lane_index, road, road_length, max_speed)
    probslow=0.3; %随机减速的概率
    probchange=0.2; %随机变道
    safelen=5; %后车的安全距离
    if isempty(lane)
        updated_lane = lane;
        return;
    end

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

        % 加速
        if isempty(front_vehicle) || front_vehicle.position - lane(i).position >= lane(i).speed + lane(i).length 
            lane(i).speed = min(lane(i).speed + 1, lane(i).max_speed);
        % 减速
        elseif front_vehicle.position - lane(i).position < lane(i).speed + lane(i).length
            lane(i).speed = min(lane(i).speed, front_vehicle.position - lane(i).position - lane(i).length);   
        % 未满足期望最大速度 就考虑是否变道（可能开启的第三条道还没加）
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
        %随机减速
        if rand < probslow
            lane(i).speed=max(lane(i).speed-1,0);
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
