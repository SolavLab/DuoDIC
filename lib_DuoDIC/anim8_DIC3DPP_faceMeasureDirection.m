function []=anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,faceMeasureString,RBMlogic,varargin)
%% function for plotting 3D-DIC results of face measures as color + direction as arrows in STEP4.
% plotting 3D surfaces from camera pairs, animation changing
% with time, and the faces colored according to faceMeasureString 
% this function is called in plotMultiDICPairResults
%
% Options:
% anim8_DIC3DPP_faceMeasureDirection(DIC_3Dallpairs_results,faceMeasureString)
% anim8_DIC3DPP_faceMeasureDirection(DIC_3Dallpairs_results,faceMeasureString,optStruct)
% 
% Inputs:
% * DIC3DAllPairsResults
% * faceMeasureString: can be any of the following:
%   'Epc1','Epc2','epc1','epc2','Lamda1','Lamda2', or a combination of two  in a cell array to plot side by side
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
    optStruct.Logic=0;
end
if ~isfield(optStruct,'FaceAlpha')
    optStruct.FaceAlpha=1;
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
if ~isfield(optStruct,'quiverScaleFactor')
    optStruct.quiverScaleFactor=20;
end
%%
nFrames=numel(DIC3DPPresults.Points3D);

[xl,yl,zl]=axesLimits(DIC3DPPresults.Points3D);
meanEdgeLength=nanmean(patchEdgeLengths(DIC3DPPresults.Faces,DIC3DPPresults.Points3D{1}));

%% Assign the right face measure into FC
Pre=struct;
if iscell(faceMeasureString)
    faceMeasureCell=faceMeasureString;
    nStrains=numel(faceMeasureString);
    switch nStrains
        case 1
            FC=cell(nFrames,nStrains);
            D=cell(nFrames,nStrains);
            Ds=cell(nFrames,nStrains);
            Vc=cell(nFrames,nStrains);
            
            Pre.FC=cell(nFrames,nStrains);
            Pre.D=cell(nFrames,nStrains);
            Pre.Vc=cell(nFrames,nStrains);
        case 2
            FC=cell(nFrames,nStrains);
            D=cell(nFrames,nStrains);
            Ds=cell(nFrames,nStrains);
            Vc=cell(nFrames,nStrains);
            
            Pre.FC=cell(nFrames,nStrains);
            Pre.D=cell(nFrames,nStrains);
            Pre.Vc=cell(nFrames,nStrains);
        
        otherwise
            error('wrong number of cells in faceMeasureString cell array (must be 1 or 2)');
    end
elseif ischar(faceMeasureString)
    nStrains=1;
    faceMeasureCell=cell(1);
    faceMeasureCell{1}=faceMeasureString;
    FC=cell(nFrames,1);
    D=cell(nFrames,1);
    Ds=cell(nFrames,1);
    Vc=cell(nFrames,1);
    
    Pre.FC=cell(nFrames,1);
	Pre.D=cell(nFrames,1);
	Pre.Vc=cell(nFrames,1);
else
    error('wrong face measure (second input variable)');
end

