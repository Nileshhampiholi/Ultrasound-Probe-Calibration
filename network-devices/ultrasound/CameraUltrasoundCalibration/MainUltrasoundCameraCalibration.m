%% Ultrasound free hand calibration
initWS;
%% Measure the wire end-points using Cambar and a stylus
if (exist('data\zWireEndPoints.mw', 'file'))
    load('data\zWireEndPoints.mw', '-mat');
else
    [p, TAll] = zWirePhantomInCameraCoord('134.28.45.17', 5, 5000, 'stylus');
end

% Four points for the Z-Phantom
p1Obs = [p(1,1:4:end); p(2,1:4:end); p(3,1:4:end)];
p2Obs = [p(1,2:4:end); p(2,2:4:end); p(3,2:4:end)];
p3Obs = [p(1,3:4:end); p(2,3:4:end); p(3,3:4:end)];
p4Obs = [p(1,4:4:end); p(2,4:4:end); p(3,4:4:end)];

meanPointsPhantom = [mean(p1Obs,2) mean(p2Obs,2) mean(p3Obs,2) mean(p4Obs,2)];
P1 = mean(p1Obs,2)';
P2 = mean(p2Obs,2)';
P3 = mean(p3Obs,2)';
P4 = mean(p4Obs,2)';

% Mean TF
meanTFs = [mean(TAll(:,1:4:end),2) mean(TAll(:,2:4:end),2) mean(TAll(:,3:4:end),2) mean(TAll(:,4:4:end),2)];
meanTF1 = reshape(meanTFs(:,1), 4,4);
meanTF2 = reshape(meanTFs(:,2), 4,4);
meanTF3 = reshape(meanTFs(:,3), 4,4);
meanTF4 = reshape(meanTFs(:,4), 4,4);

