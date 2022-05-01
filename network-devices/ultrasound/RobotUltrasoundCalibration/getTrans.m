function [ Ti ] = getTrans( Mi )
%getRot Gets the rotational part of a homogenous matrix
%   Detailed explanation goes here

Ti = Mi(1:3,4);

end

