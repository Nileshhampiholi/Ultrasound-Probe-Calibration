B_T_E_init = [
    -1     0     0     50
    0     0     1    400
    0     1     0    400
    0     0     0     1];

E_T_I = [
    1     0     0    -20
    0    -1     0    -80
    0     0    -1     30
    0     0     0     1];

I_T_IMid = [
    1     0     0     19
    0     1     0     27.5
    0     0     1      0
    0     0     0     1];
% I_T_Z = [
%      0     1     0     50
%      0     0    -1     10
%     -1     0     0    -10
%      0     0     0     1];

I_T_Z_init = [
    1     0     0     29
    0     0    -1     10
    0     1     0    -20
    0     0     0     1];

B_T_Z = B_T_E_init*E_T_I*I_T_Z_init;

B_T_IMidInit = B_T_E_init * E_T_I * I_T_IMid;

usImageWidth = 38; % mm
usImageHeight = 55; % mm
zWireXSize = 20; % mm
zWireYSize = 40; % mm
% Z_T_I_init = invTfMat(I_T_Z_init);

visRegionWidth = 0;%usImageWidth - (I_T_Z_init(1,4)-zWireXSize) - 20;
visRegionHeight = usImageHeight - I_T_Z_init(2,4) - 10;

NWireType1 = [-zWireXSize zWireYSize   0; -zWireXSize          0   0; 0 zWireYSize   0; 0          0   0];
NWireType2 = [-zWireXSize          0   0; -zWireXSize zWireYSize   0; 0          0   0; 0 zWireYSize   0];
numZWires = 20;
% zWireCornersInZ_actual = [  ...
%     NWireType1;  ...
%     NWireType2 + repmat([5  , 0,  -2.5],4,1); ...
%     NWireType1 + repmat([0  , 0,  -5  ],4,1); ...
%     NWireType2 + repmat([5  , 0,  -7.5],4,1); ...
%     NWireType1 + repmat([2.5, 0, -10  ],4,1); ...
%     NWireType2 + repmat([7.5, 0, -12.5],4,1); ...
%     NWireType1 + repmat([2.5, 0, -15  ],4,1); ...
%     NWireType2 + repmat([7.5, 0, -17.5],4,1); ...
%     ];

