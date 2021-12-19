function [ transfMarkToTip ] = markToTipCaliration( self,needleTip_m )
%transfMarkToTip Calculates the transformation from marker to needletip
%   Detailed explanation goes here

%% Load the transformation camera to marker once 
name = 'NeedleRNMOrig';
self.loadLocator(name);


prompt = 'Fix the needle and hit enter when you are ready';
input(prompt);

flag = 1;
while flag == 1
[camToMark,~] = self.getLocatorTransformMatrix(name);
flag = 0;
if (sum(camToMark(:))==1)
    flag = 1;    
    disp('Sorry, could not read the sensors, please try again!');
end

end

%% Loading the point-trained stylus and pointing at the needleend
name = 'stylus2';
self.loadLocator(name);

prompt = 'How many points for calibrating the needle end?';
N = input(prompt);

prompt = 'Place the stylus at the needleend and hit enter when you are ready';
input(prompt);

stylusPose = zeros(4,4,N);
i = 1;
while i<=N
    
    [transformMatrix,~]  = self.getLocatorTransformMatrix(name);
    
    if (sum(transformMatrix(:))~=1)
        stylusPose(:,:,i) = transformMatrix;
        i = i+1;
    else
        disp('Sorry, could not read the sensors, please try again!');
    end
    fprintf('%f\n', (i-1)/N);
    prompt = 'Hit enter to continue';
    input(prompt,'s');
    
end

%% Finally calculate Transformation from marker to needletip
needleEnd_c = 0;
for i=1:N
    needleEnd_c = needleEnd_c + getTrans(stylusPose(:,:,i));
end
% averaging the translational part in cam. coordinates
needleEnd_c = needleEnd_c / N;
% calculating needleend in marker coordinates
needleEnd_m = inv(camToMark) * [needleEnd_c;1];

% third column of the transformationmatrix
z = needleTip_m - needleEnd_m(1:3) ;
z = z/norm(z);

% second column of the transformationmatrix
y = cross(needleTip_m,needleEnd_m(1:3));
y = y/norm(y);

% first column of the transformationmatrix
x = cross(y,z);
x = x/ norm(x);

% rotational part
rotmarktoTip=[x,y,z];

transmarktoTip=needleTip_m;
transfMarkToTip = [ rotmarktoTip transmarktoTip(1:3) ; 0 0 0 1]



end

