function []=addSmoothCont(varargin)
%% Viewing figures: setting Smooth Settings
% addSmoothCont
% addSmoothCont(hf,animStruct,optStruct,DIC3DPPresults,Pre);
% This script creates a new pushtool in a figure's toolbar to manipulate
% Adding Smooth to the faces in two different level of smoothness, meaning
% if choosing level 1 take into acount only faces close to the main face around,
% if choosing level 2 taking into acount also the faces around the ones
% close by.

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
DIC3DPPresults=inputCell{4};
Pre=inputCell{5};
optStruct=hf.UserData.optStruct;
InputLogic=1;

%% Input info from user
smoothAnswer=questdlg('Do you want to smoothen the face values?','Smooth?','Yes','No','Yes');
switch smoothAnswer
    case 'Yes'
        ConctionAnswer=questdlg('What level of connectivity?','Connectivity','One','Two','One');
        switch ConctionAnswer
            case 'One'
                while InputLogic==1% Makeing sure the right Input 
                prompt1={'Enter level of smooth between 0-1 (if you leave empty, the default is 0.5)','Enter number of Repetitions (if you leave empty, the default is 1)'};
                dlgtitle ='Input';
                dims=[1,50];
                answer = inputdlg(prompt1,dlgtitle,dims);
                if ~isempty(answer)
                smoothPar.lambda1=str2double(answer{1});
                if smoothPar.lambda1<0 ||smoothPar.lambda1>1
                        uiwait(msgbox({'Wrong Input'; 'The level of smooth must be between 0 - 1'},'Wrong Input') );                     
                        InputLogic=1;
                else
                     InputLogic=0;
                end
                if isnan(smoothPar.lambda1)%Input Default
                    smoothPar.lambda1=0.5;
                end
                optStruct.Smoothlambda1=smoothPar.lambda1;
                smoothPar.n=str2double(answer{2});%Input Default
                if isnan(smoothPar.n)%Input Default
                    smoothPar.n=1;
                else
                    if isreal(smoothPar.n) && rem(smoothPar.n,1)==0
                        InputLogic=0;                        
                    else
                        uiwait(msgbox({'Wrong Input';'Input must be a natural numbers'},'Wrong Input')) ;
                        InputLogic=1;
                    end
                end
                optStruct.Smoothlambda2=[];
                optStruct.Smoothn=smoothPar.n;
                optStruct.SmoothLogic=1;% Level Of Smooth
                else
                    break
                end
                end
            case 'Two'
                while InputLogic==1% Makeing sure th eright Input               
                prompt2={'Enter level of smooth for first level between 0-1 (if you leave empty, the default is 0.25 each )','Enter level of smooth for second level between 0-1 (if you leave empty, the default is 0.25)','Enter number of Repetition (if you leave empty, the default is 1)'};
                dlgtitle ='Input';
                dims=[1,50];
                answer = inputdlg(prompt2,dlgtitle,dims);
                if ~isempty(answer)
                smoothPar.lambda1=str2double(answer{1});
                smoothPar.lambda2=str2double(answer{2});
                if smoothPar.lambda1<0 ||smoothPar.lambda2<0 ||(smoothPar.lambda2+smoothPar.lambda1)>1
                    uiwait(msgbox({'Wrong Input'; 'The sum of the levels must be between 0 - 1, and positive '},'Wrong Input') );
                    InputLogic=1;
                else
                     InputLogic=0;
                end
                if isnan(smoothPar.lambda1)%Input Default
                    smoothPar.lambda1=0.25;
                end
                if isnan(smoothPar.lambda2)%Input Default
                    smoothPar.lambda2=0.25;
                end
                optStruct.Smoothlambda1=smoothPar.lambda1;
                optStruct.Smoothlambda2=smoothPar.lambda2;
                smoothPar.n=str2double(answer{3});%Input Default
                if isnan(smoothPar.n)%Input Default
                    smoothPar.n=1;
                else
                    if isreal(smoothPar.n) && rem(smoothPar.n,1)==0
                        InputLogic=0;                        
                    else
                       uiwait( msgbox({'Wrong Input';'Input must be a natural numbers'},'Wrong Input'));
                        InputLogic=1;
                    end
                end
                optStruct.Smoothn=smoothPar.n;
                optStruct.SmoothLogic=2;% Level Of Smooth
                else
                    break
                end                
                end   
        end
    case 'No'
        optStruct.SmoothLogic=0;
end
hf.UserData.optStruct=optStruct;
%% Changing plot
animStruct=animStructUpdate(hf,animStruct,optStruct,DIC3DPPresults,Pre);
%% Update Plot
hf.UserData.anim8.animStruct=animStruct;
hf.UserData.optStruct=optStruct;
drawnow ;
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

