function []=anim8_DIC3DPP_faceMeasure(DIC3DPPresults,faceMeasureString,RBMlogic,varargin)
%% function for plotting 3D-DIC results of face measures in STEP4.
% plotting 3D surfaces from camera pairs, animation changing
% with time, and the faces colored according to faceMeasureString
% this function is called in plotMultiDICPairResults
%
% Options:
% anim8_DIC3DPP_faceMeasure(D(DIC3DPPresults,faceMeasureString,RBMlogic)
% anim8_DIC3DPP_faceMeasure((DIC3DPPresults,faceMeasureString,RBMlogic,optStruct)
%
% Inputs:
% * DIC3DAllPairsResults
% * faceMeasureString: can be any of the following:
%   'J','Emgn','emgn','Epc1','Epc2','epc1','epc2','dispMgn','dispX','dispY','dispZ','FaceColors','FaceIsoInd','pairInd','Lamda1','Lamda2'
% * optStruct: optional structure for plotting options which may include any of the following fields:
%   - smoothLogic: logical variable for smoothing (true)/not smoothing (false) the face measure
%   - FaceAlpha: transparacy of the faces (scalar between 0 and 1, where zero is transparent and 1 is opaque)
%   - colorBarLimits: a 2x1 scalar vector for the colobar limits. if not set, it's automatic
%   - dataLimits: a 2x1 scalar vector for the data limits of the face measure. if a face measure is outside these limits, it is set to NaN. if not set no face is set to NaN
%   - colorMap
%   - zDirection: 1 for z up and -1 for z down
%   - lineColor: line color for the mesh. can be for example 'b','k','none',etc...
%   - supTitleString=faceMeasureString;

%% Assign plot options
Narg=numel(varargin);
switch Narg
    case 2 
        Old_set=varargin{2};
        optStruct=varargin{1};
    case 1
        optStruct=varargin{1};
    case 0
        optStruct=struct;
    otherwise
        ('wrong number of input arguments');
end
optStructOld=optStruct;
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

if ~isfield(optStruct,'maxCorrCoeff')
    optStruct.maxCorrCoeff=[];
end

%%
nFrames=numel(DIC3DPPresults.Points3D);

%% Assign the right face measure into FC
FC=cell(nFrames,1);
Pre=cell(nFrames,1);%Saving FC


switch faceMeasureString
    
    case {'FaceColors'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.(faceMeasureString);
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 255];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='gray';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Color texture from image';
    case 'FacePairInds'
        for it=1:nFrames
            FC{it}=DIC3DPPresults.FacePairInds;
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[1 max(DIC3DPPresults.FacePairInds)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='gjet';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=0.8;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='k';
        end
        faceMeasureTitle='Camera-pair index';
    case {'J'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            Jmax=max(abs(FCmat(:)-1));
            if Jmax>1
                optStruct.colorBarLimits=[0 2];
            else
                optStruct.colorBarLimits=[1-prctile(abs(FCmat(:)-1),100) 1+prctile(abs(FCmat(:)-1),100)];
            end
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Surface Area Change (Dilatation J)';
    case {'Lamda1'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            Lmax=max(abs(FCmat(:)-1));
            if Lmax>1
                optStruct.colorBarLimits=[0 2];
            else
                optStruct.colorBarLimits=[1-prctile(abs(FCmat(:)-1),100) 1+prctile(abs(FCmat(:)-1),100)];
            end
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='1st principal stretch';
    case {'Lamda2'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            Lmax=max(abs(FCmat(:)-1));
            if Lmax>1
                optStruct.colorBarLimits=[0 2];
            else
                optStruct.colorBarLimits=[1-prctile(abs(FCmat(:)-1),100) 1+prctile(abs(FCmat(:)-1),100)];
            end
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='2nd principal stretch';
    case {'Emgn'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Lagrangian strain norm';
    case {'emgn'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%AYS
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Eulerian strain norm';
    case {'Eeq'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Equivalent Lagrangian strain';
    case {'eeq'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Equivalent Eulerian strain';
    case {'EShearMax'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Max Lagrangian shear strain';
    case {'eShearMax'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Max Eulerian shear strain';
    case {'Epc1'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[-prctile(abs(FCmat(:)),100) prctile(abs(FCmat(:)),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='1st principal Lagrangian strain';
    case {'Epc2'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[-prctile(abs(FCmat(:)),100) prctile(abs(FCmat(:)),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='2nd principal Lagrangian strain';
    case {'epc1'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[-prctile(abs(FCmat(:)),100) prctile(abs(FCmat(:)),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='1st principal Eulerian strain';
    case {'epc2'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.Deform.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[-prctile(abs(FCmat(:)),100) prctile(abs(FCmat(:)),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap=0.8*coldwarm;
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='2nd principal Eulerian strain';
    case {'DispMgn'}
        for it=1:nFrames
            Fnow=DIC3DPPresults.Faces;
            if RBMlogic
                dispNow=DIC3DPPresults.Disp.DispMgn_ARBM{it}; % point measure
            else
                dispNow=DIC3DPPresults.Disp.DispMgn{it}; % point measure
            end
            FC{it}=mean(dispNow(Fnow),2); % turn into face measure
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Displacement magnitude';
    case {'DispX'}
        for it=1:nFrames
            Fnow=DIC3DPPresults.Faces;
            if RBMlogic
                dispNow=DIC3DPPresults.Disp.DispVec_ARBM{it}(:,1); % point measure
            else
                dispNow=DIC3DPPresults.Disp.DispVec{it}(:,1); % point measure
            end
            FC{it}=mean(dispNow(Fnow),2); % turn into face measure
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[min(FCmat(:)) max(FCmat(:))];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='X Displacement';
    case {'DispY'}
        for it=1:nFrames
            Fnow=DIC3DPPresults.Faces;
            if RBMlogic
                dispNow=DIC3DPPresults.Disp.DispVec_ARBM{it}(:,2); % point measure
            else
                dispNow=DIC3DPPresults.Disp.DispVec{it}(:,2); % point measure
            end
            FC{it}=mean(dispNow(Fnow),2); % turn into face measure
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[min(FCmat(:)) max(FCmat(:))];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Y Displacement';
    case {'DispZ'}
        for it=1:nFrames
            Fnow=DIC3DPPresults.Faces;
            if RBMlogic
                dispNow=DIC3DPPresults.Disp.DispVec_ARBM{it}(:,3); % point measure
            else
                dispNow=DIC3DPPresults.Disp.DispVec{it}(:,3); % point measure
            end
            FC{it}=mean(dispNow(Fnow),2); % turn into face measure
            Pre{it}=FC{it};
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[min(FCmat(:)) max(FCmat(:))];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Z Displacement';
    case {'FaceIsoInd'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 1];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Triangular face isotropy (regularity) index ';
    case {'FaceCorrComb'}
        for it=1:nFrames
            FC{it}=DIC3DPPresults.(faceMeasureString){it};
            Pre{it}=FC{it};%Save Orignal FC
            if ~isempty(optStruct.maxCorrCoeff)
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            end
        end
        FCmat = cell2mat(FC);
        if ~isfield(optStruct,'colorBarLimits')
            optStruct.colorBarLimits=[0 prctile(FCmat(:),100)];
        end
        colorBarLogic=1;
        if ~isfield(optStruct,'colorMap')
            optStruct.colorMap='parula';
        end
        if ~isfield(optStruct,'FaceAlpha')
            optStruct.FaceAlpha=1;
        end
        if ~isfield(optStruct,'lineColor') % 'none' or 'k'
            optStruct.lineColor='none';
        end
        faceMeasureTitle='Combined correlation coefficient';
        
    otherwise
        error('unexpected face measure string. plots not created');
        
end

%% Plot
[xl,yl,zl]=axesLimits(DIC3DPPresults.Points3D);

animStruct=struct;

hf=cFigure;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';
%% 
axisGeom;
ax=gca;
ax.CameraUpVector=[0 0 optStruct.zDirection];

colormap(optStruct.colorMap);
if colorBarLogic
    if strcmp(faceMeasureString,'FacePairInds')
        icolorbar(optStruct.colorBarLimits);
    else
        colorbar;
        caxis(optStruct.colorBarLimits);
    end
end

suptitle(faceMeasureTitle);
% axis off
% camlight headlight

it=1;
Fnow=DIC3DPPresults.Faces;

if RBMlogic
    Pnow=DIC3DPPresults.Points3D_ARBM{it};
else
    Pnow=DIC3DPPresults.Points3D{it};
end
CFnow=FC{it};

if optStruct.smoothLogic
    smoothPar.lambda=optStruct.smoothlambda;
    smoothPar.n=optStruct.n;
    [CFnow]=patchSmoothFaceMeasure(Fnow,Pnow,CFnow,smoothPar);
end
CFnow(CFnow<optStruct.dataLimits(1))=NaN;
CFnow(CFnow>optStruct.dataLimits(2))=NaN;
hp=gpatch(Fnow,Pnow,CFnow,optStruct.lineColor,optStruct.FaceAlpha); hold on
 

h_ax=gca;
h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;
h_ax.View = [180 255];

animStruct.Time=1:nFrames;
animStruct.Handles=cell(1,nFrames);
animStruct.Props=cell(1,nFrames);
animStruct.Set=cell(1,nFrames);


for it=1:nFrames
    animStruct.Handles{it}=[];
    animStruct.Props{it}=cell(1,2);
    animStruct.Set{it}=cell(1,2);
    
    Fnow=DIC3DPPresults.Faces;
    if RBMlogic
        Pnow=DIC3DPPresults.Points3D_ARBM{it};
    else
        Pnow=DIC3DPPresults.Points3D{it};
    end
    CFnow=FC{it};
    if optStruct.smoothLogic
        [CFnow]= patchSmoothFaceMeasure(Fnow,Pnow,CFnow,smoothPar);
    end
    CFnow(CFnow<optStruct.dataLimits(1))=NaN;
    CFnow(CFnow>optStruct.dataLimits(2))=NaN;
    animStruct.Handles{it}=[animStruct.Handles{it} hp hp]; %Handles of objects to animate
    animStruct.Props{it}{1}='CData';
    animStruct.Props{it}{2}='Vertices'; %Properties of objects to animate
    animStruct.Set{it}{1}=CFnow;
    animStruct.Set{it}{2}=Pnow; %Property values for to set in order to animate
    
    animStruct.Set{it}{3}=getPointValue(Fnow,Pnow,CFnow);%AYS
    
    h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;
    
end
h_o=get(h_ax,'OuterPosition');
h_p=get(h_ax,'Position');
    if colorBarLogic
        ax_Position=get(h_ax,'Position');
        c = colorbar;
        c.Position(1)=ax_Position(1)+ax_Position(3)+0.08;
        c.Position(3)=c.Position(3)-0.005;
        c.Position(2)=c.Position(2)+0.01;
      	set(h_ax,'OuterPosition',h_o);
        set(h_ax,'Position',h_p);
    end

%% Turn  the toolbar on the figure off
ha = findobj(hf,'type','axes');
ha(1).Toolbar.Visible = 'off';
ha(2).Toolbar.Visible = 'off';
%%

hf.UserData.optStruct=optStruct;
%% Fixing the plot look  like the former plot

if Narg==2
    ha = findobj(hf,'type','axes');
    hpatches=findobj(hf,'type','patch');
 % updating the view  to look like the former 
   set(ha(1),'CameraUpVectorMode','manual')  
   set(ha(1),'View',Old_set.view);%Here is the problem!
   set(ha(1),'CameraViewAngle',Old_set.CameraViewAngle);
   set(ha(1),'CameraPosition',Old_set.CameraPosition)
   set(ha(1),'CameraTarget',Old_set.CameraTarget);
   set(ha(1),'CameraUpVector',Old_set.CameraUpVector);    
   drawnow;
 % updating the light to look like the former   
   if~isnan(Old_set.Lightaz)
    for ia = 1:size(ha,1)%light
        axes(ha(ia));
        h(ia) = camlight(Old_set.Lightaz,Old_set.Lightel);
    end 
    numPatches = size(hpatches,1);  
    for ii = 1:numPatches
        hpatches(ii).AmbientStrength=Old_set.AmbientStrength;
        hpatches(ii).DiffuseStrength=Old_set.DiffuseStrength;
        hpatches(ii).SpecularStrength=Old_set.SpecularStrength;
        hpatches(ii).FaceLighting=Old_set.FaceLighting;
    end
   end
    
    hf.UserData.optStruct.Smoothlambda1=Old_set.Smoothlambda1;
    hf.UserData.optStruct.Smoothlambda2=Old_set.Smoothlambda2;
    hf.UserData.optStruct.SmoothLogic=Old_set.SmoothLogic;
    hf.UserData.optStruct.Smoothn=Old_set.Smoothn;    
    hf.UserData.optStruct.CorCoeffCutOff=Old_set.CorCoeffCutOff;
    hf.UserData.optStruct.CorCoeffLogic=Old_set.CorCoeffLogic;
    
    animStruct=animStructUpdate(hf,animStruct,optStruct,DIC3DPPresults,Pre);
end
anim8(hf,animStruct);

%% Buttons
addDataTip(hf,animStruct);
addColorbarLimitsButton(hf);
addColormapButton(hf);
addEdgeColorButton(hf);
addFaceAlphaButton(hf);
addUltraLightButton(hf);
addSmoothCont(hf,animStruct,optStruct,DIC3DPPresults,Pre);
addCorrCoef(hf,animStruct,optStruct,DIC3DPPresults,Pre);
addChangePlotMenu(hf,DIC3DPPresults,optStructOld,RBMlogic);

end

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
