clear;
close all;
clc;
show = true;
Threshold = 0.1;
%%
filename = 'final_12';
path_to_save = 'D:\Poject Arbeit\image_segmentation\raw_images\try_5';
image_path = fullfile(path_to_save, [filename '.jpg']);

IN_IMG=imread(image_path);
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
    imwrite(IN_IMG,"C:\Users\nhamp\Downloads\raw_image.jpg", 'jpg');
end
%==========================================================================
% %% Set kernel size
W_Size=7;

% Applying median filter of W_size x W_size
% Removes Gaussian, Random and Salt-Pepper noise.
% Center pixel of neighbourhood is replaced by median value
IN_IMG_median_filter=medfilt2(IN_IMG,[W_Size W_Size]);

% strel - morphological restructuring:disk shaped structuring with radius r
background = imopen(IN_IMG_median_filter,strel('disk',3));
IN_IMG_median_filter = IN_IMG_median_filter + background;

if show
    figure;
    imshow(IN_IMG_median_filter);
    % set(title('Median Filter'),'color','b');
    imwrite(IN_IMG,"C:\Users\nhamp\Downloads\median_filter.jpg", 'jpg');
end
%==========================================================================
%% Binary image
BW=imbinarize(IN_IMG_median_filter,0.5);
if show
    figure; 
    imshow(BW,[]); 
    set(title('Binary Image'),'color','b');
end

%% Remove all small objects
BW_big_object = bwareaopen(BW, 10,4);
if show
    figure; 
    imshow(BW_big_object,[]); 
    set(title('Removing Big Object'),'color','b');
end

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
% % 
%% Compute compliment of image
BW_compliment = imcomplement(BW_big_object);
if show
    figure; 
    imshow(BW_compliment,[]); 
    set(title('Complement of Binary Image'),'color','b');
end
%% Performs morfological operation to enhance the points 
SE = strel('disk',5);
SE2 = strel('disk',10);
BW_morp = imdilate(BW_compliment,SE2);
BW_morp = imerode(BW_morp,SE);

if show 
    figure; 
    imshow(BW_morp,[]); 
    set(title('Morfological Operation to enhance the points'),'color','b');
end

%% Plot Images
BW_8 = im2uint8(BW_morp);
BW_comp_final = imbinarize(BW_8,0.5);
BW_comp_final = bwareaopen(BW_comp_final, 5);
BW_final = imcomplement(BW_comp_final);
%%
% figure;
subplot(2,3,1),imshow(IN_IMG);
subplot(2,3,2),imshow(IN_IMG_median_filter);
subplot(2,3,3),imshow(BW);
subplot(2,3,4),imshow(BW_big_object);
subplot(2,3,5),imshow(BW_compliment);
subplot(2,3,6),imshow(BW_morp);




% 0.3 5, 7










%%



%%
% Set kernel size
% W_Size=7;
% 
% % Applying median filter of W_size x W_size
% % Removes Gaussian, Random and Salt-Pepper noise.
% % Center pixel of neighbourhood is replaced by median value
% IN_IMG_median_filter=medfilt2(IN_IMG,[W_Size W_Size]);
% 
% % strel - morphological restructuring:disk shaped structuring with radius r
% background = imopen(IN_IMG_median_filter,strel('disk',5));
% IN_IMG_median_filter = IN_IMG_median_filter + background;

% % SE2 = strel('disk',7);
% % IN_IMG_median_filter = imdilate(IN_IMG_median_filter,SE2);
% 
% figure;
% imshow(IN_IMG_median_filter);
% set(title('Median Filter'),'color','b');


