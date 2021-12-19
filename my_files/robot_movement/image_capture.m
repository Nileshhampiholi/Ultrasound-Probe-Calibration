function capture_image = image_capture(US,file_name)
    %% Acquire B-mode image
    % Set Filename
    FileName = file_name;
    ImageFrame = '1';

    fprintf(US,'setParameter\nMHD\nfilename\n %s\n', FileName);
    out = [];
    while isempty(out)==1
        out = fscanf(US);
        disp(out);
    end

    fprintf(US,'setParameter\nMHD\nmaxElements\n %s\n', ImageFrame);
    out = [];
    while isempty(out)==1
        out = fscanf(US);
        disp(out);
    end
    
    %%
    fprintf(US,'startSequence\n');
    out = fscanf(US);
    disp(out)

    pause(5);

    fprintf(US,'stopSequence\n');
    out = fscanf(US);
    disp(out)

    capture_image = true;

end