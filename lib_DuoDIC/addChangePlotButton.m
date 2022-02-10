function []=addChangePlotButton(varargin)
%% Viewing figures: setting ambient strength
% addAmbientStrengthButton
% addAmbientStrengthButton(hf)

% This script creates a new pushtool in a figure's toolbar to manipulate
% the ambient strength of a given patch of light on a displayed axis
%addChangePlotButton(hf,DIC3DPPresults,optStruct,RBMlogic);
%%
switch nargin
    case 0
        hf=gcf;
    case 4
        hf=varargin{1};
        DIC3DPPresults=varargin{2};
        optStruct=varargin{3};
        RBMlogic=varargin{4};
    case 5
        hf=varargin{1};
        DIC3DPPresults=varargin{2};
        optStruct=varargin{3};
        RBMlogic=varargin{4};
        Old_set=varargin{5};
end

% Get icon
filePath=mfilename('fullpath');
toolboxPath=fileparts(fileparts(filePath));
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');

hb = findall(hf,'Type','uitoolbar');
D=imread(fullfile(iconPath,'blur.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar

switch nargin
    case 4
    uipushtool(hb(1),'TooltipString','ambient strength','CData',S,'Tag','ambientStrength_button','ClickedCallback',{@changePlotFunc,{hf,DIC3DPPresults,optStruct,RBMlogic}});
    case 5
     uipushtool(hb(1),'TooltipString','ambient strength','CData',S,'Tag','ambientStrength_button','ClickedCallback',{@changePlotFunc,{hf,DIC3DPPresults,optStruct,RBMlogic,Old_set}});
end


end

%% Ambient strength function  ambientStrengthFunc

function changePlotFunc(~,~,inputCell)
% Get former info
a=size(inputCell);
switch a(2)
    case 4 %For former faceMeasure and faceMeasureDirection
    hf = inputCell{1};
    DIC3DPPresults=inputCell{2};
    optStruct=inputCell{3};
    RBMlogic=inputCell{4};
    
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

    case 5 %For former faceMeasure and faceMeasureDirection
        
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





Prompt={
    'Surfaces with color as combined correlation coefficient';... % 1
    'Points with color as correlation coefficient';... % 2
    'Surfaces with color as dispMgn (Displacement magnitude)';... % 3
    'Points with color as dispMgn (Displacement magnitude)';... % 4
    'Surfaces with color as dispX (X Displacement)';... % 5
    'Points with color as dispX (X Displacement)';... % 6
    'Surfaces with color as dispY (Y Displacement)';... %7 
    'Points with color as dispY (Y Displacement)';... % 8
    'Surfaces with color as dispZ (Z Displacement)';... % 9
    'Points with color as dispZ (Z Displacement)';... % 10
    'Surfaces with color as J (surface area change)';... % 11
    'Surfaces with color as lambda1 (1st principal stretch)';... % 12
    'Surfaces with color as Lambda2 (2nd principal stretch)';... % 13
    'Surfaces with color as Epc1 (1st principal Lagrangian strain)';... % 14
    'Surfaces with color as Epc2 (2nd principal Lagrangian strain)';... % 15
    'Surfaces with color as epc1 (1st principal Almansi strain)';... % 16
    'Surfaces with color as epc2 (2nd principal Almansi strain)';... % 17
    'Surfaces with color as Emgn (Lagrangian strain tensor magnitude)';... % 18
    'Surfaces with color as emgn (Almansi strain tensor magnitude)';... % 19
    'Surfaces with color as Lagrangian equivalent strain';... % 20
    'Surfaces with color as Eulerian equivalent strain';... % 21
    'Surfaces with color as Max Lagrangian shear strain';... % 22
    'Surfaces with color as Max Eulerian shear strain';... % 23
    'Surfaces with color as Lamda1+direction (1st principal stretch value and direction)';... % 24
    'Surfaces with color as Lamda2+direction (2nd principal stretch value and direction)';... % 25
    'Surfaces with color as Epc1+direction (1st principal Lagrangian strain value and direction)';... % 26
    'Surfaces with color as Epc2+direction (2nd principal Lagrangian strain value and direction)';... % 27
    'Surfaces with color as epc1+direction (1st principal Almansi strain value and direction)';... % 28
    'Surfaces with color as epc2+direction (2nd principal Almansi strain value and direction)';... % 29
    'Surfaces with color as Epc1+Epc2+direction (1st and 2nd principal Lagrangian strain values and directions)';... % 30
    'Surfaces with color as epc1+epc2+direction (1st and 2nd principal Almansi strain values and directions)'; % 31
    'Surfaces with color as Max Lagrangian shear strain + directions';... % 32
    'Surfaces with color as Max Eulerian shear strain + directions';... % 33
    'Surfaces with color as Lamda1+Lamda2+direction (1st and 2nd principal stretch values and directions)';... % 34
    'Surfaces with color as FaceIsoInd (triangular face isotropy index)';... % 35
    'Surfaces with color as FaceColors (grayscale from images)'};%36
  % Ask for next plot  
    [indx,tf] = listdlg('ListString',Prompt,'SelectionMode','single','ListSize',[900,300],'PromptString','Select New Plot');
    
    if ~tf 
        return
    end
    

%% Plot new figure

if indx==1
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'FaceCorrComb',RBMlogic,optStruct,Old_set);

    
end
if indx==2
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'corrComb',RBMlogic,optStruct,Old_set);
  
