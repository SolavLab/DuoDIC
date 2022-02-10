function install_DuoDIC

%% Add MultiDIC library path so functions are known to use here

mPath=fileparts(mfilename('fullpath')); %Get the current path
addpath(genpath(fullfile(mPath,'lib_DuoDIC'))); % add libraries
addpath(genpath(fullfile(mPath,'lib_ext'))); % add external library
addpath(genpath(fullfile(mPath,'main_scripts'))); % add external library

% install Ncorr
cd(fullfile(mPath,'lib_ext','ncorr_2D_matlab-master'));
handles_ncorr=ncorr;
cd(mPath);

% message
h=msgbox('DuoDIC installed successfully');
hp=get(h, 'position');
set(h, 'position', [hp(1) hp(2) 150 50]); %makes box bigger
ah = get( h, 'CurrentAxes' );
ch = get( ah, 'Children' );
set(ch, 'FontSize',10);

end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
