function [C_smooth]=patchSmoothFaceMeasureCon(varargin)

% function [C_smooth]=patchSmoothFaceMeasureCon(F,V,C,smoothPar)

%% Parse input
smoothPar=struct;
switch nargin
    case 3
        F=varargin{1};%Fnow with points are concted to complite a aface
        V=varargin{2};%Pnow the points of the faces
        C=varargin{3};%CFnow
        smoothPar=[];%
    case 4
        F=varargin{1};
        V=varargin{2};
        C=varargin{3};
        smoothPar=varargin{4};%lambda
end
%{ 
AYS 12/7
smoothParDefault.lambda1=0.5;
smoothParDefault.lambda2=0.5;
smoothParDefault.n=1;
smoothPar=structComplete(smoothPar,smoothParDefault,1);%AYS
%}
%% Get connectivity array


[connectivityStruct]=patchConnectivity(F,V);
faceFaceConnectivity=connectivityStruct.face.face;% Rows of 3 face that are in contact, row 1 has in contact with 2 3 4 in 2  find 1 3 5
nDims=size(C,2); %Number of dimensions
logicValid=faceFaceConnectivity>0;
C_smooth=C;
C_smooth_step=C;

%% Outer Condictivty Problem edges are weird color
X=NaN(size(C,1),6);
for i=1:size(faceFaceConnectivity,1)
    k=1;
    for j=1:size(faceFaceConnectivity,2)
        f=faceFaceConnectivity(i,j);
        if f~= 0
             for l=1:3
                 if faceFaceConnectivity(f,l)~=i && faceFaceConnectivity(f,l)~=0
                    X(i,k)=C(faceFaceConnectivity(f,l));
                    k=k+1;
                 end
             end
        end
    end
end


%% Continue
%% Problem: you cant add both lambda it gets  smaller then 1
for qIter=1:smoothPar.n 
    %Loop for all dimensions
    %Takeing the next face
    for qDim=1:1:nDims
        Xp1=NaN(size(C,1),size(faceFaceConnectivity,2));
        Xp1(logicValid)=C_smooth(faceFaceConnectivity(logicValid),qDim);%Colors of all 3 face 
        Xp1=nanmean(Xp1,2);%Average to row   
        C_smooth_step(:,qDim)=Xp1; 
    end
    Xp2=nanmean(X,2);
    %taking them into acount
    C_smooth=(1-(smoothPar.lambda1+smoothPar.lambda2)).*C_smooth+smoothPar.lambda1.*C_smooth_step+smoothPar.lambda2.*Xp2;
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
