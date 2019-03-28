clear;
clc;

% load data and model predictions for Experiment 3

load stat_negative_1C_2Phinto_Exp3 % parameters in the winning model
load modelfit_data_ChoiceAndRecall_Exp3 % data of choice and recall performance
load prec_Exp3 % predicted memory strength in the winning model
load askPropData_Exp3 % overall ask-for-help proportions
load recData_Exp3 % overall recall performance

%% Predict ask-for-help proportion

for i=1:ntrial
   ask_predict(i) = prec(i) < stats.mean.C(sub(i),condition(i));
end

for i=1:nsubj
    for j=1:4
       askProp_predict_sub(i,j)=mean(ask_predict(sub==i & condition==j)); 
    end
end

%% Predict recall performance

for i=1:ntrial
    if (condition(i)==1 || condition(i)==2) && ask_predict(i)==1
        rec_predict(i) = prec(i) + stats.mean.U_hint_obj(sub(i),condition(i));
        if rec_predict(i)>1
           rec_predict(i)=1; 
        end
    else
        rec_predict(i) = prec(i);
    end
end

for i=1:nsubj
    for j=1:2
       recProp_predict_sub(i,j)=mean(rec_predict(sub==i & condition==j)); 
    end
end

for i=1:nsubj
    for j=1:2
       recProp_ask_predict_sub(i,j)=mean(rec_predict(sub==i & condition==j & ask_predict'==1)); 
       recProp_answer_predict_sub(i,j)=mean(rec_predict(sub==i & condition==j & ask_predict'==0)); 
    end
end

%% Draw bar graph for ask-for-help proportion 

ctrs = 1:size(askPropDataMean,1);
data = askPropDataMean;
figure(1);
hBar = bar(ctrs, data,0.5);

set(hBar(1),'FaceColor',[1 248/255 220/255]);

title('Proportion of ask-for-help trials');

xlabel=cell(1,size(askPropDataMean,1));
xlabel{1}='Easy';
xlabel{2}='Difficult';
set(gca,'xticklabel', xlabel) ;

ctr = [];
ydt = [];

for k1 = 1:size(askPropDataMean,2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
e=errorbar(ctr, ydt, zeros(size(ydt)), askPropDataSE', '.k');
for i=1:1
    e(i).LineWidth=2;
end

pre_askprop=nanmean(askProp_predict_sub);
pre_askprop_se=nanstd(askProp_predict_sub)./sqrt(sum(1-isnan(askProp_predict_sub)));
pre_askprop=[pre_askprop(1) pre_askprop(2)];
pre_askprop_se=[pre_askprop_se(1) pre_askprop_se(2)];

pre_points_askprop = plot(ctr+0.05,pre_askprop','r.','MarkerSize',35);
e_pre=errorbar(ctr+0.05, pre_askprop', pre_askprop_se', pre_askprop_se', '.r');
for i=1:1
    e_pre(i).LineWidth=2;
end

set(findall(gcf,'-property','FontSize'),'FontSize',24)
set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')

%% Draw bar graph for overall recall performance

ctrs = 1:size(recCombineDataMean,1);
data = recCombineDataMean;
figure(2);
hBar = bar(ctrs, data);

set(hBar(1),'FaceColor',[0 0 205/255]);
set(hBar(2),'FaceColor',[135/255 206/255 250/255]);

title('Recall performance');

xlabel=cell(1,size(recCombineDataMean,1));
xlabel{1}='Easy';
xlabel{2}='Difficult';
set(gca,'xticklabel', xlabel) ;

legends=cell(1,size(recCombineDataMean,2));
legends{1}='Free Choice';
legends{2}='Forced Recall';
legend(hBar,legends);

ctr = [];
ydt = [];

for k1 = 1:size(recCombineDataMean,2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
e=errorbar(ctr, ydt, zeros(size(ydt)), recCombineDataSE', '.k');
for i=1:size(recCombineDataMean,1)
    e(i).LineWidth=2;
end

pre_rec=nanmean(recProp_predict_sub);
pre_rec=[[pre_rec(1);pre_rec(2)] recCombineDataMean(:,2)];
pre_rec_se=nanstd(recProp_predict_sub)./sqrt(sum(1-isnan(recProp_predict_sub)));
pre_rec_se=[[pre_rec_se(1);pre_rec_se(2)] recCombineDataSE(:,2)];

pre_points_rec = plot(ctr+0.05,pre_rec','r.','MarkerSize',35);
e_pre=errorbar(ctr+0.05, pre_rec', pre_rec_se', pre_rec_se', '.r');
for i=1:size(recCombineDataMean,1)
    e_pre(i).LineWidth=2;
end

set(findall(gcf,'-property','FontSize'),'FontSize',24)
set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')

%% Draw bar graph for recall performance in the free-choice test

ctrs = 1:size(recDataMean,1);
data = recDataMean(:,1:2);
figure(3);
hBar = bar(ctrs, data);

set(hBar(1),'FaceColor',[0 100/255 0]);
set(hBar(2),'FaceColor',[0 1 0.5]);

title('Recall performance');

xlabel=cell(1,size(recDataMean,1));
xlabel{1}='Easy';
xlabel{2}='Difficult';
set(gca,'xticklabel', xlabel) ;

legends=cell(1,2);
legends{1}='Ask';
legends{2}='Answer';
legend(hBar,legends);

ctr = [];
ydt = [];

for k1 = 1:2
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
e=errorbar(ctr, ydt, zeros(size(ydt)), recDataSE(:,1:2)', '.k');
for i=1:size(recDataMean,1)
    e(i).LineWidth=2;
end

mean_rec_ask_predict = nanmean(recProp_ask_predict_sub);
se_rec_ask_predict = nanstd(recProp_ask_predict_sub)./sqrt(sum(1-isnan(recProp_ask_predict_sub)));
mean_rec_answer_predict = nanmean(recProp_answer_predict_sub);
se_rec_answer_predict = nanstd(recProp_answer_predict_sub)./sqrt(sum(1-isnan(recProp_answer_predict_sub)));

pre_rec=[[mean_rec_ask_predict(1) mean_rec_answer_predict(1);mean_rec_ask_predict(2) mean_rec_answer_predict(2)]];

pre_rec_se=[[se_rec_ask_predict(1) se_rec_answer_predict(1);se_rec_ask_predict(2) se_rec_answer_predict(2)]];

pre_points_rec = plot(ctr+0.05,pre_rec','r.','MarkerSize',35);
e_pre=errorbar(ctr+0.05, pre_rec', pre_rec_se', pre_rec_se', '.r');
for i=1:size(recDataMean,1)
    e_pre(i).LineWidth=2;
end

set(findall(gcf,'-property','FontSize'),'FontSize',24)
set(findall(gcf,'-property','FontWeight'),'FontWeight','bold')
