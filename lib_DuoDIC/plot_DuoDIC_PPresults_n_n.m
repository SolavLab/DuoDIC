function []=plot_DuoDIC_PPresults_n_n(varargin)
%% function for plotting Surface plot results in STEP4.
% Plotting result on uploaded images 
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
Prompt={'\bf{Select which parameters to plot}';... % Instruction
    
    'Surfaces with color as J (surface area change)';... % 1 
    'Surfaces with color as Lambda1 (1st principal stretch)';... % 2 
    'Surfaces with color as Lambda2 (2nd principal stretch)';... % 3 
    'Surfaces with color as Epc1 (1st principal Lagrangian strain)';... % 4 
    'Surfaces with color as Epc2 (2nd principal Lagrangian strain)';... % 5 
    'Surfaces with color as epc1 (1st principal Almansi strain)';... % 6 
    'Surfaces with color as epc2 (2nd principal Almansi strain)';... % 7 
    'Surfaces with color as Emgn (Lagrangian strain tensor magnitude)';... % 8 
    'Surfaces with color as emgn (Almansi strain tensor magnitude)';... % 9     
    'Surfaces with color as Lagrangian equivalent strain';...      %10
    'Points with color as dispMgn (Displacement magnitude)';...% 11
    'Surfaces with color as Eulerian equivalent strain';...  %12
    'Points with color as dispX (X Displacement)';...% 13
    'Surfaces with color as Max Lagrangian shear strain';...%14
    'Points with color as dispY (Y Displacement)';...% 15
    'Surfaces with color as Max Eulerian shear strain';...  %16
    'Points with color as dispZ (Z Displacement)';...% 17
    'Select All'; }; % Select All

Title='Select which parameters to plot';

Formats=struct;
Formats(1,1).type='text'; %Instruction
Formats(1,2).type='none'; 

Formats(2,1).type='check'; %1
Formats(2,2).type='check'; %2 
Formats(3,1).type='check'; %3
Formats(3,2).type='check'; %4
Formats(4,1).type='check'; %5
Formats(4,2).type='check'; %6
Formats(5,1).type='check'; %7
Formats(5,2).type='check'; %8
Formats(6,1).type='check'; %9
Formats(6,2).type='none';% 
Formats(7,1).type='check'; %10
Formats(7,2).type='check'; %11
Formats(8,1).type='check'; %12
Formats(8,2).type='check'; %13
Formats(9,1).type='check'; %14
Formats(9,2).type='check'; %15
Formats(10,1).type='check'; %16
Formats(10,2).type='check'; %17
Formats(12,2).type='check'; % Select All
 

DefAns=cell(numel(Prompt),1);
DefAns{1}=[];
for ii=2:numel(Prompt)
    DefAns{ii}=false;
end

Options.Resize='on';
Options.FontSize=10;
% Options.ApplyButton='on';

[Answer,Canceled] = inputsdlg(Prompt, Title, Formats, DefAns, Options);
if Answer{19}
    for ii=2:14 
        Answer{ii}=true;
    end
end

if Canceled
    return
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

%% plot according to answer

if Canceled
    return
end

if Answer{2}%1
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'J',optStruct);

end
if Answer{3}%2
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Lamda1',optStruct);

end
if Answer{4}%3
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Lamda2',optStruct);

end
if Answer{5}%4
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Epc1',optStruct);

end
if Answer{6}%5
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Epc2',optStruct);

end
if Answer{7}%6
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'epc1',optStruct);

end
if Answer{8}%7
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'epc2',optStruct);

end
if Answer{9}%8
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Emgn',optStruct);

end
if Answer{10}%9
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'emgn',optStruct);

end
if Answer{11}%10
     anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Eeq',optStruct);

end
if Answer{12}%11
     anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispMgn',optStruct);

end
if Answer{13}%12
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'eeq',optStruct);

end
if Answer{14}%13
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispX',optStruct);

end

if Answer{15}%14
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'EShearMax',optStruct);

end
if Answer{16}%15
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispY',optStruct);

end
if Answer{17}%16
    anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'eShearMax',optStruct);

end
if Answer{18}%17
    anim8_DIC3DPP_pointMeasure_onImages_n_n(DIC3DPPresults,1,'DispZ',optStruct);

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
