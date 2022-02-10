function [FisoInd]=faceIsotropyIndex(F,V)
%% function for computing  triangular faces isotropy index. 
% This is an index of the  "regularity" of the triangle. Equilateral triangle (perfectly regular) 
%
% INPUTS:
% * F: nFaces-by-3 array representing the list of vertices for triangular faces
% * V: nVertices-by-3 array representing the 3d positions of the vertices of F in the reference positions
%
% OUTPUTS: 
% * FisoInd: isotropy index for each face. value of 1 means perfectly
% equilateral. value of 0 means vertices are aligned (on a line)
%
%From the paper: Surface-Marker Cluster Design Criteria for 3-D Bone Movement Reconstruction (1997)
% Aurelio Cappozzo, Angelo Cappello, Ugo Della Croce, and Francesco Pensalfini
%%

FisoInd=zeros(size(F,1),1);
for iface=1:size(F,1)
    
    x1=V(F(iface,1),:)';
    x2=V(F(iface,2),:)';
    x3=V(F(iface,3),:)';
    
    if any(any(isnan([x1 x2 x3]))) % if any nan, iso index=nan
        FisoInd(iface)=NaN;
    else
        xa=(x1+x2+x3)/3;
        X=[x1-xa,x2-xa,x3-xa]; %cluster position model
        K=X*X'/3;
        Keig=real(eig(K)); %eigenvalues of X
        FisoInd(iface)=2*Keig(2)/(Keig(2)+Keig(3)); % isotropy index
    end
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
