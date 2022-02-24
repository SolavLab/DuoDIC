clearvars; %close all

[Step4File,Step4FilePath]=uigetfile(cd,'Select the RBM results file');
load([Step4FilePath Step4File]);
[stageFile,stageFilePath]=uigetfile(cd,'Select the stage translations file');
load([stageFilePath stageFile]);

% disp_stage=0:0.2:2.8;
% save('disp_stage.mat','disp_stage')
%% Extract displacement results
nFrames=length(DIC3DPPresults.Points3D);

for ii=1:length(DIC3DPPresults.Disp.DispMgn)
    disp_dic_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii};
    disp_dic_mean(ii)=nanmean(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_min(ii)=min(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_max(ii)=max(DIC3DPPresults.Disp.DispMgn{ii});
    disp_error_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii}-disp_stage(ii);
end
disp_error_mean=nanmean(abs(disp_error_all(:)));
disp_error_std=nanstd(abs(disp_error_all(:)));

%% plot translations
figure; hold all
plot(0:nFrames-1,disp_stage,'-b','LineWidth',2);
plot(0:nFrames-1,disp_dic_mean,'r','LineWidth',2);
fill([0:nFrames-1 fliplr(0:nFrames-1)], [disp_dic_min, fliplr(disp_dic_max)], 'r','FaceAlpha',0.5);
xlabel('Frame index'); ylabel ('Trnaslation [mm]');
legend({'tranlation stage', '3D-DIC mean', '3D-DIC range'},'Location','NorthWest');

%% plot translations
figure; hold all
plot(1:nFrames,disp_stage,'+b');
boxplot(disp_dic_all,'OutlierSize',1);
xlabel('Frame index'); ylabel ('Trnaslation [mm]');

%% plot translation errors
figure; hold all
plot(0:nFrames+1,zeros(1,nFrames+2),'-','color', [.5 .5 .5])
boxplot(disp_error_all,'OutlierSize',1);
axisLim=max(max(abs(disp_error_all)))
ylim([-axisLim axisLim]);
xlabel('Frame index'); ylabel ('Trnaslation error [mm]');

%% Strain results
%% plot animation
anim8_DIC3DPP_faceMeasure(DIC3DPPresults,'Eeq',1)
% anim8_DIC3DPP_faceMeasure_onImages_n_n(DIC3DPPresults,1,'Eeq');

%% quantify and plot Eeq
Eeq_all=DIC3DPPresults.Deform.Eeq;
for ii=1:nFrames
    Eeq_all_mat(:,ii)=Eeq_all{ii};
end
Eeq_mean=nanmean(Eeq_all_mat(:));
Eeq_std=nanstd(Eeq_all_mat(:));

% plot
figure; hold all
plot(0:nFrames+1,zeros(1,nFrames+2),'-','color', [.5 .5 .5])
boxplot(Eeq_all_mat,'OutlierSize',1);
axisLim=max(max(abs(Eeq_all_mat)));
ylim([0 axisLim]);
xlabel('Frame index'); ylabel ('Equivalent Strain [ ]');
