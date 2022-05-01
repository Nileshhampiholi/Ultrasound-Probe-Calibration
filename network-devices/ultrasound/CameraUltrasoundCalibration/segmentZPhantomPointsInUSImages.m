function [c1, c2, c3, xmmPerPx, ymmPerPx, allImages] = segmentZPhantomPointsInUSImages(filenamePref, numImages)
%SEGMENTZPHANTOMPOINTSINUSIMAGES Segments the Ultrasound images
%   SEGMENTZPHANTOMPOINTSINUSIMAGES(FILENAMEPREF, NUMIMAGES)
%   Reads in NUMIMAGES images with the prefix FILENAMEPREF and outputs the
%   locations of the cross-sectional points of z-wire phantom.
%
%   Modified 22th May 2015
%   Omer Rajput - MTEC, TUHH.

% Read images
I = imread([filenamePref '0.jpg']);

% These are just example of expected segmentation results. You would
% eventually not need the following two lines.
%filenamePrefSplit = strsplit(filenamePref, {'/','\'});

%filenameSegPref = [strjoin(filenamePrefSplit(1:end-1),'\') '\seg\seg'];
%ISeg = imread([filenameSegPref '0.jpg']);

% creating a figure with dummy structure
scrsz = get(groot,'ScreenSize');
figure;%('Position',[10 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);



%subplot(1,2,1)
ims = imshow(I);
title('Image from Ultrasound device')

%subplot(1,2,2)
%ims1 = imshow(ISeg);
%title('Segmented z-wire cross-sectional points')

sz = size(I);
allImages = zeros(sz(1),sz(2),numImages);

xmmPerPxAll = zeros(1,numImages);
ymmPerPx = 40.0 / 480; % known
c1 = zeros(numImages,2);
c2 = zeros(numImages,2);
c3 = zeros(numImages,2);

for idx = 0:numImages-1
    delete(ims); %delete(ims1);
    disp(idx)
    % Reading the image
    I = imread([filenamePref num2str(idx) '.jpg']);
    allImages(:,:,idx+1) = I;
    
    %ISeg = imread([filenameSegPref num2str(idx) '.jpg']);
    % Showing the US image
    title(num2str(idx))
    %subplot(1,3,1);
    %imshow(I)
    %title('Image from Ultrasound device')
    %
    [Is, cc1, cc2, cc3] = segmentLeave3Points(I);
    % set positions of points in US image
    c1(idx+1,:)=cc1;
    c2(idx+1,:)=cc2;
    c3(idx+1,:)=cc3;

    subplot(1,2,1);
    imshow(Is); hold on;
    plot(cc1(1),cc1(2),'r*');
    plot(cc2(1),cc2(2),'r*');
    plot(cc3(1),cc3(2),'r*');
    title(idx)
    %
    % Showing the original thresholded image with centroids
    subplot(1,2,2);
    imshow(I), hold on;
    plot(cc1(1),cc1(2),'r*');
    plot(cc2(1),cc2(2),'r*');
    plot(cc3(1),cc3(2),'r*');
    title('Expected segmentation results')
    
    % It is also helpful to estimate mm per pixel
    % Counting the white pixels in each column, to find out the width in
    % pixels. This will correspond to 38mm (from the probe).
    sumRow = sum(I,1);
    indF = find(sumRow, 1, 'first');
    indL = find(sumRow, 1, 'last');
    widthPxUS = indL - indF + 1;
    xmmPerPxAll(idx+1) = 38.0 / widthPxUS;
    pause(0.1);
end
xmmPerPx = mean(xmmPerPxAll);

% Outputting all zeros - please modify it based on the segmentation above.


end