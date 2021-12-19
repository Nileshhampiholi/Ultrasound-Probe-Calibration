function [ needleAdapPose ] = getNeedlePosesForTipCaliration( self,N )
%transfMarkToTip Calculates the transformation from marker to needletip
%   Detailed explanation goes here

%% Load the transformation camera to marker once 
name = 'NeedleRNMOrig';
self.loadLocator(name);


prompt = 'Fix the needle and hit enter when you are ready';
input(prompt);
needleAdapPose = zeros(4,4,N);

i = 1;
while i<=N
    
    [transformMatrix,~]  = self.getLocatorTransformMatrix(name);
    
    if (sum(transformMatrix(:))~=1)
        needleAdapPose(:,:,i) = transformMatrix;
        i = i+1;
    else
        disp('Sorry, could not read the sensors, please try again!');
    end
    fprintf('%f\n', (i-1)/N);
    %prompt = 'Hit enter to continue';
    %input(prompt,'s');
    pause(1);
end

end