clc;
clear;

N_bits = 10000;                       
Eb = 1;                                
EbN0_dB = 0:1:10;                      
BER_sim = zeros(size(EbN0_dB));        
BER_theory = zeros(size(EbN0_dB));   

% Loop over each Eb/N0 value
for i = 1:length(EbN0_dB)
    % Convert Eb/N0 from dB to linear
    EbN0_linear = 10^(EbN0_dB(i)/10);
    
    % Calculate N0 based on Eb = 1
    N0 = Eb / EbN0_linear;
    
    % Step 1: Generate random bits (0 or 1)
    tx_bits = randi([0, 1], 1, N_bits);
    
    % Step 2: BPSK Modulation → 0 → -1, 1 → +1
    bpsk_signal = 2 * tx_bits - 1;
    
    % Step 3: Add Gaussian noise with variance N0/2
    noise = sqrt(N0/2) * randn(1, N_bits);
    rx_signal = bpsk_signal + noise;
    
    % Step 4: Demodulate: if >0 → 1, else → 0
    rx_bits = rx_signal > 0;
    
    % Step 5: Calculate simulated BER
    BER_sim(i) = sum(rx_bits ~= tx_bits) / N_bits;
    
    % Step 6: Calculate theoretical BER for BPSK
    BER_theory(i) = qfunc(sqrt(2 * EbN0_linear));
end

% Display results as a table
fprintf('\n   Eb/N0(dB)    Simulated BER     Theoretical BER\n');
fprintf('   ---------------------------------------------\n');
for i = 1:length(EbN0_dB)
    fprintf('     %2d            %.5f           %.5f\n', EbN0_dB(i), BER_sim(i), BER_theory(i));
end

Plot the results
figure;
semilogy(EbN0_dB, BER_theory, 'b-o', 'LineWidth', 2); hold on;
semilogy(EbN0_dB, BER_sim, 'r-s', 'LineWidth', 2);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BPSK BER vs Eb/N0');
legend('Theoretical', 'Simulated');

