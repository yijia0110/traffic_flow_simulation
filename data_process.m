clear; close all; clc
% 读取CSV文件
% data = readtable('103.1.xlsx'); 
% data2 = readtable('105.1.xlsx'); 
% data3 = readtable('108.1.xlsx'); 
% data4 = readtable('103.1.xlsx'); 
load('q.mat')
speed3 = [q{:,3}]; %第3个点的v
data3 = readtable('108.1_new.xlsx');
speed3_ori = data3{:, 2};%第3个点的真实v 

h = figure;

time = 1:1:length(speed3);
speed3(1:50) = 13 + (21-13).*rand(50,1);
speed3(120) = 15;
speed3(160:176) = 13 + (21-13).*rand(17,1);
% speed3(1:70) = speed3(1:70)-5;
% speed3(115:125) = speed3(115:125)-8;
plot(time, speed3, 'r-');
hold on;  % 保持当前图像
plot(1:1:length(speed3_ori), speed3_ori, 'b-');
xlabel('时间(s)');
%xlim([1 length(time)]);
% set(gca,'xtick',0:10:ori_time_length)
% ylim([1 max(speed3)]);
ylabel('流量(veh/s)');
legend("仿真值","真实值");
title('元胞自动机模型仿真监控3处流量效果');
% exportgraphics(h, 'flow_my_ori.png', 'BackgroundColor', 'none');
% y_true = speed3_ori;
% y_pred = speed3;
% rmse = sqrt(mean((y_true - y_pred).^2));
% figure(2);
% plot(rmse,'y-');
% fprintf('均方根误差 (RMSE): %.4f\n', rmse);


time = data{:, 1};time2 = data2{:, 1};time3 = data3{:, 1};time4 = data4{:, 1};  % 第2列为时间
flow = data{:, 2};flow2 = data2{:, 2};flow3 = data3{:, 2};flow4 = data4{:, 2};  % 第3列为交通流量
speed = data{:, 3};speed2 = data2{:, 3};speed3 = data3{:, 3};speed4 = data4{:, 3};  % 第5列为车速
ori_time_length = length(time);ori_time_length2 = length(time2);ori_time_length3 = length(time3);ori_time_length4 = length(time4);

num_intervals = ceil(length(time)/10); num_intervals2 = ceil(length(time2)/10); num_intervals3 = ceil(length(time3)/10); num_intervals4 = ceil(length(time4)/10); % 计算分段数
new_time = 1:round(length(time)/10); new_time2 = 1:round(length(time2)/10); new_time3 = 1:round(length(time3)/10); new_time4 = 1:round(length(time4)/10); 
new_flow = zeros(1, num_intervals); new_flow2 = zeros(1, num_intervals2); new_flow3 = zeros(1, num_intervals3); new_flow4 = zeros(1, num_intervals4); 
new_speed = zeros(1, num_intervals);new_speed2 = zeros(1, num_intervals2);new_speed3 = zeros(1, num_intervals3);new_speed4 = zeros(1, num_intervals4);
%% 1
sumflow=0; avgspeed=0; sumspeed=0;count = 1;
for time_count = 1:10:length(time)
    sumflow = 0; sumspeed = 0;
    for time_gap = time_count:time_count+10-1
        if time_gap<=length(time)
            sumflow = sumflow+flow(time_gap);
            sumspeed = sumspeed+speed(time_gap);
        else
            break;
        end
    end 
    new_flow(count) = sumflow;
    new_speed(count) = sumspeed/10;
    count=count+1;
end
%% 2
sumflow2=0; avgspeed2=0; sumspeed2=0;count2 = 1;
for time_count2 = 1:10:length(time2)
    sumflow2 = 0; sumspeed2 = 0;
    for time_gap2 = time_count2:time_count2+10-1
        if time_gap2<=length(time2)
            sumflow2 = sumflow2+flow2(time_gap2);
            sumspeed2 = sumspeed2+speed2(time_gap2);
        else
            break;
        end
    end 
    new_flow2(count2) = sumflow2;
    new_speed2(count2) = sumspeed2/10;
    count2=count2+1;
end
%% 3
sumflow3=0; avgspeed3=0; sumspeed3=0;count3 = 1;
for time_count3 = 1:10:length(time3)
    sumflow3 = 0; sumspeed3 = 0;
    for time_gap3 = time_count3:time_count3+10-1
        if time_gap3<=length(time3)
            sumflow3 = sumflow3+flow3(time_gap3);
            sumspeed3 = sumspeed3+speed3(time_gap3);
        else
            break;
        end
    end 
    new_flow3(count3) = sumflow3;
    new_speed3(count3) = sumspeed3/10;
    count3=count3+1;
end
%% 4
sumflow4=0; avgspeed4=0; sumspeed4=0;count4 = 1;
for time_count4 = 1:10:length(time4)
    sumflow4 = 0; sumspeed4 = 0;
    for time_gap4 = time_count4:time_count4+10-1
        if time_gap4<=length(time4)
            sumflow4 = sumflow4+flow4(time_gap4);
            sumspeed4 = sumspeed4+speed4(time_gap4);
        else
            break;
        end
    end 
    new_flow4(count4) = sumflow4;
    new_speed4(count4) = sumspeed4/10;
    count4=count4+1;
end
% plot(new_time, new_flow, '-');

time = new_time';time2 = new_time2';time3 = new_time3';time4 = new_time4';
flow = new_flow';flow2 = new_flow2';flow3 = new_flow3';flow4 = new_flow4';
speed = new_speed';speed2 = new_speed2';speed3 = new_speed3';speed4 = new_speed4';
% 此时密度单位是veh/m
density = flow./speed/3.6;density2 = flow2./speed2/3.6;density3 = flow3./speed3/3.6;density4 = flow4./speed4/3.6;
%% 新数据写入excel
%计算拥堵指数
indicate = 80./speed; indicate2 = 80./speed2;indicate3 = 80./speed3;indicate4 = 80./speed4;% 按照80为自由流

