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

%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
