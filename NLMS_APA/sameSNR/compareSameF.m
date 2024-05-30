close all; clc;
x = 0.0001 : 0.0001 : 0.9999;
%nlms_f1
figure;


plot(x, nlms_SNR15f10000mu0d0001, 'rx', 'LineWidth', 1);
hold on;  % 保持图形，允许在同一图上绘制更多线条
plot(x, nlms_SNR15f1000mu0d0001, 'r:', 'LineWidth', 0.1); 
plot(x, nlms_SNR15f100mu0d0001, 'r--', 'LineWidth', 1); 
plot(x, nlms_SNR15f1mu0d0001, 'r-', 'LineWidth', 1);  
plot(x, apa_SNR15f10000mu0d0001, 'bx', 'LineWidth', 1);  
plot(x, apa_SNR15f1000mu0d0001, 'b:', 'LineWidth', 0.1);  
plot(x, apa_SNR15f100mu0d0001, 'b--', 'LineWidth', 1);  
plot(x, apa_SNR15f1mu0d0001, 'b-', 'LineWidth', 1);  

% 添加图例
ylim([-40 0]);
xlim([0 0.05]);
xticks(0:0.01:0.05);
legend('NLMS f=10000', 'NLMS f=1000', 'NLMS f=100', 'NLMS f=1','APA f=10000', 'APA f=1000', 'APA f=100', 'APA f=1','NumColumns', 2);

% 添加标题和坐标轴标签
title('step size \mu sensitivity');
xlabel('step size \mu');
ylabel('error to clean signal ratio(dB)');

% 关闭 hold 状态
hold off;
