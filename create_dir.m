function create_dir(path)

    if ~exist(path, 'dir')
           mkdir(path)
    end

end