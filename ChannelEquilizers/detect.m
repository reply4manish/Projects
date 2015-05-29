function bhat = detect(r)
% bhat = detect(r)
%
% Computes the received bits given a received sequence of (phase-corrected)
% QPSK symbols. Gray coding of the individual bits is assumed. Hence, the
% two bits for each symbol can be detected from the real and imaginary
% parts, respectively. The first of the two bits below is output first in
% the bhat-sequence.
%
% Assumed mapping:
%
%  10 x   |   x 00
%         |
%  -------+-------
%         |
%  11 x   |   x 01
%
% Input:
%   r  = sequence of complex-valued QPSK symbols
%
% Output:
%   bhat  = bits {0,1} corresponding to the QPSK symbols

detected=[];
y_IComponent=real(r);
y_QComponent=imag(r);
for k=1:length(r)

if(y_QComponent(1,k)>0)
    detectedQ=0;
else
    detectedQ=1;
end    
if(y_IComponent(1,k)>0)
    detectedI=0;
else
    detectedI=1;
end    
detected=[detected detectedI detectedQ];

end
bhat= detected;
