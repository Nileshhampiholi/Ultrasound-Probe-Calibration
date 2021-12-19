x = 226; %[px]
y = 132; %[px]

tumorPx = [x; y];

xmmPerPx = 0.0819;
ymmPerPx = 0.0833;
scaleMat = diag([xmmPerPx ymmPerPx]);

tfMatImageToProbe = [[   -0.2958   -0.9552   -0.0135  -44.6195];
                     [   -0.9536    0.2944    0.0637   71.3635];
                     [    0.0569   -0.0317    0.9979   17.9848];
                     [         0         0         0    1.0000]];

tfMatProbeToCamera = 1.0e+03 * [[ -0.0010   -0.0001   -0.0002    0.0110];
                                [  0.0001    0.0006   -0.0008   -0.1264];
                                [  0.0002   -0.0008   -0.0006   -1.5563];
                                [       0         0         0    0.0010]];
                            
tumorMm = (scaleMat*reshape(tumorPx,2,[]))';
tumorPoseInImage = [tumorMm 0 1]';
tumorPoseInCamera = tfMatProbeToCamera*tfMatImageToProbe * tumorPoseInImage;