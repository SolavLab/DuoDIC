function [] = anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,pairIndex,faceMeasureString,varargin)
%% function for plotting 3D-DIC post-processing results from step 4 projected on the 2D images
% plotting the images with the 3D face measure results plotted on top
% on the left side the images from the reference camera (reference image and current images), and on the right side the
% images from the deformed camera
%
% calling options:
% [] = anim8_DIC3D_faceMeasures_onImages_n_n(DIC3DPPresults,pairIndex,faceMeasureString);
% [] = anim8_DIC3D_faceMeasures_onImages_n_n(DIC3DPPresults,pairIndex,faceMeasureString,optStruct); 

%%
Points=DIC3DPPresults.DIC2Dinfo{pairIndex}.Points;
nCamRef=DIC3DPPresults.DIC2Dinfo{pairIndex}.nCamRef;
nCamDef=DIC3DPPresults.DIC2Dinfo{pairIndex}.nCamDef;
nImages=DIC3DPPresults.DIC2Dinfo{pairIndex}.nImages;
currentFacesLogic=DIC3DPPresults.FacePairInds==pairIndex;
currentPointIndex=find(DIC3DPPresults.PointPairInds==pairIndex);
firstCurrentPointIndex=currentPointIndex(1);
F=DIC3DPPresults.Faces(currentFacesLogic,:);
F=F-firstCurrentPointIndex+1;
FaceCorr=cell(nImages,1);
for ii=1:nImages
    FaceCorr{ii}=DIC3DPPresults.FaceCorrComb{ii}(currentFacesLogic,:);
end
ImSet=cell(2*nImages,1);
ImPaths=DIC3DPPresults.DIC2Dinfo{pairIndex}.ImPaths;

