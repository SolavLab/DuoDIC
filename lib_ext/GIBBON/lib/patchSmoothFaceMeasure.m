function [C_smooth]=patchSmoothFaceMeasure(varargin)

% function [C_smooth]=patchSmoothFaceMeasure(F,V,C,smoothPar)

%% Parse input
smoothPar=struct;%AYS
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
        smoothPar=varargin{4};%AYS.lambda
end

% smoothParDefault.lambda=0.5;
% smoothParDefault.n=1;
% smoothPar=structComplete(smoothPar,smoothParDefault,1);%AYS

%% Get connectivity array

[connectivityStruct]=patchConnectivity(F,V);
faceFaceConnectivity=connectivityStruct.face.face;% Rows of 3 face that are in contact, row 1 has in contact with 2 3 4 in 2  find 1 3 5
nDims=size(C,2); %Number of dimensions
logicValid=faceFaceConnectivity>0;
C_smooth=C;
C_smooth_step=C;


%{
%% Outer Condictivty Problem edges are weird color
X=zeros(size(C,1),6);
for i=1:size(faceFaceConnectivity,1)
    k=1;
    for j=1:size(faceFaceConnectivity,2)
        f=faceFaceConnectivity(i,j);
        if f~= 0
             for l=1:3
                 if faceFaceConnectivity(f,l)~=i && faceFaceConnectivity(f,l)~=0
                    X(i,k)=X(i,k)+C(faceFaceConnectivity(f,l));
                    k=k+1;
                 end
             end
        end
    end
end


X;%After we add what is needed to make sure X is new
%}
%% Continue
for qIter=1:smoothPar.n 
    %Loop for all dimensions
    %Takeing the next face
    for qDim=1:1:nDims
        Xp=NaN(size(C,1),size(faceFaceConnectivity,2));
        Xp(logicValid)=C_smooth(faceFaceConnectivity(logicValid),qDim);%Colors of all 3 face 
        %Xp=[Xp,X];%AYS
        Xp=nanmean(Xp,2);%Average to row      
        C_smooth_step(:,qDim)=Xp;
   
    end
    %taking them into acount
    C_smooth=((1-smoothPar.lambda1).*C_smooth)+(smoothPar.lambda1.*C_smooth_step);
end
