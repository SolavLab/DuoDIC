function []=addFaceAlphaButton(varargin)
%% Viewing figures: setting face alpha
% addFaceAlphaButton
% addFaceAlphahButton(hf)

% This script creates a new pushtool in a figure's toolbar to manipulate
% the transparency of a displayed image by changing its face alpha value
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
D=imread(fullfile(iconPath,'ghost.jpg'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','Face Alpha','CData',S,'Tag','faceAlpha_button','ClickedCallback',{@faceAlphaFunc,{hf}});
end

%% Face alpha function  faceAlphaFunc

function faceAlphaFunc(~,~,inputCell)

hf = inputCell{1};
prompt = {'Input a value [0,1]:'};
dlg_title = 'Set face alpha';

hpatches = findobj(hf,'type','patch');
if ~isempty(hpatches)
    numPatches = size(hpatches,1);
    for i = 1:numPatches
        default = hpatches(i).FaceAlpha;
        defaultOption = {num2str(default)};
    end
    s = 40 + max([cellfun(@numel,prompt) cellfun(@numel,defaultOption)]);

    Q = inputdlg(prompt,dlg_title,[1 s],defaultOption);
    if ~isempty(Q)
        for ii = 1:numPatches
            hpatches(ii).FaceAlpha = str2double(Q{1});
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
