classdef IPaddresses
    enumeration
        Robot_Lab, Robot_Local, Robot_VM, Cambar_Lab, Robot_VM2, TrackingServer_Laptop
    end
    methods
        function s = char(obj)
            switch(obj)
                case IPaddresses.Robot_Local
                    s = '127.0.0.1';
                case IPaddresses.Robot_Lab
                    s = '134.28.45.11';
                case IPaddresses.Robot_VM
                    s = '192.168.56.101';
                case IPaddresses.Robot_VM2
                    s = '192.168.56.102';
                case IPaddresses.Cambar_Lab
                    s = '134.28.45.63';
                case IPaddresses.TrackingServer_Laptop
                    s = '134.28.45.17';
            end
        end        
        function disp(obj)
            disp( char(obj) )
        end
    end
end