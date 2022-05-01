%% Z-Wire Calibration Simulation

% Consider a z-wire phantom with dimensions 20x20 and lying on plane z=20
zoff = 40;
yoff = 20;
xoff = 20;
p1 = [xoff+ 0 yoff+ 0 zoff]';
p2 = [xoff+20 yoff+ 0 zoff]';
p3 = [xoff+ 0 yoff+20 zoff]';
p4 = [xoff+20 yoff+20 zoff]';
p1p2 = p2-p1;
p2p3 = p3-p2;
p3p4 = p4-p3;

pointsPhantomCamera = [p1 p2 p3 p4];

% Visualize the phantom
scrsz = get(groot,'ScreenSize');
figure('Renderer','opengl','Position',[10 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);
hold on;
plot3(pointsPhantomCamera(1,:), pointsPhantomCamera(2,:), pointsPhantomCamera(3,:), '*-')
text(pointsPhantomCamera(1,:), pointsPhantomCamera(2,:), pointsPhantomCamera(3,:), ['$$p_1$$'; '$$p_2$$'; '$$p_3$$'; '$$p_4$$'],'Interpreter','latex', 'FontSize', 14)

scf = 40;
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[1 0 0]',[0 1 0]',[0 0 1]',scf,'k','filled','LineWidth',2)
text([scf 0 0]',[0 scf 0]',[0 0 scf]', ['$$x_\mathrm{cam}$$'; '$$y_\mathrm{cam}$$'; '$$z_\mathrm{cam}$$'],'Interpreter','latex', 'Color','k', 'FontSize', 14)

hold off;
% axis tight
axis equal
axis vis3d
xlabel('x')
ylabel('y')
zlabel('z')
view(30,30)

%% Image Frame
% Let's assume that the Image Reference Frame has the following
% Transformation relative to the Ultrasound Probe Reference Frame
% Note: This transformation will remain fixed. The goal of the calibration
% is to find this transformation. But, in this script we are simulating
% with known transformation to understand the problem.

% Translation
% Assuming that the origin of image frame is offset in y and z
usImOriginInUSP = [0 -20 10]';

% Orientation
rotxHomog = [1 0 0 0; 0 cos(pi/2) -sin(pi/2) 0; 0 sin(pi/2) cos(pi/2) 0; 0 0 0 1];
rotyHomog = [cos(pi/2) 0 sin(pi/2) 0; 0 1 0 0; -sin(pi/2) 0 cos(pi/2) 0; 0 0 0 1];
rotImToUSPHomog = rotxHomog*rotyHomog;
transImToUSPHomog = [[eye(3) usImOriginInUSP]; [zeros(1,3) 1]];
tfUSImToUSP = transImToUSPHomog*rotImToUSPHomog;

%% US probe
% Say, initially the US Probe positioned above the z-phantom centered at
% the mid of z-wire phantom

% This US probe pose would changes with each image
% Following loop tries to model the free hand motion move in x, rot around z
numImages = 0;

% The following three variables would eventually contain the three
% cross-sectional points of the z-wire phantom in Image Reference Frame
c1ImageAll = [];
c2ImageAll = [];
c3ImageAll = [];

% The following variable would eventually contain the middle of the three
% cross-sectional points of the z-wire phantom in Camera Coordinate System.
c2CameraAll = [];

% The following variable would eventually contain the pose of the
% Ultrasound probe in Camera Coordinate System. It would serve similar to
% poses acquired by the Tracking camera (example in
% data\ultrasoundImagesAndPoses\probePoses.txt
probePosesAll = [];
hold on;
axUSP = plot(1);
axTxtUSP = plot(1);
axIm = plot(1);
axTxtIm = plot(1);

% Simulating the free-hand motion
for xv = -5:2.5:5
    for thv = 0:pi/8:pi/8
        delete(axUSP); delete(axTxtUSP); delete(axIm); delete(axTxtIm);
        uspOriginCamera = [xoff+10+xv yoff+10 zoff+20]';
        rotyUSPToCameraHomog = [cos(pi) 0 sin(pi) 0; 0 1 0 0; -sin(pi) 0 cos(pi) 0; 0 0 0 1];
        rotzHomog = [cos(thv) -sin(thv) 0 0; sin(thv) cos(thv) 0 0; 0 0 1 0; 0 0 0 1];
        transUSPToCameraHomog = [[eye(3) uspOriginCamera]; [zeros(1,3) 1]];
        tfUSPToCamera = transUSPToCameraHomog*rotyUSPToCameraHomog*rotzHomog;

        tfUSImToCamera = tfUSPToCamera*tfUSImToUSP;
        %if (numImages == 0 || numImages == 9)
            % Plotting USP Frame for 0th and 9th image
            uspOriginCameraRep = repmat(uspOriginCamera,[1 3]);
            suf = 15;
            axUSP = quiver3(uspOriginCameraRep(1,:),uspOriginCameraRep(2,:),uspOriginCameraRep(3,:),tfUSPToCamera(1,1:3),tfUSPToCamera(2,1:3),tfUSPToCamera(3,1:3),suf,'r','filled','LineWidth',1.5);
            subscr = ['{\mathrm{usp},' num2str(numImages) '}'];
            uspAxes = tfUSPToCamera*[suf*eye(3); [1 1 1]];
            axTxtUSP = text(uspAxes(1,:)',uspAxes(2,:)',uspAxes(3,:)', [['$$x_',subscr,'$$']; ['$$y_',subscr,'$$']; ['$$z_',subscr,'$$']],'Interpreter','latex', 'Color','r', 'FontSize', 14);
            
            
            sif = 10;
            imAxes = tfUSImToCamera*[sif*eye(3); [1 1 1]];
            imOriginCamera = tfUSImToCamera*[zeros(3,1);1];
            imOriginCameraRep = repmat(imOriginCamera, [1,3]);
            axIm = quiver3(imOriginCameraRep(1,:),imOriginCameraRep(2,:),imOriginCameraRep(3,:),tfUSImToCamera(1,1:3),tfUSImToCamera(2,1:3),tfUSImToCamera(3,1:3),suf,'b','filled','LineWidth',1.5);
            subscr = ['{\mathrm{im},' num2str(numImages) '}'];
            axTxtIm = text(imAxes(1,:)',imAxes(2,:)',imAxes(3,:)', [['$$x_',subscr,'$$']; ['$$y_',subscr,'$$']; ['$$z_',subscr,'$$']],'Interpreter','latex', 'Color','b', 'FontSize', 14);
            
        %end
        imSiz = 40;
        imageCorners = imSiz*[0 0 0; 1 0 0; 1 1 0; 0 1 0]; % x,y,z vertex coordinates
        imageCornersInCam = tfUSImToCamera*[imageCorners'; ones(1,4)];
        verts = imageCornersInCam(1:3,:)'; % x,y,z vertex coordinates
        fac = [1 2 3 4]; % vertices to connect to make square
        patch('Faces',fac,'Vertices',verts,'FaceColor', 'g', 'FaceAlpha', 0.5);
        
        probePosesAll = [probePosesAll tfUSPToCamera(:)];
        % points in Image
        % define horizontal plane through origin
        % O v1 v2
        plane = [uspOriginCamera(1:3)'   tfUSPToCamera(1:3,2)'   tfUSPToCamera(1:3,3)'];
        %drawPlane3d(plane, 'g', 'FaceAlpha', 0.5);
        % intersection with a vertical line
        p1p2line = [p1'  p1p2'];
        c1Camera = [intersectLinePlane(p1p2line, plane) 1]';
        p2p3line = [p2'  p2p3'];
        c2Camera = [intersectLinePlane(p2p3line, plane) 1]';
        c2CameraAll = [c2CameraAll c2Camera(1:3)];
        p3p4line = [p3'  p3p4'];
        c3Camera = [intersectLinePlane(p3p4line, plane) 1]';
        cCamera  = [c1Camera(1:3)'; c2Camera(1:3)'; c3Camera(1:3)'];
        hold on
        %drawPoint3d([c1Camera(1:3)'; c2Camera(1:3)'; c3Camera(1:3)'], 'k+');
        plot3(cCamera(:,1),cCamera(:,2),cCamera(:,3),'k+')
        c1Image = inv(tfUSImToUSP)*inv(tfUSPToCamera)*c1Camera;
        c1ImageAll = [c1ImageAll c1Image(1:2)];
        c2Image = inv(tfUSImToUSP)*inv(tfUSPToCamera)*c2Camera;
        c2ImageAll = [c2ImageAll c2Image(1:2)];
        c3Image = inv(tfUSImToUSP)*inv(tfUSPToCamera)*c3Camera;
        c3ImageAll = [c3ImageAll c3Image(1:2)];
        drawnow
        numImages=numImages+1;
        pause(0.5)
    end
end

hold off

%% Inverse - Actual calibration problem
% Same as the code section named 'Estimating Tranformation between image
% coordinate system and US Probe coordinate system.' in the script
% 'MainUltrasoundCameraCalibration'
% ...