% if ImPaths are not valid (for example if using on another computer, ask
% user to provide a new folder where all the images are located.
try
    ImSet{1}=imread(ImPaths{1});
catch
    newPath=uigetdir([],'Path to images is invalid. Please provide the correct path to the images (the folder containing all camera folders with the processed gray images)');
    for ii=1:length(ImPaths)
        [a,b,c]=fileparts(ImPaths{ii});
        as = strsplit(a,{'\','/'});
        ImPaths{ii}=[newPath '\' as{end} '\' b c];
    end
end

for ii=1:2*nImages
    ImSet{ii}=imread(ImPaths{ii});
    if size(ImSet{ii},3)==3
        ImSet{ii}=rgb2gray(ImSet{ii});
    end
end

switch nargin
    case 3 %No results were entered
        optStruct=struct;
    case 4
        optStruct=varargin{1};
    otherwise
        error('wrong number of input arguments');
end

%%
FC=cell(nImages,1);
optStruct.type=faceMeasureString;
switch faceMeasureString
    case {'J','Lamda1','Lamda2'}
        for ii=1:nImages
            FC{ii}=DIC3DPPresults.Deform.(faceMeasureString){ii}(currentFacesLogic,:);
        end
        if isfield(optStruct,'cMap')
            cMap=optStruct.cMap;
        else
            cMap=coldwarm;
        end
        if ~isfield(optStruct,'FClimits')
            FCmax=0;
            for ii=1:nImages
                FCmax=max([max(abs(FC{ii}(~isnan(FaceCorr{ii}))-1)) FCmax]);
            end
            FClimits=[1-FCmax 1+FCmax];
        else
            FClimits=optStruct.FClimits;
        end
    case {'Emgn','emgn','Eeq','eeq','EShearMax','eShearMax'}
        for ii=1:nImages
            FC{ii}=DIC3DPPresults.Deform.(faceMeasureString){ii}(currentFacesLogic,:);
        end
        if isfield(optStruct,'cMap')
            cMap=optStruct.cMap;
        else
            cMap='parula';
        end
        if ~isfield(optStruct,'FClimits')
            FCmax=0;
            for ii=1:nImages
                FCmax=max([max(FC{ii}(~isnan(FaceCorr{ii}))) FCmax]);
            end
            FClimits=[0 FCmax];
        else
            FClimits=optStruct.FClimits;
        end
        
    case {'Epc1','Epc2','epc1','epc2'}
        for ii=1:nImages
            FC{ii}=DIC3DPPresults.Deform.(faceMeasureString){ii}(currentFacesLogic,:);
        end
        if isfield(optStruct,'cMap')
            cMap=optStruct.cMap;
        else
            cMap=coldwarm;
        end
        if ~isfield(optStruct,'FClimits')
            FCmax=0;
            for ii=1:nImages
                FCmax=max([max(abs(FC{ii}(~isnan(FaceCorr{ii})))) FCmax]);
            end
            FClimits=[-FCmax FCmax];
        else
            FClimits=optStruct.FClimits;
        end
    otherwise
        error('unexpected face measure string. plots not created');
end

for ii=1:nImages
    FC{ii}(isnan(FaceCorr{ii}))=NaN;
end


Pre.FC=FC;%Saving orginal settings 
Pre.Points=Points;
%% cut out point with extreme face color values
if ~isfield(optStruct,'dataLimits')
    dataLimits=[min(min(cell2mat(FC))) max(max(cell2mat(FC)))];
    optStruct.dataLimits=dataLimits;
else
    dataLimits=optStruct.dataLimits;
end

for ii=1:nImages
    FC{ii}(FC{ii}<dataLimits(1) | FC{ii}>dataLimits(2))=NaN;
end



%% plot
hf=cFigure;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';

% Ref
ii=1;
subplot(1,2,1)
hp1=imagesc(repmat(ImSet{ii},1,1,3)); hold on;
hp2=gpatch(F,Points{ii},FC{ii},'none',0.5);
pbaspect([size(ImSet{ii},2) size(ImSet{ii},1) 1])
hs1=title(['Cam ' num2str(nCamRef) ' frame ' num2str(1)]);
colormap(cMap);
hc1=colorbar;
caxis(FClimits)
title(hc1, faceMeasureString);
hc1.FontSize=16;
axis off

% Cur
ii=nImages+1;
subplot(1,2,2)
hp3=imagesc(repmat(ImSet{ii},1,1,3)); hold on
hp4=gpatch(F,Points{ii},FC{1},'none',0.5);
pbaspect([size(ImSet{ii},2) size(ImSet{ii},1) 1])
hs2=title(['Cam ' num2str(nCamDef) ' frame ' num2str(1)]);
colormap(cMap);
hc2=colorbar;
caxis(FClimits);
title(hc2, faceMeasureString);
hc2.FontSize=16;
axis off

drawnow

%Create the time vector
animStruct.Time=linspace(0,1,nImages);

for ii=1:nImages
    Pnow1=Points{ii};
    Pnow2=Points{ii+nImages};
    
    cNow1=FC{ii};
    cNow2=FC{ii};
    
    TitleNow1=['Cam ' num2str(nCamRef) ' frame ' num2str(ii)];
    TitleNow2=['Cam ' num2str(nCamDef) ' frame ' num2str(ii)];
    
    %Set entries in animation structure
    animStruct.Handles{ii}=[hp1,hp3,hp2,hp2,hp4,hp4,hs1,hs2]; %Handles of objects to animate
    animStruct.Props{ii}={'CData','CData','Vertices','CData','Vertices','CData','String','String'}; %Properties of objects to animate
    animStruct.Set{ii}={repmat(ImSet{ii},1,1,3),repmat(ImSet{ii+nImages},1,1,3),Pnow1,cNow1,Pnow2,cNow2,TitleNow1,TitleNow2}; %Property values for to set in order to animate                
                           
end

%% Turn  the toolbar on the figure off
ha = findobj(hf,'type','axes');
ha(1).Toolbar.Visible = 'off';
ha(2).Toolbar.Visible = 'off';
%%
if ~isfield(hf.UserData,'optStruct')
    hf.UserData.optStruct=optStruct;
end
animStruct=animStructUpdate_n_n(hf,animStruct,DIC3DPPresults,Pre);
anim8(hf,animStruct);
%% Extra Apps
addFigureButtons;
addSmoothCont_n_n(hf,animStruct,optStruct,DIC3DPPresults,Pre);%AYS 12/7
addCorrCoef_n_n(hf,animStruct,optStruct,DIC3DPPresults,Pre);%AYS 12/7
optStructOld=optStruct; addChangePlotMenu_n_n(hf,DIC3DPPresults,optStructOld);%AYS 12/9
end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
