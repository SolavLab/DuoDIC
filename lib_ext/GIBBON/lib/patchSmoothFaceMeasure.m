function [C_smooth]=patchSmoothFaceMeasure(varargin)

% function [C_smooth]=patchSmoothFaceMeasure(F,V,C,smoothPar)

%% Parse input
smoothPar=struct;%AYS
switch nargin
    case 3
        F=varargin{1};%Fnow with points are connect to complete a face
        V=varargin{2};%Pnow the points of the faces
        C=varargin{3};%CFnow
        smoothPar=[];%
    case 4
        F=varargin{1};
        V=varargin{2};
        C=varargin{3};
        smoothPar=varargin{4};%AYS.lambda
end

%% Get connectivity array

[connectivityStruct]=patchConnectivity(F,V);
faceFaceConnectivity=connectivityStruct.face.face;% Each rows repersents a face. In the columns are the face number (row) that are in contact with the face
nDims=size(C,2); %Number of dimensions
logicValid=faceFaceConnectivity>0;
C_smooth=C;
C_smooth_step=C;


%% Continue
for qIter=1:smoothPar.n 
    %Loop for all dimensions
    %Takeing the next face
    for qDim=1:1:nDims
        Xp=NaN(size(C,1),size(faceFaceConnectivity,2));
        Xp(logicValid)=C_smooth(faceFaceConnectivity(logicValid),qDim);% Takeing the value (color) of each face that are in contant 
        Xp=nanmean(Xp,2);%Average of the faces in contact       
        C_smooth_step(:,qDim)=Xp;
    end
    %taking them into acount the percentage that is wanted 
    C_smooth=((1-smoothPar.lambda1).*C_smooth)+(smoothPar.lambda1.*C_smooth_step);
end
