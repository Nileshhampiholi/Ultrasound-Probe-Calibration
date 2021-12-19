function [window] = calibrateWindow(cambar)
%CALIBRATEWINDOW prompts the user to poke the window corners,
% and averages the position to get the window in camera coordinates
    name = 'stylus2';
    cambar.loadLocator(name);
    disp('Dear user, poke the 1st point of the window. Are you ready?');
    pause();
    [tf,~] = cambar.getSafeLocatorTransformMatrix(name);    
    p1 = tf(1:3,4);
    disp('Dear user, poke the 2nd point of the window. Are you ready?');
    pause();
    [tf,~] = cambar.getSafeLocatorTransformMatrix(name);
    p2 = tf(1:3,4);
    disp('Dear user, poke the 3rd point of the window. Are you ready?');
    pause();
    [tf,~] = cambar.getSafeLocatorTransformMatrix(name);
    p3 = tf(1:3,4);
    disp('Dear user, poke the 4th point of the window. Are you ready?');
    pause();
    [tf,~] = cambar.getSafeLocatorTransformMatrix(name);
    p4 = tf(1:3,4);
    window = (p1+p2+p3+p4)/4;
    window = [window; 1];
end