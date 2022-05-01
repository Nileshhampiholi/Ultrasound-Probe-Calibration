function jTgtNew = wrapJointAngles(jTgt, jRef)
    if nargin ~= 2
        error('Robot::wrapJointAngles: Wrong number of input arguments!');
    end
    corrFlag = abs(jRef-jTgt)>180;
    if any(corrFlag)
        % if self.verbose
        %     jTgtO = jTgt;
        % end
        jTgtNew = jTgt + (jTgt<0).*corrFlag*360 - (jTgt>=0).*corrFlag*360;
        % if self.verbose
        %     fprintf('Joints corrected from \n');
        %     fprintf('%f ', jTgtO)
        %     fprintf('\n to \n');
        %     fprintf('%f ', jTgtNew)
        %     fprintf('\n');
        % end
    else
        jTgtNew = jTgt;
    end