function d = qpsk(b)
if (b==[0,0]) 
    d=exp(i*pi/4);
end

if (b==[0,1]) 
    d=exp(i*7*pi/4);
end
if (b==[1,0]) 
    d=exp(i*3*pi/4);
end
if (b==[1,1]) 
    d=exp(i*5*pi/4);
end
;
% d = qpsk(b)
%
% Map the bits to be transmitted into QPSK symbols using Gray coding. 
%The resulting QPSK symbol is complex-valued, where one of the two bits 
%in each QPSK symbol affects the real part (I channel) of the symbol and
%the other bit the imaginary part (Q channel). Each part is subsequently
%PAM modulated to form the complex-valued QPSK symbol. The energy per QPSK
% symbol is normalized to unity.
%
% The mapping resulting from the two PAM branches are:
%
% complex part (Q channel)
%         ^
%         |
%  10 x   |   x 00   (odd bit, even bit)
%         |
%  -------+------->  real part (I channel)
%         |
%  11 x   |   x 01
%         |
%
%
%
% Input:
%   b = bits {0, 1} to be mapped into QPSK symbols
%
% Output:
%   d = complex-valued QPSK symbols


