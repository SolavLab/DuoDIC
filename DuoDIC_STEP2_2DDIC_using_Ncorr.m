%% DuoDIC: 2-camera 3D-DIC toolbox

%% STEP 2: 2D-DIC using Ncorr
% This is a main script to perform 2D-DIC using the following steps:
% 1) Select speckle images from camera1 and camera2
% 2) Plot animation figure with all images from the two views
% 3) Select ROI
% 4) Open Ncorr and run 2D-DIC analysis
% 5) Import results to main script and plot  animated figures of correlated points and correlation coefficients 
% 6) Save results as DIC2DpairResults structure

%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information

%%
clearvars; close all; clc;

%%
fs=get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
oldWarningState1 = warning('off','MATLAB:subscripting:noSubscriptsSpecified');
oldWarningState2 = warning('off', 'MATLAB:ui:javacomponent:FunctionToBeRemoved');

%% CHOOSE PATHS OPTIONS
% initial image path
folderPathInitial=pwd;

% select the folder containing the analysis images (if imagePathInitial=[] then the initial path is the current path)
folderPath1=uigetdir(folderPathInitial,'Select the folder containing speckle images from the first camera');
folderPathInitial2 = fileparts(folderPath1);
folderPath2=uigetdir(folderPathInitial2,'Select the folder containing speckle images from the second camera');
folderPaths=cell(1,2);
folderPaths{1}=folderPath1;
folderPaths{2}=folderPath2;

% camera indeces for current analysis  
folderNameCell=strsplit(folderPaths{1},filesep);
folderNameStr=folderNameCell{end};
folderNameStrSplit=strsplit(folderNameStr,'_');
nCam1=str2double(folderNameStrSplit{end});
folderNameCell=strsplit(folderPaths{2},filesep);
folderNameStr=folderNameCell{end};
folderNameStrSplit=strsplit(folderNameStr,'_');
nCam2=str2double(folderNameStrSplit{end});

% save 2D-DIC results? choose save path
[save2DDIClogic,savePath]=Qsave2DDICresults(folderPaths);


%% create structure for saving the 2DDIC results
DIC2DpairResults = struct;

DIC2DpairResults.nCamRef=nCam1;
DIC2DpairResults.nCamDef=nCam2;

%%  load images from the paths, convert to gray , and create IMset cell for Ncorr
createmodeStruct.Interpreter = 'tex';
createmodeStruct.WindowStyle = 'non-modal';
h=msgbox('\fontsize{16}Please wait while loading images','Wait',createmodeStruct);
[ImPaths,ImSet]=createDICimageSet(folderPaths,[]);
DIC2DpairResults.nImages=numel(ImPaths)/2;
DIC2DpairResults.ImPaths=ImPaths;
if isvalid(h)
    close(h);
end
%% animate the 2 sets of images to be correlated with Ncorr
hf1=anim8_DIC_images(ImPaths,ImSet);
pause

%% choose ROI
% This is a GUI for choosing the ROI instead of choosing the ROI in the
% NCorr softwhere (too small). It also allows the assistance of SIFT
% matches (it helps locating the overlapping region, but is time costly)

chooseMaskButton = questdlg('Create new mask for correlation, use saved mask, or use Ncorr to draw mask?', 'mask options?', 'New', 'Saved','Ncorr', 'New'); % existing mask should be in savePath
switch chooseMaskButton
    case 'New'
        nROI=1;
        % input box to select number of ROIs (comment out the next two
        % lines to use the above default without having to click the box
        answer=inputdlg('Enter the number of ROIs','Enter the number of ROIs',1,{'1'});
        nROI=str2double(answer{1});        

        ROImask = selectROI(ImSet{1},nROI);
        
        if save2DDIClogic
            % save image mask
            % The format is ROIMask_C01_C02, where 01 is the reference camera of the pair, and 02 is the "deformed" camera of the pair.
            save(fullfile(savePath, 'ROIMask'),'ROImask');
        end
        DIC2DpairResults.ROImask=ROImask;
    case 'Saved'
        if save2DDIClogic
            PathInitial=fullfile(savePath, 'ROIMask');
        else
            PathInitial=folderPathInitial;
        end
        [FileName,PathName,~] = uigetfile('','Select ROI file',PathInitial);
        load([PathName FileName]);
        DIC2DpairResults.ROImask=ROImask;
    case 'Ncorr'
end

%% Start Ncorr 2D analysis

% Set analysis in Ncorr and wait
createmodeStruct.Interpreter = 'tex';
createmodeStruct.WindowStyle = 'non-modal';
h = msgbox({'\fontsize{16}Please wait while initializing Ncorr GUI.'; 'Continue the analysis in Ncorr GUI using the DuoDIC instruction manual.';'';...
    'When you finish, return to MATLAB and press any key to continue \bf{WITHOUT} closing the Ncorr window';'';},'Ncorr GUI Instructions',createmodeStruct);

% open Ncorr
handles_ncorr = ncorr;
% set reference image
handles_ncorr.set_ref(ImSet{1});
% set current image
handles_ncorr.set_cur(ImSet);
% set ROI (skip this step if you want to select the ROI in Ncorr)
if ~strcmp(chooseMaskButton,'Ncorr')
    handles_ncorr.set_roi_ref(ROImask);
end


disp('When Ncorr analysis is finished, press any key to continue (without closing Ncorr window) ');
pause

%% Extract results from Ncorr and calculate correlated image points, correlation coefficients, faces and face colors
[Points,CorCoeffVec,F,CF] = extractNcorrResults(handles_ncorr,ImSet{1});
DIC2DpairResults.ncorrInfo=handles_ncorr.data_dic.dispinfo;
DIC2DpairResults.Points=Points;
DIC2DpairResults.CorCoeffVec=CorCoeffVec;
DIC2DpairResults.Faces=F;
DIC2DpairResults.FaceColors=CF;
if ~strcmp(chooseMaskButton,'Ncorr')
    DIC2DpairResults.ROImask=handles_ncorr.reference.roi.mask;
end

%% plot?
set(0, 'DefaultUIControlFontSize', 14);

plotButton = questdlg('Plot correlated points on images?', 'Plot?', 'Yes', 'No', 'Yes');
switch plotButton
    case 'Yes'
        plotNcorrPairResults(DIC2DpairResults);       
    case 'No'
end

%% save important variables for further analysis (write text files of correlated 2D points, their cirrelation coefficients, triangular faces, and face colors
if save2DDIClogic
    saveName=fullfile(savePath, 'DIC2DpairResults.mat');
    
    % rename if exists
    icount=1;
    while exist(saveName,'file')     
        saveName=fullfile(savePath, ['DIC2DpairResults ' '(' num2str(icount) ').mat']);
        icount=icount+1;      
    end  
    save(saveName,'DIC2DpairResults','-v7.3');
end

%% close Ncorr GUI
close(handles_ncorr.handles_gui.figure);

if isvalid(h)
    close(h);
end
% close first animation figure
if isvalid(hf1)
    close(hf1);
end

%% finish
createmodeStruct.Interpreter = 'tex';
createmodeStruct.WindowStyle = 'non-modal';
hm=msgbox('\fontsize{16}DuoDIC STEP2 is completed','Step2 completed',createmodeStruct);

set(0, 'DefaultUIControlFontSize', fs);
warning(oldWarningState1);  % revert to displaying the warning
warning(oldWarningState2);  % revert to displaying the warning
