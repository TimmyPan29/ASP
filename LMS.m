clc; close all ;
% Parameter definitions
fs = 1000;         % Sampling frequency
t = 0:1/fs:1-1/fs; % Time vector
f = 10;             % Frequency of the sine wave

%A = 1.4226
%A = 4.4987;
A = 14.2262;

A_Noise = 0.8 ;
z = 1 ;
clean_signal = zeros(size(t));
% Generate a clean sine wave signal
%clean_signal = 2*sin(2 * pi * 2*f * t)+2*sin(2 * pi * 3*f * t)+2*sin(2 * pi * 5*f * t)+2*sin(2 * pi * 7*f * t);
for i = 0:1:z-1
    clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)+A*cos(2*pi*(1+i*2)*f*t) ;
    %clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)*sqrt(2).*cos(2*pi*(1+i*2)*f*t) ;
end

% Add Gaussian white noise
noise = A_Noise * randn(size(t));
noisy_signal = clean_signal + noise;
temp1 = mean(clean_signal.^2);
temp2 = mean(A_Noise.^2); 
SNR = 10*log10(temp1/temp2)
% LMS algorithm parameters
mu = 0.0001;         % Step size (learning rate)
strmu = string(mu);
M = 32;            % Length of the filter

% Initialize variables
N = length(noisy_signal);
w = zeros(1, M);   % Filter coefficients initialized
e = zeros(1, N);   % Error signal
output = zeros(1, N);  % Filter output
muj = 0.0001 :0.0001:0.0999;
y_errtoclean = zeros(1,999);
j = 1
% % LMS algorithm
while j < 1000
    for n = M:N
        % Take the last M samples of the current time
        x = noisy_signal(n:-1:n-M+1);

        % Filter output
        output(n) = w * x';

        % Error calculation
        e(n) = clean_signal(n) - output(n);

        % Coefficients update
        w = w + 2 * muj(j) * e(n) * x;
    end
    temp3 = mean(e(33:end).^2) ;
    temp4 = mean(clean_signal(33:end).^2) ;
    err_clean_dB = 10*log10(temp3/temp4) ;
    y_errtoclean(j) = err_clean_dB ;
    j = j + 1 ;
end
lms_SNR25f10mu0d0001 = y_errtoclean;
% for n = M:N
%         % Take the last M samples of the current time
%         x = noisy_signal(n:-1:n-M+1);
% 
%         % Filter output
%         output(n) = w * x';
% 
%         % Error calculation
%         e(n) = clean_signal(n) - output(n);
% 
%         % Coefficients update
%         w = w + 2 * mu * e(n) * x;
% end
% temp3 = mean(e(33:end).^2) ;
% temp4 = mean(clean_signal(33:end).^2) ;
% err_clean_dB = 10*log10(temp3/temp4) ;


% Plotting the results
% folderPath = '/Users/timmy29/desktop/asp/LMS_NLMS'; 
% %folderPath = 'C:\Users\f1406\Downloads\asp_matlab\LMS_NLMS\SNR相同_特性相同_步數敏感度'; % Windows样式的路径
% baseFileName = 'lms_SNR25f10one_mu'; % 基本文件名
% jpgFileName = fullfile(folderPath, sprintf('%s%s.jpg', baseFileName,strmu));
% figure;
% subplot(3,1,1);
% plot(t, clean_signal);
% title('Clean Signal');
% xlabel('Time (s)');
% ylabel('signal (V)');
% 
% subplot(3,1,2);
% plot(t, noisy_signal);
% title('Noisy Signal');
% xlabel('Time (s)');
% ylabel('signal (V)');
% 
% subplot(3,1,3);
% plot(t, output);
% title('Output Signal using LMS');
% xlabel('Time (s)');
% ylabel('signal (V)');
% % saveas(gcf, jpgFileName);
% % Display the error plot
% figure;
% plot(t, e);
% title('Error Signal');
% xlabel('Time (s)');
% ylabel('signal (V)');
% baseFileName = 'lms_SNR25f10two_mu'; % 基本文件名
% jpgFileName = fullfile(folderPath, sprintf('%s%s.jpg', baseFileName,strmu));
% % saveas(gcf, jpgFileName);
