function [ H , freq ] = powerspectrum( ai, ti )
%Calculate the power distribution across frequencies 0 to 2E9 hz using
%the equation for channel frequency response
freq = zeros(1000,1);
partialH = zeros(size(ai,1),1);
H = freq;
    for freqindex = 1:1000
        freq(freqindex) = 890 * 10^6 + 20000 * freqindex;
        for i = 1:size(ai)
            partialH(i) = (ai(i)*exp(-1i*2*pi*freq(freqindex)*ti(i)));
        end
        H(freqindex) = 20*log10(abs(sum(partialH)));
    end
plot(freq,H)
title('Channel power spectrum at time t=0')
xlabel('Frequency')
ylabel('Power gain in dB')
end




