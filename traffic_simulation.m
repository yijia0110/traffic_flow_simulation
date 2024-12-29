clear; close all; clc
% 读取CSV文件
data4 = readtable('103.1_new.xlsx');
data2 = readtable('105.1_new.xlsx');
data1 = readtable('107.1_new.xlsx');
data1_ori = readtable('107.1.xlsx');
data3 = readtable('108.1_new.xlsx');
%% 计算和处理
time = data1{:, 1};time2 = data2{:, 1};time3 = data3{:, 1};time4 = data4{:, 1};  % 第2列为时间
flow = data1{:, 2};flow2 = data2{:, 2};flow3 = data3{:, 2};flow4 = data4{:, 2};  % 第3列为交通流量
speed = data1{:, 3};speed2 = data2{:, 3};speed3 = data3{:, 3};speed4 = data4{:, 3};  % 第5列为车速
%% 注意单位 ！！！
density = data1{:, 4};density2 = data2{:, 4};density3 = data3{:, 4};density4 = data4{:, 4};  % 第5列为密度
%计算拥堵指数
indicate = 80./speed; indicate2 = 80./speed2;indicate3 = 80./speed3;indicate4 = 80./speed4;% 按照80为自由流

ori_time_length = length(time);ori_time_length2 = length(time2);ori_time_length3 = length(time3);ori_time_length4 = length(time4);

%% 数据计算
flow1_avg = mean(flow);flow2_avg = mean(flow2);flow3_avg = mean(flow3);flow4_avg = mean(flow4);
speed1_avg = mean(speed);speed2_avg = mean(speed2);speed3_avg = mean(speed3);speed4_avg = mean(speed4);
density1_avg = mean(density);density2_avg = mean(density2);density3_avg = mean(density3);density4_avg = mean(density4);

%% 参数设置
paracal_flag = 0; % 并行计算开启标志，1为开启，0为关闭
paracal_num = 2; % 并行计算使用的CPU核心数
skip_flag = 0; % 这里是可视化跳过标志，1为开启，0为关闭
skip_step = 2; % 这里是跳过的仿真补偿，当设置为1时，等于没开启跳过

road_length = 5000;  % 道路长度 (m)
num_lanes = 2;  % 普通车道数量
emergency_lane = 1;  % 应急车道数量
total_lanes = num_lanes + emergency_lane;  % 总车道数量
% num_vehicles = 500;  % 车辆数量(实际比这个多多了 难道要全部显示吗)
simulation_steps = 827;  % 仿真步数(秒数) 对应第一个视频13m47s
max_speed_small = 33;  % 高速限速 (m/s) 120km/h
max_speed_other = 27; % 高速限速 (m/s) 100km/h
min_speed = 16; % 高速最低限速 (m/s) 60km/h
emergency_flag = 0; %默认不启用紧急车道
v_flag = 0; rou_flag = 0;
observation_points = [0, 1000, 2000, 5000];  % 观察点位置 (m)
caculate_points = [[900, 1100];
                   [1900,2100];
                   [4800,5000]];  % 观察点位置 (m)
v_limit = 40;% km/h 
rou_limit = 0.08; % veh/m
laneflag_count = 0; %指示期望开车道的频次

%% 初始变量声明
vehicles = struct('id', {}, 'type', {}, 'length', {}, 'max_speed', {}, 'speed', {}, 'position', {}, 'lane', {});

%% 关于参数设置的输出部分
% fprintf("本次仿真共有%d步, 车辆数量%d个，最高速度%d km/h\n", simulation_steps, num_vehicles, max_speed_small*3.6)
% if skip_flag == 1
%     fprintf("仿真每%d步可视化依次\n", skip_step)
% else
%     fprintf("仿真可视化跳过未开启\n")
% end
% 
% if paracal_flag == 1
%     fprintf("使用的并行核心为%d个\n", paracal_num)
%     % 这里是启用paracal_num个核心，我的电脑CPU有8个核心，全启动对大规模计算是有帮助的
%     parpool('local', paracal_num); 
% else
%     fprintf("多核心并行计算未开启\n")
% end

