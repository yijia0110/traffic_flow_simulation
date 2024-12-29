function visualize_road2(road, time_step, observation_points)
    colors = {'blue', 'green', 'red'};
    obs_colors = {'cyan', 'magenta', 'yellow', 'black'};
    clf;
    hold on;
    title(['Time Step: ', num2str(time_step)]);
    xlabel('X (m)');
    ylabel('Y (m)');
    
    % 画观察点
    for i = 1:length(observation_points)
        if observation_points(i) <= 2000
            x = observation_points(i) * cosd(35);
            y = observation_points(i) * sind(35);
        else
            x = 2000 * cosd(35) + (observation_points(i) - 2000) * cosd(65);
            y = 2000 * sind(35) + (observation_points(i) - 2000) * sind(65);
        end
        plot(x, y, 'o', 'Color', obs_colors{i}, 'MarkerFaceColor', obs_colors{i}, 'DisplayName', ['Observation Point ', num2str(i)]);
    end
    
    % 画道路
    for lane = 1:length(road)
        % 第一段
        plot([0, 2000 * cosd(35)], [lane *15 * 6, lane * 15 * 6 + 2000 * sind(35)], 'k-');
        % 第二段
        plot([2000 * cosd(35), 2000 * cosd(35) + 3000 * cosd(65)], ...
             [lane * 15 * 6 + 2000 * sind(35), lane * 15 * 6 + 2000 * sind(35) + 3000 * sind(65)], 'k-');
    end
    
    % 画车辆
    label_positions = [0, 0];  % 用于记录标签位置，防止重叠
    for lane = 1:length(road)
        for i = 1:length(road{lane})
            vehicle = road{lane}(i);
            if vehicle.position <= 2000
                x = vehicle.position * cosd(35);
                y = (lane*15 - 1) * 6 + vehicle.position * sind(35);
            else
                x = 2000 * cosd(35) + (vehicle.position - 2000) * cosd(65);
                y = (lane*15 - 1) * 6 + 2000 * sind(35) + (vehicle.position - 2000) * sind(65);
            end
            color_idx = find(strcmp(vehicle.type, {'small', 'medium', 'large'}));
            scatter(x, y, 50, 'MarkerFaceColor', colors{color_idx}, 'MarkerEdgeColor', colors{color_idx});

            % 确定标签位置，防止重叠
            label_x = x + 15;
            label_y = y;

            while any(sqrt((label_positions(:,1) - label_x).^2 + (label_positions(:,2) - label_y).^2) < 20)
                if any(abs(label_positions(:,1) - label_x) < 15)
                    label_x = label_x - 50;  % 调整标签位置，防止重叠
                end

                if any(abs(label_positions(:,2) - label_y) < 10)
                    label_y = label_y - 10;  % 调整标签位置，防止重叠
                end
            end
            label_positions = [label_positions; label_x, label_y];
            
            text(label_x, label_y, ['ID: ', num2str(vehicle.id), ', Speed: ', num2str(vehicle.speed*3.6), ' km/h'], 'Color', 'black', 'FontSize', 8);
        end
    end
    
    hold off;
end
