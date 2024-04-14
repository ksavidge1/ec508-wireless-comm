function [ ai, ti ] = attenuationanddelay( ri )
%Calculate a vector of attenuations and delays, with a row in the vector
%constituing a single path
%   We input the pathlength distances calculated using the pathlengths.m
%   function 

%initialize Tx and Rx antenna gains, carrier wavelength, and speed of light
Gtx = 1;
Grx = 1;
Fc = 900 * 10^6;
c = 3 * 10^8;
lambda = c/Fc;

%calculate ai for all pathlengths
aidenom = (4*pi*ri);
ainum = sqrt(Gtx*Grx)*lambda;
ai = ainum./aidenom;

%calculate ti for all pathlengths
ti = ri/c;
end

