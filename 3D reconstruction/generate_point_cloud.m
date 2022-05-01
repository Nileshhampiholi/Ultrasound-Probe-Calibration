function point_cloud = generate_point_cloud(path, show_image)

%%
    files = dir(fullfile(path, "*.jpg"));
    files = struct2table(files);
    file_names = files.name(3:end);
    file_path = files.folder;
    numberOfSlices = length(file_names);
    point_cloud =[];
    scale = get_pixel_to_mm_conversion_factor_part(path);
%%
    for slice = 1:numberOfSlices
        fullFileName = fullfile(file_path{slice}, file_names{slice});
        image = imread(fullFileName); 
        gray_image = im2gray(image);
        binary = imbinarize(gray_image, 0.5);     
        [rows, columns] = find(binary');
        scaled = [rows, columns] *scale;
        points = [scaled(:,1), ones(size(rows,1),1), scaled(:,2)]; 
        point_cloud = [point_cloud; pointCloud(points)];
%%        
        if show_image
            figure(8)
            imagesc(image)
            xlabel('u', 'FontSize', 24)
            ylabel('w', 'FontSize', 24)

            figure(9)
            imagesc(binary)
            xlabel('u', 'FontSize', 24)
            ylabel('w', 'FontSize', 24)
            
            figure(10)

            plot(rows, columns, '.r')
            xlabel('u', 'FontSize', 24)
            ylabel('w', 'FontSize', 24)

             
            figure(11)
            plot(scaled(:,1), scaled(:,2), '.r')
            xlabel('X', 'FontSize', 24)
            ylabel('Z', 'FontSize', 24)
            
            pause;


%             figure
%             subplot(2,2,1)
%             imagesc(image)
%             xlabel('u', 'FontSize', 24)
%             ylabel('w', 'FontSize', 24)
% 
%             subplot(2,2,2)
%             imagesc(binary)
%             xlabel('u', 'FontSize', 24)
%             ylabel('w', 'FontSize', 24)
% 
%             subplot(2,2,3)
%             plot(rows, columns, '.r')
%             xlabel('u', 'FontSize', 24)
%             ylabel('w', 'FontSize', 24)
% 
% 
%             subplot(2,2,4)
%             h1 = axes;
%             plot(scaled(:,1), scaled(:,2), '.r')
%             xlabel('u', 'FontSize', 24)
%             ylabel('w', 'FontSize', 24)
%             set(h1, 'Ydir', 'reverse')
        end
    end
end