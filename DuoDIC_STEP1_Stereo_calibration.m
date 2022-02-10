%% DuoDIC: 2-camera 3D-DIC toolbox

%% Step 1: Stereo Camera Calibration
% This is a main script to perform stereo camera calibration using the following steps:
% 1) Select folders with checkerboard images captured from camera1 and camera2
% 2) Select checkerboard square size
% 3) Open MATLAB stereoCameraCalibrator GUI, perform calibration and save session

%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information

%%
clear all; close all; clc;

%%
fs=get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
warning('off','MATLAB:subscripting:noSubscriptsSpecified');

%%
% initial image path
folderPathInitial=pwd;

% select the folder containing the stereo checkerboard images (if imagePathInitial=[] then the initial path is the current path)
folderPath1=uigetdir(folderPathInitial,'Select the folder containing the stereo checkerboard images from the first camera');
folderPathInitial2 = fileparts(folderPath1);
folderPath2=uigetdir(folderPathInitial2,'Select the folder containing the stereo checkerboard images from the second camera');

%% Specify the Square size is in millimeters.
squareSize = 10;
answer = inputdlg({'Enter square size [mm]:'},'Input',[1,50],{num2str(squareSize)});
squareSize=str2double(answer{1});

%% Stereo calibration
createmodeStruct.Interpreter = 'tex';
createmodeStruct.WindowStyle = 'non-modal';
h = msgbox({'\fontsize{14}\bfPlease wait for the images to upload and continue with the Stereo Camera Calibrator GUI using the following instructions:';'';...
    '\rm1. Select Radial distortion, Skew, and Tangential Distortion option.';'';...
    '\rm2. Click on Calibrate.'; '';...
    '\rm3. Examine the reprojection errors. If some of them are too high, drag the red line downwards to select outliers, right click on the detected images and select "Remove and Recalibrate".'; '';...
    '\rm4. Save the session results (calibrationSession.mat file) by clicking on "Save Session" and then close the GUI.';'';...
    '\rm5. Return to MATLAB and press any key to continue.';'';},'Calibaration GUI Instructions',createmodeStruct);

set(0, 'DefaultUIControlFontSize', 10);
stereoCameraCalibrator(folderPath1, folderPath2, squareSize);

disp('Press any key to continue')
pause

hm=msgbox({'\fontsize{14}DuoDIC STEP1 is completed'},'DuoDIC STEP1 is completed',createmodeStruct);

set(0, 'DefaultUIControlFontSize', fs);