% %%
% 
% IN_IMG_median_filter =IN_IMG;
% IN_IMG_median_filter_1 = IN_IMG_median_filter(1:700,:);
% IN_IMG_median_filter_2= IN_IMG_median_filter(700:end,:);
% % 
% figure;
% imshow(IN_IMG_median_filter_1);
% figure;
% imshow(IN_IMG_median_filter_2);
% 
% BW_1 = IN_IMG_median_filter_1;
% BW_1(1:200 ,:) = 0;
% BW_1(350:700 ,:) = 0;
% % 
% % BW_1(850:1250 ,:) = 0;
% BW_1 = imbinarize(BW_1,0.1);
% SE = strel('disk',6);
% SE2 = strel('disk',4);
% BW_morp = imdilate(BW_1,SE2);
% BW_1 = imerode(BW_morp,SE);
% figure 
% imshow(BW_1,[])
% 
% 
% % 
% BW_2 = IN_IMG_median_filter_2;
% BW_2(150:400 ,:) = 0;
% BW_2(700:1050 ,:) = 0;
% BW_2(1200:end ,:) = 0;
% BW_2=imbinarize(BW_2,0.38);
% SE = strel('disk',15);
% SE2 = strel('disk',5);
% BW_2 = imdilate(BW_2,SE2);
% BW_2 = imerode(BW_2,SE);
% 
% figure 
% imshow(BW_2,[])
% 
% %% Binary image
% % % 
% % BW_1 = imbinarize(IN_IMG_median_filter_1,0.2);
% % BW_1(150:300 ,:) = 0;
% % BW_1(1150:end ,:) = 0;
% % BW_1(650:1000 ,:) = 0;
% % 
% % BW_up = BW_1;
% % SE = strel('disk',8);
% % SE2 = strel('disk',5);
% % BW_morp = imdilate(BW_1,SE2);
% % BW_1 = imerode(BW_morp,SE);
% % figure 
% % imshow(BW_1,[])
% % % 
% % 
% % 
% % 
% % BW_1 = imbinarize(IN_IMG_median_filter_1,0.2);
% % BW_1(100:300 ,:) = 0;
% % BW_1(1100:end ,:) = 0;
% % BW_1(600:1000 ,:) = 0;
% % SE = strel('disk',10);
% % SE2 = strel('disk',8);
% % BW_morp = imdilate(BW_1,SE2);
% % BW_1 = imerode(BW_morp,SE);
% % figure 
% % imshow(BW_1,[])
% % 
% % %
% % 
% 
% BW_2=imbinarize(IN_IMG_median_filter_2,0.4);
% BW_2(130:end ,:) = 0;
% BW_down = BW_2;
% 
% 
% bW_full =[BW_up ; BW_down];
% figure 
% imshow(bW_full);


% SE = strel('disk',5);
% SE2 = strel('disk',10);
% BW_morp = imdilate(BW_2,SE2);
% BW_2 = imerode(BW_2,SE);
% figure 
% imshow(BW_2,[])


%%
% % 
% BW = [BW_1; BW_2];
% 
% figure; 
% imshow(BW,[]); 
%  imwrite(BW,"C:\Users\nhamp\Downloads\compression.jpg", 'jpg');
% set(title('Binary Image'),'color','b');
%% Remove all small objects
% BW_big_object = bwareaopen(BW, 600,8);
% figure; 
% imshow(BW_big_object,[]); 
% set(title('Removing Big Object'),'color','b');

%% Get only small objects and remove the unwanted part
% 
% BW(1600:end ,:) = 0;
% 
% figure 
% imshow(BW, [])
% BW_small_objects(: ,1:150) = 0;
% figure; 
% imshow(BW_small_objects,[]); 
% set(title('Required Small Objects'),'color','b');
%% Compute compliment of image
% BW_compliment = imcomplement(BW);
% figure; 
% imshow(BW_compliment,[]); 
% set(title('Complement of Binary Image'),'color','b');

%% Performs morfological operation to enhance the points 
% SE = strel('disk',8);
% SE2 = strel('disk',5);
% BW_morp = imdilate(BW,SE2);
% % BW_morp = imerode(BW_morp,SE);
% BW_morp = imerode(BW_morp,SE);
% figure; 
% imshow(BW_morp,[]); 
% % imwrite(BW_morp,"C:\Users\nhamp\Downloads\expansion.jpg", 'jpg');
% set(title('Morfological Operation to enhance the points'),'color','b');
% 
% % %% Convert Back to black background
% BW_8 = im2uint8(BW_morp);
% BW_comp_final = imbinarize(BW_8,0.5);
% BW_final = imcomplement(BW_comp_final);
% 
% figure; 
% imshow(BW_final,[]); 
% set(title('Final Segmentation Result'),'color','black');

