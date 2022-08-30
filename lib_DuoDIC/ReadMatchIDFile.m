
%% This fucntion plots the data extrcted from MatchID, The data needs to extracted in this way in order for the function to work
% Data extraction:
% Data extracted in csv, All veriables, Datafile name, Delimeter Comma,
% Scientific notation 5, Header Fromat [Category].[Long variable name].[units],Each time step im different file.
% Note: The data the is extracted 
clc;clear;
%%
folderPathInitial=pwd;
Datacell={};
% select the folder containing the data
folderPath=uigetdir(folderPathInitial,'Select the folder containing speckle images from the first camera');
files = dir([folderPath, '\*.csv']);
fullFileNames = fullfile(folderPath,{files.name});
numFile=length(files);
for it = 1:numel(files)
    Datacell{it} = readcell(fullFileNames{it}); 
    dataName{it}=detectImportOptions(fullFileNames{it});
end
%% Change databale to DIC3DPPresults

for it = 1:numel(files)

Xpoint=Extract_Data(Datacell{it},'coor.X [mm]');
Ypoint=Extract_Data(Datacell{it},'coor.Y [mm]');
Zpoint=Extract_Data(Datacell{it},'coor.Z [mm]');

XDis=Extract_Data(Datacell{it},'disp.Horizontal Displacement U [mm]');
YDis=Extract_Data(Datacell{it},'disp.Vertical Displacement V [mm]');
ZDis=Extract_Data(Datacell{it},'disp.Out-Of-Plane: W [mm]');
DisMag=Extract_Data(Datacell{it},'disp.Displacement Magnitude [mm]');

CorrComb=Extract_Data(Datacell{it},'CrossCamera.Correlation Value Persp [-]');
PPInds=Extract_Data(Datacell{it},'SameCamera.Correlation Value 2D [-]');


DIC3DPPresults.Points3D{it}=[Xpoint,Ypoint,Zpoint];
DIC3DPPresults.Disp.DispMgn{it}=DisMag;
DIC3DPPresults.Disp.DispVec{it}=[XDis,YDis,ZDis];
DIC3DPPresults.corrComb{it}=CorrComb;
DIC3DPPresults.PointPairInds=PPInds;

end

%%
optStruct=struct;
optStruct.zDirection=1;
optStruct.FaceAlpha=1;
optStruct.Smoothlambda1=[];
optStruct.Smoothlambda2=[];
optStruct.Smoothn=[];
optStruct.SmoothLogic=0;
optStruct.CorCoeffCutOff=[];
optStruct.CorCoeffLogic=0;
%%
plot_DuoDIC_MatchID(DIC3DPPresults,optStruct)

%%
function [wanted_data,range] = Extract_Data(data,name_extract)
wanted_data=zeros;
length=size(data,1);
[r,c]=find(contains(string(data),name_extract));
range=zeros(2,1);

ii=1;
for jj=1+r:length
    if ~ismissing(string(data(jj,c)))
        wanted_data(ii,1)=cell2mat(data(jj,c));
        ii=ii+1;
    else
        wanted_data(ii,1)=nan;
        ii=ii+1;
    end
end
end
