function [cMap]=coldwarm(varargin)
% function [cMap]=coldwarm
% function [cMap]=coldwarm(n)
% ------------------------------------------------------------------------
% Creates the colormap data for n levels for the cold and warm colormap. Low
% values define a cold blue color while high values define a warm/hot
% color. The 0 value is white. Therefore this map is suitable for data centered around 0
%------------------------------------------------------------------------

switch nargin
    case 0
        n=250;
    case 1
        n=varargin{1};
end

cFire=flipud([0.526,0.0720,0.00200;0.620,0.100,0.00300;...
       0.693,0.131,0.0110;0.770,0.172,0.0190;0.837,0.217,0.0320;0.894,0.261,0.0430;...
       0.954,0.315,0.0520;0.993,0.379,0.0630;0.998,0.484,0.0780;1,0.574,0.110;...
       1,0.644,0.152;1,0.711,0.211;1,0.773,0.274;1,0.837,0.322;1,0.914,0.369;...
       1,0.953,0.443;1,0.982,0.539;0.999,1,0.646;0.985,1,0.772;1,1,1]);
cMap=[rot90(cFire,2); cFire(2:end,:)];

[cMap]=resampleColormap(cMap,n);
 

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
