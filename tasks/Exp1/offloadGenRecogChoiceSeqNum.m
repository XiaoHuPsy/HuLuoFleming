function Data = offloadGenRecogChoiceSeqNum (trialnum, choicenum)
% Generate number sequence for recogntion choice
% Typically no less than 30 trials and no more than 10 choices for each trial

Data=(1:trialnum)';

for cycle=1:(choicenum-1)
Data(:,cycle+1)=-1;
RandRow=(1:trialnum)';
i=1;
while i<=trialnum
    [row, col]=find(Data==i);
    RandRow_1=RandRow;
    for j=1:length(row)
        RandRow_1(RandRow_1==row(j))=[];
    end
    if isempty(RandRow_1)
        RandRow_perm=RandRow(randperm(length(RandRow)));
        for j=1:cycle
           [row_0 col_0]= find(Data(:,cycle+1)==Data(RandRow_perm(1),j));
           row=unique([row; row_0]);
        end
        RandRow_2=(1:trialnum)';
        for j=1:length(row)
            RandRow_2(RandRow_2==row(j))=[];
        end
        RandRow_2=RandRow_2(randperm(length(RandRow_2)));
        row_2=RandRow_2(1);
        temp=Data(row_2,cycle+1);
        Data(row_2,cycle+1)=Data(RandRow_perm(1),cycle+1);
        Data(RandRow_perm(1),cycle+1)=temp;
        RandRow(RandRow==RandRow_perm(1))=row_2;
        continue;
    else
        RandRow_1=RandRow_1(randperm(length(RandRow_1)));
        row_1=RandRow_1(1);
    end
    Data(row_1,cycle+1)=i;
    RandRow(RandRow==row_1)=[];
    i=i+1;
end
end

% randperm for choice order
for i=1:trialnum
    Data_row=Data(i,:);
    Data_row=Data_row(randperm(choicenum));
    Data(i,:)=Data_row;
end