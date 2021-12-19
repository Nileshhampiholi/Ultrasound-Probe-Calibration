classdef DevanitHartenberg
    %DEVANITHARTENBERG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess='public', SetAccess='private')
        thetas=sym('theta', [6 1])
        ds=sym('d', [6 1])
        as=sym('a', [6 1])
        alphas=sym('alpha', [6 1])
    end
    
    methods (Access = public)
        function self = DevanitHartenberg(thetas, ds, as, alphas)
            if(~isequal(size(thetas), size(ds), size(as), size(alphas)))
                error('Vector size of Devanit-Hartenberg parameters should be equal!');
            else
                self.thetas=thetas;
                self.ds=ds;
                self.as=as;
                self.alphas=alphas;
            end
        end
    end
    methods (Static, Access = private)
        function matrix = dhMat(theta,d,a,alpha)
            matrix = [ ...
                cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha),  a*cos(theta); ...
                sin(theta), cos(theta)*cos(alpha),  -cos(theta)*sin(alpha), a*sin(theta); ...
                0,          sin(alpha),             cos(alpha),             d; ...
                0,          0,                      0,                      1];
        end
    end
    methods (Access = public)
        function matrix = getA(self,i,theta)
            d = self.ds(i);
            a = self.as(i);
            alpha = self.alphas(i);
            if length(i)>1
                matrix = eye(4);
                for j = 1:length(i)
                    matrix = matrix*DevanitHartenberg.dhMat(theta(j),d(j),a(j),alpha(j));
                end
            else               
                matrix = DevanitHartenberg.dhMat(theta,d,a,alpha);
            end
            
        end
        function matrix = getAinv(self,i,theta)
            d = self.ds(i);
            a = self.as(i);
            alpha = self.alphas(i);
            matrix = [ ...
                cos(theta),             sin(theta),             0,          -a; ...
                -sin(theta)*cos(alpha), cos(theta)*cos(alpha),  sin(alpha), -d*sin(alpha); ...
                sin(alpha)*sin(theta),  -cos(theta)*sin(alpha), cos(alpha), -d*cos(alpha); ...
                0,          0,                      0,                      1];
        end
    end
end

