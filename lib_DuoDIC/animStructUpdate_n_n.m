function animStructUp=animStructUpdate_n_n(varargin)
%% animStruct Update 
% animStructUpdate_n_n
% animStructUpdate_n_n(hf,animStruct,DIC3DPPresults,Pre)

% This function updates animStruct by using the global variables of smooth
% correlation coefficient
% 
%%
hf=varargin{1};
animStruct=varargin{2};
DIC3DPPresults=varargin{3};
Pre=varargin{4};


optStruct=hf.UserData.optStruct;
CorCoeffCutOff=optStruct.CorCoeffCutOff;
CorCoeffLogic=optStruct.CorCoeffLogic;
smoothPar.lambda1=optStruct.Smoothlambda1;
smoothPar.lambda2=optStruct.Smoothlambda2;
smoothPar.n=optStruct.Smoothn;
SmoothLogic=optStruct.SmoothLogic;


hpatches = findobj(hf,'type','patch');

if ~isempty(hpatches)
    numPatches = size(hpatches,1);
    for ii = 1:numPatches
        Fnow = hpatches(ii).Faces;
    end
end

nFrames=size(animStruct.Time,2);
%% Inputing Original Faces and Points
switch optStruct.type
    case {'J','Lamda1','Lamda2','Emgn','emgn','Eeq','eeq','EShearMax','eShearMax','Epc1','Epc2','epc1','epc2'}% Face plots  
        FC=Pre.FC;
        Points=Pre.Points;
        dataLimits=[min(min(cell2mat(FC))) max(max(cell2mat(FC)))];
        for ii=1:nFrames
            FC{ii}(FC{ii}<dataLimits(1) | FC{ii}>dataLimits(2))=NaN;   
            Pnow1{ii}=Points{ii};
            Pnow2{ii}=Points{ii+nFrames};
            cNow1{ii}=FC{ii};
            cNow2{ii}=FC{ii};
        end
    case{'DispMgn','DispX','DispY','DispZ'}% Point plots       
        PC=Pre.PC;
        Points=Pre.Points;
        for ii=1:nFrames
            xNow1{ii}=Points{ii}(:,1);
            yNow1{ii}=Points{ii}(:,2);
            xNow2{ii}=Points{ii+nFrames}(:,1);
            yNow2{ii}=Points{ii+nFrames}(:,2);
            cNow1{ii}=PC{ii};
            cNow2{ii}=PC{ii};  
        end
end

%% Updating Correlation Coefficient 
if CorCoeffLogic
    switch optStruct.type
      case {'J','Lamda1','Lamda2','Emgn','emgn','Eeq','eeq','EShearMax','eShearMax','Epc1','Epc2','epc1','epc2'}% Face plots    
        for it=1:1:nFrames   
            corrNow=DIC3DPPresults.FaceCorrComb{it};
            cNow1{it}(corrNow>CorCoeffCutOff,:)=NaN;
            cNow2{it}(corrNow>CorCoeffCutOff,:)=NaN;
        end 
    case{'DispMgn','DispX','DispY','DispZ'}% Point plots    
        for it=1:nFrames
            currentPointLogic=DIC3DPPresults.PointPairInds==1;
            CorCoeffVec{it}=DIC3DPPresults.corrComb{it}(currentPointLogic,:);
            CorCoeffVec{it}(CorCoeffVec{it}>CorCoeffCutOff)=NaN;   
            xNow1{it}=Points{it}(~isnan(CorCoeffVec{it}),1);
            yNow1{it}=Points{it}(~isnan(CorCoeffVec{it}),2);
            xNow2{it}=Points{it+nFrames}(~isnan(CorCoeffVec{it}),1);
            yNow2{it}=Points{it+nFrames}(~isnan(CorCoeffVec{it}),2);
            cNow1{it}=PC{it}(~isnan(CorCoeffVec{it}));
            cNow2{it}=PC{it}(~isnan(CorCoeffVec{it}));
        end         
    end
end
%% Update Smooth
switch SmoothLogic
    case 1
        switch optStruct.type
            case {'J','Lamda1','Lamda2','Emgn','emgn','Eeq','eeq','EShearMax','eShearMax','Epc1','Epc2','epc1','epc2'}% Face plots 
                for it=1:1:nFrames
                    [cNow1{it}]=patchSmoothFaceMeasure(Fnow,Pnow1{it},cNow1{it},smoothPar);
                    [cNow2{it}]=patchSmoothFaceMeasure(Fnow,Pnow1{it},cNow2{it},smoothPar);                 
                end   
        end
    case 2
        switch optStruct.type
            case {'J','Lamda1','Lamda2','Emgn','emgn','Eeq','eeq','EShearMax','eShearMax','Epc1','Epc2','epc1','epc2'}% Face plots 
                for it=1:1:nFrames
                    [cNow1{it}]=patchSmoothFaceMeasureCon(Fnow,Pnow1{it},cNow1{it},smoothPar);
                    [cNow2{it}]=patchSmoothFaceMeasureCon(Fnow,Pnow1{it},cNow2{it},smoothPar);  
                end    
        end
end 

%% AFter Change Faces and Points By need Input into animStruct
switch optStruct.type
  case {'J','Lamda1','Lamda2','Emgn','emgn','Eeq','eeq','EShearMax','eShearMax','Epc1','Epc2','epc1','epc2'}% Face plots 
            for it=1:1:nFrames
                animStruct.Set{it}{3}=Pnow1{it};
                animStruct.Set{it}{4}=cNow1{it};
                animStruct.Set{it}{5}=Pnow2{it};
                animStruct.Set{it}{6}=cNow2{it};                        
            end    
    case{'DispMgn','DispX','DispY','DispZ'} % Point plots 
            for it=1:1:nFrames
                animStruct.Set{it}{3}=xNow1{it};
                animStruct.Set{it}{4}=yNow1{it};
                animStruct.Set{it}{5}=cNow1{it};
                animStruct.Set{it}{6}=xNow2{it};
                animStruct.Set{it}{7}=yNow2{it};
                animStruct.Set{it}{8}=cNow2{it}; 
            end    
end

%% Output
animStructUp=animStruct;
end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information

