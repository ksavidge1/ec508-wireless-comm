function [ T_d , W_c ] = delayspread( ri )
%T_d is the delay spread, which is calculated by the maximum difference of
%path lengths, divided by the speed of light.  W_c is the coherence
%bandwidth, and is a simple calculation of 1/(2*T_d)

T_d = (max(ri)-min(ri))/(3 * 10^8);
W_c = 1/(2*T_d);
%T_c = 1/(4*D_s);
end