end
if indx==3
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'DispMgn',RBMlogic,optStruct,Old_set);
   
end
if indx==4
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispMgn',RBMlogic,optStruct,Old_set);

end
if indx==5
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'DispX',RBMlogic,optStruct,Old_set);

end
if indx==6
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispX',RBMlogic,optStruct,Old_set);

end
if indx==7
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'DispY',RBMlogic,optStruct,Old_set);

end
if indx==8
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispY',RBMlogic,optStruct,Old_set);

end
if indx==9
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'DispZ',RBMlogic,optStruct,Old_set);

end
if indx==10
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispZ',RBMlogic,optStruct,Old_set);

end
if indx==11
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'J',RBMlogic,optStruct,Old_set);

end
if indx==12
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Lamda1',RBMlogic,optStruct,Old_set);

end
if indx==13
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Lamda2',RBMlogic,optStruct,Old_set);

end
if indx==14
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Epc1',RBMlogic,optStruct,Old_set);

end
if indx==15
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Epc2',RBMlogic,optStruct,Old_set);

end
if indx==16
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'epc1',RBMlogic,optStruct,Old_set);

end
if indx==17
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'epc2',RBMlogic,optStruct,Old_set);

end
if indx==18
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Emgn',RBMlogic,optStruct,Old_set);

end
if indx==19
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'emgn',RBMlogic,optStruct,Old_set);

end
if indx==20
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Eeq',RBMlogic,optStruct,Old_set);

end
if indx==21
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'eeq',RBMlogic,optStruct,Old_set);

end
if indx==22
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'EShearMax',RBMlogic,optStruct,Old_set);

end
if indx==23
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'eShearMax',RBMlogic,optStruct,Old_set);

end
if indx==24
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'Lamda1',RBMlogic,optStruct,Old_set);

end
if indx==25
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'Lamda2',RBMlogic,optStruct,Old_set);

end
if indx==26
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'Epc1',RBMlogic,optStruct,Old_set);

end
if indx==27
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'Epc2',RBMlogic,optStruct,Old_set);

end
if indx==28
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'epc1',RBMlogic,optStruct,Old_set);
 
end
if indx==29
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,'epc2',RBMlogic,optStruct,Old_set);
 
end
if indx==30
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,{'Epc1','Epc2'},RBMlogic,optStruct,Old_set);

end
if indx==31
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,{'epc1','epc2'},RBMlogic,optStruct,Old_set);
  
end
if indx==32 
    msgbox('Shear directions cannot be plotted. This feature is under construction...');
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,{'EShearMax1','EShearMax2'},RBMlogic,optStruct);%AYS    
end
if indx==33 
    msgbox('Shear directions cannot be plotted. This feature is under construction...');
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,{'eShearMax1','eShearMax2'},RBMlogic,optStruct);%AYS    
end
if indx==34
    anim8_DIC3DPP_faceMeasureDirection(DIC3DPPresults,{'Lamda1','Lamda2'},RBMlogic,optStruct,Old_set);

end
if indx==35
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'FaceIsoInd',RBMlogic,optStruct,Old_set);
 
end
if indx==36
    anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'FaceColors',RBMlogic,optStruct,Old_set);

end







end
   
     
   

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
