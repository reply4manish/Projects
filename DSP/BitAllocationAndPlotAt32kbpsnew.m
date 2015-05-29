clear
%The filters in Time Domain:
h0=[-0.125  0.25  0.75 0.25  -0.125];
g0=[0.5 1 0.5];
h1=[0.5 -1 0.5];
g1=[0.125 0.25 -0.75 0.25 0.125];
%assume an input signal y=[10];
%[y, Fs, nbits]=wavread('thank.wav');
[y, Fs, nbits]=wavread('thank.wav');
[y_ori, Fs_ori, nbits_ori]=wavread('orinoccio.wav');

%Listen(Input signal)
%soundsc(y,8000);


%% Applying Analysis Filters to the input signal to thank.wav

v0=conv(y,h1);
y1=downsample(v0,2); % part one of the spectrum to be transmitted

%applying Analysis part of Filter banks
v1=conv(y,h0);
x=downsample(v1,2);
ra=conv(x,h1);
y01=downsample(ra,2); % part two of the spectrum to be transmitted

%applying figure 1 lower branch-b:
rb=conv(x,h0);
y00=downsample(rb,2); % part 3 of the spectrum to be transmitted

%% Applying Analysis Filters to the input signal to orinoccio.wav

v0_ori=conv(y_ori,h1);
y1_ori=downsample(v0_ori,2); % part one of the spectrum to be transmitted

%applying Analysis part of Filter banks
v1_ori=conv(y_ori,h0);
x_ori=downsample(v1_ori,2);
ra_ori=conv(x_ori,h1);
y01_ori=downsample(ra_ori,2); % part two of the spectrum to be transmitted

%applying figure 1 lower branch-b:
rb_ori=conv(x_ori,h0);
y00_ori=downsample(rb_ori,2); % part 3 of the spectrum to be transmitted


%% Inplement Quantization and assign Bits to different frequency components for thank.wav

scaling=max(abs(y1))/(1-pow2(-2));
y1_z = scaling*double(fixed(2, y1/scaling));
%soundsc(y1_z,2000);

scaling=max(abs(y01))/(1-pow2(-4));
y01_z = scaling*double(fixed(4, y01/scaling));
%soundsc(y01_z,4000);

scaling=max(abs(y00))/(1-pow2(-8));
y00_z = scaling*double(fixed(8, y00/scaling));
%soundsc(y00_z,4000);


%% Inplement Quantization and assign Bits to different frequency components for oricco.wav

scaling=max(abs(y1_ori))/(1-pow2(-2));
y1_z_ori = scaling*double(fixed(2, y1_ori/scaling));
%soundsc(y1_z_ori,2000);

scaling=max(abs(y01_ori))/(1-pow2(-4));
y01_z_ori = scaling*double(fixed(4, y01_ori/scaling));
%soundsc(y01_z_ori,4000);

scaling=max(abs(y00_ori))/(1-pow2(-8));
y00_z_ori = scaling*double(fixed(8, y00_ori/scaling));
%soundsc(y00_z_ori,4000);



%% Applying Synthesis part of Filter Banks

%Figure 2 upper branch
delay_filter=[0  0 0 1];
l=conv((y1_z),delay_filter);
r0= upsample(l,2);
y1r=conv(r0,g1);% First recovered part

%Figure 2 lower branch-a
r1=upsample((y01_z),2);
r2=upsample((y00_z),2);
p0=conv(r1,g1);
p1=conv(r2,g0);
p=p0+p1;

%Figure 2 lower branch-b
m=upsample(p,2);
y2r=conv(m,g0);

