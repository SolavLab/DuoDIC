function CPoint = getPointValue(F,P,CF)
%% Output the value of each point in face plot
% Getting the averge of the faces around point to determine the value of point
%%
    for ii=1:size(P,1)
        [row,col]=find(F==ii);
        FaceValue=CF(row);
        CPoint(ii,1)=mean(FaceValue);
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