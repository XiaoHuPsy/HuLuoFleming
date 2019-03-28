clear;
load rawData_Experiment2a.mat % load raw data from Experiment 2a or 2b

% summary statistics (copy the data in these matrices/cells into SPSS for further statistical analysis)
sumStats_saveProp = [];
sumStats_askProp = {};
sumStats_rec = {};
sumStats_recFree = {};
sumStats_confDiffi = {};
sumStats_confSave = {};
sumStats_indiDiff = zeros(length(rawData.age),3);

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
    
    % confidence in free-choice test (difficulty is included as a variable)
    conf_easyAskHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_easyAskNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_easyAnswerHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_easyAnswerNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_diffiAskHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_diffiAskNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_diffiAnswerHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_diffiAnswerNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    
    sumStats_confDiffi = [sumStats_confDiffi;{subj} {'easy'} {'ask'} {'with_hint'} conf_easyAskHint;{subj} {'easy'} {'ask'} {'without_hint'} conf_easyAskNoHint;...
        {subj} {'easy'} {'answer'} {'with_hint'} conf_easyAnswerHint;{subj} {'easy'} {'answer'} {'without_hint'} conf_easyAnswerNoHint;...
        {subj} {'difficult'} {'ask'} {'with_hint'} conf_diffiAskHint;{subj} {'difficult'} {'ask'} {'without_hint'} conf_diffiAskNoHint;...
        {subj} {'difficult'} {'answer'} {'with_hint'} conf_diffiAnswerHint;{subj} {'difficult'} {'answer'} {'without_hint'} conf_diffiAnswerNoHint];
    
    % confidence in free-choice test (saved/unsaved is included as a variable)
    conf_savedAskHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_savedAskNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_savedAnswerHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_savedAnswerNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'saved') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_unsavedAskHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_unsavedAskNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==1 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    conf_unsavedAnswerHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'with_hint'),11)));
    conf_unsavedAnswerNoHint = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,9),'unsaved') & cell2mat(retrieval_free(:,7))==0 & strcmp(retrieval_free(:,10),'without_hint'),11)));
    
    sumStats_confSave = [sumStats_confSave;{subj} {'saved'} {'ask'} {'with_hint'} conf_savedAskHint;{subj} {'saved'} {'ask'} {'without_hint'} conf_savedAskNoHint;...
        {subj} {'saved'} {'answer'} {'with_hint'} conf_savedAnswerHint;{subj} {'saved'} {'answer'} {'without_hint'} conf_savedAnswerNoHint;...
        {subj} {'unsaved'} {'ask'} {'with_hint'} conf_unsavedAskHint;{subj} {'unsaved'} {'ask'} {'without_hint'} conf_unsavedAskNoHint;...
        {subj} {'unsaved'} {'answer'} {'with_hint'} conf_unsavedAnswerHint;{subj} {'unsaved'} {'answer'} {'without_hint'} conf_unsavedAnswerNoHint];
    
    % individual difference
    sumStats_indiDiff(subj,1) = mean(cell2mat(retrieval_free(:,7))); % overall ask-for-help proportion in the free-choice test
    sumStats_indiDiff(subj,2) = mean(cell2mat(retrieval_free(:,11))); % mean confidence in the free-choice test
    sumStats_indiDiff(subj,3) = mean(cell2mat(retrieval(strcmp(retrieval(:,4),'forced'),5))); % overall recall performance in the forced-recall test

end

% replace NaN with 999
sumStats_askProp(isnan(cell2mat(sumStats_askProp(:,4))),4) = {999};
sumStats_rec(isnan(cell2mat(sumStats_rec(:,5))),5) = {999};
sumStats_recFree(isnan(cell2mat(sumStats_recFree(:,5))),5) = {999};
sumStats_confDiffi(isnan(cell2mat(sumStats_confDiffi(:,5))),5) = {999};
sumStats_confSave(isnan(cell2mat(sumStats_confSave(:,5))),5) = {999};