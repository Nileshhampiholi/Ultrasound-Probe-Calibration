function [ T, s, tf ] = loadTfFromFile( FileNamePath )
%LOADTFFROMFILE open a text file created by the camera and returns:
% T - timestamp
% s - status (should be 1)
% tf - 4x4 transformation matrix

    fileID = fopen(FileNamePath,'r');
    pose = fscanf(fileID,'%f');
    fclose(fileID);
    
    % TODO: probably some error checking, exception-style...
    T = pose(1);
    s = pose(2);
    tf = reshape(pose(3:18), 4,4)';
end