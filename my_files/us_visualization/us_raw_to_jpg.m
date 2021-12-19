function success = us_raw_to_jpg(path_image, path_to_save, filename, show_image)
%% specify paths and load data and header
    path_reco = fullfile(path_image, [filename '.raw']);
    path_mhd = fullfile(path_image, [filename '.mhd']);
    path_save = fullfile(path_to_save, [filename '.jpg']);

%% Read image 
    fid = fopen(path_reco);
    data = fread(fid, 'float32');
    fclose(fid);
    fid2 = fopen(path_mhd, 'r');
    header = fscanf(fid2, '%s');
    
%% read dim-info from mhd
    [~,endIndex] = regexp(header, 'DimSize');
    dimx = str2num(header(endIndex+2:endIndex+5));
    dimy = str2num(header(endIndex+6:endIndex+9));
    numvol = str2num(header(endIndex+10));

%% visualize volume

    BScan = reshape(data, [dimx, dimy, numvol]);
    
    if show_image == true
        figure(1)
        imagesc(BScan')
        colormap gray
        title('B Scan');
    end

%% Write image 
    gray_image = im2gray(BScan');
    imwrite(gray_image,gray, path_save);
    success = true;
end