%% Estimate mm per pixel
% sumRow = sum(I,1);
% indF = find(sumRow, 1, 'first');
% indL = find(sumRow, 1, 'last');
% widthPxUS = indL - indF + 1;
% xmmPerPxAll = 38.0 / widthPxUS;
% 
% %% Plot Images
% figure;
% subplot(2,3,1),imshow(IN_IMG);
% subplot(2,3,2),imshow(IN_IMG_median_filter);
% subplot(2,3,3),imshow(BW);
% subplot(2,3,4),imshow(BW_compliment);
% subplot(2,3,5),imshow(BW_morp);
% subplot(2,3,6),imshow(BW_final);


%%
% close all;
% clear all;
% clc;
% %%
% folder = "D:\SEM_4\Project\my_files\image_segmentation\pre_processing\";
% image_file = fullfile(folder,'1_pre_process.jpg');
% I = imread(image_file);
% [Inr,Inc] = size(I);
% figure;
% imshow(I);
% set(title("Preprocessed Image", 'color', 'b'));
% hold on;
% plot(I(1,1),I(1,1), "r.", 'markerSize', 15);
% %%
% [L,n] = bwlabel(BW_final);
% blobs = regionprops(BW_final, 'BoundingBox');
% 
% s = regionprops(L,'centroid');
% 
% 
% centroids = cat(1, s.Centroid); 
% centroids = sortrows(centroids,2);
% % centroids = centroids(1:9,:);
% % L = bwlabeln(I);
% figure;
% imshow(L);
% plot(centroids(:,1), centroids(:,2), 'o');
% %%
% x = imbinarize(BW_final,0.5);
% figure;
% imshow(x);
% [L,Centers] = imsegkmeans(x,9);
% plot(Centers, 'r.');
%%
%  x = imbinarize(BW_final,0.5);
%  y = imcomplement(BW_final);

cc = bwconncomp(BW_final,8);
labelled = labelmatrix(cc);
rgblabel = label2rgb(labelled,'spring','c','shuffle');
figure
imshow(rgblabel)
set(title('Centriod Extraction'),'color','black');

hold on;

s = regionprops(labelled,'centroid');
% c = regionprops(labelled,'BoundingBox');
% rectangle('Position', c(1).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(2).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(3).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(4).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(5).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(6).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(7).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(8).BoundingBox, 'Edgecolor', 'b');
% rectangle('Position', c(9).BoundingBox, 'Edgecolor', 'b');
c = regionprops(labelled,'BoundingBox');
boxes = cat(1, c.BoundingBox); 
for i = 1:size(boxes,1)
    rectangle('Position', boxes(i,:), 'Edgecolor', 'b');

end
hold on 
centroids = cat(1, s.Centroid); 
centroids = sortrows(centroids,2);
% point_cloud_image = [centroids(:,1) zeros(size(centroids, 1),1) centroids(:,2)];
plot(centroids(:,1), centroids(:,2), 'b.', 'MarkerSize' ,12);


scale = get_pixel_to_mm_conversion_factor(path_to_save);

scaled_centriods = centroids*scale;
point_cloud_image_scaled = [scaled_centriods(:,1) zeros(size(scaled_centriods, 1),1) scaled_centriods(:,2)];
% point_cloud_phantom_full = csvread('wire_phantom.csv');
% 
% figure
% plot3(  point_cloud_phantom_full(:,1),...
%         point_cloud_phantom_full(:, 2),...
%         point_cloud_phantom_full(:, 3),...
%         'bo', 'MarkerSize', 1)
% grid on;
% hold on 
% h = plot3(  point_cloud_image_scaled(:, 1),...
%             point_cloud_image_scaled(:, 2),...
%             point_cloud_image_scaled(:, 3),...
%             'r.', 'MarkerSize' , 5);
% 
% h = plot3(  point_cloud_image(:, 1),...
%             point_cloud_image(:, 2),...
%             point_cloud_image(:, 3),...
%             'b.', 'MarkerSize' , 5);


