function phihat = phase_estimation(r, b_train)
% phihat = phase_estimation(r, b_train)
%
% Phase estimator using the training sequence. The phase estimate is
% obtained by minimizing the norm of the difference between the known
% transmitted QPSK-modulated training sequence and the received training
% part. NB! There are other ways of estimating the phase, this is just
% one example.
%
% Input:
%   r       = received baseband signal
%   b_train = the training sequence bits
%
% Output:
%   phihat     = estimated phase


c=qpsk(b_train);% c will contain the equivalient baseband qpsk of the training sequnce
% converting the training sequene to equivalient baseband qpsk
phase_sum=0;
for i=1:length(c)
phase_sum= phase_sum + angle(r(i)*conj(c(i)));
end
phihat=(1/length(c))*phase_sum;
