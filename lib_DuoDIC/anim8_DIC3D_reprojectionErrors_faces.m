function []=anim8_DIC3D_reprojectionErrors_faces(DIC3D,varargin)
%% function for plotting 3D-DIC 3D reconstruction results of reprojection errors in STEP3.
% plotting 3D points and meshes, animation changing with time, and the faces colored according to the reprojection errors. 
% this function is called in the end of Step3.
%
% Options:
% anim8_DIC3D_reprojectionErrors_faces(DIC3D)
% anim8_DIC3D_reprojectionErrors_faces(DIC3D,optStruct)
%

%% Assign plot options
Narg=numel(varargin);
switch Narg
    case 1
        optStruct=varargin{1};
    case 0
        optStruct=struct;
    otherwise
        ('wrong number of input arguments');
end

% complete the struct fields
if ~isfield(optStruct,'smoothLogic')
    optStruct.smoothLogic=0;
end
if ~isfield(optStruct,'dataLimits')
    optStruct.dataLimits=[-inf inf];
end
if ~isfield(optStruct,'zDirection') % 1 or -1
    optStruct.zDirection=1;
end
if ~isfield(optStruct,'lineColor') % 'none' or 'k'
    optStruct.lineColor='none';
end
if ~isfield(optStruct,'maxCorrCoeff')
    optStruct.maxCorrCoeff=[];
end

%%
nFrames=numel(DIC3D.Points3D);

%% Assign the right face measure into FC
FC=cell(nFrames,1);
for it=1:nFrames
    FC{it}=DIC3D.FacereprojectionErrors{it};
    if ~isempty(optStruct.maxCorrCoeff)
        corrNow=DIC3D.FacereprojectionErrors{it};
        FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
    end
end
colorBarLogic=1;
if ~isfield(optStruct,'colorMap')
    optStruct.colorMap='parula';
end
if ~isfield(optStruct,'FaceAlpha')
    optStruct.FaceAlpha=0.8;
end

%% Assign the right point measure into VC
VC=cell(nFrames,1);
for it=1:nFrames
    VC{it}=DIC3D.reprojectionErrors{it};
    if ~isempty(optStruct.maxCorrCoeff)
        corrNow=DIC3D.reprojectionErrors{it};
        VC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
    end
end
VCmat = cell2mat(VC);
if ~isfield(optStruct,'colorBarLimits')
    optStruct.colorBarLimits=[prctile(VCmat(:),0) prctile(VCmat(:),100)];
end

%% Plot
[xl,yl,zl]=axesLimits(DIC3D.Points3D);

animStruct=struct;

hf=cFigure; hold on;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';

axisGeom;
ax=gca;
ax.CameraUpVector=[0 0 optStruct.zDirection];
view(180, 255);
colormap(optStruct.colorMap);
if colorBarLogic
    cbh=colorbar;
    cbh.FontSize=16;
    caxis(optStruct.colorBarLimits);
    title(cbh,{'Reprojection';'Error [pix]'},'FontSize',16);
end

gtitle('3D reconstruction results. Press Play to start animation',20);
% axis off
% camlight headlight

it=1;
Fnow=DIC3D.Faces;
Pnow=DIC3D.Points3D{it};
CFnow=FC{it};
CVnow=VC{it};
if optStruct.smoothLogic
    [CFnow]=triSmoothFaceMeasure(CFnow,Fnow,Pnow,[],[]);
end
CFnow(CFnow<optStruct.dataLimits(1))=NaN;
CFnow(CFnow>optStruct.dataLimits(2))=NaN;
CVnow(CVnow<optStruct.dataLimits(1))=NaN;
CVnow(CVnow>optStruct.dataLimits(2))=NaN;

hp1=scatterV(Pnow,10,CVnow,'Filled');
hp2=gpatch(Fnow,Pnow,CFnow,optStruct.lineColor,optStruct.FaceAlpha); hold on

h_ax=gca;
h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;

animStruct.Time=1:nFrames;
animStruct.Handles=cell(1,nFrames);
animStruct.Props=cell(1,nFrames);
animStruct.Set=cell(1,nFrames);

ic=1;
for it=1:nFrames
    animStruct.Handles{ic}=[];
    animStruct.Props{ic}=cell(1,2);
    animStruct.Set{ic}=cell(1,2);
    
        Fnow=DIC3D.Faces;
        Pnow=DIC3D.Points3D{it};
        CFnow=FC{it};
        if optStruct.smoothLogic
            [CFnow]=triSmoothFaceMeasure(CFnow,Fnow,Pnow,[],[]);
        end
        CFnow(CFnow<optStruct.dataLimits(1))=NaN;
        CFnow(CFnow>optStruct.dataLimits(2))=NaN;
        animStruct.Handles{ic}=[animStruct.Handles{ic} hp1 hp1 hp1 hp1 hp2 hp2]; %Handles of objects to animate
        animStruct.Props{ic}{1}='XData';
        animStruct.Props{ic}{2}='YData';
        animStruct.Props{ic}{3}='ZData';
        animStruct.Props{ic}{4}='CData';
        animStruct.Props{ic}{5}='CData';
        animStruct.Props{ic}{6}='Vertices'; %Properties of objects to animate
        animStruct.Set{ic}{1}=Pnow(:,1);
        animStruct.Set{ic}{2}=Pnow(:,2);
        animStruct.Set{ic}{3}=Pnow(:,3);
        animStruct.Set{ic}{4}=CVnow;
        animStruct.Set{ic}{5}=CFnow;
        animStruct.Set{ic}{6}=Pnow; %Property values for to set in order to animate
    
    h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;
    
    ic=ic+1;
end

anim8(hf,animStruct);
addFigureButtons;
addMarkerSize(hf);
end

%% 
% MultiDIC: a MATLAB Toolbox for Multi-View 3D Digital Image Correlation
% 
% License: <https://github.com/MultiDIC/MultiDIC/blob/master/LICENSE.txt>
% 
% Copyright (C) 2018  Dana Solav
% 
% If you use the toolbox/function for your research, please cite our paper:
% <https://engrxiv.org/fv47e>