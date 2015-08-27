% Skeleton code for simulation chain


clear
t_samparray=[];
  
% Initialization
EbN0_db = 0:10;                     % Eb/N0 values to simulate (in dB)
nr_bits_per_symbol = 2;             % Corresponds to k in the report
nr_guard_bits = 10;                 % Size of guard sequence (in nr bits)
                                    % Guard bits are appended to transmitted bits so
                                    % that the transients in the beginning and end
                                    % of received sequence do not affect the samples
                                    % which contain the training and data symbols.
nr_data_bits = 1000;                % Size of each data sequence (in nr bits)
nr_training_bits = 100;             % Size of training sequence (in nr bits)
nr_blocks = 50;                     % The number of blocks to simulate
Q = 8;                              % Number of samples per symbol in baseband
temp_samp=[];

pulse_shape = ones(1, Q);
%pulse_shape = root_raised_cosine(Q);

% Matched filter impulse response. 
mf_pulse_shape = fliplr(pulse_shape);


% Loop over different values of Eb/No.
nr_errors = zeros(1, length(EbN0_db));   % Error counter
for snr_point = 1:length(EbN0_db)
  
  % Loop over several blocks to get sufficient statistics.
  for blk = 1:nr_blocks

    %%%
    %%% Transmitter
    %%%

    % Generate training sequence.
    b_train = training_sequence(nr_training_bits);
    
    % Generate random source data {0, 1}.
    b_data = random_data(nr_data_bits);

    % Generate guard sequence.
    b_guard = random_data(nr_guard_bits);
 
    % Multiplex training and data into one sequence.
    b = [b_guard b_train b_data b_guard];
    
    % Map bits into complex-valued QPSK symbols.
    d = qpsk(b);

    % Upsample the signal, apply pulse shaping.
    tx = upfirdn(d, pulse_shape, Q, 1);

     
    %%%
    %%% AWGN Channel
    %%%
    
    % Compute variance of complex noise according to report.
    sigma_sqr = norm(pulse_shape)^2 / nr_bits_per_symbol / 10^(EbN0_db(snr_point)/10);

    % Create noise vector.
    n = sqrt(sigma_sqr/2)*(randn(size(tx))+j*randn(size(tx)));

    % Received signal.
    
    rx = tx + n;

    %%%
    %%% Receiver
    %%%
    % Matched filtering.
    mf=conv(mf_pulse_shape,rx);
%Synchronization
t_start=1+Q*nr_guard_bits/2;
t_end=t_start+18;
t_samp = sync(mf, b_train, Q, t_start, t_end);
t_samparray=[t_samparray, t_samp];

   
    
    
    k=t_samp:Q:t_samp+Q*(nr_training_bits+nr_data_bits)/2-1;
    r = mf(t_samp:Q:t_samp+Q*(nr_training_bits+nr_data_bits)/2-1);

     
    % Phase estimation and correction.
    phihat = phase_estimation(r, b_train);
    r = r * exp(-j*phihat);
      
    r = r * exp(j*0);
    bhat = detect(r);
    temp=bhat(1+nr_training_bits:nr_training_bits+nr_data_bits) ~= b_data;
    nr_errors(snr_point) = nr_errors(snr_point) + sum(temp);

    % Next block.
  end

  % Next Eb/No value.
end

% Compute the BER. 
BER = nr_errors / nr_data_bits / nr_blocks;

semilogy((EbN0_db),BER,'b*-');grid on;hold on
thr=erfc(sqrt(2*10.^(EbN0_db/10)));
semilogy((EbN0_db),thr,'rx-');grid on;
xlabel('Eb/No (dB)');
ylabel('Bit Error rate');
title('Simulated Vs Theoritical Bit Error Rate for QPSK');
legend('Simulation','Theory');

