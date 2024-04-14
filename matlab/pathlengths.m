function [ ri ] = pathlengths( t, reflectMat )
%Calculate a vector of pathlengths, between the origin, a given reflector,
%and the reciever
%   We pass in the time and a matrix of reflector positions.
%   The last row in the output vector will be the direct Rx to Tx distance.  
%   We are only considering 1 reflection in any given path length, operating under
%   the assumption that the amplitude from multiple reflections is suffienctly small

%initialize the velocity vector, Rx initial coordinates, reflector
%positions
v = [10, 10];
dRx0 = [500, 1200];
di = reflectMat;
c = 3 * 10^8;
Fc = 900 * 10^6;

%calculate the new position of the Rx based on elapsed time
dRx = (t * v) + dRx0;

%generate vector of zeros to use pdist2 function between all reflectors and
%the Tx
origin = zeros(1,2);

%calculate distances between Rx and each reflector, and Tx and each
%reflector.  Sum the distances for a given reflector
dRx2di = transpose(pdist2(dRx,di));
ddi2Tx = pdist2(di,origin);
ri = dRx2di + ddi2Tx;

%add in a row at the bottom of the matrix for direct path:
directPath = pdist2(dRx, origin);
ri = [ri;directPath];

end

