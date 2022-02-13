%% DuoDIC: 2-camera 3D-DIC toolbox

%% STEP 4: 3D Post Processing
% This is a main script to perform 3D reconstruction using the following steps:
% 1) Select 3D reconstruction results file (from STEP3)
% 2) calculate diplacements, deformations, strains, etc.
% 3) Plot animated figures of 3D reconstructed points and faces with various displacement and deformation measures
% 4) Save results as DIC3D_PPresults structure

%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information

%%
clearvars; close all

fs=get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
warning('off','MATLAB:subscripting:noSubscriptsSpecified');

%% CHOOSE PATHS OPTIONS

% select DIC3DpairResults structures
PathInitial=pwd;
[file,path] = uigetfile(PathInitial,'Select a DIC3D_stereo results file');

DIC3D=load([path file]);
DIC3Dname=fieldnames(DIC3D);
DIC3D=DIC3D.(DIC3Dname{1});

% save 3D-DIC post processing results? choose save path and overwrite options
[save3DDIClogic,savePath]=Qsave3DDICPPresults(path);


%% 3D reconstruction using Direct Linear Transformation

nImages= numel(DIC3D.Points3D);

% pre-allocate 3D-DIC result variables
DIC3D.Points3D_ARBM=cell(1,nImages);
DIC3D.RBM.RotMat=cell(1,nImages);
DIC3D.RBM.TransVec=cell(1,nImages);

F=DIC3D.Faces;

hw = waitbar(0,'Calculating displacements and rigid body motion');

for ii=1:nImages % loop over images (time frames)
    waitbar(ii/(nImages));
     
    % Compute rigid body transformation between point clouds
    [RotMat,TransVec,Points3D_ARBM]=rigidTransformation(DIC3D.Points3D{ii},DIC3D.Points3D{1});
    DIC3D.RBM.RotMat{ii}=RotMat;
    DIC3D.RBM.TransVec{ii}=TransVec;
    DIC3D.Points3D_ARBM{ii}=Points3D_ARBM;
    
    % Compute displacements between sets - after RBM
    DispVec=DIC3D.Points3D_ARBM{ii}-DIC3D.Points3D_ARBM{1};
    DIC3D.Disp.DispVec_ARBM{ii}=DispVec;
    DIC3D.Disp.DispMgn_ARBM{ii}=sqrt(DispVec(:,1).^2+DispVec(:,2).^2+DispVec(:,3).^2);
    
    % compute face centroids - after RBM
    for iface=1:size(F,1)
        DIC3D.FaceCentroids_ARBM{ii}(iface,:)=mean(Points3D_ARBM(F(iface,:),:));
    end
    
end
delete(hw);

% compute deformation and strains (per triangular face)
deformationStruct=triSurfaceDeformation(F,DIC3D.Points3D{1},DIC3D.Points3D);
DIC3D.Deform=deformationStruct;

% compute deformation and strains (per triangular face) after RBM
deformationStruct_ARBM=triSurfaceDeformation(F,DIC3D.Points3D_ARBM{1},DIC3D.Points3D_ARBM);
DIC3D.Deform_ARBM=deformationStruct_ARBM;

% compute triangle regularity (isotropy index)
for ii=1:nImages
    [FisoInd]=faceIsotropyIndex(F,DIC3D.Points3D{ii});
    DIC3D.FaceIsoInd{ii}=FisoInd;
end

DIC3DPPresults=DIC3D;

%% save results
if save3DDIClogic
    saveName=fullfile(savePath, 'DIC3DPPresults.mat');
    icount=1;
    while exist(saveName,'file')
        saveName=fullfile(savePath, ['DIC3DPPresults(' num2str(icount) ').mat']);
        icount=icount+1;
    end
    save(saveName,'DIC3DPPresults','-v7.3');
end

%% Plot results
plotButton = questdlg('Plot 3D-DIC post-processing results?', 'Plot?', 'Yes', 'No', 'Yes');
switch plotButton
    case 'Yes'
        plotMoreLogic=true;    
        while plotMoreLogic
            dimButton = questdlg('Plot 3D mesh or project the 3D results on 2D images?', 'Define Plot', 'Plot 3D meshes', 'Plot on 2D images', 'Plot 3D meshes');
                    optStruct=struct;
                    optStruct.zDirection=1;
                    optStruct.FaceAlpha=1;
                    optStruct.Smoothlambda1=[];
                    optStruct.Smoothlambda2=[];
                    optStruct.Smoothn=[];
                    optStruct.SmoothLogic=0;
                    optStruct.CorCoeffCutOff=[];
                    optStruct.CorCoeffLogic=0;
                switch dimButton
                    case 'Plot 3D meshes'
                    % PLOT
                    plot_DuoDIC_PPresults(DIC3DPPresults,optStruct);                   
                case 'Plot on 2D images'
                     % PLOT
                    plot_DuoDIC_PPresults_n_n(DIC3DPPresults,optStruct);
                end 
                plotMoreButton = questdlg('Plot more results?', 'Plot?', 'Yes', 'No', 'Yes');           
               switch plotMoreButton
                  case 'Yes'
                     plotMoreLogic=true;     
                  case 'No'
                     plotMoreLogic=false;
              end                
        end
    case 'No'        
end

%% finish
h=msgbox('STEP4 is completed');
h.CurrentAxes.Children.FontSize=11;

set(0, 'DefaultUIControlFontSize', fs);

