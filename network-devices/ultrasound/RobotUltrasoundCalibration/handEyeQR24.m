function [X_orth, Y_orth, X, Y, trnslErrAll, trnslOrthErrAll, rotErrAll, rotOrthErrAll, randInd] = handEyeQR24(Mi, Ni, varargin)

% QR24 parameters:
transFactor = 1; % factor to rescale translational values
conf = 'Minv'; % parameter to select one of the two possible ways to solve the eqns in QR24 method

% evaluation parameters:

% Let's say there are N poses in Mi & Ni. We would like to see by
% improvement in the calib with increasing number of poses provided to
% QR24. We will start with QR24 applied to only 'minObs' of the N poses. We
% would also like to keep a certain set of poses ('validatSet') for validation, i.e., not
% used in QR24. We can also permutate the order of the poses (doPerm==true) in the Mi and
% Ni vars, to select different validatSet each time this function
% ('handEyeQR24') is called. 'jumpObs' defines how to increment from
% 'minObs' to 'maxObs == N-validatSet'

minObs = 10; 
validatSet = 10;
doPerm = false;
jumpObs = 10;
if nargin == 3
    transFactor = varargin{1};
elseif nargin == 4
    transFactor = varargin{1};
    conf = varargin{2};
elseif nargin == 5
    transFactor = varargin{1};
    conf = varargin{2};
	minObs = varargin{3};
elseif nargin == 6
    transFactor = varargin{1};
    conf = varargin{2};
	minObs = varargin{3};
	validatSet = varargin{4};
elseif nargin == 7
    transFactor = varargin{1};
    conf = varargin{2};
	minObs = varargin{3};
	validatSet = varargin{4};
	doPerm  = varargin{5};
elseif nargin == 8
    transFactor = varargin{1};
    conf = varargin{2};
	minObs = varargin{3};
	validatSet = varargin{4};
	doPerm  = varargin{5};
    jumpObs = varargin{6};
elseif nargin ~= 2
    error('handEyeQR24:argChk', ['Wrong number of input arguments\n',...
                          'Usage: [X, Y] = handEyeQR24(RobPoses, TrackedLocatorPoses[, transFactor, conf, minObs, validatSet, doPerm, jumpObs])'])
end

numObs = size(Mi,3);

randInd = 1:numObs;
if doPerm
	randInd = randperm(numObs,numObs);
	Mi = Mi(:,:,randInd);
	Ni = Ni(:,:,randInd);
end

% QR24 Trials for varying number of observations
if (validatSet == numObs)
    maxObs = numObs;
    validStart = 1;
else
    maxObs = numObs-validatSet;
    validStart = maxObs+1;
