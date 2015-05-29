
clear
%The filters in Time Domain:
h0=[-0.125  0.25  0.75 0.25  -0.125];
g0=[0.5 1 0.5];
h1=[0.5 -1 0.5];
g1=[0.125 0.25 -0.75 0.25 0.125];
%assume an input signal y=[10];
[y, Fs, nbits]=wavread('orinoccio.wav');

%Listen(Input signal)
sound(y);


%applying figure 1 upper branch:
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

%Allocations of bits to each decimated frequency signal
%Quantization and Sclaing using fixed function

% y1_z=fixed(2,y1);
% y01_z=fixed(6,y01);
% y00_z=fixed(6,y00);
bits_y1=2;
bits_y01=4;
bits_y00=8;

scaling=max(abs(y1))/(1-pow2(-bits_y1));
y1_z = scaling*double(fixed(bits_y1, y1/scaling));

scaling=max(abs(y01))/(1-pow2(-bits_y01));
y01_z = scaling*double(fixed(bits_y01, y01/scaling));

scaling=max(abs(y00))/(1-pow2(-bits_y00));
y00_z = scaling*double(fixed(bits_y00, y00/scaling));

%Applying Synthesis part of Filter Banks

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
yr=y1r+y2r;%recovered signal y

%Listen receievd v(n)
sound(yr) % Yr ar 32kbps

% Directly change input to 32kbps
scaling=max(abs(y))/(1-pow2(-4));
y_32kbps = scaling*double(fixed(4, y/scaling));

% y_32kbps=fixed(4,y);
% y_32kbps=double(y_32kbps);

%Listen Orginal signal @32kbps
sound((y_32kbps)); %orginal signal at 32kbps

shifted_input = delayseq(y,10); %shift the input signal by 9 samples
shifted_input1=[shifted_input;zeros(1,length(yr)-length(shifted_input))']; %padding zeros to signal so to match matrix length

%other way round to match the matrix dimensions instead of paddinf zeros
% yr=transpose(yr);
% yr=yr(1:length(y_32kbps));
% yr=transpose(yr);

SQNRWithFilterbanks= ((mean(y.^2))./(mean((yr-shifted_input1).^2))); %SQNR when we use filter banks for rate conversion
SQNRWithDirectRateChange = ((mean(y.^2))./(mean((y_32kbps-y).^2))); % SQNR when we directly reduce rate by alloating 4 bits/Quantization and scaling.


str1=sprintf('Reconstructed Signal at 32kbps SQNR(dB): %f\n',10*log10(SQNRWithFilterbanks));
str2=sprintf('Original Signal Quantized at  32kbps  SQNR(dB): %f\n',10*log10(SQNRWithDirectRateChange));
%plotting Y and yr reducea at 32Kbps using Filter banks 
plotspectrum((yr),'b'); hold on;
plotspectrum(y_32kbps,'r'); 
title('Frequency spectrum of the Input and Received signal at 32kbps');
xlabel('Normalized Frequency (v)') % x-axis label
legend(str1,str2);
ylabel('|Y(v)| (dB)') % y-axis label

% str1=sprintf('Reconstructed Signal at 32kbps SQNR: %f\n',SQNRWithFilterbanks);
% str2=sprintf('Original Signal Quantized at  32kbps  SQNR: %f\n',SQNRWithDirectRateChange);
% %plotting Y and yr reducea at 32Kbps using Filter banks 
% plotspectrum((yr),'b'); hold on;
% plotspectrum(y,'r'); hold on;
% plotspectrum(y_32kbps,'g');
% title('Frequency spectrum of the Input and Received signal at 32kbps');
% xlabel('Normalized Frequency (v)') % x-axis label
% legend('yr','y','y_32kbps');
% ylabel('|Y(v)| (dB)') % y-axis label



