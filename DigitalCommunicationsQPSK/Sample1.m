clear all; clc;
n=10; %Number of data symbols
Tsym=8; %Symbol time interms of sample time or oversampling rate equivalently
%data=2*(rand(n,1)&lt;0.5)-1;
data=[1 -1 1 -1 1 -1 1 -1 1 -1]'; %BPSK data
bpsk=reshape(repmat(data,1,Tsym)',n*Tsym,1); %BPSK signal

figure('Color',[1 1 1]);
subplot(3,1,1);
plot(bpsk);
title('Ideal BPSK symbols');
xlabel('Sample index [n]');
ylabel('Amplitude')
set(gca,'XTick',0:8:80);
axis([1 80 -2 2]); grid on;