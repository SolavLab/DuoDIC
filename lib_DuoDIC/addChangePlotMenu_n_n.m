function []=addChangePlotMenu_n_n(varargin)
%% Changing Figures
% addChangePlotMenu_n_n
% addChangePlotMenu_n_n(hf,DIC3DPPresults,optStructOld);

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
end

Prompt={'--Select Next Plot--';
    'Surfaces with color as J (surface area change)';... % 1 
    'Surfaces with color as Lambda1 (1st principal stretch)';... % 2 
    'Surfaces with color as Lambda2 (2nd principal stretch)';... % 3 
    'Surfaces with color as Epc1 (1st principal Lagrangian strain)';... % 4 
    'Surfaces with color as Epc2 (2nd principal Lagrangian strain)';... % 5 
    'Surfaces with color as epc1 (1st principal Almansi strain)';... % 6 
    'Surfaces with color as epc2 (2nd principal Almansi strain)';... % 7 
    'Surfaces with color as Emgn (Lagrangian strain tensor magnitude)';... % 8 
    'Surfaces with color as emgn (Almansi strain tensor magnitude)';... % 9     
    'Surfaces with color as Lagrangian equivalent strain';...      %10
    'Points with color as dispMgn (Displacement magnitude)';...% 11
    'Surfaces with color as Eulerian equivalent strain';...  %12
    'Points with color as dispX (X Displacement)';...% 13
    'Surfaces with color as Max Lagrangian shear strain';...%14
    'Points with color as dispY (Y Displacement)';...% 15
    'Surfaces with color as Max Eulerian shear strain';...  %16
    'Points with color as dispZ (Z Displacement)';...% 17
    };

uicontrol(hf,'Style','popupmenu','Position',[10 70 160 50],'String',Prompt,'FontSize',12,'Callback',{@changePlotFunc,{hf,DIC3DPPresults,optStruct}} );


end

%% Ambient strength function  ambientStrengthFunc

function changePlotFunc(src,event,inputCell)
% Get former info
hf = inputCell{1};
DIC3DPPresults=inputCell{2};
optStruct=inputCell{3};
if isfield(hf.UserData,'optStruct')
    optStruct=hf.UserData.optStruct;
end
indx=src.Value-1;

%% Plot new figure

if indx==1
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'J',optStruct);

end
if indx==2
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Lamda1',optStruct);

end
if indx==3
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Lamda2',optStruct);

end
if indx==4
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Epc1',optStruct);

end
if indx==5
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Epc2',optStruct);

end
if indx==6
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'epc1',optStruct);

end
if indx==7
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'epc2',optStruct);

end
if indx==8
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Emgn',optStruct);

end
if indx==9
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'emgn',optStruct);

end
if indx==10
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Eeq',optStruct);

end
if indx==11
     anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispMgn',optStruct);

end
if indx==12
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'eeq',optStruct);

end
if indx==13
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispX',optStruct);

end

if indx==14
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'EShearMax',optStruct);

end
if indx==15
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispY',optStruct);

end
if indx==16
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'eShearMax',optStruct);

end
if indx==17
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispZ',optStruct);

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
