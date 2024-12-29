function visualize_road(time_step, road, observation_points, max_speed, paracal_flag, num_vehicles, emergency_flag)
    obs_colors = {'#6F4F67', '#8F302E', '#D27E64', '#5D977B'}; % 观察点颜色图谱
    clf;
    hold on;
    title(['Time Step: ', int2str(time_step)]); % 图像标题
    xlabel('X (m)'); % X轴标题
    ylabel('Y (m)'); % Y轴标题
    degree1 = 50; % 路段1斜率
    degree2 = 35; % 路段2斜率

    if emergency_flag==1
        txt = {'On'};
    else
        txt = {'Down'};
    end
    text(3500,4200,txt);

    %% 绘制观察点
    for i = 1:length(observation_points)
        if observation_points(i) <= 2000
            x1 = observation_points(i) * cosd(degree1);
            y1 = 0;

            x2 = observation_points(i) * cosd(degree1);
            y2 = 4500;
        else
            x1 = 2000 * cosd(degree1) + (observation_points(i) - 2000) * cosd(degree2);
            y1 = 0;

            x2 = 2000 * cosd(degree1) + (observation_points(i) - 2000) * cosd(degree2);
            y2 = 4500;
        end

        % 使用 patch 函数绘制观察点为宽度15的矩形
        faces = [1, 2, 3, 4];
        vertices = [x1, y1; x1, y2; x2+15, y2; x2+15, y1];
        patch('faces', faces, 'vertices', vertices, 'EdgeColor', 'None', 'FaceColor', obs_colors{i}, 'FaceAlpha', 0.5);
    end
    
    %% 道路绘制
    for lane = (0:length(road))-0.5
        % 第一段公路绘制
        plot([0, 2000 * cosd(degree1)], -[lane *15 * 6, lane * 15 * 6 + 2000 * sind(degree1)] + [4500 4500], 'k-');
        % 第二段公路绘制
        plot([2000 * cosd(degree1), 2000 * cosd(degree1) + 3000 * cosd(degree2)], ...
             -[lane * 15 * 6 + 2000 * sind(degree1), lane * 15 * 6 + 2000 * sind(degree1) + 3000 * sind(degree2)] + [4500 4500], 'k-');
    end
    
    %% 车辆绘制数据集中计算
    xs = [];
    ys = [];
    ad = [];
    if paracal_flag == 1
        for lane = 1:length(road)
            parfor i = 1:length(road{lane})
                vehicle = road{lane}(i);
                if vehicle.position <= 2000
                    x = vehicle.position * cosd(degree1);
                    y = 4500-((lane - 1) * 15 * 6 + vehicle.position * sind(degree1));
                else
                    x = 2000 * cosd(degree1) + (vehicle.position - 2000) * cosd(degree2);
                    y = 4500-((lane - 1) * 15 * 6 + 2000 * sind(degree1) + (vehicle.position - 2000) * sind(degree2));
                end
    
                xs = [xs, x]; % 车辆的X轴信息
                ys = [ys, y]; % 车辆的Y轴信息
                ad = [ad, vehicle.speed/max_speed*num_vehicles]; % 车辆的不透明度信息
            end
        end
    else
        for lane = 1:length(road)
            for i = 1:length(road{lane})
                vehicle = road{lane}(i);
                if vehicle.position <= 2000
                    x = vehicle.position * cosd(degree1);
                    y = 4500-((lane - 1) * 15 * 6 + vehicle.position * sind(degree1));
                else
                    x = 2000 * cosd(degree1) + (vehicle.position - 2000) * cosd(degree2);
                    y = 4500-((lane - 1) * 15 * 6 + 2000 * sind(degree1) + (vehicle.position - 2000) * sind(degree2));
                end
                xs = [xs, x]; % 车辆的X轴信息
                ys = [ys, y]; % 车辆的Y轴信息
                % ad = [ad, vehicle.speed/max_speed*num_vehicles]; % 车辆的不透明度信息
                ad = [ad, 1]; 
            end
        end
    end
    
    %% 车辆绘制
    s = scatter(xs, ys, 35, linspace(0, max_speed, length(xs)), "filled",'Marker', "square"); % 将保存好的车辆信息进行集中绘制
    s.AlphaData = ad; % 不透明度设置
    s.MarkerFaceAlpha = 'flat';

    h = colorbar; % 颜色条生成
    h.TickLabels = linspace(0, max_speed, length(h.TickLabels)); % 颜色条标签修改

    axis([-15 3800 0 4600]); % 可视化部分坐标轴限制生成
end
