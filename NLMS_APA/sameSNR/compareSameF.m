close all; clc;
x = 0.001 : 0.001 : 0.999;
%nlms_f1
figure;


plot(x, nlms_f1, 'rx', 'LineWidth', 1);
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_f10, 'r--', 'LineWidth', 1); 
plot(x, nlms_f100, 'r-', 'LineWidth', 1);  
plot(x, lms_f1, 'bx', 'LineWidth', 1);  
plot(x, lms_f10, 'bd', 'LineWidth', 1);  
plot(x, lms_f100, 'bo', 'LineWidth', 1);  

% 添加图例
ylim([-40 0]);
xlim([0 1]);
xticks(0:0.1:1);
legend('NLMS f1', 'NLMS f10', 'NLMS f100','LMS f1', 'LMS f10', 'LMS f100','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
