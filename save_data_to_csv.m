function save_data_to_csv(data, observation_points)
    fileID = fopen('vehicle_data.csv', 'w');
    fprintf(fileID, 'Time Step,Observation Point,Vehicle ID,Vehicle Type,Speed\n');
    for step = 1:size(data, 1)
        for i = 1:size(data, 2)
            records = data{step, i};
            for j = 1:size(records, 1)
                fprintf(fileID, '%d,%d,%d,%s,%.2f\n', step, observation_points(i), records{j, 1}, records{j, 2}, records{j, 3});
            end
        end
    end
    fclose(fileID);
end