%Merging the two sequnces:
ly1r=length(y1r);% length of y1r
ly2r=length(y2r);% length of y2r
%zero padding
if (ly1r>ly2r)
y2r=[y2r;zeros(1,(ly1r-ly2r))'];
end
if (ly1r<ly2r)
y1r=[y1r;zeros(1,(ly2r-ly1r))'];
end

iiii=zeros(1,(ly2r-ly1r));
yr=y1r+y2r;%recovered signal y

%Listen receievd v(n)
%soundsc(yr,8000) % Yr ar 32kbps

% Directly change input to 32kbps
scaling=max(abs(y))/(1-pow2(-4));
y_32kbps = scaling*double(fixed(4, y/scaling));

for i=1:1:length(y_32kbps)
    tempy = y_32kbps(i);
    tempz(i+9)=tempy;
end
y_delayed_32kbps_thank=tempz;
shifted_32kbps_Properlength_thank=[transpose(y_delayed_32kbps_thank);(zeros(1,length(yr)-length(y_delayed_32kbps_thank)))'];


%Listen Orginal signal @32kbps
%soundsc((y_32kbps),8000); %orginal signal at 32kbps

tempz=[];
for i=1:1:length(y)
    tempy = y(i);
    tempz(i+9)=tempy;
end
y_delayed=tempz;

shifted_input_Properlength_thank=[transpose(y_delayed);(zeros(1,length(yr)-length(y_delayed)))'];
SQNRWithFilterbanks_thank= ((mean(y.^2))/(mean((yr-shifted_input_Properlength_thank).^2))); %SQNR when we use filter banks for rate conversion
SQNRWithDirectRateChange_thank = ((mean(y.^2))./(mean((y_32kbps-y).^2))); % SQNR when we directly reduce rate by alloating 4 bits/Quantization and scaling.


%% Applying Synthesis part of Filter Banks

%Figure 2 upper branch
delay_filter=[0  0 0 1];
l=conv((y1_z_ori),delay_filter);
r0_ori= upsample(l,2);
y1r_ori=conv(r0_ori,g1);% First recovered part

%Figure 2 lower branch-a
r1_ori=upsample((y01_z_ori),2);
r2_ori=upsample((y00_z_ori),2);
p0_ori=conv(r1_ori,g1);
p1_ori=conv(r2_ori,g0);
p_ori=p0_ori+p1_ori;

%Figure 2 lower branch-b
m=upsample(p_ori,2);
y2r_ori=conv(m,g0);

%Merging the two sequnces:
ly1r=length(y1r_ori);% length of y1r
ly2r=length(y2r_ori);% length of y2r
%zero padding
if (ly1r>ly2r)
y2r_ori=[y2r_ori;zeros(1,(ly1r-ly2r))'];
end
if (ly1r<ly2r)
y1r_ori=[y1r_ori;zeros(1,(ly2r-ly1r))'];
end

iiii=zeros(1,(ly2r-ly1r));
yr_ori=y1r_ori+y2r_ori;%recovered signal y

%Listen receievd v(n)
%soundsc(yr,8000) % Yr ar 32kbps

% Directly change input to 32kbps
scaling=max(abs(y_ori))/(1-pow2(-4));
y_32kbps_ori = scaling*double(fixed(4, y_ori/scaling));

for i=1:1:length(y_32kbps_ori)
    tempy = y_32kbps_ori(i);
    tempz(i+9)=tempy;
end
y_delayed_32kbps_ori=tempz;
shifted_32kbps_Properlength_ori=[transpose(y_delayed_32kbps_ori);(zeros(1,length(yr_ori)-length(y_delayed_32kbps_ori)))'];

%Listen Orginal signal @32kbps
%soundsc((y_32kbps_ori),8000); %orginal signal at 32kbps

tempz=[];
for i=1:1:length(y_ori)
    tempy = y_ori(i);
    tempz(i+9)=tempy;
end
y_delayed_ori=tempz;

shifted_input_Properlength_ori=[transpose(y_delayed_ori);(zeros(1,length(yr_ori)-length(y_delayed_ori)))'];

SQNRWithFilterbanks_ori= ((mean(y_ori.^2))/(mean((yr_ori-shifted_input_Properlength_ori).^2))); %SQNR when we use filter banks for rate conversion
SQNRWithDirectRateChange_ori = ((mean(y_ori.^2))./(mean((y_32kbps_ori-y_ori).^2))); % SQNR when we directly reduce rate by alloating 4 bits/Quantization and scaling.

str1=sprintf('Error Spectrum thank.wav SQNR(dB) v(n)-y(n):%0.2f\n',10*log10(SQNRWithFilterbanks_thank));
str2=sprintf('Error Spectrum orinoccio.wav SQNR(dB) v(n)-y(n): %0.2f\n',10*log10(SQNRWithFilterbanks_ori));
str3=sprintf('Error Spectrum(thank)quantized at 32kbps SQNR(dB):%0.2f\n',10*log10(SQNRWithDirectRateChange_thank));
str4=sprintf('Error Spectrum(orinoccio)quantized at 32kbps SQNR(dB):%0.2f\n',10*log10(SQNRWithDirectRateChange_ori));

%plotspectrum(-yr+shifted_input_Properlength_thank,'r');hold on;
plotspectrum(y-y_32kbps,'r');hold on;
%plotspectrum(-yr_ori+shifted_input_Properlength_ori,'k');hold on;
plotspectrum(y_ori-y_32kbps_ori,'k');hold on;
%plotspectrum(y_ori,'b');


% [pyr_ori,f_ori]=plotspectrumQ5(yr_ori,'r');hold on;
% [py_ori_32,f_ori_32]=plotspectrumQ5(shifted_32kbps_Properlength_ori,'b');
% 
% [pyr_thank,f_thank]=plotspectrumQ5(yr,'r');hold on;
% [py_thank_32,f_thank_32]=plotspectrumQ5(shifted_32kbps_Properlength_thank,'b');
% 
% plot(10*log10(py_thank_32-pyr_thank));hold on;grid on;
% plot(10*log10(py_ori_32-pyr_ori));


%title('Frequency spectrum of the Error between reconstructed and original input signals');
title('Frequency spectrum of the Error between directly quantized and input signals');
xlabel('Normalized Frequency (v)') % x-axis label
%legend(str1,str2);
legend(str3,str4);
ylabel('|Y(v)| (dB)') % y-axis label





