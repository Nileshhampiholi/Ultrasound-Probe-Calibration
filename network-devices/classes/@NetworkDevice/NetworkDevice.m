classdef (Abstract) NetworkDevice
    %NETWORKDEVICE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        client;
    end
    properties
        % verbose==1: displays all network msgs.
        verbose = 1;
        delay = 0.01;
    end    
    methods (Access = protected)
        function self = NetworkDevice(ip, port)
            self.client = self.connect(ip, port);
        end
    end

    methods (Static)
        function displayMsg(msg)
            fprintf('MSG: %s\n', msg);
        end
        function displayCmdMsg(cmd,msg)
            fprintf('CMD: %s\nMSG: %s\n', cmd, msg);
        end
    end
    
    methods (Access = private)
        function client = connect(self, ip, port)
            switch(class(ip))
                case 'IPaddresses'
                    ip = char(ip);
                case 'char'
                    ip = regexp(ip, '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$', 'match');
                    if(isempty(ip))
                        error('Your input should have an IP format!');
                    else
                        ip = char(ip);
                    end
                otherwise
                    ip = char(Robot.promptForIP());
            end
            % Open the TCP/IP-Connection
            client = jtcp('request', ip, port,'serialize',false);
            pause(0.1);
            msg = char(jtcp('read',client));
            disp(msg);
        end
    end
    
end