%% Checking if p1p2 and p3p4 are parallel
% If the z-wire doesnot have parallel lines then it will affect the
% accuracy of the calibration process. 
p1p2 = meanPointsPhantom(:,2)-meanPointsPhantom(:,1);
p2p3 = meanPointsPhantom(:,3)-meanPointsPhantom(:,2);
p3p4 = meanPointsPhantom(:,4)-meanPointsPhantom(:,3);
theta = acosd((p1p2./norm(p1p2))'*(p3p4./norm(p3p4)));

% Normal to the z-wire phantom - later used for visualization purposes.
normalToZWire = cross(p1p2, p2p3);
normalToZWire = normalToZWire./norm(normalToZWire);
%% Visualize Z-Wire phantom
figure;hold on;
plot3(meanPointsPhantom(1,:), meanPointsPhantom(2,:), meanPointsPhantom(3,:), '*-')
text(meanPointsPhantom(1,:), meanPointsPhantom(2,:), meanPointsPhantom(3,:), ['p1'; 'p2'; 'p3'; 'p4'])
rmsDistFromMean = [rmsDeviation(p1Obs, meanPointsPhantom(:,1)) rmsDeviation(p2Obs, meanPointsPhantom(:,2)) rmsDeviation(p3Obs, meanPointsPhantom(:,3)) rmsDeviation(p4Obs, meanPointsPhantom(:,4))];
[x,y,z] = sphere;
surf(rmsDistFromMean(1)*x+meanPointsPhantom(1,1),rmsDistFromMean(1)*y+meanPointsPhantom(2,1),rmsDistFromMean(1)*z+meanPointsPhantom(3,1),'EdgeColor','none')
surf(rmsDistFromMean(2)*x+meanPointsPhantom(1,2),rmsDistFromMean(2)*y+meanPointsPhantom(2,2),rmsDistFromMean(2)*z+meanPointsPhantom(3,2),'EdgeColor','none')
surf(rmsDistFromMean(3)*x+meanPointsPhantom(1,3),rmsDistFromMean(3)*y+meanPointsPhantom(2,3),rmsDistFromMean(3)*z+meanPointsPhantom(3,3),'EdgeColor','none')
surf(rmsDistFromMean(4)*x+meanPointsPhantom(1,4),rmsDistFromMean(4)*y+meanPointsPhantom(2,4),rmsDistFromMean(4)*z+meanPointsPhantom(3,4),'EdgeColor','none')

%% Acquire Ultrasound images and corresponding poses of the US probe
% Take at least 20 images. 
% Make sure that the depth level at which the z-wire phantom is located is
% in focus. You adjust this directly at the Ultrasonix device.
% Also, make sure contrast of the images is apropriate for good
% segmentation results.

%% Segmenting Ultrasound images
numImages = 20;
[c1, c2, c3, xmmPerPx, ymmPerPx, allImages] = segmentZPhantomPointsInUSImages('data\ultrasoundImagesAndPoses\fileout_', numImages);

%% If the segmented locations are in pixels, convert them to 'mm'.
scaleMat = diag([xmmPerPx ymmPerPx]);
c1 = (scaleMat*reshape(c1',2,[]))';
c2 = (scaleMat*reshape(c2',2,[]))';
c3 = (scaleMat*reshape(c3',2,[]))';

%% Calculate the distances c1c2, c2c3 and c1c3 in mm
% This is necessary for estimating the c2 (middle of the three cross-
% sectional points of the z-wire phantom. We can call this point 'zMid') in
% camera coordinate system.
c1c2 = c1-c2; c1c2 = sqrt(c1c2(:,1).^2 + c1c2(:,2).^2);
c2c3 = c2-c3; c2c3 = sqrt(c2c3(:,1).^2 + c2c3(:,2).^2);
c1c3 = c1-c3; c1c3 = sqrt(c1c3(:,1).^2 + c1c3(:,2).^2);
%% Find the global coordinates of middle of the three cross-sectional 
% points of the z-wire phanton in ultrasound images
zMidCamera = (c2c3./c1c3)*(P3-P2) + ones([20,1])*P2;

%% Estimating Tranformation between image coordinate system and US Probe coordinate system.

% While acquiring ultrasound images, you would have saved the corresponding
% pose of probe. All of these poses are saved in a text file. 

% Read probe poses
probePoses = importProbePoses('data\ultrasoundImagesAndPoses\probePoses.txt');
% 4x4 matrix:
% timestamp, visible-flag, R00, R01, R02, X, R10, R11, R12, Y, R20, R21, R22, Z, 0, 0, 0, 1
probePoses = probePoses(:, 3:end);

%% zMidCamera can be tranformed to Probe Coordinate System using the above
% poses
zMidProbe = zeros(numImages,3);
for i=1:numImages
  %T = probePoses(i,:);
  %T = reshape(T,4,4)';
  tfMatProbeToCamera = reshape(probePoses(i,:), 4,4)';
  a = [zMidCamera(i,:)'; 1];
  zMidProbe_current = inv(tfMatProbeToCamera) * a;
  zMidProbe(i,:) = zMidProbe_current(1:3)';
end    

%%
% Appending 0 z-coordinate to the 2D segmented points in image coordinate
% system.
zMidImage = [c2 zeros(numImages,1)];

% Using least squares to estimate the transformation
[R,T,Yf,ErrUSP] = rot3dfit(zMidImage,zMidProbe);
tfMatImageToProbe = [[R' T']; [zeros(1,3) 1]];
zInImageToCamera = zeros(numImages,3);
for i=1:numImages
  %T = probePoses(i,:);
  %T = reshape(T,4,4)';
  tfMatProbeToCamera = reshape(probePoses(i,:), 4,4)';
  a = [zMidImage(i,:)'; 1];
  zMidImageToCamera_current = tfMatProbeToCamera*tfMatImageToProbe * a;
  zInImageToCamera(i,:) = zMidImageToCamera_current(1:3)';
end  

%% Visualize the calibration error
% Comparing the zMidCamera and zInImageToCamera

%%% Uncomment the following lines, once you have computed zMidCamera and 
%%% zInImageToCamera

%hold on; % plot over the last figure
figure;
zMidCompX = [zMidCamera(:,1)'; zInImageToCamera(:,1)'];
zMidCompY = [zMidCamera(:,2)'; zInImageToCamera(:,2)'];
zMidCompZ = [zMidCamera(:,3)'; zInImageToCamera(:,3)'];
plot3(zMidCamera(:,1), zMidCamera(:,2), zMidCamera(:,3), '*'); hold on;
plot3(zMidCompX, zMidCompY, zMidCompZ, 'r+-')
hold off;
axis equal
axis vis3d
xlabel('x')
ylabel('y')
zlabel('z')
title('Z-Wire Phantom and detected mid-points in camera reference frame')
err=sqrt(abs(zMidCompX(1,:)-zMidCompX(2,:)).^2+abs(zMidCompY(1,:)-zMidCompY(2,:)).^2+abs(zMidCompZ(1,:)-zMidCompZ(2,:)).^2);

%% Transform Images to Camera coordinate system
sz = size(allImages);
numPx = sz(1)*sz(2);
xImRange = xmmPerPx*(0:sz(2)-1); % locations along x-axis in images
yImRange = ymmPerPx*(0:sz(1)-1); % locations along y-axis in images
[xgrid, ygrid] = meshgrid(xImRange,yImRange); % creating a grid using above locations

% In order to (later) interpolate to get a reconstructed volume. It would
% be helpful to use the following datastructure 
% X Y Z Intenstity (for all the pixels in all images)
%|-----|
%   |
%   V
% These should be in camera coordinate system.
imageAs3DPtsInImageWithIntensity = [xgrid(:) ygrid(:) zeros(numPx,1) ones(numPx,1)];
allImagesAs3DPtsInWorldWithIntensity = zeros(numImages*numPx,4);
for idx = 1:numImages
    tfMatProbeToCamera = reshape(probePoses(idx,:), 4,4)';
    imageAs3DPtsInWorldWithIntensity = (tfMatProbeToCamera*tfMatImageToProbe*imageAs3DPtsInImageWithIntensity')';
    allImagesAs3DPtsInWorldWithIntensity((idx-1)*numPx+1:idx*numPx, 1:3) = imageAs3DPtsInWorldWithIntensity(:,1:3);
    Icurr = allImages(:,:,idx);
    allImagesAs3DPtsInWorldWithIntensity((idx-1)*numPx+1:idx*numPx, 4) = Icurr(:);
end

%% Interpolating the volume
minV = min(allImagesAs3DPtsInWorldWithIntensity(:,1:3));
maxV = max(allImagesAs3DPtsInWorldWithIntensity(:,1:3));
midV = (minV+maxV)/2;
diffV = (maxV-minV);

% The mat-file contains an interpolated reconstructed volume of the z-wire
% phantom from an earlier experiment
if (exist('data\zWirePhantomVolume.mw', 'file'))
    load('data\zWirePhantomVolume.mw', '-mat');
else    
    % creating a grid where we would like to interpolate the data
    [XV,YV,ZV] = meshgrid(minV(1)+1:0.5:maxV(1)-1,minV(2)+1:0.5:maxV(2)-1,minV(3)+1:0.5:maxV(3)-1);
    % Interpolating the scattered data - this might take a long time -
    % therefore it would be advisable to save the interpolated volume in a
    % mat-file
    Vq = griddata(allImagesAs3DPtsInWorldWithIntensity(:,1),allImagesAs3DPtsInWorldWithIntensity(:,2),allImagesAs3DPtsInWorldWithIntensity(:,3),allImagesAs3DPtsInWorldWithIntensity(:,4),XV,YV,ZV,'natural');
end

%% Visualization of the volume
% plot isosurfaces at each level, using direct color mapping
scrsz = get(groot,'ScreenSize');
figure('Renderer','opengl','Position',[10 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);

% volumetric data, and iso-levels we want to visualize
isovalues = linspace(10,40,4);
fAlphaVals = linspace(0.1,0.4,4);
fAlphaVals(4) = 1;
num = numel(isovalues);

p = zeros(num,1);
for i=1:num
    p(i) = patch( isosurface(XV,YV,ZV,Vq,isovalues(i)) );
    isonormals(XV,YV,ZV,Vq,p(i))
    set(p(i), 'CData',i);
    set(p(i), 'FaceAlpha',fAlphaVals(i));
end
set(p, 'CDataMapping','direct', 'FaceColor','flat', 'EdgeColor','none')

% define the colormap
clr = hsv(num);
colormap(clr)

% fix the colorbar to show iso-levels and their corresponding color
caxis([0 num])
colorbar('YTick',(1:num)+0.5, 'YTickLabel',num2str(isovalues(:)))

% tweak the plot and view
box on; grid on; view(-95,-35);
axis tight;
axis vis3d; daspect([1 1 1])
camproj perspective
camlight; lighting gouraud;
rotate3d on

title('Example: Reconstructed volume of the z-wire phantom')

hold on
mp = zeros(2,1);idp = 1;
mp(idp) = plot3(meanPointsPhantom(1,:), meanPointsPhantom(2,:), meanPointsPhantom(3,:), '*-');idp = idp+1;
% mp(idp) = plot3(zMidCamera(:,1), zMidCamera(:,2), zMidCamera(:,3), '*');idp = idp+1;
hold off;

angRot = 10;
for idy = 1:90/angRot
    rotate([p; mp],normalToZWire,angRot)
    drawnow
    pause(0.01)
end