%% 车辆类型
vehicle_types = {
    'small', 4, max_speed_small;  % 小型汽车
    'medium', 6, max_speed_other;  % 中型车辆
    'large', 8, max_speed_other  % i大型车辆
};

%% 初始化道路
road = cell(total_lanes, 1);
for lane = 1:total_lanes
    road{lane} = [];
end

%% 初始化车辆
distance = [1000,1000,3000];
% 速度计算时都是m/s
speed_list = [speed1_avg/3.6, speed2_avg/3.6, speed3_avg/3.6, speed4_avg/3.6];
%% 密度这里先不弄太多
num_vehicles_list = [round(density1_avg*1000), round(density2_avg*1000), round(density3_avg*3000)];
total_num_vehicles = sum(num_vehicles_list);
num_vehicles = total_num_vehicles;
count = 1;
for i = 1:3
    position_range = observation_points(i:i+1);
    for j = count:count+num_vehicles_list(i)
        type_idx = randi(size(vehicle_types, 1));
        vehicles(j).id = j;
        vehicles(j).type = vehicle_types{type_idx, 1};
        vehicles(j).length = vehicle_types{type_idx, 2};
        vehicles(j).max_speed = vehicle_types{type_idx, 3};
        vehicles(j).speed = speed_list(i); %初始设置比实际小一点
        vehicles(j).position = randi(position_range);  % 随机均匀分布初始位置
        vehicles(j).lane = randi(num_lanes); %初始化随机放在普通车道上
        % 将车辆放置在车道上
        road{vehicles(j).lane} = [road{vehicles(j).lane}, vehicles(j)]; 
    end
    count=count+num_vehicles_list(i);
end

% lane是索引
for lane = 1:num_lanes %注意num_lanes普通车到和emergency_lane紧急车道和total车道
    %% 按位置排序车辆
    [~, idx] = sort([road{lane}.position]);
    road{lane} = road{lane}(idx);
end

%% 设置图形窗口
figure;
set(gcf, 'OuterPosition', get(0, 'ScreenSize')); % 设置图窗大小为屏幕尺寸

%% 临时数据初始化
num_trials = 3; % 设置取样次数
counts = zeros(1, num_trials);% 初始化结果数组
%% 仿真
for step = 1:simulation_steps
    disp(["step number: ",step]);
    %disp("Shut up(1)/down(0) Emergency lane?");
    if mod(step,3)==0  % 3s生成一次 (理不清楚了。。先这样把。。)
        % 根据流量数据在起点动态生成新车
        num_new_vehicles = round(flow(step/3));  % 根据流量得到每秒生成车辆数量
        % 随机放出个数的序列
        remaining_count = num_new_vehicles;% 随机分配数字
        for i = 1:num_trials-1
            % 随机生成每次取出的数，范围从 0 到剩余数
            counts(i) = randi([0, remaining_count]); 
            remaining_count = remaining_count - counts(i); % 更新剩余数
        end
        counts(num_trials) = remaining_count; % 最后一次取出剩余的数
    else
        % 新生成的个数继续累加
        if ~isempty(counts)
            for i = 1:counts(mod(step,3))
                type_idx = randi(size(vehicle_types, 1));
                vehicles(i).id = i+num_vehicles;
                vehicles(i).type = vehicle_types{type_idx, 1};
                vehicles(i).length = vehicle_types{type_idx, 2};
                vehicles(i).max_speed = vehicle_types{type_idx, 3};
