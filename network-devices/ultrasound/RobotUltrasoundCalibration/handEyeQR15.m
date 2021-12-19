function [Y_orth, X, Y] = handEyeQR15(Mi, Ni)

numObs = size(Mi,3);

% perform and evaluate the calibration for n samples
nCnt = 0;
for n = numObs
    nCnt = nCnt+1;
    [X, Y] = QR15(Mi(:,:,1:n), Ni(:,:,1:n));
    Y_orth_sum = zeros(4,4);
    for i=1:numObs
        % Trying Ortonormalisation of YN
        YNi = Y*Ni(:,:,i);
        [UYNi, SYNi, VYNi] = svd(YNi(1:3,1:3));
        YNi_orth = UYNi*VYNi';
        Y_rot_orth = YNi_orth(1:3,1:3)*Ni(1:3,1:3,i)';
        Y_trans_orth = YNi(1:3,4)-Y_rot_orth(1:3,1:3)*Ni(1:3,4,i);
        Y_orth_new = [[Y_rot_orth Y_trans_orth]; [0 0 0 1]];
        Y_orth_sum = Y_orth_sum + Y_orth_new;
    end
    Y_orth = Y_orth_sum ./ numObs ;
end
end