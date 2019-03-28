clear;

% load data and model predictions for Experiment 3

load modelfit_data_Confidence_Exp3 % data of confidence
load confpre_Exp3 % predicted confidence rating in the winning model


%% Predicted confidence
confpredict=confpre;

%% Draw bar graph for confidence (difficulty is included as a variable)

% mean confidence in different conditions
for subj=1:nsubj
    confdata_difficulty_subj(subj,1)=mean(conf(sub==subj & ask==1 & condition<2 & confcondition==0));
    confdata_difficulty_subj(subj,2)=mean(conf(sub==subj & ask==1 & condition>=2 & confcondition==0));
    confdata_difficulty_subj(subj,3)=mean(conf(sub==subj & ask==0 & condition<2 & confcondition==0));
    confdata_difficulty_subj(subj,4)=mean(conf(sub==subj & ask==0 & condition>=2 & confcondition==0));
    confdata_difficulty_subj(subj,5)=mean(conf(sub==subj & ask==1 & condition<2 & confcondition==1));
    confdata_difficulty_subj(subj,6)=mean(conf(sub==subj & ask==1 & condition>=2 & confcondition==1));
    confdata_difficulty_subj(subj,7)=mean(conf(sub==subj & ask==0 & condition<2 & confcondition==1));
    confdata_difficulty_subj(subj,8)=mean(conf(sub==subj & ask==0 & condition>=2 & confcondition==1));
end

mean_confdata_difficulty = [nanmean(confdata_difficulty_subj(:,1:4)); nanmean(confdata_difficulty_subj(:,5:8))]';
se_confdata_difficulty = [nanstd(confdata_difficulty_subj(:,1:4))./sqrt(sum(1-isnan(confdata_difficulty_subj(:,1:4))));...
    nanstd(confdata_difficulty_subj(:,5:8))./sqrt(sum(1-isnan(confdata_difficulty_subj(:,5:8))))]';

%confidence prediction

for subj=1:nsubj
    confpredict_difficulty_subj(subj,1)=mean(confpredict(sub==subj & ask==1 & condition<2 & confcondition==0));
    confpredict_difficulty_subj(subj,2)=mean(confpredict(sub==subj & ask==1 & condition>=2 & confcondition==0));
    confpredict_difficulty_subj(subj,3)=mean(confpredict(sub==subj & ask==0 & condition<2 & confcondition==0));
    confpredict_difficulty_subj(subj,4)=mean(confpredict(sub==subj & ask==0 & condition>=2 & confcondition==0));
    confpredict_difficulty_subj(subj,5)=mean(confpredict(sub==subj & ask==1 & condition<2 & confcondition==1));
    confpredict_difficulty_subj(subj,6)=mean(confpredict(sub==subj & ask==1 & condition>=2 & confcondition==1));
    confpredict_difficulty_subj(subj,7)=mean(confpredict(sub==subj & ask==0 & condition<2 & confcondition==1));
    confpredict_difficulty_subj(subj,8)=mean(confpredict(sub==subj & ask==0 & condition>=2 & confcondition==1));
end

mean_confpredict_difficulty = [nanmean(confpredict_difficulty_subj(:,1:4)); nanmean(confpredict_difficulty_subj(:,5:8))]';
se_confpredict_difficulty = [nanstd(confpredict_difficulty_subj(:,1:4))./sqrt(sum(1-isnan(confpredict_difficulty_subj(:,1:4))));...
    nanstd(confpredict_difficulty_subj(:,5:8))./sqrt(sum(1-isnan(confpredict_difficulty_subj(:,5:8))))]';

% Draw bar graph

ctrs = 1:size(mean_confdata_difficulty,1);
data = mean_confdata_difficulty;
figure(1);
hBar = bar(ctrs, data);

set(hBar(1),'FaceColor',[112/255 138/255 144/255]);
set(hBar(2),'FaceColor',[230/255 230/255 250/255]);

title('Confidence');

xlabel=cell(1,size(mean_confdata_difficulty,1));
xlabel{1}='Easy-Ask';
xlabel{2}='Difficult-Ask';
xlabel{3}='Easy-Answer';
xlabel{4}='Difficult-Answer';
set(gca,'xticklabel', xlabel) ;

legends=cell(1,size(mean_confdata_difficulty,2));
legends{1}='Confidence without hint';
legends{2}='Confidence with hint';
legend(hBar,legends);

ctr = [];
ydt = [];

for k1 = 1:size(mean_confdata_difficulty,2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
e=errorbar(ctr, ydt, zeros(size(ydt)), se_confdata_difficulty', '.k');
for i=1:size(mean_confdata_difficulty,1)
    e(i).LineWidth=2;
end

pre_points_conf = plot(ctr+0.05,mean_confpredict_difficulty','r.','MarkerSize',35);
e_pre=errorbar(ctr+0.05, mean_confpredict_difficulty', se_confpredict_difficulty', se_confpredict_difficulty', '.r');
for i=1:size(mean_confdata_difficulty,1)
    e_pre(i).LineWidth=2;
end

set(findall(gcf,'-property','FontSize'),'FontSize',24)
set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')