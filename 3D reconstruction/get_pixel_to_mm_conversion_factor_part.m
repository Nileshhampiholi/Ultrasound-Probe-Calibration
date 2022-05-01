function scaleMat = get_pixel_to_mm_conversion_factor_part(path)
    %% List files in dir
    files = dir(fullfile(path, '*.jpg'));
    files = struct2table(files);
    file_names = files.name;
    % Read images
    

    %% Read 1st image 
    path_image = fullfile(path, file_names{1});
    I = imread(path_image);
    sz = size(I);
    xmmPerPxAll = zeros(1,size(file_names,1));
    %% Are the known values same ffor me as well. I mean same probe was used?
    % If not where to find this value 
    % 1876
    ymmPerPx = 40.0 / 2001; % known
    
    for idx=1:size(file_names,1)
        
        I = imread(fullfile(path, file_names{idx}));
        sumRow = sum(I,1);
        indF = find(sumRow, 1, 'first');
        indL = find(sumRow, 1, 'last');
        widthPxUS = indL - indF + 1;
        % why 38 
        xmmPerPxAll(idx+1) = 38 / widthPxUS;
    end
    xmmPerPx = mean(xmmPerPxAll);
    scaleMat = diag([xmmPerPx  ymmPerPx]);

end