clear
%The filters in Time Domain:
h0=[-0.125  0.25  0.75 0.25  -0.125];
g0=[0.5 1 0.5];
h1=[0.5 -1 0.5];
g1=[0.125 0.25 -0.75 0.25 0.125];
%assume an input signal y=[10];
%[y, Fs, nbits]=wavread('thank.wav');
[y, Fs, nbits]=wavread('thank.wav');

%Listen(Input signal)
soundsc(y,8000);


%% Applying Analysis Filters to the input signal

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


%% Plot Signal Energy before quantization

figure(1);
plotspectrum(y1,'r'); hold on;
plotspectrum(y01,'b'); hold on;
plotspectrum(y00,'g');
title('Frequency spectrum of the different decimated Signal component after Analysis part');
xlabel('Normalized Frequency (v)') % x-axis label
legend('Signal component y1','Signal component y01','Signal component y00');
ylabel('|Y(v)| (dB)') % y-axis label

%% Inplement Quantization and assign Bits to different frequency components

scaling=max(abs(y1))/(1-pow2(-2));
y1_z = scaling*double(fixed(2, y1/scaling));
soundsc(y1_z,2000);

scaling=max(abs(y01))/(1-pow2(-4));
y01_z = scaling*double(fixed(4, y01/scaling));
soundsc(y01_z,4000);

scaling=max(abs(y00))/(1-pow2(-8));
y00_z = scaling*double(fixed(8, y00/scaling));
soundsc(y00_z,4000);



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
soundsc(yr,8000) % Yr ar 32kbps

% Directly change input to 32kbps
scaling=max(abs(y))/(1-pow2(-4));
y_32kbps = scaling*double(fixed(4, y/scaling));

%Listen Orginal signal @32kbps
soundsc((y_32kbps),8000); %orginal signal at 32kbps

tempz=[];
for i=1:1:length(y)
    tempy = y(i);
    tempz(i+9)=tempy;
end
y_delayed=tempz;

%shifted_input = delayseq(y,10); %shift the input signal by 9 samples
%shifted_input_Properlength=[shifted_input;zeros(1,length(yr)-length(shifted_input))']; %padding zeros to signal so to match matrix length
yyy=transpose(zeros(1,length(yr)-length(y_delayed)));
shifted_input_Properlength=[transpose(y_delayed);(zeros(1,length(yr)-length(y_delayed)))'];

%other way round to match the matrix dimensions instead of padding zeros

SQNRWithFilterbanks= ((mean(y.^2))/(mean((yr-shifted_input_Properlength).^2))); %SQNR when we use filter banks for rate conversion
SQNRWithDirectRateChange = ((mean(y.^2))./(mean((y_32kbps-y).^2))); % SQNR when we directly reduce rate by alloating 4 bits/Quantization and scaling.
%SQNRWithDirectRateChange= ((mean(y.^2))/(2^(-2*3)/12)); % SQNR when we directly reduce rate by alloating 4 bits/Quantization and scaling.

str1=sprintf('Reconstructed Signal at 32kbps SQNR(dB): %f\n',10*log10(SQNRWithFilterbanks));
str2=sprintf('Original Signal Quantized at  32kbps  SQNR(dB): %f\n',10*log10(SQNRWithDirectRateChange));
%plotting Y and yr reducea at 32Kbps using Filter banks 
figure(2);
plotspectrum((yr),'b'); hold on;
plotspectrum(y_32kbps,'r');

figure(3);
for i=1:1:length(y_32kbps)
    tempy = y(i);
    tempz(i+9)=tempy;
end
y_delayed=tempz;
shifted_32kbps_Properlength=[transpose(y_delayed);(zeros(1,length(yr)-length(y_delayed)))'];

% zzz=-abs(yr)+abs(shifted_32kbps_Properlength);
% plotspectrumQ5(zzz);
plotspectrum(yr-shifted_32kbps_Properlength,'r');


title('Frequency spectrum of the Input and Received signal at 32kbps');
xlabel('Normalized Frequency (v)') % x-axis label
legend(str1,str2);
ylabel('|Y(v)| (dB)') % y-axis label





