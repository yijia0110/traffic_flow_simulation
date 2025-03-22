function data = record_data(road, caculate_points)
    data = [];
    % caculate_points = [1,2];
    for lane = 1:length(road)
        for i = 1:length(road{lane})
            % 在区间内
            % disp(caculate_points(1));disp(caculate_points(2));
            if road{lane}(i).position >= caculate_points(1) && road{lane}(i).position < caculate_points(2)
                data = [data; {road{lane}(i).id, road{lane}(i).type, road{lane}(i).speed}];
            end
        end
    end
end