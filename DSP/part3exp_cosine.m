clear
%The filters in Time Domain:
h0=[-0.125  0.25  0.75 0.25  -0.125];
g0=[0.5 1 0.5];
h1=[0.5 -1 0.5];
g1=[0.125 0.25 -0.75 0.25 0.125];
%assume an input signal y=[10];
% [y, Fs, nbits]=wavread('thank.wav');

n=(0:100000);

y=(.9.^n);
%applying figure 1 upper branch:
v0=conv(y,h1);
y1=downsample(v0,2);
%applying fi    gure 1 lower branch-a:
v1=conv(y,h0);
x=downsample(v1,2);
ra=conv(x,h1);
y01=downsample(ra,2);
%applying figure 1 lower branch-b:
rb=conv(x,h0);
y00=downsample(rb,2);

%No Quantizer to be used here
%Applying Figure 2 
%Figure 2 upper branch
delay_filter=[0  0 0 1];
l=conv(y1,delay_filter);
r0= upsample(l,2);
y1r=conv(r0,g1);% First recovered part

%Figure 2 lower branch-a
r1=upsample(y01,2);
r2=upsample(y00,2);
p0=conv(r1,g1);
p1=conv(r2,g0);
p=p0+p1;
%Figure 2 lower branch-b
m=upsample(p,2);
y2r=conv(m,g0);

%merging the two sequnces:
ly1r=length(y1r);% length of y1r
ly2r=length(y2r);% length of y2r
%zero badding
if (ly1r>ly2r)
y2r=[y2r,zeros(1,(ly1r-ly2r))];
end
if (ly1r<ly2r)
y1r=[y1r,zeros(1,(ly2r-ly1r))];
end
yr=y1r+y2r;%recovered signal y

%plotting i/p signal Y(v)
subplot(2,2,1)
plotspectrum(y); 
title('Frequency spectrum of the input signal y(n)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('|Y(v)| (dB)') % y-axis label

%plotting Decimated signals 
subplot(2,2,2)
plotspectrum(y1); 
title('Frequency spectrum of the decimated signal y1(n)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('|Y1(v)| (dB)') % y-axis label

subplot(2,2,3)
plotspectrum(y01); 
title('Frequency spectrum of the decimated signal y01(n)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('|Y01(v)| (dB)') % y-axis label


subplot(2,2,4)
plotspectrum(y00); 
title('Frequency spectrum of the decimated signal y00(n)')
xlabel('Normalized Frequency (v)') % x-axis label
ylabel('|Y00(v)| (dB)') % y-axis label
