I_T_Z = [
     0     1     0     50
     0     0    -1     10
    -1     0     0    -10
     0     0     0     1];
ptsInImageWithoutNoise = [50*rand(9,2) zeros(9,1)];

noiseParamImg = 2;
noiseParamZ = 2;

ptsInImage = ptsInImageWithoutNoise + [noiseParamImg*rand(9,2) zeros(9,1)];

ptsInZSimulatedWithoutNoise = invTfMat(I_T_Z)*[ptsInImageWithoutNoise ones(9,1)]';
ptsInZSimulatedWithoutNoise =   ptsInZSimulatedWithoutNoise(1:3,:)';

ptsInZSimulated = ptsInZSimulatedWithoutNoise + [noiseParamZ*rand(9,2) zeros(9,1)];

[estR, estTr, Yf,ErrRMS,ErrFro] = rot3dfit(ptsInZSimulated, ptsInImage);

ErrRMS
ErrFro
I_T_Z_est = [estR', estTr']
det(I_T_Z_est(1:3,1:3))