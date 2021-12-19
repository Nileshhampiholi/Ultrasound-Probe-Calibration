%% Ultrasound Robot calibration
initWS;

testNo = 2;

%%
% P1 = [ 0  0;  0  0;  5  0;  5  0];    %  P2|\   |P4
% P2 = [ 0 40;  0 40;  5 40;  5 40];    %    | \  |
% P3 = [20  0; 20  0; 25  0; 25  0];    %    |  \ |
% P4 = [20 40; 20 40; 25 40; 25 40];    %  P1|   \|P3

P1 = [0;0];
P2 = [0;40];
P3 = [25;0];
P4 = [25;40];

%% Acquire Ultrasound images and corresponding poses of the US probe
% Take at least 20 images. 
% Make sure that the depth level at which the z-wire phantom is located is
% in focus. You adjust this directly at the Ultrasonix device.
% Also, make sure contrast of the images is apropriate for good
% segmentation results.

%% Segmenting Ultrasound images
numImages = 20;
without3 = [2 6 14 15 17 24 25 27 29 30 41 42 43 47 48];
without = [5 8 9 12 17 18];
numImages2 = numImages - length(without);
%[c1, c2, c3, xmmPerPx, ymmPerPx, allImages] = segmentZPhantomPointsInUSImages('data\ultrasoundImagesAndPoses\fileoutpos.txt_', numImages);
zCount = 12;

