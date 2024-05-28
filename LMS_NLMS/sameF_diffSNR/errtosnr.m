close all; clc;
x = 0.0001 : 0.0001 : 0.0999;
%nlms_f1
figure;


plot(x, nlms_SNR25f10mu0d0001, 'rx-', 'LineWidth', 1);
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_SNR15f10mu0d0001, 'r--', 'LineWidth', 1); 
plot(x, nlms_SNR5f10mu0d0001, 'r-', 'LineWidth', 1);  
plot(x, lms_SNR25f10mu0d0001, 'bx-', 'LineWidth', 1,'MarkerFaceColor', 'b');  
plot(x, lms_SNR15f10mu0d0001, 'bd-', 'LineWidth', 1);  
plot(x, lms_SNR5f10mu0d0001, 'bo-', 'LineWidth', 1,'MarkerFaceColor', 'b');  

% 添加图例
ylim([-50 200]);
xlim([0 0.1]);
xticks(0:0.01:0.1);
legend('SNR=25', 'SNR=15', 'SNR=5','SNR=25', 'SNR=15', 'SNR=5','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