directionStringCell=cell(nStrains,1);
for is=1:nStrains
    switch faceMeasureCell{is}
        case 'Epc1'
            directionStringCell{is}='Epc1vecCur';
            optStruct.supTitleString{is}='1st principal Lagrangian strain';
        case 'Epc2'
            directionStringCell{is}='Epc2vecCur';
            optStruct.supTitleString{is}='2nd principal Lagrangian strain';
        case 'epc1'
            directionStringCell{is}='epc1vec';
            optStruct.supTitleString{is}='1st principal Eulerian strain';
        case 'epc2'
            directionStringCell{is}='epc2vec';
            optStruct.supTitleString{is}='2nd principal Eulerian strain';
        case 'Lamda1'
            directionStringCell{is}='Epc1vecCur';
            optStruct.supTitleString{is}='1st principal stretch';
        case 'Lamda2'
            directionStringCell{is}='Epc2vecCur';
            optStruct.supTitleString{is}='2nd principal stretch';
        case 'EShearMax1'
            faceMeasureCell{is}='EShearMax';
            directionStringCell{is}='EShearMaxVec1';
            optStruct.supTitleString{is}='1st Lagrangian Max shear strain (Lagrangian)';
        case 'EShearMax2'
            faceMeasureCell{is}='EShearMax';
            directionStringCell{is}='EShearMaxVec2';
            optStruct.supTitleString{is}='2nd Lagrangian Max shear strain (Lagrangian)'; 
        case 'eShearMax1'
            faceMeasureCell{is}='eShearMax';
            directionStringCell{is}='eShearMaxVec1';
            optStruct.supTitleString{is}='1st Eulerian Max shear strain (Eulerian)';
         case 'eShearMax2'
            faceMeasureCell{is}='eShearMax';
            directionStringCell{is}='eShearMaxVec2';
            optStruct.supTitleString{is}='2nd Eulerian Max shear strain (Eulerian)';   
            
        otherwise
            error('unexpected face measure string. plots not created');
    end
    for it=1:nFrames
        if RBMlogic
            FC{it,is}=DIC3DPPresults.Deform_ARBM.(faceMeasureCell{is}){it}; % face color (strain)
            D{it,is}=DIC3DPPresults.Deform_ARBM.(directionStringCell{is}){it}; % direction (unit vector)
            
            Pre.FC{it,is}=DIC3DPPresults.Deform_ARBM.(faceMeasureCell{is}){it};
            Pre.D{it,is}=DIC3DPPresults.Deform_ARBM.(directionStringCell{is}){it};
            switch faceMeasureCell{is}
                case {'Epc1','Epc2','epc1','epc2','EShearMax','eShearMax'}
                    Ds{it,is}=optStruct.quiverScaleFactor*FC{it,is}.*D{it,is}; % direction with magnitude (scaled vector)
                    DsLengths=sqrt((sum(Ds{it,is}.^2,2)));
                    LogicTooLong=DsLengths>meanEdgeLength;
                    Ds{it,is}(LogicTooLong,:)=meanEdgeLength*Ds{it,is}(LogicTooLong,:)./DsLengths(LogicTooLong);        
                case {'Lamda1','Lamda2'}
                    Ds{it,is}=optStruct.quiverScaleFactor*(FC{it,is}-1).*D{it,is}; % direction with magnitude (scaled vector)
                    DsLengths=sqrt((sum(Ds{it,is}.^2,2)));
                    LogicTooLong=DsLengths>meanEdgeLength;
                    Ds{it,is}(LogicTooLong,:)=meanEdgeLength*Ds{it,is}(LogicTooLong,:)./DsLengths(LogicTooLong);
            end
            Vc{it,is}=DIC3DPPresults.FaceCentroids_ARBM{it}-.5*Ds{it,is};
            Pre.Vc{it,is}=DIC3DPPresults.FaceCentroids_ARBM{it}-.5*Ds{it,is};
        else
            FC{it,is}=DIC3DPPresults.Deform.(faceMeasureCell{is}){it}; % face color (strain)
            D{it,is}=DIC3DPPresults.Deform.(directionStringCell{is}){it}; % direction (unit vector)
            Pre.FC{it,is}=DIC3DPPresults.Deform.(faceMeasureCell{is}){it};
            Pre.D{it,is}=DIC3DPPresults.Deform.(directionStringCell{is}){it};
            switch faceMeasureCell{is}
                case {'Epc1','Epc2','epc1','epc2','EShearMax','eShearMax'}
                    Ds{it,is}=optStruct.quiverScaleFactor*FC{it,is}.*D{it,is}; % direction with magnitude (scaled vector)
                    DsLengths=sqrt((sum(Ds{it,is}.^2,2)));
                    LogicTooLong=DsLengths>meanEdgeLength;
                    Ds{it,is}(LogicTooLong,:)=meanEdgeLength*Ds{it,is}(LogicTooLong,:)./DsLengths(LogicTooLong);                    
                case {'Lamda1','Lamda2'}
                    Ds{it,is}=optStruct.quiverScaleFactor*(FC{it,is}-1).*D{it,is}; % direction with magnitude (scaled vector)
                    DsLengths=sqrt((sum(Ds{it,is}.^2,2)));
                    LogicTooLong=DsLengths>meanEdgeLength;
                    Ds{it,is}(LogicTooLong,:)=meanEdgeLength*Ds{it,is}(LogicTooLong,:)./DsLengths(LogicTooLong);                    
            end
            Vc{it,is}=DIC3DPPresults.FaceCentroids{it}-.5*Ds{it,is};
            Pre.Vc{it,is}=DIC3DPPresults.FaceCentroids{it}-.5*Ds{it,is};
        end
        if ~isempty(optStruct.maxCorrCoeff)
            corrNow=DIC3DPPresults.FaceCorrComb{it};
            FC{it,is}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            D{it,is}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
            Vc{it,is}(corrNow>optStruct.maxCorrCoeff,:)=NaN;
        end        
    end
