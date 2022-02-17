function []=addCorrCoef_n_n(varargin)
%% Viewing figures: setting Correlation Coefficient
% addCorrCoef_n_n
% addCorrCoef_n_n(hf,animStruct,optStruct,DIC3DPPresults,Pre);
% For surface plot  
% Changes the correlation coefficient of Plot 

% This script creates a new pushtool in a figure's toolbar to manipulate
% Get icon in https://icon-library.com/icon/clean-icon-19.html

%%
switch nargin
    case 0
        hf=gcf;
    case 5
        hf=varargin{1};
        animStruct=varargin{2};
        optStruct=varargin{3};
        DIC3DPPresults=varargin{4};
        Pre=varargin{5};
end


filePath=mfilename('fullpath');%File is located
toolboxPath=fileparts(fileparts(filePath));%2 steps back Dou_DIC
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');% Path to icon

hb = findall(hf,'Type','uitoolbar');
D=imread(fullfile(iconPath,'clean.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','Correlation Coefficient','CData',S,'Tag','CorrCoef_button','ClickedCallback',{@FaceCleanFunc,{hf,animStruct,optStruct,DIC3DPPresults,Pre}});
end

%% Face Cleaning function  FaceCleanFunc %AYS

function FaceCleanFunc(~,~,inputCell)
%% Defining variables    
    hf=inputCell{1};
    animStruct=inputCell{2};
    optStruct=inputCell{3};
    DIC3DPPresults=inputCell{4};
    Pre=inputCell{5};
%% Input info from user
answer = inputdlg({'Enter maximum correlation coefficient to keep points (leave blank for keeping all points)'},'Input',[1,50]);
if ~isempty(answer)
CorCoeffCutOff=str2double(answer{1}); % maximal correlation coefficient for display (use [] for default which is max)
if isnan(CorCoeffCutOff)
    optStruct.CorCoeffCutOff=[];
    optStruct.CorCoeffLogic=0;
else
    optStruct.CorCoeffCutOff=CorCoeffCutOff;
    optStruct.CorCoeffLogic=1;
end
hf.UserData.optStruct=optStruct;
%% Changing plot 
animStruct=animStructUpdate_n_n(hf,animStruct,DIC3DPPresults,Pre);
%% Update Plot  
hf.UserData.anim8.animStruct=animStruct;
drawnow ;
%% to restart image moving slider back and forth
ResetPlot(hf);
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