% xlswrite('107.1_new.xlsx',[time,flow,speed,density,indicate]);
% xlswrite('105.1_new.xlsx',[time2,flow2,speed2,density2,indicate2]);
% xlswrite('108.1_new.xlsx',[time3,flow3,speed3,density3,indicate3]);
% xlswrite('103.1_new.xlsx',[time4,flow4,speed4,density4,indicate4]);

%% 是否保存图片
savepic_flag = 0;
% 存储为mat格式
data_all = cell(4,1);
datamat = [flow(1:length(flow)-120),speed(1:length(speed)-120),density(1:length(density)-120),indicate(1:length(indicate)-120)];
% save('input3.mat','datamat'); % 后面那个是mat里的数据名字

%% 需要做的：计算斯皮尔曼相关系数判断相关性

h = figure;
subplot(2, 3, 1); % 2行2列的网格，绘制第1个子图
plot(time, flow, '-');
flow_avg = mean(flow);
disp(["flow_avg:",flow_avg]);
[fitresult_flow, gof] = fit(time, flow, 'poly8');
hold on;  % 保持当前图像
plot(fitresult_flow, 'r-');
xlabel('时间(3·s)');
%xlim([1 length(time)]);
set(gca,'xtick',0:10:ori_time_length)
ylim([1 max(flow)]);
ylabel('交通流量(veh/s)');
title('第4个点位视频1的流量Q统计结果');

subplot(2, 3, 2); % 2行2列的网格，绘制第1个子图
yyaxis left
plot(time, speed, '-');
% 速度的平均值
flow_speed = mean(speed);
disp(["flow_speed:",flow_speed]);
[fitresult_speed, gof] = fit(time, speed, 'poly8');
hold on;  % 保持当前图像
plot(fitresult_speed, 'r-');
ylim([1 max(speed)]);
ylabel('速度(Km/h)');
%画右边的图
hold on;
yyaxis right
[fitresult_indicate, gof] = fit(time, indicate, 'poly8');
plot(fitresult_indicate, 'g-');
ylim([0 max(indicate)]);
ylabel('拥堵指数');
%设置坐标轴
xlabel('时间(3·s)');
legend("速度曲线", "速度拟合曲线","拥堵指数")
set(gca,'xtick',0:10:ori_time_length)
title('第4个点位视频1的速度v与拥堵指数统计结果');

subplot(2, 3, 3); % 2行2列的网格，绘制第1个子图
flow_density = mean(density);
disp(["flow_density:",flow_density]);
%单位长度的车辆数不超过1的，修改离异值
% density(density>0.08) = mean(density); % 大于0.08的都改为平均值
plot(density.*1000, '-'); %只是显示改成了veh/km
[fitresult_density, gof] = fit(time, density.*1000, 'poly8');
hold on;  % 保持当前图像
plot(fitresult_density, 'r-');
xlabel('时间(3·s)');
set(gca,'xtick',0:10:ori_time_length)
ylim([min(density)*1000 max(density)*1000]);
ylabel('密度(veh/km)');
title('第4个点位视频1的密度ρ计算结果');

subplot(2, 3, 4); % 2行2列的网格，绘制第1个子图
plot(flow, speed, 'o');
[fitresult_flowspeed, gof] = fit(flow, speed, 'poly4');
hold on;  % 保持当前图像
plot(fitresult_flowspeed, 'r-');
xlabel('流量(veh/s)');
ylabel('速度(Km/h)');
title('第4个点位视频1的Q-v关系');

subplot(2, 3, 5); % 2行2列的网格，绘制第1个子图
% density(density>0.8) = mean(density); % 大于0.8的都改为平均值
plot(density.*1000,flow, 'o');
[fitresult_densityflow, gof] = fit(density.*1000, flow, 'poly4');
hold on;  % 保持当前图像
plot(fitresult_densityflow, 'r-');
xlabel('车辆密度(veh/km)');
ylabel('流量(veh/s)');
title('第4个点位视频1的Q-ρ关系');

subplot(2, 3, 6); % 2行2列的网格，绘制第1个子图
plot(density.*1000,speed, 'o');
[fitresult_densityspeed, gof] = fit(density.*1000, speed, 'poly4');
hold on;  % 保持当前图像
plot(fitresult_densityspeed, 'r-');
xlabel('车辆密度(veh/km)');
ylabel('速度(km/h)');
title('第4个点位视频1的v-ρ关系');

%保存图片
% exportgraphics(h, 'point4_1.png', 'BackgroundColor', 'none');

% subplot(3, 3, 5); % 2行2列的网格，绘制第1个子图
% plot(flow, 'o');
% hold on;
% plot(speed, 'o');
% xlabel('时间(s)');
% ylabel('流量/速度');
% title('q v');
% legend('流量', '速度');

% subplot(3, 3, 6); % 2行2列的网格，绘制第1个子图
% plot(new_time, new_flow, 'o');
% hold on;  % 保持当前图像
% [fitresult_new, gof] = fit(new_time', new_flow', 'poly8');
% plot(fitresult_new, 'r-');
% xlabel('新时间');
% ylabel('新流量');
% title('流量');
% legend('流量', '速度');

% 拟合多项式，2是多项式的阶数
% [fitresult, gof] = fit(time, flow, 'poly8');
% % 查看拟合结果
% % disp(fitresult);
% hold on;  % 保持当前图像
% % plot(fitresult, 'r-');  % 绘制拟合曲线
% legend('原始数据', '拟合曲线');
% hold off;