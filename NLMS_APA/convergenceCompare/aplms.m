clc; close all ;
% Parameter definitions
fs = 1000;         % Sampling frequency
t = 0:1/fs:1-1/fs; % Time vector
f = 10;             % Frequency of the sine wave
A_Noise = 0.8 ;
z = 1 ;
A = 1.4226; SNRstrAPA = 'APA SNR=5' ;
%A = 4.4987; SNRstrAPA = 'APA SNR=15' ;
%A = 14.2262; SNRstrAPA = 'APA SNR=25' ;
clean_signal = 0 ;
%desired signal
for i = 0:1:z-1
    clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)+A*cos(2*pi*(1+i*2)*f*t) ;
    %clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)*sqrt(2).*cos(2*pi*(1+i*2)*f*t) ;
end
D = clean_signal ;
%A is signal with noise
%randn mean:0 sigma:1
n = numel(D);
noise = A_Noise*randn(1,n);
temp1 = mean(noise.^2) ;
temp2 = mean(clean_signal.^2);
SNR = 10*log10(temp2/temp1)
A = D(1:n) + noise ;
M = 32;
wi = zeros(1,M);
E = [];
phi=0.00001; %eliminate the probability of singular matrix
mu = 0.1;
for i = M:n
    I = eye(M);
    E(i) = D(i) - wi*A(i:-1:i-M+1)';
    wi = wi + mu*A(i:-1:i-M+1)*(inv(A(i:-1:i-M+1)'*A(i:-1:i-M+1)+phi*I))*E(i);
end

%estimation signal
Y = zeros(n,1);
for i = M:n
    j = A(i:-1:i-M+1);
    Y(i) = ((wi)*(j)');
end

%error signal
Err = Y'- D;
temp3 = mean(Err(33:end).^2) ;
temp4 = mean(clean_signal(33:end).^2) ;
ErrtoCleanSignal = 10*log10(temp3/temp4) 
ErrtoCleanSignal_single_APA = 10*log10(Err.^2./clean_signal.^2);

%Plot
figure ;
subplot(4,1,1), plot(t,D);
title('Desired signal');
xlabel('Time (s)');
ylabel('signal (V)');
subplot(4,1,2), plot(t,A);
title('signal corrupted with Noise');
xlabel('Time (s)');
ylabel('signal (V)');
subplot(4,1,3), plot(t,Y);
title('Estimation signal');
xlabel('Time (s)');
ylabel('signal (V)');
subplot(4,1,4), plot(t,Err);
title('Error Signal');
xlabel('Time (s)');
ylabel('signal (V)');

figure ;
title('Error to Clean Signal ratio');
xlabel('Time (s)');
ylabel('dB');
plot(t,ErrtoCleanSignal_single_APA);
legend(SNRstrAPA);