end

FCmat = cell2mat(FC);
if ~isfield(optStruct,'colorBarLimits')
    switch faceMeasureCell{is}
        case {'Epc1','Epc2','epc1','epc2'}
            Emax=max(abs(FCmat(:)));
            optStruct.colorBarLimits=[-Emax Emax];
        case {'Lamda1','Lamda2'}
            Lmax=max(abs(FCmat(:)-1));
            if Lmax>1
                optStruct.colorBarLimits=[0 2];
            else
                optStruct.colorBarLimits=[1-prctile(abs(FCmat(:)-1),100) 1+prctile(abs(FCmat(:)-1),100)];
            end
        case {'EShearMax','eShearMax'}
            Emax=max(abs(FCmat(:)));
            optStruct.colorBarLimits=[0 Emax];

    end
end
colorBarLogic=1;
if ~isfield(optStruct,'colorMap')
    switch faceMeasureCell{is}
        case {'Epc1','Epc2','epc1','epc2','Lamda1','Lamda2'}
            optStruct.colorMap=.8*coldwarm;
        case {'EShearMax','eShearMax'}
            optStruct.colorMap='parula';
    end
    
end


%% Plot

animStruct=struct;

hf=cFigure;
hf.Units='normalized'; hf.OuterPosition=[.05 .05 .9 .9]; hf.Units='pixels';

for is=1:nStrains
    subplot(1,nStrains,is);
    
    axisGeom;     
    ax=gca;
    if nStrains~= 1 &&  is ==1
            ax.Position(1)=ax.Position(1)-0.05;   
    end   
    ax.CameraUpVector=[0 0 optStruct.zDirection];
    colormap(optStruct.colorMap);
    if colorBarLogic
        colorbar;
        caxis(optStruct.colorBarLimits);
    end
    
    title(optStruct.supTitleString{is});
    % axis off
    % camlight headlight
    
    it=1;
    Fnow=DIC3DPPresults.Faces;
    if RBMlogic
        Pnow=DIC3DPPresults.Points3D_ARBM{it};
    else
        Pnow=DIC3DPPresults.Points3D{it};   
    end
   
    Vnow=Vc{it,is};
    FCnow=FC{it,is};
    Dnow=Ds{it,is};
    if optStruct.smoothLogic
        smoothPar.lambda=optStruct.smoothlambda;
        smoothPar.n=optStruct.n;
        [FCnow]=patchSmoothFaceMeasure(Fnow,Pnow,FCnow,smoothPar);
    end
    FCnow(FCnow<optStruct.dataLimits(1))=NaN;
    FCnow(FCnow>optStruct.dataLimits(2))=NaN;

    hp(is)=gpatch(Fnow,Pnow,FCnow,optStruct.lineColor,optStruct.FaceAlpha); hold on
    hq(is)=quiver3(Vnow(:,1),Vnow(:,2),Vnow(:,3),Dnow(:,1),Dnow(:,2),Dnow(:,3),0,'Color',.2*[1 1 1],'ShowArrowHead','off','AutoScale','off'); hold on;        
    h_ax=gca;
    h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;
    h_ax.View = [180 255];
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
end

%% fill in the animstruct

animStruct.Time=1:nFrames;
animStruct.Handles=cell(1,nFrames);
animStruct.Props=cell(1,nFrames);
animStruct.Set=cell(1,nFrames);

