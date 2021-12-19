function [centroids]= centriod_extraction(filename, image_path, path_to_save, show)
%% ========================================================================
if nargin==1
    show = false;
end

%% ========================================================================
 path_image = fullfile(image_path, filename);
 path_save = fullfile(path_to_save, filename);

I = imread(path_image);
X = imbinarize(I,0.5);
I_C = imcomplement(X);
if show
    figure;
    imshow(I_C);
    set(title("Preprocessed Image", 'color', 'b'));
end

%% ========================================================================
% differentiate between the components of the image 
cc = bwconncomp(I_C,8);

% Label the different components so that regionprops can find centriods 
labelled = labelmatrix(cc);

% colour label just for presentation 
rgblabel = label2rgb(labelled,@copper,'c','shuffle');

% Find the centriods of thhe components 
s = regionprops(labelled,'centroid');

% Just fro presentation 
c = regionprops(labelled,'BoundingBox');

%% ========================================================================

% Plot centriods. They need to sorted
centroids = cat(1, s.Centroid); 
centroids = sortrows(centroids,2);

if show
    figure;
    imshow(rgblabel);
    hold on;

    plot(centroids(:,1), centroids(:,2), 'b.', 'MarkerSize' ,12);

    % Plot bounding box around components 
    boxes = cat(1, c.BoundingBox); 
    for i = 1:size(boxes,1)
        rectangle('Position', boxes(i,:), 'Edgecolor', 'b');
    end
    
end
%% ========================================================================

imwrite(rgblabel,path_save, 'jpg');

end
