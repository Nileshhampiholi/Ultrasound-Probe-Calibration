clear all
close all
clc
instrreset


%%%%%%%%%%
% The Cephasonics system needs to be running in cc mode. Check throughput
% with script on Desktop and if necessary re-insert DMA driver. You can find more infos
% in the MTEC WIKI.

% Run QT with config file:
% shear wave -> config/configCephasonicsSW.xml
% volume probe -> config/configCephasonics3D_TUHH.xml
%%%%%%%%%%
%% Connect to Server
US=tcpip('134.28.45.11',4567);
fopen(US);
set(US, 'TimeOut', 1);

%% Choose .xml Profile - B Mode Imaging
fprintf(US,'setParametersXMLFile\n/home/tuhh/git/supra_shearwave/config/configCephasonics.xml\n');
out = fscanf(US);
disp(out);
%% Choose .xml Profile - SWEI
fprintf(US,'setParametersXMLFile\n/home/tuhh/git/supra_shearwave2/config/configCephasonicsSW2.xml\n');
out = fscanf(US);disp(out);

%% Acquire B-mode image
% Set Filename
FileName = 'testFileName';
ImageFrame = '1';

fprintf(US,['setParameter\nMHD\nfilename\n' FileName '\n']);
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end

fprintf(US,['setParameter\nMHD\nmaxElements\n' ImageFrame '\n']);
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end
%%
fprintf(US,'unfreezeImaging\n');
out = fscanf(US);
disp(out);

pause(5)

fprintf(US,'startSequence\n');
out = fscanf(US);
disp(out)

pause(5);

fprintf(US,'stopSequence\n');
out = fscanf(US);
disp(out)

fprintf(US,'freezeImaging\n');
out = fscanf(US);
disp(out)

%% Stop Imaging
fprintf(US,'stopImaging\n');
out = fscanf(US);
disp(out);
out = fscanf(US);
disp(out);
%% Parameters for Pushing
parameters_US = {...
    'mockDataFilename'				'testfolder';...
    'pushVoltage'					100;...
    'pushXLocation'					0 ;...
    'writeMockData'					1 ;...
    'antiAliasingFilterFrequency'	15 ;...
    'decimation'					2 ;...
    'decimationFilterBypass'		1;...
    'endDepth'						30 ;...
    'highPassFilterBypass'			1 ;...
    'highPassFilterFrequency'		0.898;...
    'imagingBeams'					3;...
    'imagingFrames'					20;...
    'imagingVoltage'				120;...
    'inputImpedance'				200;...
    'lowNoiseAmplifierGain'			18.5;...
    'measureThroughput'				0;...
    'pauseAfterPush'				0.25;...
    'pre'							0;...
    'prf'							7000;...
    'probeName'						'CPLA12875';...
    'pushFocalDepth'				20;...
    'pushMode'						'Both';...
    'pushPulses'					2500;...
    'raw'							1;...
    'scanAngle'						10;...
    'shiftCount'					1;...
    'shiftRatio'					0.25;...
    'speedOfSound'					1615;...
    'startDepth'					10;...
    'systemTxClock'					20;...
    'tgc0'							18;...
    'tgc1'							21;...
    'tgc10'							55;...
    'tgc2'							24;...
    'tgc3'							27;...
    'tgc4'							26;...
    'tgc5'							30;...
    'tgc6'							32;...
    'tgc7'							33;...
    'tgc8'							40;...
    'tgc9'							52;...
    'txFrequency'					5.5;...
    };

clc
for p = 1:size(parameters_US,1)
    fprintf(US,['setParameter\nUS-Cep\n' parameters_US{p,1} '\n' num2str(parameters_US{p,2}) '\n']);
    out = fscanf(US);disp(out);
    
    if contains( out,'wrong')==1
        ['setParameter\nUS-Cep\n' parameters_US{p,1} '\n' num2str(parameters_US{p,2}) '\n']
    end
end
%% Push 1
fprintf(US,'startImaging\n');
out = fscanf(US);
disp(out);

% Received Command
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end

% Finished Pushing
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end
%% Push XX
fprintf(US,'unfreezeImaging\n');
out = fscanf(US);
disp(out)

% Received Command
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end

% Finished Pushing
out = [];
while isempty(out)==1
    out = fscanf(US);
    disp(out);
end
%% Get Parameters from current .xml file
fprintf(US,'getParameters\n');
out=[];
while true
    str = fscanf(US);
    out = [out str];
    if isempty(str) == 1
        break
    end
end
clc
params = fprintf(out);

%% Load Beamformed Image
fileID  = fopen('C:\Users\Neidhardt\Desktop\beamformed2_1.raw');
image = fread(fileID,'float32');
(2500*2000)-size(image,1)
imagesc(reshape(image,2500,2000))
%% Define Scanlines of Volume Probe
scanlines_x_dir = 16;
fprintf(US,['setParameter\nUS-Cep\nnumScanlinesX\n' scanlines_x_dir  '\n']);
out = fscanf(US);
disp(out)

scanlines_y_dir = 8;
fprintf(US,['setParameter\nUS-Cep\nnumScanlinesY\n' scanlines_y_dir  '\n']);
out = fscanf(US);
disp(out)

%% Record Sequence of Volumes
fprintf(US,'unfreezeImaging\n');
out = fscanf(US);
disp(out)

pause(5)

fprintf(US,'startSequence\n');
out = fscanf(US);
disp(out)

pause(20);

fprintf(US,'stopSequence\n');
out = fscanf(US);
disp(out)

fprintf(US,'freezeImaging\n');
out = fscanf(US);
disp(out)
%% Quit
fprintf(US,'endConnection\n');
fclose(US);
delete(US);
