nFrames=31;
disp_stage=0:0.1:3;
for ii=1:length(DIC3DPPresults.Disp.DispMgn)
    disp_dic_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii};
    disp_dic_mean(ii)=nanmean(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_min(ii)=min(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_max(ii)=max(DIC3DPPresults.Disp.DispMgn{ii});
    disp_dic_error_all(:,ii)=DIC3DPPresults.Disp.DispMgn{ii}-disp_stage(ii);
end

figure; hold all
plot(0:nFrames-1,disp_stage,'+');
plot(0:nFrames-1,[disp_stage;disp_dic_mean;disp_dic_min;disp_dic_max]);
plot(0:nFrames-1,[disp_stage;disp_dic_mean;disp_dic_min;disp_dic_max]);
plot(0:nFrames-1,[disp_stage;disp_dic_mean;disp_dic_min;disp_dic_max]);
plot(0:nFrames-1,[disp_stage;disp_dic_mean;disp_dic_min;disp_dic_max]);

% plot([0 3],[0 3])

figure; hold all
plot(1:nFrames,disp_stage,'o');
boxplot(disp_dic_all)

figure; hold all
plot(0:nFrames-1,disp_dic_mean-disp_stage,'+');

figure; hold all
plot(disp_stage,disp_dic_mean-disp_stage,'+');

figure; hold all
boxplot(disp_dic_error_all,'OutlierSize',1);
ylim([min(min(disp_dic_error_all)) max(max(disp_dic_error_all))]);

