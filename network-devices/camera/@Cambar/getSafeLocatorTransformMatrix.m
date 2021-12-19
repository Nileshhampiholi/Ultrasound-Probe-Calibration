function [T,timestamp] =  getSafeLocatorTransformMatrix(self, name)
%getSafeLocatorTransformMatrix Returns always a transformmatrix which was
%                               read by the cameras
%   Can be used everytime when we have to calibrate by hand

whileflag = 1;
while whileflag == 1
    [T,timestamp] =  self.getLocatorTransformMatrix(name);
    if ( sum(T(:)) == 1 )
        disp('Sorry, could not read the sensors, please try again!');
        prompt = 'Hit enter to continue';
        input(prompt,'s');
    else
        whileflag = 0;
    end
end

end

