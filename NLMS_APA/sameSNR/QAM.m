% 参数定义
M = 16;  % 16-QAM
bit_stream = randi([0 1], 1000, 1); % 生成1000个随机比特
symbol_indices = bi2de(reshape(bit_stream, log2(M), []).', 'left-msb'); % 将比特转换为符号索引

% QAM 调制
symbols = qammod(symbol_indices, M, 'UnitAveragePower', true);

% 载波参数
fc = 1e3;  % 载波频率
fs = 10e3; % 采样频率
T_s = 1e-3; % 符号周期
T = 1/fs;  % 采样周期
num_samples_per_symbol = T_s / T; % 每个符号的采样点数

% 生成时间向量
t = 0:T:(length(symbols)*num_samples_per_symbol-1)*T;  % 时间向量

% 生成时间域 QAM 信号
qam_signal = zeros(1, length(t)); % 初始化 QAM 信号
for k = 1:length(symbols)
    % 提取每个符号的 I 和 Q 分量
    I = real(symbols(k));
    Q = imag(symbols(k));
    
    % 生成该符号对应的时间段内的信号
    qam_signal((k-1)*num_samples_per_symbol + 1 : k*num_samples_per_symbol) = ...
        I * cos(2*pi*fc*t((k-1)*num_samples_per_symbol + 1 : k*num_samples_per_symbol)) - ...
        Q * sin(2*pi*fc*t((k-1)*num_samples_per_symbol + 1 : k*num_samples_per_symbol));
end

% 绘制结果
figure;
subplot(2, 1, 1);
plot(t, qam_signal);
title('16-QAM 信号');
xlabel('时间 (s)');
ylabel('幅度');

subplot(2, 1, 2);
scatterplot(symbols);
title('16-QAM 星座图');
grid on;
