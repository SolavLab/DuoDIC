clearvars; close all

[Step4File,Step4FilePath]=uigetfile(cd,'Select the RBM results file');
load([Step4FilePath Step4File]);

nFrames=length(DIC3DPPresults.Points3D);
disp_stage=0:0.2:2.8;
for ii=1:length(DIC3DPPresults.Disp.DispMgn)
    disp_dic_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii};
    disp_dic_mean(ii)=nanmean(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_min(ii)=min(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_max(ii)=max(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_error_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii}-disp_stage(ii);
    disp_dic_rel_error_all(:,ii)=100*disp_dic_error_all(:,ii)./disp_stage(ii);
end

%% plot translations
figure; hold all
plot(0:nFrames-1,disp_stage,'-b','LineWidth',2);
plot(0:nFrames-1,disp_dic_mean,'r','LineWidth',2);
fill([0:nFrames-1 fliplr(0:nFrames-1)], [disp_dic_min, fliplr(disp_dic_max)], 'r','FaceAlpha',0.5);
xlabel('Frame index'); ylabel ('Trnaslation [mm]');
legend({'tranlation stage', '3D-DIC mean', '3D-DIC range'},'Location','NorthWest');

%% plot translation errors
figure; hold all
boxplot(disp_dic_error_all,'OutlierSize',1);
ylim([min(min(disp_dic_error_all)) max(max(disp_dic_error_all))]);
xlabel('Frame index'); ylabel ('Trnaslation error [mm]');

%% plot translation relative errors
figure; hold all
boxplot(disp_dic_rel_error_all,'OutlierSize',1);
ylim([min(min(disp_dic_rel_error_all)) max(max(disp_dic_rel_error_all))]);
xlabel('Frame index'); ylabel ('Trnaslation relative error [%]');



