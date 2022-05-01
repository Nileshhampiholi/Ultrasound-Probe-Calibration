function BW= image_pre_processing(filename, image_path, path_to_save, dialate, erode, show, Threshold)
%% Specify paths 
    path_image = fullfile(image_path, filename);
    path_save = fullfile(path_to_save, filename);


%==========================================================================
if nargin==4
    Threshold=0.9;
    show = false;
    dialate = 5;
    erode = 7;
end
%==========================================================================
%% Read Image
IN_IMG=imread(path_image);
IN_IMG = im2gray(IN_IMG);
global NROWS
global NCOLS
NROWS=size(IN_IMG,1);
NCOLS=size(IN_IMG,2);
%==========================================================================
%% Set kernel size
W_Size=7;

% Applying median filter of W_size x W_size
% Removes Gaussian, Random and Salt-Pepper noise.
% Center pixel of neighbourhood is replaced by median value
IN_IMG_median_filter=medfilt2(IN_IMG,[W_Size W_Size]);

% strel - morphological restructuring:disk shaped structuring with radius r
background = imopen(IN_IMG_median_filter,strel('disk',3));
IN_IMG_median_filter = IN_IMG_median_filter + background;

%==========================================================================
%% Binary image
BW=imbinarize(IN_IMG_median_filter,Threshold);

%% Remove all small objects
BW_big_object = bwareaopen(BW, 600,8);

%% Get only small objects and remove the unwanted part
% BW_small_objects = BW- BW_big_object;
% BW_small_objects(300:end ,:) = 0;
% BW_small_objects(:, 1:150)= 0;
% 
% if show
%     figure; 
%     imshow(BW_small_objects,[]); 
%     set(title('Required Small Objects'),'color','b');
% end
% 
%% Compute compliment of image
BW_compliment = imcomplement(BW_big_object);

%% Performs morfological operation to enhance the points 
SE = strel('disk',erode);
SE2 = strel('disk',dialate);
BW_morp = imdilate(BW_compliment,SE2);
BW_morp = imerode(BW_morp,SE);


%% Plot Images
if show 
    figure(2);
    subplot(2,3,1),imshow(IN_IMG);
    subplot(2,3,2),imshow(IN_IMG_median_filter);
    subplot(2,3,3),imshow(BW);
    subplot(2,3,4),imshow(BW_big_object);
    subplot(2,3,5),imshow(BW_compliment);
    subplot(2,3,6),imshow(BW_morp);
    
end

%==========================================================================
%% Save Image
imwrite(BW_morp,path_save, 'jpg');

%==========================================================================
end