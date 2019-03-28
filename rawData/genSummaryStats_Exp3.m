clear;
load rawData_Experiment3.mat 

% summary statistics (copy the data in these matrices/cells into SPSS for further statistical analysis)
sumStats_askProp = {};
sumStats_rec = {};
sumStats_recFree = {};
sumStats_confDiffi = {};
sumStats_indiDiff = zeros(length(rawData.age),3);

for subj = 1:length(rawData.age)
    
    retrieval = rawData.retrieval{subj};
        
    % ask-for-help proportion in free-choice test
    retrieval_free = retrieval(strcmp(retrieval(:,4),'free'),:);
    askProp_easy = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy'),7)));
    askProp_diffi = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult'),7)));
    
    sumStats_askProp = [sumStats_askProp;{subj} {'easy'} askProp_easy;{subj} {'difficult'} askProp_diffi;];
    
    % recall performance
    rec_easyFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,4),'free'),5)));
    rec_easyForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'easy') & strcmp(retrieval(:,4),'forced'),5)));
    rec_diffiFree = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,4),'free'),5)));
    rec_diffiForced = mean(cell2mat(retrieval(strcmp(retrieval(:,8),'difficult') & strcmp(retrieval(:,4),'forced'),5)));
    
    sumStats_rec = [sumStats_rec;{subj} {'easy'} {'free'} rec_easyFree;{subj} {'easy'} {'forced'} rec_easyForced;...
        {subj} {'difficult'} {'free'} rec_diffiFree;{subj} {'difficult'} {'forced'} rec_diffiForced];
    
    % recall performance in free-choice test
    rec_easyAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_easyAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'easy') & cell2mat(retrieval_free(:,7))==0,5)));
    rec_diffiAsk = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==1,5)));
    rec_diffiAnswer = mean(cell2mat(retrieval_free(strcmp(retrieval_free(:,8),'difficult') & cell2mat(retrieval_free(:,7))==0,5)));
    
    sumStats_recFree = [sumStats_recFree;{subj} {'easy'} {'ask'} rec_easyAsk;{subj} {'easy'} {'answer'} rec_easyAnswer;...
        {subj} {'difficult'} {'ask'} rec_diffiAsk;{subj} {'difficult'} {'answer'} rec_diffiAnswer];
    
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
        
    % individual difference
    sumStats_indiDiff(subj,1) = mean(cell2mat(retrieval_free(:,7))); % overall ask-for-help proportion in the free-choice test
    sumStats_indiDiff(subj,2) = mean(cell2mat(retrieval_free(:,11))); % mean confidence in the free-choice test
    sumStats_indiDiff(subj,3) = mean(cell2mat(retrieval(strcmp(retrieval(:,4),'forced'),5))); % overall recall performance in the forced-recall test

end

% replace NaN with 999
sumStats_askProp(isnan(cell2mat(sumStats_askProp(:,3))),3) = {999};
sumStats_rec(isnan(cell2mat(sumStats_rec(:,4))),4) = {999};
sumStats_recFree(isnan(cell2mat(sumStats_recFree(:,4))),4) = {999};
sumStats_confDiffi(isnan(cell2mat(sumStats_confDiffi(:,5))),5) = {999};