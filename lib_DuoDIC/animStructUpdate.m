function animStructUp=animStructUpdate(varargin)
%% animStruct Update
% animStructUpdate
% animStructUpdate(hf,animStruct,optStruct,DIC3DPPresults,Pre)
% for each update first  we need to find what kind of plot is updated then
% we will be able to update
% This function updates animStruct by using the global variables of smooth
% and correlation coefficient
% correlation coefficient
% 
%%
hf=varargin{1};
animStruct=varargin{2};
optStruct=varargin{3};
DIC3DPPresults=varargin{4};
Pre=varargin{5};
%%
if isfield(hf.UserData,'optStruct')
    optStruct=hf.UserData.optStruct;
end
%Inputing the change parameters 
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

%%
structLogic=isstruct(Pre);%to define if driction 
nFrames=size(animStruct.Time,2);
KindPlot=size(Pre);
%% Inputing Original Faces and Points
if KindPlot(2)==1 %Checking if plot is a Face plot
	if structLogic %Checking if there is Diriction in plot 
        FC=Pre.FC;
        D=Pre.D;
        Vc=Pre.Vc;
        nStrains=size(FC,2);
        for is=1:nStrains
            for it=1:nFrames
                Pnow{it,is}=animStruct.Set{it}{2+8*(is-1)};
            end
        end
        CFnow=FC;
        Vnow=Vc;
        else% There is No Diriction in plot
            FC=Pre;
            for it=1:1:nFrames            
                Pnow{it}=animStruct.Set{it}{2};
            end
        CFnow=FC;
	end
	else %Point plot
        PC=Pre;
        Pnow=PC;
end    

%% Updating Correlation Coefficient 
if CorCoeffLogic %Check if there need for Correlation Coefficient update
  if KindPlot(2)==1 %Checking if plot is a Face plot
        if structLogic %Checking if there is Diriction in plot 
             for is=1:nStrains
                for it=1:nFrames
                    corrNow=DIC3DPPresults.FaceCorrComb{it};
                    FC{it,is}(corrNow>CorCoeffCutOff,:)=NaN;
                    D{it,is}(corrNow>CorCoeffCutOff,:)=NaN;
                    Vc{it,is}(corrNow>CorCoeffCutOff,:)=NaN;
                    Pnow{it,is}=animStruct.Set{it}{2+8*(is-1)};                   
                end
             end
            CFnow=FC;
            Vnow=Vc;
        else%There is No Diriction in plot
            for it=1:1:nFrames
                corrNow=DIC3DPPresults.FaceCorrComb{it};
                FC{it}(corrNow>CorCoeffCutOff,:)=NaN; 
            end
            CFnow=FC;
        end
	else %Point plot
       for it=1:nFrames
            Pnow{it}=PC{it};
            corrNow=DIC3DPPresults.corrComb{it};
            Pnow{it}(corrNow>CorCoeffCutOff,:)=NaN;
        end 
	end    
end

%% Update Smooth
% Checking what kind of smooth is wanted first or secons level
if KindPlot(2)==1 %Checking if plot is a Face plot
switch SmoothLogic
    case 1 % First level
        if structLogic % Checking if there is Diriction in plot 
            % Resmoothing
                for it=1:1:nFrames
                    for is=1:nStrains
                        [CFnow{it,is}]=patchSmoothFaceMeasure(Fnow,Pnow{it,is},CFnow{it,is},smoothPar);
                        CFnow{it,is}(CFnow{it,is}<optStruct.dataLimits(1))=NaN;
                        CFnow{it,is}(CFnow{it,is}>optStruct.dataLimits(2))=NaN;
                    end
                end
        else% There is No Diriction in plot
            for it=1:1:nFrames
                [CFnow{it}]=patchSmoothFaceMeasure(Fnow,Pnow{it},CFnow{it},smoothPar);
                CFnow{it}(CFnow{it}<optStruct.dataLimits(1))=NaN;
                CFnow{it}(CFnow{it}>optStruct.dataLimits(2))=NaN;
            end    
        end
    case 2    
        if structLogic % Checking if there is Diriction in plot 
            for it=1:1:nFrames
                for is=1:nStrains
                    [CFnow{it,is}]=patchSmoothFaceMeasureCon(Fnow,Pnow{it,is},CFnow{it,is},smoothPar);
                    CFnow{it,is}(CFnow{it,is}<optStruct.dataLimits(1))=NaN;
                    CFnow{it,is}(CFnow{it,is}>optStruct.dataLimits(2))=NaN;
                end
            end
        else% There is No Diriction in plot
            for it=1:1:nFrames
                [CFnow{it}]=patchSmoothFaceMeasureCon(Fnow,Pnow{it},CFnow{it},smoothPar);
                CFnow{it}(CFnow{it}<optStruct.dataLimits(1))=NaN;
                CFnow{it}(CFnow{it}>optStruct.dataLimits(2))=NaN;
            end    
        end
end
end
%% AFter Change Faces and Points By need Input into animStruct
if KindPlot(2)==1 %If face measure 
        if structLogic %Face plot with Diriction 
            nStrains=size(FC,2);
             for is=1:nStrains
                for it=1:nFrames
                        animStruct.Set{it}{1+8*(is-1)}=CFnow{it,is};
                        animStruct.Set{it}{2+8*(is-1)}=Pnow{it,is}; %Property values for to set in order to animate
                        animStruct.Set{it}{3+8*(is-1)}=Vnow{it,is}(:,1); %Property values for to set in order to animate
                        animStruct.Set{it}{4+8*(is-1)}=Vnow{it,is}(:,2); %Property values for to set in order to animate
                        animStruct.Set{it}{5+8*(is-1)}=Vnow{it,is}(:,3); %Property values for to set in order to animate;   
                end
             end
        else% %Face plot with No Diriction
            for it=1:1:nFrames
                animStruct.Set{it}{1}=CFnow{it};
                animStruct.Set{it}{2}=Pnow{it};
            end
        end
	else %Point plot
        for it=1:nFrames
            animStruct.Set{it}{1}=Pnow{it}(:,1);
            animStruct.Set{it}{2}=Pnow{it}(:,2);
            animStruct.Set{it}{3}=Pnow{it}(:,3);
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
