function [recogChoiceSequence, correctChoice] = offloadGenRecogChoice(targetWordList,choiceNum)

targetWordNum = length(targetWordList);

recogChoiceNumSequence = offloadGenRecogChoiceSeqNum (targetWordNum, choiceNum);
recogChoiceSequence = targetWordList(recogChoiceNumSequence);


correctChoice=[];
for i=1:size(recogChoiceSequence,1)
    correctChoice(i,1) = find(strcmp(recogChoiceSequence(i,:),targetWordList(i)));
end