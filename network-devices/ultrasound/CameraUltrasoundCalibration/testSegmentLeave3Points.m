I = imread('data\ultrasoundImagesAndPoses\fileout_0.jpg');
% segmentation
Ibw = im2bw(I, 0.2);
Ibw(1:50,:) = 0; % remove the edge of the water which is usually in the top
% part of the image
% get centroids (CenterOfMass coordinates) of all objects
s = regionprops(Ibw,'centroid');
centroids = cat(1, s.Centroid); 
% sort the centroids according to Y coord
centroids = sortrows(centroids,2);

% each objects gets its own 'label', i.e. id number
L = bwlabeln(Ibw);
% we get ids of the 3 topmost objects
labellist = [];
for i=1:3
  labellist = [labellist L(round(centroids(i,2)),  round(centroids(i,1)))];
end    

% if the pixel is not a part of our 3 topmost objects, set it to 0
% if it is, set it to 1
for i=1:numel(L)
  if ~any(L(i)==labellist)
      L(i)=0;
  else
     L(i)=1; 
  end    
end
L=logical(L);

subplot(1,3,1);
imagesc(I);
subplot(1,3,2);
imagesc(Ibw);
subplot(1,3,3);
imagesc(L);
hold on
plot(centroids(1:3,1),centroids(1:3,2), 'r.')
hold off


