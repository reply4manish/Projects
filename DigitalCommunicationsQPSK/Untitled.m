
nr_training_bits = 100;             % Size of training sequence (in nr bits)
Q = 8;                              % Number of samples per symbol in baseband
b_train = training_sequence(nr_training_bits);
nr_guard_bits = 10;                 % Size of guard sequence (in nr bits)
t_start=1+Q*nr_guard_bits/2;
t_end=t_start+10;


c=qpsk(b_train);
r=[];
for(t=t_start:t_end)
for(k=1:50)
  r(k)=mf(Q*k+t);
end
end

crosscorrelation=abs(xcorr(r,c,'biased'));
[row,col] = max(crosscorrelation(:));
t_samp=col+t_start;
