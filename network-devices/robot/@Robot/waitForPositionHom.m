function waitForPositionHom(self,H,varargin)
direct = false;
if (nargin == 3)
    direct = varargin{1};
elseif (nargin ~= 2)
    error('Wrong number of args!');
end

if(~all(size(H) == [3,4]))
    error('Hom matrix has to have 3x4 dimensions');
else
    if (direct)
        currentH = self.getExactPositionHomRowWise();
    else
        currentH = self.getPositionHomRowWise();
    end
    while(sum(abs(currentH(:)-H(:))) > 1e-1)
        i = 0;
        while(size(self.client.outputStream) == 0)
            i = i + 1;
            if(mod(i, 10))
                disp('Waiting for positioning...');
            end
        end
        
        pause(0.5);
        if (direct)
            currentH = self.getExactPositionHomRowWise();
        else
            currentH = self.getPositionHomRowWise();
        end
    end
end
end

