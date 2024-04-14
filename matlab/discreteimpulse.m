function [ h ] = discreteimpulse( ai, ti )
%Calculate the impulse response for the channel at m=0, using the formula
%for discrete time.  W = 1 MHz, and fc = 1.9 GHz.  Trial and error to
%generate the necessary number of taps without having too many that are
%essentially zero.

%initialize necessary variables
fc  = 900 * 10^6;
W = 1 *10 ^ 6;

%loop over all values of ai and ti
partialh = zeros(size(ai,1),1);
l = zeros(21,1);
h = l;
    for j = 1:size(l,1)
        l(j) = j-1;
        for i = 1:size(ai)
            partialh(i) = ai(i)*exp(-1i*2*pi*fc*ti(i))*sinc(l(j) - (ti(i) * W));
        end
        h(j) = abs(sum(partialh));
    end
        
stem(l,h)
title('Absolute value of discrete impulse response at m=0')
xlabel('l')
ylabel('abs(h_l(m))')
end