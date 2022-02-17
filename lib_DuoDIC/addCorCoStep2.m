function []=addCorCoStep2(varargin)
%% Viewing figures: setting face alpha
% addFaceAlphaButton
% addFaceAlphahButton(hf)

% This script creates a new pushtool in a figure's toolbar to manipulate
% the transparency of a displayed image by changing its face alpha value
%%
switch nargin
    case 0
        hf=gcf;
    case 4
        hf=varargin{1};
        animStruct=varargin{2};
        Original=varargin{3};
        kind=varargin{4};
end

% Get icon
filePath=mfilename('fullpath');
toolboxPath=fileparts(fileparts(filePath));
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');

hb = findall(hf,'Type','uitoolbar');
D=imread(fullfile(iconPath,'clean.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','Correlation Coefficient','CData',S,'Tag','CorrCoef_button','ClickedCallback',{@faceAlphaFunc,{hf,animStruct,Original,kind}});
end

%% Face alpha function  faceAlphaFunc

function faceAlphaFunc(~,~,inputCell)

hf = inputCell{1};
animStruct=inputCell{2};
Original=inputCell{3};
kind=inputCell{4};
n=size(animStruct.Time,2);
CorCoeffVec=Original.CorCoeffVec;
Points=Original.Points;

answer = inputdlg({'Enter maximum correlation coefficient to keep point (leave blank for keeping all points)'},...
                   'Input',[1,50]); 
if ~isempty(answer)
CorCoeffCutOff=str2double(answer{1}); % maximal correlation coefficient to display point (use [] for default which is keep all points)
    switch kind
        case 'points_1_2n'
            for ii=1:n
                if ~isempty(answer)
                   CorCoeffVec{ii}(CorCoeffVec{ii}>CorCoeffCutOff)=NaN;
                end
                xNow1=Points{1}(~isnan(CorCoeffVec{ii}),1);
                yNow1=Points{1}(~isnan(CorCoeffVec{ii}),2);
                xNow2=Points{ii}(~isnan(CorCoeffVec{ii}),1);
                yNow2=Points{ii}(~isnan(CorCoeffVec{ii}),2);
                cNow=CorCoeffVec{ii}(~isnan(CorCoeffVec{ii}));
                
                animStruct.Set{ii}{2}=xNow1;
                animStruct.Set{ii}{3}=yNow1;
                animStruct.Set{ii}{4}=cNow;
                animStruct.Set{ii}{5}=xNow2;
                animStruct.Set{ii}{6}=yNow2;
                animStruct.Set{ii}{7}=cNow;
            end          
        case 'points_n_n'
             if ~isempty(answer)
                for ii=1:2*n
                    CorCoeffVec{ii}(CorCoeffVec{ii}>CorCoeffCutOff)=NaN;
                end
             end
            
            for ii=1:n 
                xNow1=Points{ii}(~isnan(CorCoeffVec{ii}),1);
                yNow1=Points{ii}(~isnan(CorCoeffVec{ii}),2);
                xNow2=Points{ii+n}(~isnan(CorCoeffVec{ii+n}),1);
                yNow2=Points{ii+n}(~isnan(CorCoeffVec{ii+n}),2);
                cNow1=CorCoeffVec{ii}(~isnan(CorCoeffVec{ii}));
                cNow2=CorCoeffVec{ii+n}(~isnan(CorCoeffVec{ii+n}));
                
                animStruct.Set{ii}{3}=xNow1;
                animStruct.Set{ii}{4}=yNow1;
                animStruct.Set{ii}{5}=cNow1;
                animStruct.Set{ii}{6}=xNow2;
                animStruct.Set{ii}{7}=yNow2;
                animStruct.Set{ii}{8}=cNow2;
            end
            
        case 'faces_n_n'
            for ii=1:n
                
                Pnow1=Points{ii};
                Pnow2=Points{ii+n};
                cNow1=CorCoeffVec{ii};
                cNow2=CorCoeffVec{ii+n};
                
                 if ~isempty(answer)
                  cNow1(cNow1>CorCoeffCutOff)=NaN;   
                  cNow2(cNow2>CorCoeffCutOff)=NaN; 
                 end
                 
                animStruct.Set{ii}{3}=Pnow1;
                animStruct.Set{ii}{4}=cNow1;
                animStruct.Set{ii}{5}=Pnow2;
                animStruct.Set{ii}{6}=cNow2; 
            end
            
    end
    
    hf.UserData.anim8.animStruct=animStruct;
    drawnow
    %% to restart image moving slider back and forth
    valueSlider=get(hf.UserData.anim8.sliderHandles{1},'Value');
    maxSlider=get(hf.UserData.anim8.sliderHandles{1},'Maximum');

    if valueSlider ~= maxSlider
        set(hf.UserData.anim8.sliderHandles{1},'Value',valueSlider+1);
        set(hf.UserData.anim8.sliderHandles{1},'Value',valueSlider);
    else
        set(hf.UserData.anim8.sliderHandles{1},'Value',valueSlider-1);
        set(hf.UserData.anim8.sliderHandles{1},'Value',valueSlider);
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