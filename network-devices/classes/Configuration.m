classdef Configuration
    properties
        flip=true
        up=false;
        lefty=false;
    end
    methods
        function obj = Configuration(flip,up,lefty)
            if(~(islogical(flip) && islogical(up) && islogical(lefty)))
                if(~(isnumeric(flip) && isnumeric(up) && isnumeric(lefty)))
                    if(~(ischar(flip) && ischar(up) && ischar(lefty)))
                        error('Arguments for Configuration constructor are not valid.');
                    else
                        switch(flip)
                            case 'flip'
                                flip = true;
                            case 'noflip'
                                flip = false;
                            otherwise
                                error(sprintf('flip argument has to be flip/noflip instead of %s', flip));
                        end
                        switch(up)
                            case 'up'
                                up = true;
                            case 'down'
                                up = false;
                            otherwise
                                error(sprintf('up argument has to be up/down instead of %s', up));
                        end
                        switch(lefty)
                            case 'lefty'
                                lefty = true;
                            case 'righty'
                                lefty = false;
                            otherwise
                                error(sprintf('lefty argument has to be lefty/righty instead of %s', lefty));
                        end
                    end
                else
                    switch(flip)
                        case 1
                            flip = true;
                        case 0
                            flip = false;
                        otherwise
                            error('flip hast to be 1/0');
                    end
                    switch(up)
                        case 1
                            up = true;
                        case 0
                            up = false;
                        otherwise
                            error('up has to be 1/0');
                    end
                    switch(lefty)
                        case 1
                            lefty = true;
                        case 0
                            lefty = false;
                        otherwise
                            error('lefty has to be 1/0');
                    end
                end
            end
            
            obj.flip=flip;
            obj.up=up;
            obj.lefty=lefty;
        end
        function s = char(self)
            if(self.flip); flipnoflip='flip'; else flipnoflip='noflip'; end
            if(self.up); updown='up'; else updown='down'; end
            if(self.lefty); leftyrighty='lefty'; else leftyrighty='righty'; end
            s = sprintf('%s %s %s\n', flipnoflip, updown, leftyrighty);
        end
        function  display(self)
            disp(char(self));
        end
    end
end