end
obsForCalib =  minObs:jumpObs:maxObs;
numCalcs = length(obsForCalib);
trnslErrAll = zeros(numCalcs,validatSet);
trnslOrthErrAll = zeros(numCalcs,validatSet);
rotErrAll = zeros(numCalcs,validatSet);
rotOrthErrAll = zeros(numCalcs,validatSet);
errFroNormAll = zeros(numCalcs,validatSet);
errOrthFroNormAll = zeros(numCalcs,validatSet);
% perform and evaluate the calibration for n samples
nCnt = 0;
for n = obsForCalib % try 5:numObs-5
    nCnt = nCnt+1;
    [X, Y] = QR24(Mi(:,:,1:n), Ni(:,:,1:n), transFactor, conf);
    X_orth_sum = zeros(4,4);
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
        X_orth_new = invTfMat(Mi(:,:,i))*Y_orth_new*Ni(:,:,i);
        X_orth_sum = X_orth_sum + X_orth_new;
    end
    Y_orth = Y_orth_sum ./ numObs ;
    X_orth = X_orth_sum ./ numObs ;
    iCnt = 1;
    for i=validStart:numObs
        errFroNormAll(nCnt,iCnt) = norm(Mi(:,:,i)*X - Y*Ni(:,:,i),'fro');
        errOrthFroNormAll(nCnt,iCnt) = norm(Mi(:,:,i)*X_orth - Y_orth*Ni(:,:,i),'fro');
        
        expctdIdent = invTfMat(X)*invTfMat(Mi(:,:,i))*Y*Ni(:,:,i);
        expctdIdentOrth = invTfMat(X_orth)*invTfMat(Mi(:,:,i))*Y_orth*Ni(:,:,i);
        % translation error
        trnslErrAll(nCnt,iCnt) = norm(expctdIdent(1:3,4));
        trnslOrthErrAll(nCnt,iCnt) = norm(expctdIdentOrth(1:3,4));
        % rotation error
        R = expctdIdent(1:3,1:3);
        R_orth = expctdIdentOrth(1:3,1:3);
        %orthonormalization
        [u,s,v] = svd(R);
        r = vrrotmat2vec(u*v');
        rotErrAll(nCnt,iCnt) = rad2deg(r(4));
        [u,s,v] = svd(R_orth);
        r = vrrotmat2vec(u*v');
        rotOrthErrAll(nCnt,iCnt) = rad2deg(r(4));
        iCnt = iCnt + 1;
    end
end
meanTrnslErr = mean(trnslErrAll,2);
meanRotErr = mean(rotErrAll,2);
meanErrFroNorm = mean(errFroNormAll,2);

meanTrnslOrthErr = mean(trnslOrthErrAll,2);
meanRotOrthErr = mean(rotOrthErrAll,2);
meanOrthErrFroNorm = mean(errOrthFroNormAll,2);

statsTBStatus = license('checkout','Statistics_Toolbox');

% plot the errors
scrsz = get(groot,'ScreenSize');
figure('Position',[10 scrsz(4)*1/8 scrsz(3)*3/4 scrsz(4)*3/4]);
subplot(3,1,1)
p111 = plot(obsForCalib, meanTrnslErr,'k', 'DisplayName', 'Mean Transl. Err.');
hold on;
p112 = plot(obsForCalib, meanTrnslOrthErr,'k-.', 'DisplayName', 'Mean Transl. Err. after OrthN.');
if statsTBStatus
    boxplot(trnslErrAll',obsForCalib,'positions',obsForCalib, 'Whisker', Inf)
else
    for iii = 1:numCalcs
        bplot(trnslErrAll(iii,:)',obsForCalib(iii), 'whisker', 0)
    end
end
hold off;
axis tight
legend([p111 p112])
xlabel('number of samples used')
ylabel('Calibration error in mm');
subplot(3,1,2);
p211 = plot(obsForCalib,meanRotErr,'r', 'DisplayName', 'Mean Rot. Err.');
hold on;
p212 = plot(obsForCalib, meanRotOrthErr,'r-.', 'DisplayName', 'Mean Rot. Err. after OrthN.');
if statsTBStatus
    boxplot(rotErrAll',obsForCalib,'positions',obsForCalib, 'Whisker', Inf)
else
    for iii = 1:numCalcs
        bplot(rotErrAll(iii,:)',obsForCalib(iii), 'whisker', 0)
    end
end
hold off;
axis tight
legend([p211 p212])
xlabel('number of samples used');
ylabel('Calibration error in degree');
subplot(3,1,3);
p311 = plot(obsForCalib,meanErrFroNorm,'b', 'DisplayName', 'Fro. Norm Err.');
hold on;
p312 = plot(obsForCalib, meanOrthErrFroNorm,'b-.', 'DisplayName', 'Fro. Norm Err. after OrthN.');
if statsTBStatus
    boxplot(errFroNormAll',obsForCalib,'positions',obsForCalib, 'Whisker', Inf)
else
    for iii = 1:numCalcs
        bplot(errFroNormAll(iii,:)',obsForCalib(iii),'whisker', 0)
    end
end
hold off;
axis tight
legend([p311 p312])
xlabel('number of samples used');
ylabel('Fro. Norm of (M*X - Y*N)');
% clc
disp(['Mean translation error: ' num2str(meanTrnslErr(end)) ' mm'])
disp(['Mean translation error after orthonormalization: ' num2str(meanTrnslOrthErr(end)) ' mm'])
disp(['Mean rotation error: ' num2str(meanRotErr(end)) ' degrees'])
disp(['Mean rotation error after orthonormalization: ' num2str(meanRotOrthErr(end)) ' degrees'])
disp(['Mean Fro. Norm: ' num2str(meanErrFroNorm(end))])
disp(['Mean Fro. Norm after orthonormalization: ' num2str(meanOrthErrFroNorm(end))])

% disp('R^H_T: ');
% disp(Y);
% disp('R^H_T orth: ');
% disp(Y_orth);
% 
% disp('E^H_M: ');
% disp(X);
% disp('E^H_M orth: ');
% disp(X_orth);