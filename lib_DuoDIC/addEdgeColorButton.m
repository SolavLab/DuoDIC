function []=addEdgeColorButton(varargin)
%% Viewing figures: setting edge color
% addEdgeColorButton
% addEdgeColorButton(hf)

% This script creates a new pushtool in a figure's toolbar to manipulate
% the edge color of all patch objects on a displayed figure
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
D=imread(fullfile(iconPath,'spline.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','edge color','CData',S,'Tag','edgeColor_button','ClickedCallback',{@edgeColorFunc,{hf}});
end

%% Edge color function  edgeColorFunc

function edgeColorFunc(~,~,inputCell)

hf = inputCell{1};

% Change edge color for all existing images accordingly
hpatches = findobj(hf,'type','patch');
if ~isempty(hpatches)
    
    prompt = {'EdgeColor'};
    title = '';
    format = struct('type','list');
    format.style = 'popupmenu';
    format.items = {' -- Select an edge color -- ','none','black','white'};
    default = cell(size(prompt,1),1);
    default{1,1} = 1; % Default selection will always be instruction item
    default = cell2struct(default,prompt,1);
    prompt = repmat(prompt,1,2);
    options.AlignControls = 'on';
    choice = inputsdlg(prompt,title,format,default,options);
    
    numPatches = size(hpatches,1);
        if choice.EdgeColor == 2
            for i = 1:numPatches
                hpatches(i).EdgeColor = 'none';
            end
        elseif choice.EdgeColor == 3
            for i = 1:numPatches
                hpatches(i).EdgeColor = 'k';
            end
        elseif choice.EdgeColor == 4
            for i = 1:numPatches
                hpatches(i).EdgeColor = 'w';
            end
        end
else
    msgbox('There are no patch objects in the figure');
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