for it=1:nFrames
    animStruct.Handles{it}=[];
    animStruct.Props{it}=cell(1,8*nStrains);
    animStruct.Set{it}=cell(1,8*nStrains);    
    for is=1:nStrains
        if RBMlogic
            Pnow=DIC3DPPresults.Points3D_ARBM{it};
        else
            Pnow=DIC3DPPresults.Points3D{it};
        end
        Fnow=DIC3DPPresults.Faces;
        FCnow=FC{it,is};
        if optStruct.smoothLogic
            [FCnow]=patchSmoothFaceMeasure(Fnow,Pnow,FCnow,smoothPar);%AYS
        end
        FCnow(FCnow<optStruct.dataLimits(1))=NaN;
        FCnow(FCnow>optStruct.dataLimits(2))=NaN;
        
        Vnow=Vc{it,is};
        Dnow=Ds{it,is};
    
        animStruct.Handles{it}=[animStruct.Handles{it} hp(is) hp(is) hq(is) hq(is) hq(is) hq(is) hq(is) hq(is)]; %Handles of objects to animate (add one every pair)
        
        animStruct.Props{it}{1+8*(is-1)}='CData';
        animStruct.Props{it}{2+8*(is-1)}='Vertices'; %Properties of objects to animate
        animStruct.Props{it}{3+8*(is-1)}='XData'; %Properties of objects to animate
        animStruct.Props{it}{4+8*(is-1)}='YData'; %Properties of objects to animate
        animStruct.Props{it}{5+8*(is-1)}='ZData'; %Properties of objects to animate
        animStruct.Props{it}{6+8*(is-1)}='UData'; %Properties of objects to animate
        animStruct.Props{it}{7+8*(is-1)}='VData'; %Properties of objects to animate
        animStruct.Props{it}{8+8*(is-1)}='WData'; %Properties of objects to animate        
        animStruct.Set{it}{1+8*(is-1)}=FCnow;
        animStruct.Set{it}{2+8*(is-1)}=Pnow; %Property values for to set in order to animate
        animStruct.Set{it}{3+8*(is-1)}=Vnow(:,1); %Property values for to set in order to animate
        animStruct.Set{it}{4+8*(is-1)}=Vnow(:,2); %Property values for to set in order to animate
        animStruct.Set{it}{5+8*(is-1)}=Vnow(:,3); %Property values for to set in order to animate
        animStruct.Set{it}{6+8*(is-1)}=Dnow(:,1); %Property values for to set in order to animate
        animStruct.Set{it}{7+8*(is-1)}=Dnow(:,2); %Property values for to set in order to animate
        animStruct.Set{it}{8+8*(is-1)}=Dnow(:,3); %Property values for to set in order to animate       
        h_ax.XLim = xl; h_ax.YLim = yl; h_ax.ZLim = zl;
        
    end
end

%% Turn  the toolbar on the figure off
ha = findobj(hf,'type','axes');
ha(1).Toolbar.Visible = 'off';
if size(ha,1)>1
    ha(2).Toolbar.Visible = 'off';
end

hf.UserData.optStruct=optStruct;
%% Fixing the plot look  like the former plot
if Narg==2
    ha = findobj(hf,'type','axes');
    hpatches=findobj(hf,'type','patch');
  % updating the view  to look like the former 
   
   set(ha(1),'CameraUpVectorMode','manual')  
   set(ha(1),'View',Old_set.view);
   set(ha(1),'CameraViewAngle',Old_set.CameraViewAngle);
   set(ha(1),'CameraPosition',Old_set.CameraPosition)
   set(ha(1),'CameraTarget',Old_set.CameraTarget);
   set(ha(1),'CameraUpVector',Old_set.CameraUpVector);
   drawnow;
   
  % updating the light to look like the former  
    if~isnan(Old_set.Lightaz) && ~isnan(Old_set.Lightel)
        for ia = 1:size(ha,1)
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
 %% Adding Buttons 
addColorbarLimitsButton(hf);
addColormapButton(hf);
addEdgeColorButton(hf);
addFaceAlphaButton(hf);
addQuiverFactorButton(hf);
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