zWireCornersInZ_actual = repmat([NWireType2;  NWireType2], numZWires/2, 1) + ...
    [   reshape(repmat(linspace(0,visRegionWidth,numZWires/2)',1,8)' + repmat([zeros(4,1); 0*ones(4,1)],1,numZWires/2), 4*numZWires,1), ...
        zeros(4*numZWires,1), ...
        reshape(repmat(-linspace(0,visRegionHeight,numZWires)',1,4)',4*numZWires,1)]; 

% zWireCornersInZ_actual = [  -20 40   0; -20  0   0; 0 40   0; 0  0   0;  ...
%                             -20 40  -5; -20  0  -5; 0 40  -5; 0  0  -5;  ...
%                             -20 40 -10; -20  0 -10; 0 40 -10; 0  0 -10;  ...
%                             -20 40 -15; -20  0 -15; 0 40 -15; 0  0 -15;  ...
% ];


noiseParamZWire = 0;
noiseParamImage = 0;

zWireCornersInZ_assumed = zWireCornersInZ_actual+noiseParamZWire*randn(numZWires*4,3);
p1p2 = zWireCornersInZ_actual(2:4:end,:)-zWireCornersInZ_actual(1:4:end,:);
p2p3 = zWireCornersInZ_actual(3:4:end,:)-zWireCornersInZ_actual(2:4:end,:);
p3p4 = zWireCornersInZ_actual(4:4:end,:)-zWireCornersInZ_actual(3:4:end,:);

p1p2line = [zWireCornersInZ_actual(1:4:end,:)  p1p2];
p2p3line = [zWireCornersInZ_actual(2:4:end,:)  p2p3];
p3p4line = [zWireCornersInZ_actual(3:4:end,:)  p3p4];

imageCorners_in_I = [0 0 0; usImageWidth 0 0; usImageWidth usImageHeight 0; 0 usImageHeight 0];
imagePlane_in_I = [0 0 0; 1 0 0; 0 1 0];
facePlane = 1:4;
numRandPoses = 1;
B_T_E_i = zeros(4,4,numRandPoses);
I_T_Z_ideal_i = zeros(4,4,numRandPoses);
I_T_Z_est_i = zeros(4,4,numRandPoses);
idx = 1;
figure
hold on
for jdx = 1:numZWires
    plot3(zWireCornersInZ_actual((jdx-1)*4+(1:4), 1), zWireCornersInZ_actual((jdx-1)*4+(1:4), 2), zWireCornersInZ_actual((jdx-1)*4+(1:4), 3), 'o-')
    plot3(zWireCornersInZ_assumed((jdx-1)*4+(1:4), 1), zWireCornersInZ_assumed((jdx-1)*4+(1:4), 2), zWireCornersInZ_assumed((jdx-1)*4+(1:4), 3), '+--')
end
while idx <= numRandPoses
    B_T_IMid = calculateAngles(1,B_T_IMidInit,10, [-10 10 -10 10 -10 10]);
    B_T_E_i(:,:,idx) = B_T_IMid*invTfMat(I_T_IMid)*invTfMat(E_T_I);
    B_T_E = B_T_E_i(:,:,idx);
    I_T_Z = invTfMat(E_T_I)*invTfMat(B_T_E)*B_T_Z;
    Z_T_I = invTfMat(I_T_Z);
    I_T_Z_ideal_i(:,:,idx) = I_T_Z;
    imageCorners_in_Z = Z_T_I*[imageCorners_in_I ones(4,1)]';
    imageCorners_in_Z = imageCorners_in_Z(1:3,:)';
    imagePlane_in_Z = [Z_T_I(1:3,4)' Z_T_I(1:3,1)' Z_T_I(1:3,2)'];
    imagePoints_in_Z = intersectLinePlane([p1p2line;p2p3line;p3p4line], imagePlane_in_Z);
    imagePoints_ideal_in_I = I_T_Z*[imagePoints_in_Z ones(numZWires*3,1)]';
    imagePoints_ideal_in_I = imagePoints_ideal_in_I(1:3,:)';
    zWireVisFlag = ~any(imagePoints_ideal_in_I(:,1)<2 | imagePoints_ideal_in_I(:,1)>36 | imagePoints_ideal_in_I(:,2)<2 | imagePoints_ideal_in_I(:,2)>53);
    if ~zWireVisFlag
        continue;
    end
    
    imagePoints_realistic_in_I = (imagePoints_ideal_in_I)+noiseParamImage*randn(numZWires*3,3);
    imagePoints_realistic_in_I(:,3) = 0;
    % Seen in Image
    c1 = imagePoints_realistic_in_I(1:numZWires, :);
    c2 = imagePoints_realistic_in_I(numZWires+1:2*numZWires, :);
    c3 = imagePoints_realistic_in_I(2*numZWires+1:3*numZWires, :);
    
    % Calculate the distances c1c2, c2c3 and c1c3 in mm
    % This is necessary for estimating the c2 (middle of the three cross-
    % sectional points of the z-wire phantom. We can call this point 'zMid') in
    % camera coordinate system.
    c1c2 = c1-c2; c1c2 = sqrt(c1c2(:,1).^2 + c1c2(:,2).^2);
    c2c3 = c2-c3; c2c3 = sqrt(c2c3(:,1).^2 + c2c3(:,2).^2);
    c1c3 = c1-c3; c1c3 = sqrt(c1c3(:,1).^2 + c1c3(:,2).^2);
    % Find the global coordinates of middle of the three cross-sectional
    % points of the z-wire phanton in ultrasound images
    zMid_in_Z = repmat((c1c2./c1c3),1,3).*p2p3 + zWireCornersInZ_assumed(2:4:end,:);
    [estR, estTr, Yf,ErrRMS,ErrFro] = rot3dfit(zMid_in_Z, c2, 100);
    while (round(det(estR)) == -1)
        [estR, estTr, Yf,ErrRMS,ErrFro] = rot3dfit(zMid_in_Z, c2+[zeros(numZWires,2) 0.0005*randn(numZWires,1)], 100);
    end
    ErrRMS
    %ErrFro
    I_T_Z_est = [estR', estTr'; 0 0 0 1];
    I_T_Z_est_i(:,:,idx) = I_T_Z_est;
    patch('Faces',facePlane,'Vertices',imageCorners_in_Z,'FaceColor', 'g', 'FaceAlpha', 0.5);
    plot3(imagePoints_in_Z(:, 1), imagePoints_in_Z(:, 2), imagePoints_in_Z(:, 3), '*')
    plot3(zMid_in_Z(:, 1), zMid_in_Z(:, 2), zMid_in_Z(:, 3), 'o')
    
    idx = idx + 1;
end
hold off;
axis equal vis3d
%%
[rotErrAll, trnslErrAll, errFroNormAll] = rotAndTranslResidueErrInTfMatAll(I_T_Z_ideal_i, I_T_Z_est_i)
if numRandPoses > 10
    %[X_orth_ideal, Y_orth_ideal] = handEyeQR24(invTfMatAll(B_T_E_i), I_T_Z_ideal_i, 100, 'Minv', 5, 5, 0, 1);
    errThresh = 4;
    n = sum(trnslErrAll<errThresh);
    [X15, Y15] = QR15(invTfMatAll(B_T_E_i(:,:,trnslErrAll<errThresh)), I_T_Z_est_i(:,:,trnslErrAll<errThresh), 100)
    [X_orth, Y_orth, X, Y, trnslErrAll, trnslOrthErrAll, rotErrAll, rotOrthErrAll, randInd] = handEyeQR24(invTfMatAll(B_T_E_i(:,:,trnslErrAll<errThresh)), I_T_Z_est_i(:,:,trnslErrAll<errThresh), 100, 'Minv', ceil(n/10), ceil(n/10), 0, 1);
    disp('B_T_Z')
    X_orth
    %X_orth_ideal
    X15
    B_T_Z
    
    disp('E_T_I')
    Y_orth
    [rotErrAll, trnslErrAll, errFroNormAll] = rotAndTranslResidueErrInTfMatAll(E_T_I, Y_orth)
    %Y_orth_ideal
    Y15
    E_T_I
    [rotErrAll, trnslErrAll, errFroNormAll] = rotAndTranslResidueErrInTfMatAll(E_T_I, Y15)
end
%%
% ptsInImageWithoutNoise = [50*rand(9,2) zeros(9,1)];
%
% noiseParamImg = 2;
% noiseParamZ = 2;
%
% ptsInImage = ptsInImageWithoutNoise + [noiseParamImg*rand(9,2) zeros(9,1)];
%
% ptsInZSimulatedWithoutNoise = invTfMat(I_T_Z)*[ptsInImageWithoutNoise ones(9,1)]';
% ptsInZSimulatedWithoutNoise =   ptsInZSimulatedWithoutNoise(1:3,:)';
%
% ptsInZSimulated = ptsInZSimulatedWithoutNoise + [noiseParamZ*rand(9,2) zeros(9,1)];
%
% [estR, estTr, Yf,ErrRMS,ErrFro] = rot3dfit(ptsInZSimulated, ptsInImage);
%
% ErrRMS
% ErrFro
% I_T_Z_est = [estR', estTr']
% det(I_T_Z_est(1:3,1:3))