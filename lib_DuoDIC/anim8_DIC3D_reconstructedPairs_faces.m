function []=anim8_DIC3D_reconstructedPairs_faces(DIC3D,varargin)
%% function for plotting 3D-DIC results of face measures in STEP3.
% plotting 3D surfaces from camera pairs, animation changing
% with time, and the faces colored according to faceMeasureString 
% this function is called in plotMultiDICPairResults
%
% Options:
% anim8_DIC_3D_pairs_faceMeasure(DIC3DAllPairsResults,faceMeasureString)
% anim8_DIC_3D_pairs_faceMeasure(DIC3DAllPairsResults,faceMeasureString,optStruct)
% 
% Inputs:
% * DIC3DAllPairsResults
% * faceMeasureString: can be any of the following:
%   'dispMgn','dispX','dispY','dispZ','FaceColors','FaceIsoInd','pairInd'
% * optStruct: optional structure for plotting options which may include any of the following fields:
%   - smoothLogic: logical variable for smoothing (true)/not smoothing (false) the face measure 
%   - FaceAlpha: transparacy of the faces (scalar between 0 and 1, where zero is transparent and 1 is opaque) 
%   - colorBarLimits: a 2x1 scalar vector for the colobar limits. if not set, it's automatic
%   - dataLimits: a 2x1 scalar vector for the data limits of the face measure. if a face measure is outside these limits, it is set to NaN. if not set no face is set to NaN
%   - colorMap
%   - zDirection: 1 for z up and -1 for z down
%   - lineColor: line color for the mesh. can be for example 'b','k','none',etc...
%   - TitleString=faceMeasureString;

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
nPairs=1;

%% Assign the right face measure into FC
FC=cell(nFrames,1);
for it=1:nFrames
    FC{it}=DIC3D.FaceCorrComb{it};
    if ~isempty(optStruct.maxCorrCoeff)
        corrNow=DIC3D.FaceCorrComb{it};
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
    VC{it}=DIC3D.corrComb{it};
    if ~isempty(optStruct.maxCorrCoeff)
        corrNow=DIC3D.corrComb{it};
        VC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
    end
end
VCmat = cell2mat(VC);
if ~isfield(optStruct,'colorBarLimits')
    optStruct.colorBarLimits=[0 prctile(VCmat(:),100)];
end

%% Plot
[xl,yl,zl]=axesLimits(DIC3D.Points3D);

animStruct=struct;

hf=cFigure; hold on;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';

axisGeom;
ax=gca;
ax.CameraUpVector=[0 0 optStruct.zDirection];

colormap(optStruct.colorMap);
if colorBarLogic
    cbh=colorbar;
    cbh.FontSize=16;
    caxis(optStruct.colorBarLimits);
    title(cbh,{'Correlation';'Coefficient'},'FontSize',16);
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
    animStruct.Props{ic}=cell(1,2*nPairs);
    animStruct.Set{ic}=cell(1,2*nPairs);
    
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
addEdgeColorButton(hf);
addFaceAlphaButton(hf);
addUltraLightButton(hf);

end

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
