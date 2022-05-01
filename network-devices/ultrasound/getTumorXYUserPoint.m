function [ x,y ] = getTumorXYUserPoint( ImageFileNamePath )
%getTumorXYUserPoint Displays the US image to the user and prompts to find
%                    the tumor.
    USImage = imread(ImageFileNamePath);
    h = figure;
    imagesc(USImage);
    title('Pick the location of the tumor!');
    [x,y] = ginput(1);
    close(h);
end