close all;
clear all;
clc;
set(groot, 'DefaultAxesFontName', 'LM Sans 12');
set(groot,'DefaultAxesFontSize', 12)
set(groot,'DefaultAxesXGrid', 'on')
set(groot,'DefaultAxesYGrid', 'on')
set(groot,'DefaultAxesZGrid', 'on')
% scrsz = get(groot,'ScreenSize');
set(groot, 'DefaultFigurePosition', [1 41 1600 783])%[10 scrsz(4)*1/8 scrsz(4)* scrsz(4)*3/4*3/4])
set(groot,'DefaultTextInterpreter', 'latex')
set(groot,'DefaultFigureColormap', parula)