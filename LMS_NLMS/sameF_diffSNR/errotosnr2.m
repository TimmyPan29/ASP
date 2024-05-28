close all; clc;
x = 0.001 : 0.001 : 0.999;
%nlms_f1
figure;


plot(x, nlms_SNR25f10, 'rx-', 'LineWidth', 1);
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_SNR15f10, 'r--', 'LineWidth', 1); 
plot(x, nlms_SNR5f10, 'r-', 'LineWidth', 1);  
plot(x, lms_SNR25f10, 'bx-', 'LineWidth', 1,'MarkerFaceColor', 'b');  
plot(x, lms_SNR15f10, 'bd-', 'LineWidth', 1);  
plot(x, lms_SNR5f10, 'bo-', 'LineWidth', 1,'MarkerFaceColor', 'b');  

% 添加图例
ylim([-50 200]);
xlim([0 0.05]);
xticks(0:0.05:0.05);
legend('SNR=25', 'SNR=15', 'SNR=5','SNR=25', 'SNR=15', 'SNR=5','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
