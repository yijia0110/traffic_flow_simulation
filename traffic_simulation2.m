clear; close all; clc
% 参数设置
road_length = 5000;  % 道路长度 (m)
num_lanes = 2;  % 普通车道数量
emergency_lane = 0;  % 应急车道数量
total_lanes = num_lanes + emergency_lane;  % 总车道数量
num_vehicles = 100;  % 车辆数量(实际比这个多多了 难道要全部显示吗)
simulation_steps = 800;  % 仿真步数(秒数)
max_speed = 50;  % 高速限速 (m/s)
observation_points = [0, 1000, 2000, 5000];  % 观察点位置 (m)

% 车辆类型
vehicle_types = {
    'small', 3.5, max_speed;  % 小型汽车
    'medium', 4.5, max_speed - 5;  % 中型车辆
    'large', 8, max_speed - 10  % 大型车辆
};

% 初始化车辆
% 速度 流量 密度 已知 确定加速度
vehicles = initialize_vehicles(num_vehicles, vehicle_types);

% 初始化道路
road = cell(total_lanes, 1);
for lane = 1:total_lanes
    road{lane} = [];
end

% 随机将车辆放置在车道上
for i = 1:num_vehicles
    lane = randi(total_lanes);
    vehicles(i).lane = lane;
    road{lane} = [road{lane}, vehicles(i)]; %递增吗
end

% lane是索引
for lane = 1:total_lanes
    % 按位置排序车辆
    [~, idx] = sort([road{lane}.position]);
    road{lane} = road{lane}(idx);
end

% 数据记录
data = cell(simulation_steps, length(observation_points));

% 设置图形窗口
figure;
set(gcf, 'OuterPosition', get(0, 'ScreenSize')); % 设置图窗大小为屏幕尺寸
% 仿真
for step = 1:simulation_steps
    % 根据加入新车
    road{lane}

    % 更新车辆状态
    for lane = 1:total_lanes
        road{lane} = update_lane(road{lane}, lane, road, road_length, max_speed);
    end
    
    % 记录数据
    for i = 1:length(observation_points)
        data{step, i} = record_data(road, observation_points(i));
    end
    
    % 可视化（有的时候突然卡住不知道怎么回事，以及显示会有问题会多不动的点）
    visualize_road(road, step, observation_points);
    pause(0.0001);
end

% 保存数据到CSV文件
save_data_to_csv(data, observation_points);