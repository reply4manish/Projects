clear
%the frequencies range
v=(0:0.001:0.5);
%filters are in Z-domain, z=exp(i*2*pi*v); is to convert them to frequncy
%domain
z=exp(i*2*pi*v);
% the Filters were derived after finding Q(z) which satisfies the nobel
% identites 
H0=-0.125 + 0.25.*(z.^-1)+ 0.75.*(z.^-2)+ 0.25.*(z.^-3)- 0.125*(z.^-4);
G0=0.5 + (z.^-1) + 0.5.*(z.^-2);
H1=0.5 - (z.^-1) + 0.5.*(z.^-2);
G1=0.125 + 0.25.*(z.^-1)- 0.75.*(z.^-2)+ 0.25.*(z.^-3)+ 0.125*(z.^-4);
% plotting the filters 




subplot(2,2,1)
plot((0:0.001:0.5),abs(H0)) 
title('H0(v)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('Abs(H0(v))') % y-axis label

subplot(2,2,2)
plot((0:0.001:0.5),abs(G0)) 
title('G0(v)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('Abs(G0(v))') % y-axis label

subplot(2,2,3)
plot((0:0.001:0.5),abs(H1)) 
title('H1(v)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('Abs(H1(v))') % y-axis label

subplot(2,2,4)
plot((0:0.001:0.5),abs(G1)) 
title('G1(v)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('Abs(G1(v))') % y-axis label




