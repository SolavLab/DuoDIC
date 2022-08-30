function []=plot_DuoDIC_MatchID(varargin)
%% function for plotting 3D-DIC results in STEP4.
% Plotting the 3D reconstruction of points correlated with Ncorr
% The function opens a selection window for all the possible measures to plot
% After selection, the animation figures are plotted
%
% INPUT options:
% DIC3DPPresults

%%
switch nargin
    case 0 % in case no results were entered
        % ask user to load results from 1 or more camera pairs and turn
        % into a cell array
        [file,path] = uigetfile(pwd,'Select a DIC3DPPresults structure');
        result=load([path file]);
        DIC3DPPresults=result.DIC3DPPresults;
        optStruct=struct;
    case 1
        % use given struct
        DIC3DPPresults=varargin{1};
        optStruct=struct;
    case 2
        % use given struct
        DIC3DPPresults=varargin{1};
        optStruct=varargin{2};
    otherwise
        error('wrong number of input arguments');
end

%% select what to plot
Prompt={'\bf{Select which parameters to plot}';... 

    'Points with color as correlation coefficient';... 

    'Points with color as dispMgn (Displacement magnitude)';...

    'Points with color as dispX (X Displacement)';... 

    'Points with color as dispY (Y Displacement)';... 

    'Points with color as dispZ (Z Displacement)';... 
    
    'Select All'; }; 

Title='Select which parameters to plot';

Formats=struct;

Formats(1,1).type='text'; 

Formats(2,1).type='check';

Formats(3,1).type='check'; 

Formats(4,1).type='check'; 

Formats(5,1).type='check'; 

Formats(6,1).type='check'; 

Formats(7,1).type='check'; 
 
DefAns=cell(numel(Prompt),1);
DefAns{1}=[];
for ii=2:numel(Prompt)
    DefAns{ii}=false;
end

Options.Resize='on';
Options.FontSize=10;
% Options.ApplyButton='on';

[Answer,Canceled] = inputsdlg(Prompt, Title, Formats, DefAns, Options);
if Answer{7}
    for ii=[2:36 38]
        Answer{ii}=true;
    end
end

%% create option struct for plotting
% complete the struct fields
if ~isfield(optStruct,'zDirection')
    optStruct.zDirection=1;
end
%optStruct.maxCorrCoeff=CorCoeffCutOff; 
%optStruct.maxCorrCoeff=1;
% optStruct.lineColor='k';
 optStruct.smoothLogic=0;
% optStruct.colorMap=cMap;
% optStruct.supTitleString=pointMeasureString;
RBMlogic=0;

%% plot according to answer

if Canceled
    return
end

if Answer{2}
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'corrComb',RBMlogic,optStruct);
    
end
if Answer{3}
    anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispMgn',RBMlogic,optStruct);

  
end
if Answer{4}

   anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispX',RBMlogic,optStruct);
end
if Answer{5}
     anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispY',RBMlogic,optStruct);

   
end
if Answer{6}
      anim8_DIC3DPP_pointMeasure(DIC3DPPresults,'DispZ',RBMlogic,optStruct);
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
