function needleTipP = needleTipCalibration(self)
%% Loading the marker attached to the needle
name = 'NeedleRNMOrig';
self.loadLocator(name);
%% Asking how many points the user want to use
prompt = 'How many points?';
N = input(prompt);

prompt = 'Now fix a point with the needletip (pivot) and hit the enter button when you are ready';
input(prompt);


%% Getting marker poses while pivoting the needle
markPose = zeros(4,4,N);
i = 1;
while i<=N
    
    [transformMatrix,~]  = self.getLocatorTransformMatrix(name);
    
    if (sum(transformMatrix(:))~=1)
        markPose(:,:,i) = transformMatrix;
        i = i+1;
    else
        disp('Sorry, could not read the sensors, please try again!');
    end
    fprintf('%f\n', (i-1)/N);
    prompt = 'Hit enter to continue';
    input(prompt,'s');
    
end

%% Do the needle tip calibration
A = zeros(N*3,6);
b = zeros(N*3,1);
for i=1:N
    Atmp = [ getRot(markPose(:,:,i)) , -eye(3) ];
    p = 1 + 3*(i-1); % Index
    A( p : p+2 , : ) = Atmp;
    b( p : p+2) = -getTrans( markPose(:,:,i));
end

transErrNeedleMat = zeros(N);
for i = 1:N
    p = 1 + 3*(i-1);
    AcalcNeedle( p : p+2 , : )  = A(p : p+2 , :);
    bcalcNeedle( p : p+2 ) = b( p : p+2  );
    
    berrNeedle = bcalcNeedle';
    [Q,R] = qr(AcalcNeedle);
    z = Q'*berrNeedle;
    w = R\z;
    
    needleTipP = w(1:3); % This is y <=> tip in marker coordinates IMPORTANT
    camPiv = w(4:6);     % this is x <=> tip(pivot) in camera coordinates
    
    if i >= 3
        for j=1:N
            transErrNeedle = [camPiv;1] - markPose(:,:,j) * [needleTipP;1];
            transErrNeedleMat(j,i) =  norm(transErrNeedle);
        end
    end
end

figure
boxplot(transErrNeedleMat);
ylabel('Average translation error of the needletip in millimeters');

disp('Needletip point w.r.t. marker coordinates');
needleTipP = w(1:3)
disp('Pivotpoint w.r.t. camera coordinates');
camPiv = w(4:6)

end

