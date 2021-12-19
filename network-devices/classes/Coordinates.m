classdef Coordinates
    properties
        x = 0;
        y = 0;
        z = 0;
    end
    methods
        function obj = Coordinates(x,y,z)
            obj.x = x;
            obj.y = y;
            obj.z = z;
        end
        function s = char(self)
            s = sprintf('x = %0.1f y = %0.1f z = %0.1f', self.x, self.y, self.z);
        end
        function  display(self)   
            disp(char(self));
        end
    end
end