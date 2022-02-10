function []=createCheckerBoardImage(Nrows,Ncols,squareSize,resolution,savepath)
%% function for writing a checker board image to be printed for camera clibration in step0. 
% The function creates the image and saves it in the desired path.

% INPUT:
% * Nrows: number of rows (uneven)
% * Ncol: number of columns (even)
% * squareSize: size of each square (in meters)
% * resolution: image resolution (pixels per meter)
% * path: path where the image will be saves (including file name)

%%
squareSizePixel=squareSize*resolution;
CB = checkerboardBW(squareSizePixel,Nrows,Ncols);
figure; imshow(CB);
imwrite(CB,[savepath '\CB_' num2str(Nrows) 'x' num2str(Ncols) '_' num2str(squareSize*1000) 'mm.png'],'png','ResolutionUnit','meter','XResolution',resolution); %XResolution=pixels per meter

end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
