function BW= pre_processing_2(filename, image_path, path_to_save,show,positive)
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
%%  Show initial image
if show
    figure;
    imshow(IN_IMG);
    set(title('Raw Image'),'color','b');
end
%==========================================================================
%% Set kernel size
IN_IMG_median_filter = IN_IMG;

%% Split Image into 2 parts 

IN_IMG_median_filter_1 = IN_IMG_median_filter(1:700,:);
IN_IMG_median_filter_2= IN_IMG_median_filter(700:end,:);

%==========================================================================
%% Binary image
if positive
    BW_1 = IN_IMG_median_filter_1;
    BW_1(1:200 ,:) = 0;
    BW_1(350:700 ,:) = 0;
    % BW_1(850:end ,:) = 0;
    BW_1 = imbinarize(BW_1,0.1);
    SE = strel('disk',6);
    SE2 = strel('disk',4);
    BW_morp = imdilate(BW_1,SE2);
    BW_1 = imerode(BW_morp,SE);

    BW_2=IN_IMG_median_filter_2;
    BW_2(150:400 ,:) = 0;
    BW_2(700:1050 ,:) = 0;
    BW_2(1200:end ,:) = 0;
    BW_2=imbinarize(BW_2,0.38);
    SE = strel('disk',15);
    SE2 = strel('disk',5);
    BW_2 = imdilate(BW_2,SE2);
    BW_2 = imerode(BW_2,SE);

else
    BW_1 = imbinarize(IN_IMG_median_filter_1,0.2);
    BW_1(100:300 ,:) = 0;
    BW_1(1100:end ,:) = 0;
    BW_1(600:1000 ,:) = 0;
    SE = strel('disk',10);
    SE2 = strel('disk',7);
    BW_morp = imdilate(BW_1,SE2);
    BW_1 = imerode(BW_morp,SE);

    BW_2=imbinarize(IN_IMG_median_filter_2,0.4);
    BW_2(100:end ,:) = 0;
    SE = strel('disk',12);
    SE2 = strel('disk',3);
    BW_2 = imdilate(BW_2,SE2);
    BW_2 = imerode(BW_2,SE);
end

    BW = [BW_1; BW_2];

if show
    figure; 
    imshow(BW,[]); 
    set(title('Binary Image'),'color','b');
end

%% Compute compliment of image
BW_compliment = imcomplement(BW);
if show
    figure; 
    imshow(BW_compliment,[]); 
    set(title('Complement of Binary Image'),'color','b');
end
%% Performs morfological operation to enhance the points 
if positive
    SE = strel('disk',8);
    SE2 = strel('disk',5);
    BW_morp = imdilate(BW_compliment,SE2);
    BW_morp = imerode(BW_morp,SE);

else 
    SE = strel('disk',20);
    % SE2 = strel('disk',dialate);
    % BW_morp = imdilate(BW_compliment,SE2);
    BW_morp = imerode(BW_compliment,SE);
end
%%
BW_final = im2uint8(BW_morp);

%==========================================================================
%% Save Image
imwrite(BW_final,path_save, 'jpg');

%==========================================================================
end