[C_px, xmmPerPx, ymmPerPx, allImages] = segmentZPhantomPointsInUSImages(['_images\' num2str(testNo) '\fileoutpos.txt_'], numImages, zCount, without);

%% If the segmented locations are in pixels, convert them to 'mm'.
C_mm = zeros(length(C_px(:,1)),2);

scaleMat = diag([xmmPerPx ymmPerPx]);
for i=1:length(C_px(:,1))
c_temp = C_px(i,:);
C_mm(i,:) = (scaleMat*reshape(c_temp',2,[]))';
end

%% Calculate the distances c1c2, c2c3 and c1c3 in mm
% This is necessary for estimating the c2 (middle of the three cross-
% sectional points of the z-wire phantom. We can call this point 'zMid') in
% camera coordinate system.
CLC_mm = [];
for i=1:3:length(C_mm(:,1))
    c1 = C_mm(i,:);
    c2 = C_mm(i+1,:);
    c3 = C_mm(i+2,:);
    c1c2 = c1-c2; c1c2 = sqrt(c1c2(:,1).^2 + c1c2(:,2).^2);
    c2c3 = c2-c3; c2c3 = sqrt(c2c3(:,1).^2 + c2c3(:,2).^2);
    c1c3 = c1-c3; c1c3 = sqrt(c1c3(:,1).^2 + c1c3(:,2).^2);
    CLC_mm = [CLC_mm; c1c2, c2c3, c1c3];
end

%% Find the local phantom coordinates of middle of the three cross-sectional 
% points of the z-wire phanton in ultrasound image

zMidPhantom_mm = zeros(length(CLC_mm(:,1)),2);

% for i=1:4:length(CLC_mm(:,1))
%     zMidPhantom_mm(i+0,:) = CLC_mm(i+0,2)/CLC_mm(i+0,3)*(P1(1,:)-P4(1,:)) + P4(1,:);
%     zMidPhantom_mm(i+1,:) = CLC_mm(i+1,2)/CLC_mm(i+1,3)*(P2(2,:)-P3(2,:)) + P3(2,:);
%     zMidPhantom_mm(i+2,:) = CLC_mm(i+2,2)/CLC_mm(i+2,3)*(P2(3,:)-P3(3,:)) + P3(3,:);
%     zMidPhantom_mm(i+3,:) = CLC_mm(i+3,2)/CLC_mm(i+3,3)*(P1(4,:)-P4(4,:)) + P4(4,:);
% end

for i=1:length(CLC_mm(:,1))
     zMidPhantom_mm(i,:) = CLC_mm(i,2)/CLC_mm(i,3)*(P2-P3)' + P3';
end



% 2D -> 3D
z1 = [];
for i=0:zCount/3-1
   z1 = [z1; -i*5];
end

z2 = [];
for i=1:numImages2
    z2 = [z2; z1];
end
zMidPhantom_mm = [zMidPhantom_mm z2];

z1 = [];
for i=0:zCount/3-1
    for j=1:3
        z1 = [z1; -i*5];
    end
end

z2 = [];
for i=1:numImages2
    z2 = [z2; z1];
end

C_mm = [C_mm z2];


zMidImage_mm = zeros(length(zMidPhantom_mm(:,1)),3);
zMidImage_px = zeros(length(zMidPhantom_mm(:,1)),3);
j = 1;
for i=2:3:length(C_mm(:,1))
    zMidImage_mm(j,1:2) = C_mm(i,1:2);
    zMidImage_px(j,1:2) = C_px(i,:);
    j = j+1;
end


%% min(zMidPhantom_mm - T_Image2Phantom * zMidImage_mm)
% poses

j = 1;
ErrRMS = zeros(numImages2,1);
ErrFro = zeros(numImages2,1);

I_T_P = zeros(4,4,numImages2);

for i=1:4:length(zMidPhantom_mm(:,1))
    %zMidImage(i:i+3,:)
    [estR, estTr, Yf,ErrRMS(j),ErrFro(j)] = rot3dfit(zMidPhantom_mm(i:i+3,:), zMidImage_mm(i:i+3,:));
     while (round(det(estR')) == -1)
         [estR, estTr, Yf,ErrRMS(j),ErrFro(j)] = rot3dfit(zMidPhantom_mm(i:i+3,:), zMidImage_mm(i:i+3,:)+[zeros(4,2) randn(4,1)*0.0009 ]);
     end
    I_T_P(:,:,j) = [estR', estTr';0 0 0 1];
   % det(estR')
    j = j+1; 
end

disp(['Phantom to Image: ErrRMS = ' num2str(mean(ErrRMS)) ', ErrFro = ' num2str(mean(ErrFro))]);

boxplot([ErrRMS,ErrFro])
%% plot calculated points

zMidImageTrans_px = zeros(length(zMidImage_px(:,1)),2);
zMidImageTrans_mm = zeros(length(zMidImage_px(:,1)),3);
zMidImageTransError_mm = zeros(length(zMidImage_px(:,1)),1);
scaleMat = diag([1/xmmPerPx 1/ymmPerPx]);

for i=1:numImages2
    for j=1:zCount/3
        temp = (I_T_P(:,:,i)*[zMidPhantom_mm(j+(i-1)*zCount/3,:) 1]')';
        zMidImageTrans_mm(j+(i-1)*zCount/3,:) = temp(1:3);
        zMidImageTrans_px(j+(i-1)*zCount/3,:) = (scaleMat*reshape(temp(1:2)',2,[]))';
        diff = zMidImage_mm(j+(i-1)*zCount/3,:) - zMidImageTrans_mm(j+(i-1)*zCount/3,:);
        zMidImageTransError_mm(j+(i-1)*zCount/3) = sqrt(diff(:,1).^2 + diff(:,2).^2 + diff(:,3).^2);
    end
end

disp(['Err_mm = ' num2str(mean(zMidImageTransError_mm))]);

% uncomment this to visualize the error of I_T_P

k = 0;
for j=0:numImages2-1
    while find(without == j+k,1) > 0
       k = k+1;
    end
    I = imread(['_images\' num2str(testNo) '\fileoutpos.txt_' num2str(j+k) '.jpg']);
    imshow(I);
    hold on;
    for i=1:4
       plot(zMidImage_px(i+j*4,1),zMidImage_px(i+j*4,2),'r*');
       plot(zMidImageTrans_px(i+j*4,1),zMidImageTrans_px(i+j*4,2),'gx');
    end
    pause();
end


%% skip calculation and load the I_T_Ps
%load(['_images\' num2str(testNo) '\I_T_P.mat']);


%% Estimating Tranformation between image coordinate system and end effector coordinate system.

% While acquiring ultrasound images, you would have saved the corresponding
% pose of end effector. All of these poses are saved in a text file. 

% Read probe poses
load(['_images\' num2str(testNo) '\poses.mat']);
poses2 = zeros(4,4,numImages2);
j=1;
for i=1:numImages
   if isempty(find(without == i-1,1)) 
       poses2(:,:,j) = poses(:,:,i);
       j = j+1;
   end
end

poses3 = zeros(4,4,numImages2);
for i=1:numImages2
    poses3(:,:,i) = invTfMat(poses2(:,:,i));
end


%% QR24 
minObs = 5; 
validatSet = 4;
doPerm = true;

Mi = poses3;
Ni = I_T_P;
disp(' ');
disp('Overall Transformation: ');
[X_orth24, Y_orth24, X, Y, trnslErrAll, trnslOrthErrAll, rotErrAll, rotOrthErrAll, randInd] = handEyeQR24(Mi, Ni, 1, 'Ninv', minObs, validatSet, doPerm, 1);
[Y_orth15, X, Y] = handEyeQR15(Mi, Ni);


%% plot calculated points

zMidImageTrans2_px = zeros(length(zMidImage_px(:,1)),2);
zMidImageTrans2_mm = zeros(length(zMidImage_px(:,1)),3);
zMidImageTrans2Error_mm = zeros(length(zMidImage_px(:,1)),1);
scaleMat = diag([1/xmmPerPx 1/ymmPerPx]);

for i=1:numImages2
    for j=1:zCount/3
        temp = (invTfMat(Y_orth)*poses3(:,:,i)*X_orth*[zMidPhantom_mm(j+(i-1)*zCount/3,:) 1]')';
        zMidImageTrans2_mm(j+(i-1)*zCount/3,:) = temp(1:3);
        zMidImageTrans2_px(j+(i-1)*zCount/3,:) = (scaleMat*reshape(temp(1:2)',2,[]))';
        diff = zMidImage_mm(j+(i-1)*zCount/3,:) - zMidImageTrans2_mm(j+(i-1)*zCount/3,:);
        zMidImageTrans2Error_mm(j+(i-1)*zCount/3) = sqrt(diff(:,1).^2 + diff(:,2).^2 + diff(:,3).^2);
    end
end

%disp(['Err_mm = ' num2str(mean(zMidImageTrans2Error_mm))]);

% uncomment this to visualize the error of the transformation

figure
k = 0;
for j=0:numImages2-1
    while find(without == j+k,1) > 0
       k = k+1;
    end
    I = imread(['_images\' num2str(testNo) '\fileoutpos.txt_' num2str(j+k) '.jpg']);
    imshow(I);
    hold on;
    for i=1:4
       plot(zMidImage_px(i+j*4,1),zMidImage_px(i+j*4,2),'r*');
       plot(zMidImageTrans2_px(i+j*4,1),zMidImageTrans2_px(i+j*4,2),'gx');
    end
    pause(0.5);
end
