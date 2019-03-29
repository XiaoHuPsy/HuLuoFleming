function [stimulusSeq, conditionSeq]= offloadGenPresentSeq (stimulus)
% Generate sequence for stimulus organized in n by n by n cell
% The maximum number of independent variables is 3
% No more than 3 consecutive trials with the same level of either independent variable are presented consecutively


Maximum_variable = 3;

conditionSeq = [];
stimulusSeq={};

for i=1:numel(stimulus)
    [dim1 dim2 dim3] = ind2sub(size(stimulus),i);
    conditionItemNum = size(stimulus{dim1,dim2,dim3},1);
    conditionSeq = [conditionSeq; repmat([dim1 dim2 dim3],conditionItemNum,1)];
end

%% Generate condition sequence
m = 1;
t0 = GetSecs;
while (m==1)
   m = 0;
   conditionSeq = conditionSeq(randperm(size(conditionSeq,1)),:);
   for i=1:(length(size(stimulus))-double(length(size(stimulus))==2 && size(stimulus,2)==1))
       for j=1:(size(conditionSeq,1)-3)
           if conditionSeq(j,i)==conditionSeq(j+1,i) && conditionSeq(j,i)==conditionSeq(j+2,i) && conditionSeq(j,i)==conditionSeq(j+3,i)
               m = 1;
           end
       end
   end
   t1=GetSecs;
   if t1-t0>5
      m=0;
      break;
   end
end

%% Generate word sequence
for i=1:size(conditionSeq,1)
    indexSeq(i) = sub2ind(size(stimulus),conditionSeq(i,1),conditionSeq(i,2),conditionSeq(i,3));
end

stimulusSeq(1:size(conditionSeq,1),1:2) = {'1'};

for i=1:numel(stimulus)
    if ~isempty(stimulus{i})
       stimulus{i}=stimulus{i}(randperm(size(stimulus{i},1)),:);
       stimulusSeq(indexSeq==i,:) = stimulus{i};
    end
end

%% Remove the redundant independent variables in conditionSeq
conditionSeq(:,length(size(stimulus))-double(length(size(stimulus))==2 && size(stimulus,2)==1)+1:Maximum_variable)=[];