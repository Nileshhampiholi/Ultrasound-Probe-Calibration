function [ segmented,C ] = segmentLeave3Points( I,a )
%SEGMENTLEAVE3POINTS segments the US image and leaves only 3 topmost
%objects. The resulting image is logical.

% segmentation

% 2
I = medfilt2(I, [7 7]);
Ibw = im2bw(I, 0.1);  %0.2


% 3
%I = medfilt2(I, [6 6]);
%Ibw = im2bw(I, 0.35);  %0.2



Ibw(1:150,:) = 0; % 50 remove the edge of the water which is usually in the top
% part of the image
% get centroids (CenterOfMass coordinates) of all objects
s = regionprops(Ibw,'centroid');
centroids = cat(1, s.Centroid); 
% sort the centroids according to Y coor
centroids = sortrows(centroids,2);
% take only a first points
centroids = centroids(1:a,:);

% sort
% 1 2 3
% 4 5 6
% 7 8 9 ...

for i=1:3:a
% sort the centroids according to X coord
centroids(i:i+2,:) = sortrows(centroids(i:i+2,:),1);
end;

% each objects gets its own 'label', i.e. id number
L = bwlabeln(Ibw);
% we get ids of the a topmost objects
labellist = [];
for i=1:a
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

segmented=logical(L);
C = [];
for i=1:a
   C = [C; centroids(i,1) centroids(i,2)]; 
end

end

