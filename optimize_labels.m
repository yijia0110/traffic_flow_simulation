function optimize_labels(x, y, labels)
    % 初始标签位置
    label_pos = [x; y]';
    
    % 优化函数，最小化重叠距离
    function cost = label_cost(pos)
        cost = 0;
        for i = 1:size(pos, 1)
            for j = i+1:size(pos, 1)
                dist = norm(pos(i,:) - pos(j,:));
                cost = cost + 1 / (dist+0.01); % 距离越小，代价越大
            end
        end
    end

    % 使用 fmincon 进行优化
    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
    label_pos_opt = fmincon(@label_cost, label_pos, [], [], [], [], [], [], [], options);

    % 绘制点和优化后的标签
    % plot(x, y, 'o');
    % hold on;
    for i = 1:length(x)
        text(label_pos_opt(i, 1), label_pos_opt(i, 2), labels{i}, 'FontSize', 10, 'Margin', 1);
    end
    % hold off;
end
