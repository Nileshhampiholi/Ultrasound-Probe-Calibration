function [ Ri ] = getRot( Mi )
%getRot Gets the rotational part of a homogenous matrix
%   Detailed explanation goes here

Ri = Mi(1:3,1:3);

end

