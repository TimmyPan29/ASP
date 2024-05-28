clear;
clc;
close all;
f=100;

%desired signal
t = 0:0.001:1-0.001;
D = 2*sin(2 * pi * 2*f * t)+2*sin(2 * pi * 3*f * t)+2*sin(2 * pi * 5*f * t)+2*sin(2 * pi * 7*f * t)+2*cos(2 * pi * 2*f * t)+2*cos(2 * pi * 3*f * t)+2*cos(2 * pi * 5*f * t)+2*cos(2 * pi * 7*f * t);
%D = 2*sin(2 * pi * 2*f * t)+2*sin(2 * pi * 3*f * t)+2*sin(2 * pi * 5*f * t)+2*sin(2 * pi * 7*f * t);
%A is signal with noise
%randn mean:0 sigma:1
n = numel(D);
A = D(1:n)+0.8*randn(1,n);

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