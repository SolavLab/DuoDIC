function []=addDataTip(varargin)
%% Viewing figures: changing quiver factor
% addValuePointer
% addValuePointer(hf,animStruct)

% This script creates a new pushtool in a figure's toolbar to manipulate
% Gives datatip by pressing on the figure, Outputs X,Y,Z and
% Value. By pressing again on icon the datatip will disappear. To get
% multiple data tips, hold the Shift key while clicking the data points.
%%
switch nargin
    case 0
        hf=gcf;
    case 2
        hf=varargin{1};
        animStruct=varargin{2};
end

% Get icon
filePath=mfilename('fullpath');
toolboxPath=fileparts(fileparts(filePath));
iconPath=fullfile(toolboxPath,'lib_ext','GIBBON','icons');
hb = findall(hf,'Type','uitoolbar');

D=importdata(fullfile(iconPath,'datatip.png'));
S=double(D);
S=S-min(S(:));
S=S./max(S(:));
S(S==1)=NaN;
if size(S,3)==1
    S=repmat(S,[1 1 3]);
end

% Create a uipushtool in the toolbar
uitoggletool(hb(1),'TooltipString','DataTip','CData',S,'Tag','addDataTip_button','ClickedCallback',{@ValuePoint,{hf,animStruct}});

end

%% Control of DatatTip
function ValuePoint(~,~,inputCell)
hf = inputCell{1};
animStruct=inputCell{2};
dcm = datacursormode( hf );

switch  dcm.Enable 
    case 'off' %Turning the datatip on
        dcm.Enable = 'on';
        dcm.SnapToDataVertex='on';
        set(dcm,'UpdateFcn',{@updateDataCursor,{hf,animStruct}});
    case 'on' %Turning the datatip on and deleting the data that is on figure
        dcm.removeAllDataCursors()
        dcm.UpdateFcn = [];          
        dcm.Enable = 'off';
end
end
%% Display value  of Datatips
% Callback that producing the datatip 
function displayText = updateDataCursor(~,event_obj,inputCell)
	hf=inputCell{1};
	animStruct = inputCell{2}; 
	sliderValue=get(hf.UserData.anim8.sliderHandles{1},'Value');
    pos = get(event_obj,'Position');
    KindPlot=class(animStruct.Handles{1});%Finds the kind of plot (FaceMaesue,FaceMaesueDirerction,PointMeasure) based on the Handlers class
    
    switch KindPlot
        case 'matlab.graphics.primitive.Patch' %FaceMaesue       	
        	indx=find(animStruct.Set{sliderValue}{2}==pos);
            value=animStruct.Set{sliderValue}{3}(indx(1));
            displayText = {['[X,Y,Z]: [',num2str(pos(1),2), ' ',  num2str(pos(2),2),' ', num2str(pos(3),2),']'], ['Value: ',num2str(value)]};
        case 'matlab.graphics.primitive.Data' %FaceMaesueDirerction
            nStrains=numel(hf.UserData.optStruct.supTitleString);
            for jj=1:nStrains %Finding the subplot that was pressed on by order of titles inputed                              
                if (hf.UserData.optStruct.supTitleString{jj} ==event_obj.Target.Parent.Title.String)
                    is=jj;
                end
            end
        	indx=find(animStruct.Set{sliderValue}{2+8*(is-1)}==pos);
            value= animStruct.Set{sliderValue}{8*(nStrains)+is}(indx(1));
            displayText = {['[X,Y,Z]: [',num2str(pos(1),2), ' ',  num2str(pos(2),2),' ', num2str(pos(3),2),']'], ['Value: ',num2str(value)]};  
        case 'matlab.graphics.chart.primitive.Scatter' %PointMeasure
            Pnow=[animStruct.Set{sliderValue}{1},animStruct.Set{sliderValue}{2},animStruct.Set{sliderValue}{3}];
            indx=find(Pnow==pos);
            value= animStruct.Set{sliderValue}{4}(indx(1));
            displayText = {['[X,Y,Z]: [',num2str(pos(1),2), ' ',  num2str(pos(2),2),' ', num2str(pos(3),2),']'], ['Value: ',num2str(value)]}; 
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