function offloadMem

clear;
clc;
KbName('UnifyKeyNames');
PsychJavaTrouble()

%% Get parameter
p = offloadGetParams;

%% Instruction and Practice
HideCursor;

% Instruction
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['Welcome to this experiment! \n\n\n\n Press space bar to find out what the task involves!'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

DrawFormattedText(p.frame.ptr,['The first part of the task is to learn a list of word pairs.\n\n Each pair contains two words. \n\n\n\n'...
    'There will be a memory test for the pairs after you learn all of them.\n\n\n\n'...
    'After learning each pair, you can choose whether to save it into the computer \n\n'... 
    'by presssing the number key 1 or 2.\n\n\n\n'...
    'You may get access to the saved information to help you recall the words \n\n'... 
    'in the memory test.\n\n\n\n Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

DrawFormattedText(p.frame.ptr,['You can only save half of the pairs in the list.\n\n\n\n'...
    'When you decide whether to save each pair, you can see how many pairs you have\n\n'...
    'saved, how many pairs have been presented, and the total number of pairs. \n\n\n\n'...
    'If the number of pairs you save has reached the upper limit before you learn\n\n'...
    'all pairs, then you will not have opportunity to save the remaining pairs.\n\n\n\n Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

% Show example of word pairs and test
p.Pracresults = offloadRunPracBlock(p, {'brass','band';'inch','mile'; 'spoke','wheel';'burden','load';'alcohol','drink';'jacket','coat'},...
    {'residue','murder';'sunset','beef'; 'ivory','star';'painter','gray';'demon','mail';'acre','sheet'}, 1);


% Instruction for main experiment
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['We will now ask you to learn 3 lists of word pairs. Each list contains 40 pairs. \n\n\n\n'...
    'For each list, you can save at most 20 pairs into the computer. \n\n\n\n After learning each list, '...
    'you need to take a memory test for that list. \n\n\n\n If you have any questions, please ask the experimenter now! \n\n\n\n'...
    'Otherwise please press space bar to start.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

%% Get wordlist
if IsWin
    WordListDir = [pwd '\offloadWordList\'];
else
    WordListDir = [pwd '/offloadWordList/'];
end
 
fid=fopen([WordListDir 'highRelatedList.txt']);
highRelatedPairs = textscan(fid,'%s\t%s');
fclose(fid);

fid=fopen([WordListDir 'lowRelatedList.txt']);
lowRelatedPairs  = textscan(fid,'%s\t%s');
fclose(fid);

%% Block randomisation for wordlist

% Set random seed
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rand('seed',tseed); 

% Block randomisation
highRelatedPairs = offloadBlockRandomise(highRelatedPairs, p.blockNum);
lowRelatedPairs = offloadBlockRandomise(lowRelatedPairs, p.blockNum);

%% Run Block
for i=1:p.blockNum
    p.results{i}=offloadRunBlock(p,highRelatedPairs{i},lowRelatedPairs{i},1);
    save(p.filename);
    if i < p.blockNum
        Screen('TextSize',p.frame.ptr,26);
        Screen('TextFont',p.frame.ptr,'Consolas');
        Screen('TextStyle',p.frame.ptr,0);
        DrawFormattedText(p.frame.ptr,['Take a break! \n\n\n\n' ...
        'Please press the space bar to learn the next list of word pairs \n\n when you are ready.'],'center', 'center',[255 255 255]);
        Screen('Flip', p.frame.ptr);
        WaitSecs(0.5);
        WaitAnyPress(KbName('space'));
    end
end

%% Exit
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['The experiment is finished! \n\n\n\n Thank you very much for your participation! \n\n\n\n '...
    'Press space bar to end the experiment.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

% Calculate the total points

p.totalPoints=0;
for i=1:p.blockNum
    p.totalPoints=p.totalPoints+p.results{i}.retrievalTotalPoints;
end

Screen('CloseAll'); 
ShowCursor;

save(p.filename);