%                 vehicles(i).speed = speed(step);
                vehicles(i).speed = data1_ori{:,3}(step)/3.6;
                vehicles(i).position = randi([0, 100]);  % 起点 
                % 随机放到车道上
                vehicles(i).lane = randi(num_lanes);
                road{vehicles(i).lane} = [road{vehicles(i).lane}, vehicles(i)]; 
            end
            num_vehicles = num_vehicles + counts(mod(step,3));
        end
    end

    % 更新车辆状态
    avgv = 0; roudouble=0;
    for lane = 1:total_lanes % 对普通车道更新状态
        if ~isempty(road{lane}) % 不为空时
            road = update_lane(road{lane}, lane, road, road_length, emergency_flag);
            avgv = (mean([road{1}.speed]) + mean([road{2}.speed]))/2; %2车道的平均速度
            roudouble = (length(road{1})+length(road{2}))/5000; %2车道的平均密度
        end
    end

    %% 记录数据,绘制四个观察点的流量和速度图
    data = cell(3, length(observation_points));
    q_step_obsev = []; v_step_obsev = [];
    % 每次都记录 3步算一次 (就按3步把。。图上单位是3s，其他的理不清楚了)
    for i = 2:length(observation_points)
        if mod(step,3)==0
            step_temp = 3;
        else
            step_temp = mod(step,3);
        end
        data{step_temp, i} = record_data(road, caculate_points(i-1,:));
        %每步都记录的
        q_ori{step,i} = length(data{step_temp, i}); % vev/s
        v_ori{step,i} = (mean(cell2mat(data{step_temp, i}(:,3))))*3.6; %计算的时候都是米每秒,这里转换一下成km/h
        rou_ori{step,i} = (q_ori{step,i}/(v_ori{step,i}))*1000; % 这里单位是veh/km
    end
    if mod(step,3)==0
        % 对每一个观察点求和求平均
        for j = 2:length(observation_points)  %因为3个step统计一次
            q_temp = 0; v_temp = 0;
            for i=1:3
                if ~isempty(data{i, j})
                    count = length(data{i, j});
                    q_temp = q_temp + count;
                    v_temp = v_temp + mean(cell2mat(data{i, j}(:,3)));
                    data{i,j} = []; %记录完就清空
                end
            end
            q{step/3,j} = q_temp; % vev/s
            v{step/3,j} = (v_temp/3)*3.6; %计算的时候都是米每秒,这里转换一下成km/h
            rou{step/3,j} = (q_temp/(v_temp/3))*1000; % 这里单位是veh/km
            %% 是否开启应急车道
%             if v{step/3,j} < v_limit || rou{step/3,j}/1000 > rou_limit
%                 laneflag_count=laneflag_count+1;
%                 if laneflag_count>10
%                     laneflag_count = 0;
%                     emergency_flag = 1;
%                     disp("emergency has shut on!!!");
%                 end
%             else
%                 emergency_flag = 0;
%                 disp("emergency has shut down!!!");
%             end
            % 好像不能同时两个 动态窗口
%             figure(2)
%             hold on;
%             plot(step/5,q_temp,'r-');
%             plot(step/5,v_temp/5,'b-');
%             legend("流量","速度");
            % pause(0.01)
        end
    end

    %% 设定开启车道的规则:平均速度40以下或密度大于0.08就开放现在都针对的车道设定，而不是断面的流量或者速度
     
%     if avgv < 20/3.6 || roudouble>0.08 
%         emergency_flag = 1;
%         disp("emergency has shut on!!!");
%     else
%         emergency_flag = 0;
%         disp("emergency has shut down!!!");
%     end

    %% 计算均方根误差
    y_true = [1,1];
    y_pred = [1,1];
    rmse = sqrt(mean((y_true - y_pred).^2));
    fprintf('均方根误差 (RMSE): %.4f\n', rmse);

    %% 这里是跳过程序检测部分
    if skip_flag == 1
        if mod(step, skip_step) == 0
            visualize_road(step, road, observation_points, max_speed, paracal_flag, num_vehicles);
        end
    else
        % 可视化部分
        visualize_road(step, road, observation_points, max_speed_small, paracal_flag, num_vehicles, emergency_flag);
        %visualize_road2(road, step, observation_points);
    end
    %pause(eps); % 为了可视化的连续，进行最小停留
    pause(0.01);

end

% 保存数据到CSV文件
save_data_to_csv(data, observation_points);