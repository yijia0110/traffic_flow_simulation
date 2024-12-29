function vehicles = initialize_vehicles(num_vehicles, vehicle_types, speed, position,count)
    vehicles = struct('id', {}, 'type', {}, 'length', {}, 'max_speed', {}, 'speed', {}, 'position', {}, 'lane', {});
    for i = count:count+num_vehicles
        type_idx = randi(size(vehicle_types, 1));
        vehicles(i).id = ;
        vehicles(i).type = vehicle_types{type_idx, 1};
        vehicles(i).length = vehicle_types{type_idx, 2};
        vehicles(i).max_speed = vehicle_types{type_idx, 3};
        vehicles(i).speed = speed;
        vehicles(i).position = randi(position);  % 随机均匀分布初始位置
        vehicles(i).lane = randi(num_lanes); %初始化随机放在普通车道上
    end
end