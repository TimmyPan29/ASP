% LMS Algorithm
clc;
clear;
close all;

%% Generated signal (desire signal)
t = 0.001:0.001:1;
desire = 2*sin(2*pi*50*t);

%% noise signal
% M is tap weight number(fliter length)
M = 30;

wi = zeros(1,M);
E = [];

n = numel(desire);
add = desire(1:n) + 0.8*randn(1,n);

% parameter mu(step size)
mu = 0.001;

% iteration
for i = M:n
    E(i) = desire(i) - wi*add(i:-1:i-M+1)';
    wi = wi + 2*mu*E(i)*add(i:-1:i-M+1);
end

%% Estimation signal
Estimation = zeros(n,1);
for i = M:n
    j = add(i:-1:i-M+1);
    Estimation(i) = ((wi) * (j)');
end

Error = Estimation' - desire;

%% Display plot
subplot(4,1,1), plot(desire);
title('d(n)');
subplot(4,1,2), plot(add);
title('d(n) + noise');
subplot(4,1,3), plot(Estimation);
title('Estimation y(n)');
subplot(4,1,4), plot(Error);
title('e(n)');






