function []=addSmoothCont_n_n(varargin)
%% Viewing figures: setting Smooth Settings
% addSmoothCont_n_n
% addSmoothCont_n_n(hf,animStruct,optStruct,DIC3DPPresults,Pre);
% This script creates a new pushtool in a figure's toolbar to manipulate
% For surface plot
% Adding Smooth to the faces in two different level of smoothness, meaning
% if choosing level 1 take into acount only faces close to the main face around,
% if choosing level 2 taking into acount also the faces around the ones
% close by.

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
D=imread(fullfile(iconPath,'smooth.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','Smooth Face','CData',S,'Tag','SmoothFace_button','ClickedCallback',{@Smoothner,{hf,animStruct,optStruct,DIC3DPPresults,Pre}});
end

%% Face Cleaning function  FaceCleanFunc %AYS
function Smoothner(~,~,inputCell)
%% Defining variables
hf=inputCell{1};
animStruct=inputCell{2};
optStruct=inputCell{3};
DIC3DPPresults=inputCell{4};
Pre=inputCell{5};

optStruct=hf.UserData.optStruct;


%% Input info from user
smoothAnswer=questdlg('Do you want to smoothen the face values?','Smooth?','Yes','No','Yes');
switch smoothAnswer
    case 'Yes'
        ConctionAnswer=questdlg('What level of connectivity?','Connectivity','One','Two','One');
        switch ConctionAnswer
            case 'One'
                prompt1={'Enter level of smooth between 0-1 (if you leave empty, the default is 0.5)','Enter number of Repetitions (if you leave empty, the default is 1)'};
                dlgtitle ='Input';
                dims=[1,50];
                answer = inputdlg(prompt1,dlgtitle,dims);
                if ~isempty(answer)
                smoothPar.lambda1=str2double(answer{1});
                if smoothPar.lambda1<0 ||smoothPar.lambda1>1
                    error('Error Wrong Input')
                end
                if isnan(smoothPar.lambda1)% Default
                    smoothPar.lambda1=0.5;
                end
                optStruct.Smoothlambda1=smoothPar.lambda1;
                smoothPar.n=str2double(answer{2});% Default
                if isnan(smoothPar.n)% Default
                    smoothPar.n=1;
                else
                    if isreal(smoothPar.n) && rem(smoothPar.n,1)==0
                    else
                        error('Error Wrong Input');
                    end
                end
                optStruct.Smoothlambda2=[];
                optStruct.Smoothn=smoothPar.n;
                optStruct.SmoothLogic=1;
                end
            case 'Two'
                prompt2={'Enter level of smooth for first level between 0-1 (if you leave empty, the default is 0.25 each )','Enter level of smooth for second level between 0-1 (if you leave empty, the default is 0.25)','Enter number of Repetition (if you leave empty, the default is 1)'};
                dlgtitle ='Input';
                dims=[1,50];
                answer = inputdlg(prompt2,dlgtitle,dims);
                if ~isempty(answer)
                smoothPar.lambda1=str2double(answer{1});
                smoothPar.lambda2=str2double(answer{2});
                if smoothPar.lambda1<0 ||smoothPar.lambda2<0 ||(smoothPar.lambda2+smoothPar.lambda1)>1
                    error('Error Wrong Input')
                end
                if isnan(smoothPar.lambda1)% Default
                    smoothPar.lambda1=0.25;
                end
                if isnan(smoothPar.lambda2)% Default
                    smoothPar.lambda2=0.25;
                end
                optStruct.Smoothlambda1=smoothPar.lambda1;
                optStruct.Smoothlambda2=smoothPar.lambda2;
                smoothPar.n=str2double(answer{3});% Default
                if isnan(smoothPar.n)% Default
                    smoothPar.n=1;
                    if ~isreal(smoothPar.n) && (rem(smoothPar.n,1)~=0)
                        error('Error Wrong Input');
                    end
                end
                optStruct.Smoothn=smoothPar.n;
                optStruct.SmoothLogic=2;
                end
        end
    case 'No'
        optStruct.SmoothLogic=0;
end
hf.UserData.optStruct=optStruct;
%% Changing plot
animStruct=animStructUpdate_n_n(hf,animStruct,DIC3DPPresults,Pre);
%% Update Plot
hf.UserData.anim8.animStruct=animStruct;
drawnow ;
%% to restart image
ResetPlot(hf);
end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information

