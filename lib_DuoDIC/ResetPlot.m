function []=ResetPlot (varargin)
%% Reset Image of Pot
% ResetImage
% ResetPlot(hf)
% Resetting the plot by moving slider
%%
hf=varargin{1};
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


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
