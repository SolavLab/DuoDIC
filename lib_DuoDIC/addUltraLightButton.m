 function []=addUltraLightButton(varargin)
%% Viewing figures: projecting light
% addUltraLightButton
% addUltraLightButtob(hf)
% This function allows the user to change the lighting on the plot
% Changing the Lighting includes: Directions,  Ambeint Strength, Diffuse Strength,
% Specular Strength,FaceLight.
% This script creates a new pushtool in a figure's toolbar to manipulate
% the light projected on a displayed axis
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

D=imread(fullfile(iconPath,'lightbulb.jpg'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uipushtool(hb(1),'TooltipString','light','CData',S,'Tag','light_button','ClickedCallback',{@lightFunc,{hf}});

end

%% Light function  lightFunc

function lightFunc(~,~,inputCell)
global LogicBtn
hf = inputCell{1};
ha = findobj(hf,'type','axes');
hpatches = findobj(hf,'type','patch');

if isempty(ha)
    msgbox('There are no axes in the figure');
else
    prompt = {'Light'};
    title = '';
    format = struct('type','list');
    format.style = 'popupmenu';
    format.items = {' -- Select a lighting option -- ','none','left','right','headlight'};
    default = cell(size(prompt,1),1);
    default{1,1} = 1; % Default selection will always be instruction item
    default = cell2struct(default,prompt,1);
    prompt = repmat(prompt,1,2);
    options.AlignControls = 'on';
    choice = inputsdlg(prompt,title,format,default,options);

    
    existingLight = findobj(ha,'type','light');
    % Unless the user closes the pop up window, clear all existing light
    if choice.Light ~= 1&&choice.Light ~= 2
        s=struct('Ambiet',0.3,'Diffuse',0.6,'Speclar',0.9,'FaceLight','none');
        d = dialog('Position',[300 200 500 500],'Name','Light');
        LogicBtn=2;       
        %Choose Ambeint Strength       
        txt_Ambient_Str = uicontrol( ...
                       'Parent',d,...
                       'Style','text',...
                       'Position',[50 330 400 100],...
                       'String',' --Set Ambient Strength, Input a value [0,1]--'); 
        input_Ambient_Str=   uicontrol('Parent',d,...
                       'Style','edit',...
                       'Position',[200 360 100 30],...
                       'String','0.3', ...
                       'UserData',s,...
                       'Tag','Ambiet');

        %Choose Diffuse Strength      
        txt_Diffuse_Str =uicontrol( ...
                       'Parent',d,...
                       'Style','text',...
                       'Position',[50 240 400 100],...
                       'String',' --Set Diffuse Strength, Input a value [0,1]--');       
        input_Diffuse_Str=uicontrol(...
                       'Parent',d,...
                       'Style','edit',...
                       'Position',[200 270 100 30],...
                       'String','0.6', ...
                       'Tag','Diffuse');

        %Choose Specular Strength        
        txt_Speclar_Str = uicontrol( ...
                       'Parent',d,...
                       'Style','text',...
                       'Position',[50 160 400 100],...
                       'String',' --Set Specular Strength, Input a value [0,1]--');       
        input_Speclar_Str=   uicontrol( ...
                       'Parent',d,...
                       'Style','edit',...
                       'Position',[200 190 100 30],...
                       'String','0.9', ...
                       'Tag','Speclar');       

        %Choose FaceLight 
        txt_FaceLight = uicontrol( ...
                       'Parent',d,...
                       'Style','text',...
                       'Position',[100 120 300 50],...
                       'String','  -- Select a Lighting Smoothing Option -- ');  
        popup_FaceLight = uicontrol( ...
                       'Parent',d,...
                       'Style','popup',...
                       'Position',[200 30 100 100],...
                       'String',{'none','flat','gouraud'}, ...
                       'Tag','FaceLight');
        %Close              
        OKBtn = uicontrol( ...
                       'Parent',d,...
                       'Position',[270 50 80 25],...
                       'String','Ok',...
                       'Style','pushbutton',...
                       'UserData','OK',...
                       'Callback',{@doCallback});

        CancleBtn = uicontrol( ...
                       'Parent',d,...
                       'Position',[150 50 80 25],...
                       'Style','pushbutton',...
                       'String','Cancel',...
                       'Callback',{@doCallback});
        uiwait(d); % Wait for d to close before running to completion   
        if LogicBtn
            s.Ambiet =str2double(input_Ambient_Str.String);
            s.Diffuse= str2double(input_Diffuse_Str.String) ;
            s.Speclar=str2double(input_Speclar_Str.String);
            s.FaceLight=popup_FaceLight.Value;
        end
        delete(d);
 
        if ~isempty(existingLight)
            delete(existingLight);
        end
        % Apply selected light to all figure axes
        if choice.Light == 3
            for ia = 1:size(ha,1)
                axes(ha(ia)); % Set the current axis
                h(ia) = camlight('left');
            end
        elseif choice.Light == 4
            for ia = 1:size(ha,1)
                axes(ha(ia));
                h(ia) = camlight('right');
            end
        elseif choice.Light == 5
            for ia = 1:size(ha,1)
                axes(ha(ia));
                h(ia) = camlight('headlight');
            end
        end
        
        % AmbietStrength+DiffuseStrength + SpecularStrength
        if ~isempty(hpatches)
            numPatches = size(hpatches,1);
            if ~isempty(s.Ambiet)% AmbietStrength
                for ii = 1:numPatches
                    hpatches(ii).AmbientStrength = s.Ambiet;
                end
            end
            
            if ~isempty(s.Diffuse)%DiffuseStrength
                for ii = 1:numPatches
                    hpatches(ii).DiffuseStrength = s.Diffuse;
                end
            end 
            
            if ~isempty(s.Speclar)%SpecularStrength
                for ii = 1:numPatches
                    hpatches(ii).SpecularStrength = s.Speclar;
                end
            end
            if s.FaceLight ~= 1
                % Apply selection
                if s.FaceLight == 1
                    for ii = 1:numPatches
                        hpatches(ii).FaceLighting = 'none';
                    end
                elseif s.FaceLight == 2
                    for ii = 1:numPatches
                        hpatches(ii).FaceLighting = 'flat';
                    end
                elseif s.FaceLight == 3
                    for ii = 1:numPatches
                        hpatches(ii).FaceLighting = 'gouraud';
                    end
                end
            end
        else
            msgbox('There are no light patches in the figure');
        end
       
    else
        if choice.Light==2
         delete(existingLight);
        end
    end
        
end
end




function  doCallback(obj, evd)
global LogicBtn
    if ~strcmp(get(obj,'UserData'),'Cancel')
      set(gcbf,'UserData','OK');
      uiresume(gcbf);
     LogicBtn=1;
    else
      delete(gcbf)
      LogicBtn=0;   
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
