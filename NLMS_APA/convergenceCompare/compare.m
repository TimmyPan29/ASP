close all; clc;
x = 0.0001 : 0.0001 : 0.9999;
%nlms_f1
figure;


plot(x, nlms_SNR25f10mu0d0001, 'rx', 'LineWidth', 1);
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_SNR15f10mu0d0001, 'r--', 'LineWidth', 1); 
plot(x, nlms_SNR5f10mu0d0001, 'r-', 'LineWidth', 1);  
plot(x, apa_SNR25f10mu0d0001, 'bx', 'LineWidth', 1);  
plot(x, apa_SNR15f10mu0d0001, 'b--', 'LineWidth', 1);  
plot(x, apa_SNR5f10mu0d0001, 'b-', 'LineWidth', 1);  

% 添加图例
ylim([-50 10]);
xlim([0 0.01]);
xticks(0:0.001:0.01);
legend('NLMS SNR=25', 'NLMS SNR=15', 'NLMS SNR=5','APA SNR=25', 'APA SNR=15', 'APA SNR=5','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
