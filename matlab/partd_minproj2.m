%initialize variables, loop over 10 SNR values
L = 3;
M_train = 5;
M_c = 100;
w = zeros(M_train, L);
hhat_l = zeros(L);
fail = zeros(11, L);
probErrSim = zeros(11, L);
probErrExact = zeros(11,L);
probErrEst = zeros(11,L);

for SNRdb_1 = 1:11
SNRdb = SNRdb_1 - 1;
SNR = 10.^(SNRdb/10);

    %simulate 1000 trials of sending bit x and getting y at the Rx
    for trial = 1:5000
        %generate h_l
        h = 1/sqrt(2) * randn(L,1) + 1j/sqrt(2) * randn(L,1);
        %generate M_train noise values
        w = 1/sqrt(2) * randn(L,M_train) + 1j/sqrt(2) * randn(L,M_train);
        %calculate h(hat)_l using MMSE
        sum = 0;
        for m = 1:M_train
            sum = sum + (sqrt(SNR)/(1 + M_train * sqrt(SNR))*(h * sqrt(SNR) + w(:,m)));
        end
        hhat_l = sum;

        %send x over the channel during the remaining time on the coherence
        %interval
        x = sqrt(SNR)*((-1)^randi([0 1]));
        w = 1/sqrt(2) * randn(L,1) + 1j/sqrt(2) * randn(L,1);
        y = h * x + w;

        %ML detection, determines whether the projection of magnitude h(hat) * value of y 
        %onto the real line is closer to x or the complementary BPSK value of x 
        for l = 1:L
            h_temp = hhat_l(1:l);
            y_temp = y(1:l);
            decider = real(((h_temp')*y_temp)/norm(h_temp));
            if (abs(decider - x) > abs(decider - (-1 * x))) 
                fail(SNRdb_1, l) = fail(SNRdb_1, l) + 1;
            end
            %calculate the error rate
            probErrSim(SNRdb_1, l) = (fail(SNRdb_1,l)/trial);
        end
    end

    %exact error probablity for each L
    mu = sqrt(SNR/(1 + SNR));
    for l_temp = 1:L
        sum = 0; % reset the summation over l for each L
        for l = 0:(l_temp - 1)
           sum = sum + (((1 - mu)/2))^l_temp * nchoosek(l_temp - 1 + l, l) * ((1 + mu)/2)^l;
           probErrExact(SNRdb_1,l_temp) = sum;
        end
    end
    
end

SNRdb = transpose(0:10);
semilogy(SNRdb,probErrSim);
hold on 
semilogy(SNRdb,probErrExact);
hold off
legend('Simulated Error, L = 1', 'Simulated Error, L = 2', 'Simulated Error, L = 3', ... 
'Exact error, L =1', 'Exact error, L =2', 'Exact error, L =3');
xlabel('SNR in dB')
ylabel('Error percentage (log scale)')