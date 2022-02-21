%% DuoDIC: 2-camera 3D-DIC toolbox

%% STEP 3: 3D reconstruction
% This is a main script to perform 3D reconstruction using the following steps:
% 1) Select 2D-DIC results file (from STEP2)
% 2) Select Stereo calibration results file (from STEP1)
% 3) Perform 3D rectonstruction
% 4) Plot animated figures of 3D reconstructed points and faces with correlation coefficients 
% 5) Save results as DIC3D_stereo structure

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
set(0, 'DefaultUIControlFontSize', 16);
oldWarningState1 = warning('off','MATLAB:subscripting:noSubscriptsSpecified');
oldWarningState2 = warning('off', 'MATLAB:ui:javacomponent:FunctionToBeRemoved');

%% select 2D-DIC file and calibration file
% select DIC2DpairResults structure
PathInitial=pwd;
[speckleFile,speckleFilePath]=uigetfile(PathInitial,'Select a 2D-DIC results file (from STEP2)');
[calibrationFile,calibrationFilePath]=uigetfile(fileparts(speckleFilePath),'Select calibration session results file (from STEP1)');

%% save 3D-DIC results? choose save path and overwrite options


createmodeStruct.Interpreter = 'tex';
createmodeStruct.Default = 'Yes';
saveButton = questdlg('Save 3D-DIC results?', 'Save?', 'Yes', 'No',createmodeStruct);
switch saveButton
    case 'Yes'
        saveLogic=true(1);
        % Path where to save the camera parameters
        savePath = uigetdir(fileparts(speckleFilePath),'Select a folder for saving the results');
    case 'No'
        saveLogic=false(1);
        savePath=[];
end

% if savePath~=0

%% 3D reconstruction
DIC2D=load(fullfile(speckleFilePath,speckleFile));
load(fullfile(calibrationFilePath,calibrationFile));

DIC2D=DIC2D.DIC2DpairResults;
DIC2DPoints=DIC2D.Points;
nImages=DIC2D.nImages;
DIC2DPointsL=DIC2DPoints(1:nImages);
DIC2DPointsR=DIC2DPoints(nImages+1:2*nImages);
CorCoeff=DIC2D.CorCoeffVec;
F=DIC2D.Faces;
stereoParams=calibrationSession.CameraParameters;

DIC3D=struct;
DIC3D.stereoParams=stereoParams;
DIC3D.Faces=F;
DIC3D.FaceColors=DIC2D.FaceColors;

hw = waitbar(0,'3D reconstructing points...');
for ii=1:nImages
    waitbar(ii/(nImages));
    
    P3D=NaN(size(DIC2DPoints{1},1),3);
    DIC3D.reprojectionErrors{1,ii}=NaN(size(DIC2DPoints{1},1),1);
    
    logicNoNan=~(any(isnan(DIC2DPointsL{ii}),2) | any(isnan(DIC2DPointsR{ii}),2));
    PointNoNanL=DIC2DPointsL{ii}(logicNoNan,:);
    PointNoNanR=DIC2DPointsR{ii}(logicNoNan,:);
    
    % remove distortion from points
    % remove nan points
    DIC2DPointsL_ud=zeros(sum(logicNoNan),2);
    DIC2DPointsR_ud=zeros(sum(logicNoNan),2);
    step=min([40,size(PointNoNanL,1)]);
    times=1:step:size(PointNoNanL,1);
    % correct points in small sets because large sets are slow
    for jj=times(1:end-1)
        DIC2DPointsL_ud(jj:jj+step,:) = undistortPoints(PointNoNanL(jj:jj+step,:),stereoParams.CameraParameters1);
        DIC2DPointsR_ud(jj:jj+step,:) = undistortPoints(PointNoNanR(jj:jj+step,:),stereoParams.CameraParameters2);
    end
    DIC2DPointsL_ud(times(end):end,:) = undistortPoints(PointNoNanL(times(end):end,:),stereoParams.CameraParameters1);
    DIC2DPointsR_ud(times(end):end,:) = undistortPoints(PointNoNanR(times(end):end,:),stereoParams.CameraParameters2);
    
    % triangulate
    [P3D(logicNoNan,:),DIC3D.reprojectionErrors{1,ii}(logicNoNan,:)] = triangulate(DIC2DPointsL_ud,DIC2DPointsR_ud,stereoParams);
    DIC3D.Points3D{1,ii}=P3D;
    
    % Combined (worst) correlation coefficients
    DIC3D.corrComb{1,ii}=max([CorCoeff{ii} CorCoeff{ii+nImages}],[],2);
    % Face correlation coefficient (worst)
    DIC3D.FaceCorrComb{1,ii}=max(DIC3D.corrComb{1,ii}(F),[],2);

    %%
    DIC3D.FacereprojectionErrors{1,ii}=max(DIC3D.reprojectionErrors{1,ii}(F),[],2);

    %%
    % compute face centroids
    for iface=1:size(F,1)
        DIC3D.FaceCentroids{1,ii}(iface,:)=mean(P3D(F(iface,:),:));
    end
    
    % Compute displacements between frames (per point)
        DispVec=DIC3D.Points3D{1,ii}-DIC3D.Points3D{1,1};
        DIC3D.Disp.DispVec{1,ii}=DispVec;
        DIC3D.Disp.DispMgn{1,ii}=sqrt(DispVec(:,1).^2+DispVec(:,2).^2+DispVec(:,3).^2);
end
delete(hw);


DIC3D.DIC2Dinfo=DIC2D;

%% save 

if saveLogic
    saveName=fullfile(savePath,'DIC3Dstereo.mat');
    icount=1;
    while exist(saveName,'file')
        saveName=fullfile(savePath, ['DIC3Dstereo (' num2str(icount) ').mat']);
        icount=icount+1;
    end
    save(saveName,'DIC3D','-v7.3');
end

 %% PLOT
anim8_DIC3D_reprojectionErrors_faces(DIC3D);
anim8_DIC3D_reconstructedPairs_faces(DIC3D);

%% finish
hm=msgbox('STEP3 is completed');

set(0, 'DefaultUIControlFontSize', fs);
warning(oldWarningState1);  % revert to displaying the warning
warning(oldWarningState2);  % revert to displaying the warning

