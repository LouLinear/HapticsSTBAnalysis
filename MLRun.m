clear all; close all; clc;
addpath SavedData
addpath ML

time = datestr(now, 'ddmmyyHHMM');
mkdir(strcat('MLRun_',num2str(time)))
addpath(strcat('MLRun_',num2str(time)))
% cd(strcat('MLRun_',num2str(time)))

% run('../ML/Test.m')

ForwardSelection(1,time);
ensembleTestSelectFeaturesRoundCVPart(1, 1, 1, time, strcat('MLRun_',num2str(time)))
%randomForestAll(1,1,time,5);
% randomForestAll(1,1,time);
% randomForestAll(1,1,time);
% randomForestAll(1,1,time);
% randomForestAll(1,1,time);