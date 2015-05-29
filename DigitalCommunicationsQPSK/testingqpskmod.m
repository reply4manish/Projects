EbN0_db = 0:10;                     % Eb/N0 values to simulate (in dB)
nr_bits_per_symbol = 2;             % Corresponds to k in the report
nr_guard_bits = 10;                 % Size of guard sequence (in nr bits)
                                    % Guard bits are appended to transmitted bits so
                                    % that the transients in the beginning and end
                                    % of received sequence do not affect the samples
                                    % which contain the training and data symbols.
nr_data_bits = 100;                % Size of each data sequence (in nr bits)
nr_training_bits = 100;             % Size of training sequence (in nr bits)
nr_blocks = 50;                     % The number of blocks to simulate
Q = 8;                              % Number of samples per symbol in baseband
b_train = training_sequence(nr_training_bits);

%b=random_data(100);
pulse_shape = ones(1, 8);
%d=qpsk(b);


b_data = random_data(nr_data_bits);

    % Generate guard sequence.
    b_guard = random_data(nr_guard_bits);
 
    % Multiplex training and data into one sequence.
    b = [b_guard b_train b_data b_guard];
    
    % Map bits into complex-valued QPSK symbols.
    d = qpsk(b);




br=length(b);
T=1/br; % bit duration
t=T/99:T/99:T; % Time vector for one bit information
tt=1:1:length(b)*4;
tx = upfirdn(d, pulse_shape, 8, 1);
 sigma_sqr = norm(pulse_shape)^2 / nr_bits_per_symbol / 10^(EbN0_db(1)/10);
   n = sqrt(sigma_sqr/2)*(randn(size(tx))+j*randn(size(tx)));
   rx = tx + n;
figure(1)
plot(tt,tx);
figure(2);
plot(tt,rx);
mf_pulse_shape = fliplr(pulse_shape);
 mf=conv(mf_pulse_shape,rx);

 tp=1:1:887;
 figure(3);
 plot(tp,mf);grid on;
    t_start=1+Q*nr_guard_bits/2;
    t_end=t_start+50;
    t_samp = sync(mf, b_train, Q, t_start, t_end);
    
    
     r = mf(t_samp:Q:t_samp+Q*(nr_training_bits+nr_data_bits)/2-1);

    % Phase estimation and correction.
    phihat = phase_estimation(r, b_train);
    r = r * exp(-j*phihat);
    
    
