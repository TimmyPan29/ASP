%-----NLMS fix f=10, and diff SNR=25, 15, 5-----%
clc; close all ;
% Parameter definitions
fs = 1000;         % Sampling frequency
t = 0:1/fs:1-1/fs; % Time vector

f = 100;             % Frequency of the sine wave
flag = 3;
flagF = true ;

if(flag==1)
    A = 1.4226; SNRstrNLMS = 'NLMS SNR=5' ;
elseif(flag==2)
    A = 4.4987; SNRstrNLMS = 'NLMS SNR=15' ;
else
    A = 14.2262; SNRstrNLMS = 'NLMS SNR=25' ;
end
A_Noise = 0.8 ;
z = 5 ;
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
temp2 = mean(noise.^2); 
SNR = 10*log10(temp1/temp2)
% NLMS algorithm parameters
mu = 0.01;         % Step size (learning rate)
strmu = string(mu);
M = 32;            % Length of the filter
epsilon = 0.0001;   % Stability factor to avoid division by zero

% Initialize variables
N = length(noisy_signal);
w = zeros(1, M);   % Filter coefficients initialized
e = zeros(1, N);   % Error signal
output = zeros(1, N);  % Filter output
muj = 0.0001 :0.0001:0.9999;
y_errtoclean = zeros(1,9999);
j = 1
% NLMS algorithm
%-----one-----%
while j<10000
    for n = M:N
        % Take the last M samples of the current time
        x = noisy_signal(n:-1:n-M+1);

        % Filter output
        output(n) = w * x';

        % Error calculation
        e(n) = clean_signal(n) - output(n);

        % Coefficients update
        norm_x = x * x' + epsilon;  % Ensure no division by zero
        w = w + 2 * muj(j) * e(n) * x / norm_x;
    end
    temp3 = mean(e(33:end).^2) ;
    temp4 = mean(clean_signal(33:end).^2) ;
    err_clean_dB = 10*log10(temp3/temp4) ;
    y_errtoclean(j) = err_clean_dB ;
    j = j + 1 ;
end
if(flag==1 && f==100 && flagF)
    nlms_SNR5f100mu0d0001 = y_errtoclean;
elseif(flag==2 && f==100 && flagF)
    nlms_SNR15f100mu0d0001 = y_errtoclean;
elseif(flag==3 && f==100 && flagF)
    nlms_SNR25f100mu0d0001 = y_errtoclean;
end
if(flag==2 && flagF==false && f==1)
    nlms_SNR15f1mu0d0001 = y_errtoclean ;
elseif(flag==2 && flagF==false && f==100)
    nlms_SNR15f100mu0d0001 = y_errtoclean ;
elseif(flag==2 && flagF==false && f==1000)
    nlms_SNR15f1000mu0d0001 = y_errtoclean ;
elseif(flag==2 && flagF==false && f==10000)
    nlms_SNR15f10000mu0d0001 = y_errtoclean ;
end
% %-----two-----%
% for n = M:N
%     % Take the last M samples of the current time
%     x = noisy_signal(n:-1:n-M+1);
% 
%     % Filter output
%     output(n) = w * x';
% 
%     % Error calculation
%     e(n) = clean_signal(n) - output(n);
% 
%     % Coefficients update
%     norm_x = x * x' + epsilon;  % Ensure no division by zero
%     w = w + 2 * mu * e(n) * x / norm_x;
% end
% temp3 = mean(e(33:end).^2) ;
% temp4 = mean(clean_signal(33:end).^2) ;
% err_clean_dB = 10*log10(temp3/temp4) ;
% err_clean_dB_single_NLMS = 10*log10(e.^2./clean_signal.^2);


% % Plotting the results
% figure;
% plot(t,err_clean_dB_single_NLMS,'ro-');
% hold on
% plot(t,ErrtoCleanSignal_single_APA,'b-');
% title('Error to Clean Signal ratio');
% xlabel('Time (s)');
% ylabel('dB');
% legend(SNRstrNLMS,SNRstrAPA);
% hold off
% 
% folderPath = '/Users/timmy29/desktop/asp/LMS_NLMS'; 
% %folderPath = 'C:\Users\f1406\Downloads\asp_matlab\LMS_NLMS\SNR相同_特性相同_步數敏感度'; % Windows样式的路径
% baseFileName = 'nlms_SNR25f10one_mu'; % 基本文件名
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
% title('Output Signal using NLMS');
% xlabel('Time (s)');
% ylabel('signal (V)');
% % saveas(gcf, jpgFileName);
% % Display the error plot
% figure;
% plot(t, e);
% title('Error Signal');
% xlabel('Time (s)');
% ylabel('signal (V)');
% baseFileName = 'nlms_SNR25f10two_mu'; % 基本文件名
% jpgFileName = fullfile(folderPath, sprintf('%s%s.jpg', baseFileName,strmu));
% % saveas(gcf, jpgFileName); 
