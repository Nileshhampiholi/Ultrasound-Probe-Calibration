clear all
close 
clc
%%

path_raw_top = 'D:\Poject Arbeit\image_segmentation\raw_images\part\top\';
path_raw_left = 'D:\Poject Arbeit\image_segmentation\raw_images\part\left\';
path_raw_right = 'D:\Poject Arbeit\image_segmentation\raw_images\part\right\';

%%
X = csvread("D:\SEM_4\Project\my_files\Solve_equations\hand_eye_results\6_10.csv");
X = reshape(X',4,4,[]);
Y = X(:,:,2);
X = X(:,:,1);
X(4,1:3) = X(4,1:3)/1000;
%%

path = "D:\SEM_4\Project\my_files\3D_volume_reconstruction\part\";
%%
robot_poses = csvread(fullfile(path, "part.csv"));
AA = [];
AX = [];
count = 1;
for i = 1:3:size(robot_poses,1)
    A = [robot_poses(i:i+2,:); [0 0 0 1]];
    A(1:3,4) =  A(1:3,4)./1000;
    AA(:,:,count) = A;
    AX(:,:,count)=  A'*X;
    count = count +1;
end

%%
tfrom = affine3d([roty(90), [0; 0; 0]; [0 10 0 1]]);
files = dir(fullfile(path, "*.jpg"));
files = struct2table(files);
file_names = files.name(3:end);
file_path = files.folder;
numberOfSlices = length(file_names);
count = 1;
for slice = 1 : numberOfSlices
    fullFileName = fullfile(file_path{slice}, file_names{slice});
    thisSlice = imread(fullFileName);
%     tfrom = affine3d([AX(1:3,1:3, count), [0; 0; 0]; [0 0 0 1]]);
    % rotated_slice = imwarp(thisSlice, affine3d(AX(:,:,i)));
     tfrom = affine3d([rotx(180), [0; 0; 0]; [0 i 0 1]]);
     thisSlice = imwarp(thisSlice,tfrom);
   
    if slice == 1
      array3d = thisSlice;
    else
      array3d = cat(3, array3d, thisSlice);
    end
    count = count +1;
end	

%%
% opengl('save', 'hardware')
%%
% opengl('save', 'software')

% tfrom = affine3d([rotx(180), [0; 0; 0]; [0 0 0 1]]);
count = 1;
figure 
for i  = 1:30
    image = array3d(:,:,i);
%     image = imwarp(image,tfrom);
    [X,Z] = meshgrid(1:size(image,1), 1:size(image,2));
    hold on 
    warp(X, ones(size(X))*(count*0.1), Z, image);
    hold on 
    count = count+1;
end

xlabel('X', 'FontSize', 24)
ylabel('Y','FontSize', 24)
zlabel('Z', 'FontSize', 24)
%%
% V = squeeze(array3d);

% volshow(array3d, 'Renderer', 'MaximumIntensityProjection', 'BackgroundColor', [0, 0, 0]);
% ren = render(array3d);
% viewer3d(ren);
% slidingviewer(array3d)
% s = load('mri');
% mriVolume = squeeze(s.D);
% sizeIn = size(array3d);
% hFigOriginal = figure;
% hAxOriginal  = axes;
% slice(double(mriVolume),sizeIn(2)/2,sizeIn(1)/2,sizeIn(3)/2);
% grid on, shading interp, colormap gray

% implay(array3d)
opengl hardware
volumeViewer(array3d);
% x= vol3d('CData',array3d);