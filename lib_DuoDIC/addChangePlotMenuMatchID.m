function []=addChangePlotMenuMatchID(varargin)
%% Changing Figures
% addChangePlotMenu
% addChangePlotMenu(hf,DIC3DPPresults,optStructOld,RBMlogic)

% This script creates a new menu in a figure's toolbar to manipulate
% Opening a menu in order to change plot 
%
%%
switch nargin
    case 0
        hf=gcf;
    case 3
        hf=varargin{1};
        DIC3DPPresults=varargin{2};
        optStruct=varargin{3};
        
    case 4
        hf=varargin{1};
        DIC3DPPresults=varargin{2};
        optStruct=varargin{3};
        Old_set=varargin{5};
end

Prompt={'  -- Select Next Plot --';
     'Points with color as dispX (X Displacement)';...  %(2 1) 2
    
    'Points with color as Exx (Strain-global X)';...  %(2 2) 3

    'Points with color as dispY (Y Displacement)';... %(3 1) 4
    
	'Points with color as Eyy (Strain-global Y)';... %(3 2) 5

    'Points with color as dispZ (Z Displacement)';...  %(4 1) 6
    
	'Points with color as Exy (Strain-global XY)';... %(4,2) 7
    
    'Points with color as correlation coefficient';...  %(5,1) 8
    
    'Points with color as Gamma (Shear Angle) ';...  %(5,2) 9
    
	'Points with color as dispMgn (Displacement magnitude)';... %(6,1) 10
    
    'Points with color as EI (Maximum Principal Strain)';...  %(6,2) 11
    
    'Points with color as EII (Minimum Principal Strain)';...  %(7,2) 12
    
    
    'Points with color as Von Mises Equivalent Strain '}; %(8,2) 14    


switch nargin
    
    case 3
    uicontrol(hf,'Style','popupmenu','Position',[10 70 180 50],'String',Prompt,'FontSize',12,'Callback',{@changePlotFunc,{hf,DIC3DPPresults,optStruct}} );
        
    case 4
    uicontrol(hf,'Style','popupmenu','Position',[10 70 180 50],'String',Prompt,'FontSize',12,'Callback',{@changePlotFunc,{hf,DIC3DPPresults,optStruct,Old_set}} );
   
end


end

%% Ambient strength function  ambientStrengthFunc

function changePlotFunc(src,event,inputCell)
%% Get former info Smooth, CorrCoff, View, Light
a=size(inputCell);
switch a(2)
    case 3 %For former faceMeasure and faceMeasureDirection
    hf = inputCell{1};
    DIC3DPPresults=inputCell{2};
    optStruct=inputCell{3};
    
    Old_set=struct();
    ha = findobj(hf,'type','axes');
    existingLight = findobj(hf,'type','light');
    hpatch=findobj(hf,'type','patch');
        
   %former view 
    Old_set.CameraUpVector =ha.CameraUpVector;
    Old_set.view=ha.View;
    Old_set.CameraViewAngle=ha.CameraViewAngle;
    Old_set.CameraPosition=ha.CameraPosition;
    Old_set.CameraTarget=ha.CameraTarget;
    Old_set.Smoothlambda1=hf.UserData.optStruct.Smoothlambda1;
    Old_set.Smoothlambda2=hf.UserData.optStruct.Smoothlambda2;
    Old_set.SmoothLogic=hf.UserData.optStruct.SmoothLogic;
    Old_set.Smoothn=hf.UserData.optStruct.Smoothn;
    
    Old_set.CorCoeffCutOff=hf.UserData.optStruct.CorCoeffCutOff;
    Old_set.CorCoeffLogic=hf.UserData.optStruct.CorCoeffLogic;
    
    %former light
    if ~isempty(existingLight)

        Light=get(existingLight,'position');
        if ~isa(Light,'double')
            pos=cell2mat(Light);
        else
            pos=Light;
        end
        [az,el]=cart2sph(pos(1),pos(2),pos(3));

        Old_set.Lightaz=az;
        Old_set.Lightel=el;
        Ambient=get(hpatch,'AmbientStrength');
        Diffuse=get(hpatch,'DiffuseStrength');
        Specular=get(hpatch,'SpecularStrength');
        FaceL=get(hpatch,'FaceLighting');

        if isa(Ambient,'cell')
           vic=cell2mat(Ambient);
           Old_set.AmbientStrength=vic(1);  
        else
           Old_set.AmbientStrength=Ambient;
        end
        if isa(Diffuse,'cell')
            vic=cell2mat(Diffuse);
            Old_set.DiffuseStrength=vic(1);
        else
            Old_set.DiffuseStrength=Diffuse;
        end
        if isa(Specular,'cell')
            vic=cell2mat(Specular);
            Old_set.SpecularStrength=vic(1); 
        else
            Old_set.SpecularStrength=Specular;
        end
         if isa(FaceL,'cell')
            vic=cell2mat(FaceL);
            Old_set.FaceLighting=vic(1);
         else
            Old_set.FaceLighting=FaceL;
         end
    else
        Old_set.Lightaz=NaN;
        Old_set.Lightel=NaN;
    end

    case 5 %For former Face Plots
        
    hf = inputCell{1};
    DIC3DPPresults=inputCell{2};
    optStruct=inputCell{3};
    RBMlogic=inputCell{4};
    Old_set=inputCell{5};
    
    %former view 
    ha = findobj(hf,'type','axes');
    Old_set.CameraUpVector =ha.CameraUpVector;
    Old_set.view=ha.View;
    Old_set.CameraViewAngle=ha.CameraViewAngle;
    Old_set.CameraPosition=ha.CameraPosition;
    Old_set.CameraTarget=ha.CameraTarget;
    
    
end
indx=src.Value-1;

%% Plot new figure


if  indx==1
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispX',optStruct);
end

if  indx==2
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Exx',optStruct);
end

if  indx==3
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispY',optStruct);
end

if  indx==4
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Eyy',optStruct);
end

if  indx==5
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispZ',optStruct);
end

if indx==6
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Exy',optStruct);
end

if indx==7
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'corrComb',optStruct);
end

if indx==8
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Gamma',optStruct);
end

if indx==9
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispMgn',optStruct);
end

if indx==10
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'EI',optStruct);
end

if indx==11
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'EII',optStruct);
end

if indx==12
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'VonMises',optStruct);
end

end
   
     
   
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
