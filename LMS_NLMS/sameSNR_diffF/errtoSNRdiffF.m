close all; clc;
x = 0.0001 : 0.0001 : 0.9999;
figure;

plot(x, nlms_SNR15f10000mu0d0001, 'ro-', 'LineWidth', 1,'MarkerFaceColor', 'm','MarkerEdgeColor', 'm');
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_SNR15f100mu0d0001, 'rx-', 'LineWidth', 1);
plot(x, nlms_SNR15f10mu0d0001, 'r--', 'LineWidth', 1); 
plot(x, nlms_SNR15f1mu0d0001, 'r-', 'LineWidth', 1); 
plot(x, lms_SNR15f10000mu0d0001, 'bo-', 'LineWidth', 1,'MarkerFaceColor', 'c','MarkerEdgeColor', 'b');  
plot(x, lms_SNR15f100mu0d0001, 'bx-', 'LineWidth', 1,'MarkerFaceColor', 'b');  
plot(x, lms_SNR15f10mu0d0001, 'bd-', 'LineWidth', 1);  
plot(x, lms_SNR15f1mu0d0001, 'bo-', 'LineWidth', 1,'MarkerFaceColor', 'b');  

% 添加图例
ylim([-70 0]);
xlim([0 0.005]);
xticks(0:0.001:0.005);
legend('f=10000','f=100', 'f=10', 'f=1','f=10000','f=100', 'f=10', 'f=1','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
