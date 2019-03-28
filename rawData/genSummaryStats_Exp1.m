clear;
load rawData_Experiment1.mat

% summary statistics
sumStats_saveProp = [];
sumStats_askProp = {};
sumStats_rec = {};
sumStats_recFree = {};

for subj = 1:length(rawData.age)
    
    encoding = rawData.encoding{subj};
    retrieval = rawData.retrieval{subj};
    
    % remove no-choice trials
    encoding(strcmp(encoding(:,5),'no-choice'),:)=[];
    retrieval(strcmp(retrieval(:,9),'no-choice'),:)=[];
    
    % save proportion during learning
    saveProp_easy = sum(strcmp(encoding(:,4),'easy') & strcmp(encoding(:,5),'saved')) / sum(strcmp(encoding(:,4),'easy'));
    saveProp_difficult = sum(strcmp(encoding(:,4),'difficult') & strcmp(encoding(:,5),'saved')) / sum(strcmp(encoding(:,4),'difficult'));
    sumStats_saveProp = [sumStats_saveProp;saveProp_easy saveProp_difficult];
    
    % ask-for-help proportion in free-choice test
    retrieval_free = retrieval(strcmp(retrieval(:,4),'free'),:);
    askProp_easySave = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'saved'),7)));
    askProp_easyUnsave = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'unsaved'),7)));
    askProp_diffiSave = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'saved'),7)));
    askProp_diffiUnsave = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'unsaved'),7)));
    
    sumStats_askProp = [sumStats_askProp;{subj} {'easy'} {'saved'} askProp_easySave;{subj} {'easy'} {'unsaved'} askProp_easyUnsave;...
        {subj} {'difficult'} {'saved'} askProp_diffiSave;{subj} {'difficult'} {'unsaved'} askProp_diffiUnsave;];
    
    % recall performance
    rec_easySaveFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,9),'saved') & strcmp(retrieval(:,4),'free'),5)));
    rec_easySaveForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,9),'saved') & strcmp(retrieval(:,4),'forced'),5)));
    rec_easyUnsaveFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,9),'unsaved') & strcmp(retrieval(:,4),'free'),5)));
    rec_easyUnsaveForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,9),'unsaved') & strcmp(retrieval(:,4),'forced'),5)));
    rec_diffiSaveFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,9),'saved') & strcmp(retrieval(:,4),'free'),5)));
    rec_diffiSaveForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,9),'saved') & strcmp(retrieval(:,4),'forced'),5)));
    rec_diffiUnsaveFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,9),'unsaved') & strcmp(retrieval(:,4),'free'),5)));
    rec_diffiUnsaveForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,9),'unsaved') & strcmp(retrieval(:,4),'forced'),5)));
    
    sumStats_rec = [sumStats_rec;{subj} {'easy'} {'saved'} {'free'} rec_easySaveFree;{subj} {'easy'} {'saved'} {'forced'} rec_easySaveForced;...
        {subj} {'easy'} {'unsaved'} {'free'} rec_easyUnsaveFree;{subj} {'easy'} {'unsaved'} {'forced'} rec_easyUnsaveForced;...
        {subj} {'difficult'} {'saved'} {'free'} rec_diffiSaveFree;{subj} {'difficult'} {'saved'} {'forced'} rec_diffiSaveForced;...
        {subj} {'difficult'} {'unsaved'} {'free'} rec_diffiUnsaveFree;{subj} {'difficult'} {'unsaved'} {'forced'} rec_diffiUnsaveForced];
    
    % recall performance in free-choice test
    rec_easySaveAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_easySaveAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==0,5)));
    rec_easyUnsaveAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_easyUnsaveAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==0,5)));
    rec_diffiSaveAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_diffiSaveAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==0,5)));
    rec_diffiUnsaveAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_diffiUnsaveAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==0,5)));
    
    sumStats_recFree = [sumStats_recFree;{subj} {'easy'} {'saved'} {'ask'} rec_easySaveAsk;{subj} {'easy'} {'saved'} {'answer'} rec_easySaveAnswer;...
        {subj} {'easy'} {'unsaved'} {'ask'} rec_easyUnsaveAsk;{subj} {'easy'} {'unsaved'} {'answer'} rec_easyUnsaveAnswer;...
        {subj} {'difficult'} {'saved'} {'ask'} rec_diffiSaveAsk;{subj} {'difficult'} {'saved'} {'answer'} rec_diffiSaveAnswer;...
        {subj} {'difficult'} {'unsaved'} {'ask'} rec_diffiUnsaveAsk;{subj} {'difficult'} {'unsaved'} {'answer'} rec_diffiUnsaveAnswer];

end

% replace NaN with 999
sumStats_askProp(isnan(cell2mat(sumStats_askProp(:,4))),4) = {999};
sumStats_rec(isnan(cell2mat(sumStats_rec(:,5))),5) = {999};
sumStats_recFree(isnan(cell2mat(sumStats_recFree(:,5))),5) = {999};