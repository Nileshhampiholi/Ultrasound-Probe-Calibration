function solve_hand_eye_problem(trial_no, method, minObs,validatSet, jumpObs,home_path )

%% Read all files 
      if method ==1
        % Robot Poses 
        AA = csvread(fullfile(home_path,"robot_poses", trial_no, "\error_free\robot_poses.csv"));
        AA = reshape(AA',4,4,[]);
        AA = permute(AA, [2 1 3]);

        % Corresponding pose estimation
        BB = csvread(fullfile(home_path,"registration_icp\", trial_no,"\registration_poses.csv"));
        BB = reshape(BB',4,4,[]);
        BB = permute(BB, [2 1 3]);

      elseif method == 2
        % Robot Poses 
        AA = csvread(fullfile(home_path,"robot_poses\", trial_no, "error_free\robot_poses.csv"));
        AA = reshape(AA',4,4,[]);
        AA = permute(AA, [2 1 3]);

        % Corresponding pose estimation
        BB = csvread(fullfile(home_path,"registration_geometry\", trial_no,"\registration_poses.csv"));
        BB = reshape(BB',4,4,[]);
        BB = permute(BB, [2 1 3]);

      end
 
 %% 
%     minObs = 20; 
%     validatSet = 20;
%     doPerm = true; 
%     jumpObs = 5;
%     minObs = 20; 
%     validatSet = 30;
%     doPerm = true; 
%     jumpObs = 5;

%     minObs = 30; 
%     validatSet = 100;
%  
%     jumpObs = 20;

    Mi = AA;%(:,:,1:80);
    Ni = BB;%(:,:,1:80);
    doPerm = true; 
     
    disp(' ');
    disp('Overall Transformation: ');
    [X_orth, Y_orth, X, Y, trnslErrAll, trnslOrthErrAll, rotErrAll, rotOrthErrAll, randInd] = handEyeQR24(Mi, Ni, 1, 'Minv', minObs, validatSet, doPerm, jumpObs);

    csvwrite(fullfile(home_path,"solve_ax_y_b\", strcat(trial_no,".csv")), [X_orth; Y_orth]);

end

