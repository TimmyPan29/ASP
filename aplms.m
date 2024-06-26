clc; close all ;
% Parameter definitions
fs = 1000;         % Sampling frequency
t = 0:1/fs:1-1/fs; % Time vector
f = 10;             % Frequency of the sine wave
A_Noise = 0.8 ;
z = 1 ;
%desired signal
for i = 0:1:z-1
    clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)+A*cos(2*pi*(1+i*2)*f*t) ;
    %clean_signal = clean_signal + A*sin(2*pi*(1+i*2)*f*t)*sqrt(2).*cos(2*pi*(1+i*2)*f*t) ;
end
D = clean_signal ;
%A is signal with noise
%randn mean:0 sigma:1
n = numel(D);
noise = 0.8*randn(1,n);
temp1 = mean(noise.^2) ;
temp2 = mean()
A = D(1:n) + noise
M = 32;
wi = zeros(1,M);
E = [];
phi=0.00001 %eliminate the probability of singular matrix
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


subplot(4,1,1), plot(D);
title('Desired signal');
subplot(4,1,2), plot(A);
title('signal corrupted with Noise');
subplot(4,1,3), plot(Y);
title('Estimation signal');
subplot(4,1,4), plot(Err);
title('Error Signal');