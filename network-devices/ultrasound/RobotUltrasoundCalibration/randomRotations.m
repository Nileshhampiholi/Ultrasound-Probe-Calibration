function T = randomRotations(n, rollMin, rollMax, pitchMin, pitchMax, yawMin, yawMax)
%RANDOMORIENTATION Summary of this function goes here
%   Detailed explanation goes here
T = createArrays(n, [3,3]);

phi = (rollMin-rollMax)*rand(n,1) + rollMax;
theta = (pitchMin-pitchMax)*rand(n,1) + pitchMax;
psi = (yawMin-yawMax)*rand(n,1) + yawMax;

for i=1:n
    Rzphi = [cosd(phi(i)) -sind(phi(i)) 0 ;
             sind(phi(i))  cosd(phi(i)) 0 ;
                0              0        1];
            
    Rytheta = [ cosd(theta(i))  0  sind(theta(i)) ;
                    0           1         0       ;
               -sind(theta(i))  0  cosd(theta(i))];
           
    Rxpsi = [1      0              0      ;
             0 cosd(psi(i)) -sind(psi(i)) ;
             0 sind(psi(i))  cosd(psi(i))];
    
    T{i} = Rzphi * Rytheta * Rxpsi;
end
end

