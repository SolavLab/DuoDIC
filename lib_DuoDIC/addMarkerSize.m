function []=addMarkerSize (varargin)
%% Viewing figures: setting Market Size 
% addMarkerSize;
% addMarkerSize(hf);
% Changing the size of the points in point plots
% This script creates a new pushtool in a figure's toolbar to manipulate
% Changin the size of the marker 
%%
switch nargin
    case 0
        hf=gcf;
    case 1
        hf=varargin{1};
end

% Get icon
filePath=mfilename('fullpath');
toolboxPath=fileparts(fileparts(filePath));
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');

hb = findall(hf,'Type','uitoolbar');
D=imread(fullfile(iconPath,'grow.jpg'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','Marker Size','CData',S,'Tag','markerSize_button','ClickedCallback',{@MarkerChange,{hf}});
end

%% Face alpha function  faceAlphaFunc

function MarkerChange(~,~,inputCell)
hf = inputCell{1};
prompt = {'Input the size of the marker:'};
dlg_title = 'Set Marker Size';
answer = inputdlg( prompt,dlg_title,[1,50]);
if ~isempty(answer)
    sizer=str2double(answer);
    if isnan(sizer)
        sizer=36;
    end
    hpatches = findobj(hf,'type','scatter');
    if ~isempty(hpatches)
       numPatches = size(hpatches,1);
       for i = 1:numPatches
           hpatches(i).SizeData= sizer;
       end
    else
       msgbox('There are no patch objects in the figure');
    end    
end
end
%% 
% MultiDIC: a MATLAB Toolbox for Multi-View 3D Digital Image Correlation
% 
% License: <https://github.com/MultiDIC/MultiDIC/blob/master/LICENSE.txt>
% 
% Copyright (C) 2018  Dana Solav
% 
% Modified by Rana Odabas 2018
% 
% If you use the toolbox/function for your research, please cite our paper:
% <https://engrxiv.org/fv47e>