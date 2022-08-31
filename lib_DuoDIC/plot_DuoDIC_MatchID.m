
function []=plot_DuoDIC_MatchID(varargin)
%% function for plotting 3D-DIC results in STEP4.
% Plotting the 3D reconstruction of points correlated with Ncorr
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
Prompt={'\bf{Select which parameters to plot}';... 

    'Points with color as dispX (X Displacement)';...  %(2 1) 2
    
    'Points with color as Exx (Strain-global X)';...  %(2 2) 3

    'Points with color as dispY (Y Displacement)';... %(3 1) 4
    
	'Points with color as Eyy (Strain-global Y)';... %(3 2) 5

    'Points with color as dispZ (Z Displacement)';...  %(4 1) 6
    
	'Points with color as Exy (Strain-global XY)';... %(4,2) 7
    
    'Points with color as correlation coefficient';...  %(5,1) 8
    
    'Points with color as Gamma (Shear Angle) ';...  %(5,2) 9
    
	'Points with color as dispMgn (Displacement magnitude)';... %(6,1) 10
    
    'Points with color as EI (Maximum Principal Strain)';...  %(6,2) 11
    
    'Points with color as EII (Minimum Principal Strain)';...  %(7,2) 12
    
    'Select All'; %13
    
    'Points with color as Von Mises Equivalent Strain ';...  %(8,2) 14    
    
     }; 

Title='Select which parameters to plot';

Formats=struct;

Formats(1,1).type='text';
Formats(1,2).type='none';
Formats(2,1).type='check';
Formats(2,2).type='check';
Formats(3,1).type='check'; 
Formats(3,2).type='check'; 
Formats(4,1).type='check'; 
Formats(4,2).type='check'; 
Formats(5,1).type='check'; 
Formats(5,2).type='check';
Formats(6,1).type='none'; 
Formats(6,2).type='check'; 
Formats(7,1).type='none';
Formats(7,2).type='check';
Formats(8,1).type='none';
Formats(8,2).type='check';
Formats(9,1).type='check';
Formats(9,2).type='check';

 
DefAns=cell(numel(Prompt),1);
DefAns{1}=[];
for ii=2:numel(Prompt)
    DefAns{ii}=false;
end

Options.Resize='on';
Options.FontSize=10;
% Options.ApplyButton='on';

[Answer,Canceled] = inputsdlg(Prompt, Title, Formats, DefAns, Options);
if Answer{13}
    for ii=[2:36 38]
        Answer{ii}=true;
    end
end

%% plot according to answer

if Canceled
    return
end

if Answer{2}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispX',optStruct);
end

if Answer{3}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Exx',optStruct);
end

if Answer{4}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispY',optStruct);
end

if Answer{5}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Eyy',optStruct);
end

if Answer{6}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispZ',optStruct);
end

if Answer{7}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Exy',optStruct);
end

if Answer{8}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'corrComb',optStruct);
end

if Answer{9}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'Gamma',optStruct);
end

if Answer{10}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'DispMgn',optStruct);
end

if Answer{11}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'EI',optStruct);
end

if Answer{12}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'EII',optStruct);
end

if Answer{14}
    anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,'VonMises',optStruct);
end


end

%anim8_DIC3DPP_pointMeasureMatchID(DIC3DPPresults,pointMeasureString,varargin)

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information