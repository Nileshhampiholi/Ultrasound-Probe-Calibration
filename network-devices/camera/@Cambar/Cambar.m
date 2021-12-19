classdef Cambar < NetworkDevice
    %CAMBAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        %
        locator = loadLocator(self,name)
        %
        [T,timestamp,visFlag] = getLocatorTransformMatrix(self, name)
        %
        [T,timestamp] = getSafeLocatorTransformMatrix(self, name)
        [nPoses] = getNeedlePosesForTipCaliration(self, N)
        %
        bye(self)
        % Constructor
        function self = Cambar(ip,port)
            self@NetworkDevice(ip,port);
            % Send the keyword to authorize the client
            % msg = self.sendReceive('mtec');
            % disp(msg);
            % Writing to server.
            self.send('mtec');
        end
        % QR Calibration
        [ EndeffToMark, RobToTrack ] = robotCamCalibrationQR24(self,robot)
        % Needletip Calibration
        needleTipP = needleTipCalibration(self)
        % Transformation form marker to needletip
        transfMarkToTip = markToTipCaliration(self,needleTip_m)
    end
    
    methods (Access = private)
        %% Disconnects from robot.
        function disconnect(self)
            jtcp('close',self.client);
        end
    end
end

