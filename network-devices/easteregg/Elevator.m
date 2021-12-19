classdef Elevator
    %ELIVATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ipanemaPlayer
        bellPlayer
    end
    
    methods (Access = public)
        function self = Elevator()
            [ipanema,ipanemaFs] = audioread('easteregg\ipanema.ogg');
            [bell,bellFs] = audioread('easteregg\bellring.ogg');
            self.ipanemaPlayer = audioplayer(ipanema, ipanemaFs);
            self.bellPlayer = audioplayer(bell, bellFs);
        end
        
        function play(self, msg)
            disp(msg);
            play(self.ipanemaPlayer);
        end
        
        function stop(self, msg)
            disp(msg);
            stop(self.ipanemaPlayer);
            play(self.bellPlayer);
        end
    end
    
end

