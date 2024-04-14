%initialize variables, loop over 10 SNR values
L = 3;
fail = zeros(11, L);
probErrSim = zeros(11, L);
probErrExact = zeros(11,L);
probErrEst = zeros(11,L);

for SNRdb_1 = 1:11
SNRdb = SNRdb_1 - 1;
SNR = 10.^(SNRdb/10);

    %simulate 1000 trials of sending bit x and getting y at the Rx
    for trial = 1:1000
        h = 1/sqrt(2) * randn(L,1) + 1j/sqrt(2) * randn(L,1);
        w = 1/sqrt(2) * randn(L,1) + 1j/sqrt(2) * randn(L,1);
        x = sqrt(SNR)*((-1)^randi([0 1]));
        y = h * x + w;

        %ML detection, determines whether the projection of magnitude h * value of y 
        %onto the real line is closer to x or the complementary BPSK value of x 
        for l = 1:L
            h_temp = h(1:l);
            y_temp = y(1:l);
            h_transpose = h_temp';
            decider = real(((h_temp)'*y_temp)/norm(h_temp));
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
    
    %estimated error probability for each L
    for l = 1:L
    probErrEst(SNRdb_1, l) = nchoosek(2*l - 1, l)*(1/((4 * SNR)^l));
    end

end

SNRdb = transpose(0:10);
semilogy(SNRdb,probErrSim);
hold on 
semilogy(SNRdb,probErrExact);
semilogy(SNRdb,probErrEst);
hold off
legend('Simulated Error, L = 1', 'Simulated Error, L = 2', 'Simulated Error, L = 3', ... 
'Exact error, L =1', 'Exact error, L =2', 'Exact error, L =3', ...
'Estimated error, L=1', 'Estimated error, L=2', 'Estimated error, L=3');
xlabel('SNR in dB')
ylabel('Error percentage (log scale)')

