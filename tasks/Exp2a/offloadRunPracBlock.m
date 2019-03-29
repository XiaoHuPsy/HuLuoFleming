function results = offloadRunPracBlock(p, highRelatedPairs, lowRelatedPairs, feedback)
%

%% Instruction for encoding
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['Now you need to practice the learning process.\n\n\n\n Press space bar to start.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));
Screen('Flip', p.frame.ptr);

%% Generate presentation sequence for encoding
[wordEncodingSequence, conditionEncodingSequence] = offloadGenPresentSeq({highRelatedPairs;lowRelatedPairs});

highRelatedItemNum = length(highRelatedPairs);
lowRelatedItemNum=length(lowRelatedPairs);
trialNum = highRelatedItemNum + lowRelatedItemNum;

highRelatedPairs_Offloading = {};
highRelatedPairs_noOffloading = {};
lowRelatedPairs_Offloading = {};
lowRelatedPairs_noOffloading = {};

%% Encoding process

offloadNum = 0;

for i=1:trialNum
    % Fixation
    Screen('TextSize',p.frame.ptr,70);
    Screen('TextFont',p.frame.ptr,'Courier New');
    Screen('TextStyle',p.frame.ptr,1);
    DrawText(p.frame.ptr,{'+'},'c');
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    
    % Word pair presentation    
    Screen('TextSize',p.frame.ptr,45);
    Screen('TextFont',p.frame.ptr,'Calibri');
    Screen('TextStyle',p.frame.ptr,1);
    
    wordBound=Screen('TextBounds',p.frame.ptr,wordEncodingSequence{i,1});
    wordWidth=wordBound(3)-wordBound(1);
    wordHeight=wordBound(4)-wordBound(2);
    Screen('DrawText',p.frame.ptr,wordEncodingSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
    
    wordBound=Screen('TextBounds',p.frame.ptr,wordEncodingSequence{i,2});
    wordWidth=wordBound(3)-wordBound(1);
    wordHeight=wordBound(4)-wordBound(2);
    Screen('DrawText',p.frame.ptr,wordEncodingSequence{i,2},p.mx-wordWidth/2,p.my+100-wordHeight/2,[255 255 255]);
    
    Screen('Flip', p.frame.ptr);
    WaitSecs(p.studyDuration);
    
    % Present offloading/no-offloading choices
    if offloadNum < trialNum/2
        wordBound = Screen('TextBounds',p.frame.ptr,'Save in computer?');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'Save in computer?',p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);

        wordBound = Screen('TextBounds',p.frame.ptr,'1. Yes');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'1. Yes',p.mx-120-wordWidth/2,p.my+70-wordHeight/2,[255 255 255]);

        wordBound = Screen('TextBounds',p.frame.ptr,'2. No');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'2. No',p.mx+120-wordWidth/2,p.my+70-wordHeight/2,[255 255 255]);

        % Present offloading word count
        Screen('TextSize',p.frame.ptr,40);
        Screen('TextFont',p.frame.ptr,'Calibri');
        Screen('TextStyle',p.frame.ptr,0);

        wordBound = Screen('TextBounds',p.frame.ptr,['You have saved ' num2str(offloadNum) '/' ...
            num2str(trialNum/2) ' pairs']);
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,['You have saved ' num2str(offloadNum) '/' num2str(trialNum/2) ' pairs'],...
            p.mx-wordWidth/2,p.my+200-wordHeight/2,[255 255 255]);
        
        % Present trial count
        wordBound = Screen('TextBounds',p.frame.ptr,['This is the ' num2str(i) '/' num2str(trialNum) ' pair']);
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,['This is the ' num2str(i) '/' num2str(trialNum) ' pair'],...
            p.mx-wordWidth/2,p.my+270-wordHeight/2,[255 255 255]);

        Screen('Flip', p.frame.ptr);

        % Make offloading/no-offloading choice
        KbNameNumList_mainPad = [KbName('1!'); KbName('2@')];
        KbNameNumList_keyPad = [KbName('1'); KbName('2')];
        KbAllowed = [KbNameNumList_mainPad' KbNameNumList_keyPad'];
        while 1
            [offloading_rt, k, t0, t] = WaitAnyPress(KbAllowed);
            if length(find(k))==1
                break;
            end
        end
        [offloading_choice_made, ~] = find([KbNameNumList_mainPad KbNameNumList_keyPad]==find(k));

        if offloading_choice_made==1 % offloading
            offloadNum = offloadNum+1;
        end
        
        % Put offloading/no-offloading pairs into different cells
        if offloading_choice_made==1  % choose offloading
            if conditionEncodingSequence(i,1) == 1 % high-relatedness pair
                highRelatedPairs_Offloading = [highRelatedPairs_Offloading; wordEncodingSequence(i,:)];
            elseif conditionEncodingSequence(i,1) == 2 % low-relatedness pair
                lowRelatedPairs_Offloading = [lowRelatedPairs_Offloading; wordEncodingSequence(i,:)];
            end
        elseif offloading_choice_made==2 % choose no-offloading
            if conditionEncodingSequence(i,1) == 1 % high-relatedness pair
                highRelatedPairs_noOffloading = [highRelatedPairs_noOffloading; wordEncodingSequence(i,:)];
            elseif conditionEncodingSequence(i,1) == 2 % low-relatedness pair
                lowRelatedPairs_noOffloading = [lowRelatedPairs_noOffloading; wordEncodingSequence(i,:)];
            end
        end
        
    else
        offloading_choice_made=3; % no-choice
        
        wordBound = Screen('TextBounds',p.frame.ptr,'You cannot save this pair');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'You cannot save this pair',p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
        
        wordBound = Screen('TextBounds',p.frame.ptr,'Press space bar to continue');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'Press space bar to continue',p.mx-wordWidth/2,p.my+70-wordHeight/2,[255 255 255]);
        
        % Present offloading word count
        Screen('TextSize',p.frame.ptr,40);
        Screen('TextFont',p.frame.ptr,'Calibri');
        Screen('TextStyle',p.frame.ptr,0);

        wordBound = Screen('TextBounds',p.frame.ptr,['You have saved ' num2str(offloadNum) '/' ...
            num2str(trialNum/2) ' pairs']);
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,['You have saved ' num2str(offloadNum) '/' num2str(trialNum/2) ' pairs'],...
            p.mx-wordWidth/2,p.my+200-wordHeight/2,[255 255 255]);
        
        % Present trial count
        wordBound = Screen('TextBounds',p.frame.ptr,['This is the ' num2str(i) '/' num2str(trialNum) ' pair']);
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,['This is the ' num2str(i) '/' num2str(trialNum) ' pair'],...
            p.mx-wordWidth/2,p.my+270-wordHeight/2,[255 255 255]);

        Screen('Flip', p.frame.ptr);
        
        % Press space bar to continue
        [spacebar_rt, k, t0, t] = WaitAnyPress(KbName('Space'));
        
        % Put pairs into no-offloading cells
        if conditionEncodingSequence(i,1) == 1 % high-relatedness pair
            highRelatedPairs_noOffloading = [highRelatedPairs_noOffloading; wordEncodingSequence(i,:)];
        elseif conditionEncodingSequence(i,1) == 2 % low-relatedness pair
            lowRelatedPairs_noOffloading = [lowRelatedPairs_noOffloading; wordEncodingSequence(i,:)];
        end
        
    end
    
    % JOL rating
    %[conf, RT] = collectConfidence(p.frame.ptr,p);
    
    % Data recording
    results.encoding{i,1} = wordEncodingSequence{i,1}; % Cue word
    results.encoding{i,2} = wordEncodingSequence{i,2}; % Target word
    if conditionEncodingSequence(i,1)==1 % High/Low relatedness
        results.encoding{i,3} = 'High';
    elseif conditionEncodingSequence(i,1)==2
        results.encoding{i,3} = 'Low';
    end
    if offloading_choice_made==1 % offloading
        results.encoding{i,4} = 'Offloading';
    elseif offloading_choice_made==2 % no-offloading
        results.encoding{i,4} = 'noOffloading';
    elseif offloading_choice_made==3 % no-choice
        results.encoding{i,4} = 'noChoice';
    end
    if offloading_choice_made~=3
        results.encoding{i,5} = offloading_rt; %RT for offloading/no-offloading choice
    else
        results.encoding{i,5} = spacebar_rt;
    end
    %results.encoding{i,5} = conf; % JOL rating
    %results.encoding{i,6} = RT; % JOL response time
end

%% Instruction for confidence
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['You need to take a memory test after you learn all of the word pairs. \n\n\n\n'...
        'The top word in each pair will be presented, and you should recall the\n\n'...
        'correct bottom word.\n\n\n\n'...
        'Before recalling the bottom word, you need to first rate the confidence\n\n'...
        'that you will later be able to recall the word.\n\n\n\n'...
        'Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
if mod(str2double(p.subID{1,1}),2)==1
    DrawFormattedText(p.frame.ptr,['There are two types of confidence rating task.\n\n\n\n'...
            'If you see "Confidence WITH hint" (always in green color), you need\n\n'...
            'to rate the confidence that you will later be able to recall the\n\n'...
            'bottom word when you are given the first two letters of the word.\n\n\n\n'...
            'If you see "Confidence WITHOUT hint" (always in red color), you need\n\n'...
            'to rate the confidence that you will later be able to recall the\n\n'... 
            'bottom word without any hint.\n\n\n\n'...
            'Press space bar to continue.'],'center', 'center',[255 255 255]);
else
    DrawFormattedText(p.frame.ptr,['There are two types of confidence rating task.\n\n\n\n'...
            'If you see "Confidence WITH hint" (always in red color), you need\n\n'...
            'to rate the confidence that you will later be able to recall the\n\n'...
            'bottom word when you are given the first two letters of the word.\n\n\n\n'...
            'If you see "Confidence WITHOUT hint" (always in green color), you need\n\n'...
            'to rate the confidence that you will later be able to recall the\n\n'... 
            'bottom word without any hint.\n\n\n\n'...
            'Press space bar to continue.'],'center', 'center',[255 255 255]);
end
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['You will see a sliding scale to allow you to\n\n'...
        'rate your confidence. You can move the cursor around on the scale\n\n'...
        'using the left and right arrow keys. Then you should press the Enter\n\n'...
        'key to submit your confidence rating.\n\n\n\n'...
        'The left end of the scale means that you are least confident, and the\n\n'...
        'right end of the scale means that you are most confident.\n\n\n\n'...
        'We encourage you to use the whole scale.\n\n\n\n'...
        'Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

DrawFormattedText(p.frame.ptr,['Now you need to practice the confidence rating task. \n\n\n\n Press space bar to start.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));
Screen('Flip', p.frame.ptr);

%% Randomly allocate pairs into help/no-help condition
r = round(rand());

highRelatedPairs_Offloading = highRelatedPairs_Offloading(randperm(size(highRelatedPairs_Offloading,1)),:);
highRelatedPairs_noOffloading = highRelatedPairs_noOffloading(randperm(size(highRelatedPairs_noOffloading,1)),:);
lowRelatedPairs_Offloading = lowRelatedPairs_Offloading(randperm(size(lowRelatedPairs_Offloading,1)),:);
lowRelatedPairs_noOffloading = lowRelatedPairs_noOffloading(randperm(size(lowRelatedPairs_noOffloading,1)),:);

highRelatedPairs_Offloading_allocated = offloadBlockRandomise(highRelatedPairs_Offloading, 2, r);
highRelatedPairs_Offloading_Help = highRelatedPairs_Offloading_allocated{1};
highRelatedPairs_Offloading_noHelp = highRelatedPairs_Offloading_allocated{2};

lowRelatedPairs_Offloading_allocated = offloadBlockRandomise(lowRelatedPairs_Offloading, 2, 1-r);
lowRelatedPairs_Offloading_Help = lowRelatedPairs_Offloading_allocated{1};
lowRelatedPairs_Offloading_noHelp = lowRelatedPairs_Offloading_allocated{2};

highRelatedPairs_noOffloading_allocated = offloadBlockRandomise(highRelatedPairs_noOffloading, 2, 1-r);
highRelatedPairs_noOffloading_Help = highRelatedPairs_noOffloading_allocated{1};
highRelatedPairs_noOffloading_noHelp = highRelatedPairs_noOffloading_allocated{2};

lowRelatedPairs_noOffloading_allocated = offloadBlockRandomise(lowRelatedPairs_noOffloading, 2, r);
lowRelatedPairs_noOffloading_Help = lowRelatedPairs_noOffloading_allocated{1};
lowRelatedPairs_noOffloading_noHelp = lowRelatedPairs_noOffloading_allocated{2};

%% Randomly allocate pairs into ConfAsk/ConfAnswer condition

% High related pairs
highRelatedPairs_Offloading_Help = highRelatedPairs_Offloading_Help(randperm(size(highRelatedPairs_Offloading_Help,1)),:);
highRelatedPairs_Offloading_noHelp = highRelatedPairs_Offloading_noHelp(randperm(size(highRelatedPairs_Offloading_noHelp,1)),:);
highRelatedPairs_noOffloading_Help = highRelatedPairs_noOffloading_Help(randperm(size(highRelatedPairs_noOffloading_Help,1)),:);
highRelatedPairs_noOffloading_noHelp = highRelatedPairs_noOffloading_noHelp(randperm(size(highRelatedPairs_noOffloading_noHelp,1)),:);

r = round(rand());

highRelatedPairs_Offloading_Help_allocated = offloadBlockRandomise(highRelatedPairs_Offloading_Help, 2, r);
highRelatedPairs_Offloading_Help_confAnswer = highRelatedPairs_Offloading_Help_allocated{1};
highRelatedPairs_Offloading_Help_confAsk = highRelatedPairs_Offloading_Help_allocated{2};

highRelatedPairs_Offloading_noHelp_allocated = offloadBlockRandomise(highRelatedPairs_Offloading_noHelp, 2, 1-r);
highRelatedPairs_Offloading_noHelp_confAnswer = highRelatedPairs_Offloading_noHelp_allocated{1};
highRelatedPairs_Offloading_noHelp_confAsk = highRelatedPairs_Offloading_noHelp_allocated{2};

r = round(rand());

highRelatedPairs_noOffloading_Help_allocated = offloadBlockRandomise(highRelatedPairs_noOffloading_Help, 2, 1-r);
highRelatedPairs_noOffloading_Help_confAnswer = highRelatedPairs_noOffloading_Help_allocated{1};
highRelatedPairs_noOffloading_Help_confAsk = highRelatedPairs_noOffloading_Help_allocated{2};

highRelatedPairs_noOffloading_noHelp_allocated = offloadBlockRandomise(highRelatedPairs_noOffloading_noHelp, 2, r);
highRelatedPairs_noOffloading_noHelp_confAnswer = highRelatedPairs_noOffloading_noHelp_allocated{1};
highRelatedPairs_noOffloading_noHelp_confAsk = highRelatedPairs_noOffloading_noHelp_allocated{2};

% Low related pairs
lowRelatedPairs_Offloading_Help = lowRelatedPairs_Offloading_Help(randperm(size(lowRelatedPairs_Offloading_Help,1)),:);
lowRelatedPairs_Offloading_noHelp = lowRelatedPairs_Offloading_noHelp(randperm(size(lowRelatedPairs_Offloading_noHelp,1)),:);
lowRelatedPairs_noOffloading_Help = lowRelatedPairs_noOffloading_Help(randperm(size(lowRelatedPairs_noOffloading_Help,1)),:);
lowRelatedPairs_noOffloading_noHelp = lowRelatedPairs_noOffloading_noHelp(randperm(size(lowRelatedPairs_noOffloading_noHelp,1)),:);

r = round(rand());

lowRelatedPairs_Offloading_Help_allocated = offloadBlockRandomise(lowRelatedPairs_Offloading_Help, 2, 1-r);
lowRelatedPairs_Offloading_Help_confAnswer = lowRelatedPairs_Offloading_Help_allocated{1};
lowRelatedPairs_Offloading_Help_confAsk = lowRelatedPairs_Offloading_Help_allocated{2};

lowRelatedPairs_Offloading_noHelp_allocated = offloadBlockRandomise(lowRelatedPairs_Offloading_noHelp, 2, r);
lowRelatedPairs_Offloading_noHelp_confAnswer = lowRelatedPairs_Offloading_noHelp_allocated{1};
lowRelatedPairs_Offloading_noHelp_confAsk = lowRelatedPairs_Offloading_noHelp_allocated{2};

r = round(rand());

lowRelatedPairs_noOffloading_Help_allocated = offloadBlockRandomise(lowRelatedPairs_noOffloading_Help, 2, r);
lowRelatedPairs_noOffloading_Help_confAnswer = lowRelatedPairs_noOffloading_Help_allocated{1};
lowRelatedPairs_noOffloading_Help_confAsk = lowRelatedPairs_noOffloading_Help_allocated{2};

lowRelatedPairs_noOffloading_noHelp_allocated = offloadBlockRandomise(lowRelatedPairs_noOffloading_noHelp, 2, 1-r);
lowRelatedPairs_noOffloading_noHelp_confAnswer = lowRelatedPairs_noOffloading_noHelp_allocated{1};
lowRelatedPairs_noOffloading_noHelp_confAsk = lowRelatedPairs_noOffloading_noHelp_allocated{2};

%% Generate presentation sequence for retrieval
[wordRetrievalSequence, conditionRetrievalSequence] = offloadGenPresentSeq(cat(4,cat(3,{highRelatedPairs_Offloading_Help_confAnswer highRelatedPairs_noOffloading_Help_confAnswer; ...
    lowRelatedPairs_Offloading_Help_confAnswer lowRelatedPairs_noOffloading_Help_confAnswer},{highRelatedPairs_Offloading_noHelp_confAnswer highRelatedPairs_noOffloading_noHelp_confAnswer; ...
    lowRelatedPairs_Offloading_noHelp_confAnswer lowRelatedPairs_noOffloading_noHelp_confAnswer}),cat(3,{highRelatedPairs_Offloading_Help_confAsk highRelatedPairs_noOffloading_Help_confAsk; ...
    lowRelatedPairs_Offloading_Help_confAsk lowRelatedPairs_noOffloading_Help_confAsk},{highRelatedPairs_Offloading_noHelp_confAsk highRelatedPairs_noOffloading_noHelp_confAsk; ...
    lowRelatedPairs_Offloading_noHelp_confAsk lowRelatedPairs_noOffloading_noHelp_confAsk})));

%% Confidence rating task
for i=1:trialNum
   % Fixation
    Screen('TextSize',p.frame.ptr,70);
    Screen('TextFont',p.frame.ptr,'Courier New');
    Screen('TextStyle',p.frame.ptr,1);
    DrawText(p.frame.ptr,{'+'},'c');
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    
    if mod(str2double(p.subID{1,1}),2)==1
        [conf, RT_conf] = collectConfidence_selfPaced_withCue_noPoint_RedGreen(p.frame.ptr,p,wordRetrievalSequence{i,1},conditionRetrievalSequence(i,4)); 
    else
        [conf, RT_conf] = collectConfidence_selfPaced_withCue_noPoint_GreenRed(p.frame.ptr,p,wordRetrievalSequence{i,1},conditionRetrievalSequence(i,4)); 
    end
    
    % 500 ms blank screen
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
end

%% Instruction for retrieval
Screen('TextSize',p.frame.ptr,26);
Screen('TextFont',p.frame.ptr,'Consolas');
Screen('TextStyle',p.frame.ptr,0);
DrawFormattedText(p.frame.ptr,['During the memory test, after you rate confidence for recalling each\n\n'...
        'bottom word, you should use the keypad to type the correct bottom word.\n\n'...
        'You need to press Enter key after typing the word.\n\n\n\n'... 
        'For half of the time, you must type the full word by yourself. For the\n\n'...
        'other half of the time, you can decide whether to use the saved pairs\n\n'... 
        'by pressing 1 or 2 before answering.\n\n\n\n'... 
        'Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

DrawFormattedText(p.frame.ptr,['When you choose to use the saved pair, the first two letters of the\n\n'...
        'bottom word will be presented if you have saved this pair during \n\n'...
        'learning. You only need to type the remaining letters of the bottom \n\n'... 
        'word and press Enter. \n\n\n\n'...
        'However, you need to type the full word if you have not saved this pair.\n\n\n\n'...
        'Please consider carefully when to use the saved pair. \n\n\n\n Press space bar to continue. \n\n\n\n'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));
Screen('Flip', p.frame.ptr);

DrawFormattedText(p.frame.ptr,['You will earn 20 points whenever you type a correct bottom word. \n\n'...
    'You will lose 20 points whenever you type an incorrect bottom word. \n\n\n\n'...
    'Each time you choose to use the saved pair, this will cost you 3 points.\n\n\n\n'...
    'You should try to maximise the points in the test. The points you get \n\n'...
    'will be converted into the amount of bonus you will receive.\n\n\n\n'...
    'There will be feedback showing the points you earn or lose for each \n\n'...
    'word pair, and the total number of points you have will be always \n\n'...
    'presented at the bottom of the screen. \n\n\n\n'...
    'Press space bar to continue.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));
Screen('Flip', p.frame.ptr);


DrawFormattedText(p.frame.ptr,['Now you need to practice the memory test. \n\n\n\n Press space bar to start.'],'center', 'center',[255 255 255]);
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));
Screen('Flip', p.frame.ptr);

%% Retrieval process
totalPoints = 0;

% Draw point line & par with zero point
offloadDrawPointBar(totalPoints,p);
Screen('Flip', p.frame.ptr);


for i=1:trialNum
    % Fixation
    Screen('TextSize',p.frame.ptr,70);
    Screen('TextFont',p.frame.ptr,'Courier New');
    Screen('TextStyle',p.frame.ptr,1);
    DrawText(p.frame.ptr,{'+'},'c');
    offloadDrawPointBar(totalPoints,p);
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    
    if mod(str2double(p.subID{1,1}),2)==1
        [conf, RT_conf] = collectConfidence_selfPaced_withCue_RedGreen(p.frame.ptr,p,wordRetrievalSequence{i,1},totalPoints,conditionRetrievalSequence(i,4));
    else
        [conf, RT_conf] = collectConfidence_selfPaced_withCue_GreenRed(p.frame.ptr,p,wordRetrievalSequence{i,1},totalPoints,conditionRetrievalSequence(i,4));
    end
    
    % 500 ms blank screen with cue word
    Screen('TextSize',p.frame.ptr,45);
    Screen('TextFont',p.frame.ptr,'Calibri');
    Screen('TextStyle',p.frame.ptr,1);

    wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
    wordWidth = wordBound(3)-wordBound(1);
    wordHeight = wordBound(4)-wordBound(2);
    Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
    offloadDrawPointBar(totalPoints,p); 
    Screen('Flip', p.frame.ptr);
    WaitSecs(0.5);
    
    
    % Cue word presentation
    Screen('TextSize',p.frame.ptr,45);
    Screen('TextFont',p.frame.ptr,'Calibri');
    Screen('TextStyle',p.frame.ptr,1);
    
    wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
    wordWidth = wordBound(3)-wordBound(1);
    wordHeight = wordBound(4)-wordBound(2);
    Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
    
    offloadDrawPointBar(totalPoints,p);
    
    if conditionRetrievalSequence(i,3)==2 % No-help condition
        % Recall task
        [rec_string,terminatorChar,firstRT,completeRT] = GetEchoString_withRT(p.frame.ptr,'Answer:  ',p.mx-200,p.my+70,[255 255 255],[0 0 0]);
        Screen('Flip', p.frame.ptr);
        
        % Give feedback
        if feedback
           if strcmp(wordRetrievalSequence{i,2},rec_string)
               Screen('TextSize',p.frame.ptr,45);
               Screen('TextFont',p.frame.ptr,'Calibri');
               Screen('TextStyle',p.frame.ptr,1);
               DrawFormattedText(p.frame.ptr,'Correct','center', p.my-50,[255 255 255]);
               DrawFormattedText(p.frame.ptr,['+' num2str(p.correctAnswerPoints)],'center', p.my+50,[255 255 255]);
               totalPoints = totalPoints + p.correctAnswerPoints;
               offloadDrawPointBar(totalPoints,p); 
               Screen('Flip', p.frame.ptr);
               WaitSecs(p.recFeedbackDuration);
           else
               Screen('TextSize',p.frame.ptr,45);
               Screen('TextFont',p.frame.ptr,'Calibri');
               Screen('TextStyle',p.frame.ptr,1);
               DrawFormattedText(p.frame.ptr,'Incorrect','center',p.my-50,[255 255 255]);
               DrawFormattedText(p.frame.ptr,num2str(p.incorrectAnswerPoints),'center', p.my+50,[255 255 255]);
               totalPoints = totalPoints + p.incorrectAnswerPoints;
               offloadDrawPointBar(totalPoints,p); 
               Screen('Flip', p.frame.ptr);
               WaitSecs(p.recFeedbackDuration);               
           end
        end
        
        % Data recording
        results.retrieval{i,1} = wordRetrievalSequence{i,1}; % Cue word
        results.retrieval{i,2} = wordRetrievalSequence{i,2}; % Target word
        results.retrieval{i,3} = 'noHelp'; % Help/noHelp condition
        results.retrieval{i,4} = double(strcmp(wordRetrievalSequence{i,2},rec_string)); % correct or incorrect in recall test
        results.retrieval{i,5} = rec_string; % the answer
        results.retrieval{i,6} = firstRT; % first-key RT
        results.retrieval{i,7} = completeRT; % complete RT
        if results.retrieval{i,4}==1 % Points
            results.retrieval{i,10} = p.correctAnswerPoints;
        else
            results.retrieval{i,10} = p.incorrectAnswerPoints;
        end
        
    elseif conditionRetrievalSequence(i,3)==1 % Help condition
        % Present help/no-help choices
        wordBound = Screen('TextBounds',p.frame.ptr,'1. Answer by yourself');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'1. Answer by yourself',p.mx-wordWidth/2,p.my+50-wordHeight/2,[255 255 255]);
        
        wordBound = Screen('TextBounds',p.frame.ptr,'2. Use saved pair');
        wordWidth = wordBound(3)-wordBound(1);
        wordHeight = wordBound(4)-wordBound(2);
        Screen('DrawText',p.frame.ptr,'2. Use saved pair',p.mx-wordWidth/2,p.my+140-wordHeight/2,[255 255 255]);     
        offloadDrawPointBar(totalPoints,p); 
        Screen('Flip', p.frame.ptr);
        
        % Make help/no-help choice
        KbNameNumList_mainPad = [KbName('1!'); KbName('2@')];
        KbNameNumList_keyPad = [KbName('1'); KbName('2')];
        KbAllowed = [KbNameNumList_mainPad' KbNameNumList_keyPad'];
        while 1
            [help_rt, k, t0, t] = WaitAnyPress(KbAllowed);
            if length(find(k))==1
                break;
            end
        end
        [help_choice_made, ~] = find([KbNameNumList_mainPad KbNameNumList_keyPad]==find(k));
        
        if help_choice_made==1 % Choose no-help
            
            % 500 ms blank screen with cue word
            Screen('TextSize',p.frame.ptr,45);
            Screen('TextFont',p.frame.ptr,'Calibri');
            Screen('TextStyle',p.frame.ptr,1);

            wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
            offloadDrawPointBar(totalPoints,p); 
            Screen('Flip', p.frame.ptr);
            WaitSecs(0.5);
            
            % Recall task        
            Screen('TextSize',p.frame.ptr,45);
            Screen('TextFont',p.frame.ptr,'Calibri');
            Screen('TextStyle',p.frame.ptr,1);

            wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
            offloadDrawPointBar(totalPoints,p); 
            
            [rec_string,terminatorChar,firstRT,completeRT] = GetEchoString_withRT(p.frame.ptr,'Answer:  ',p.mx-200,p.my+70,[255 255 255],[0 0 0]);
            Screen('Flip', p.frame.ptr);
            
            % Give feedback
            if feedback
               if strcmp(wordRetrievalSequence{i,2},rec_string)
                   Screen('TextSize',p.frame.ptr,45);
                   Screen('TextFont',p.frame.ptr,'Calibri');
                   Screen('TextStyle',p.frame.ptr,1);
                   DrawFormattedText(p.frame.ptr,'Correct','center', p.my-50,[255 255 255]);
                   DrawFormattedText(p.frame.ptr,['+' num2str(p.correctAnswerPoints)],'center', p.my+50,[255 255 255]);
                   totalPoints = totalPoints + p.correctAnswerPoints;
                   offloadDrawPointBar(totalPoints,p); 
                   Screen('Flip', p.frame.ptr);
                   WaitSecs(p.recFeedbackDuration);                   
               else
                   Screen('TextSize',p.frame.ptr,45);
                   Screen('TextFont',p.frame.ptr,'Calibri');
                   Screen('TextStyle',p.frame.ptr,1);
                   DrawFormattedText(p.frame.ptr,'Incorrect','center',p.my-50,[255 255 255]);
                   DrawFormattedText(p.frame.ptr,num2str(p.incorrectAnswerPoints),'center', p.my+50,[255 255 255]);
                   totalPoints = totalPoints + p.incorrectAnswerPoints;
                   offloadDrawPointBar(totalPoints,p); 
                   Screen('Flip', p.frame.ptr);
                   WaitSecs(p.recFeedbackDuration);                   
               end
            end
            
            % Data recording
            results.retrieval{i,1} = wordRetrievalSequence{i,1}; % Cue word
            results.retrieval{i,2} = wordRetrievalSequence{i,2}; % Target word
            results.retrieval{i,3} = 'Help'; % Help/noHelp condition
            results.retrieval{i,4} = double(strcmp(wordRetrievalSequence{i,2},rec_string)); % correct or incorrect in recall test
            results.retrieval{i,5} = rec_string; % the answer
            results.retrieval{i,6} = firstRT; % first-key RT
            results.retrieval{i,7} = completeRT; % complete RT
            results.retrieval{i,8} = 0; % help/no-help choice, 0 = no-help, 1 = help
            results.retrieval{i,9} = help_rt; % RT for help/no-help choice
            if results.retrieval{i,4}==1 % Points
                results.retrieval{i,10} = p.correctAnswerPoints;
            else
                results.retrieval{i,10} = p.incorrectAnswerPoints;
            end
            
        elseif help_choice_made==2 % Choose help
            
            % lose points for help
            totalPoints=totalPoints-p.helpLosePoints;
            
            % Cue word presentation
            Screen('TextSize',p.frame.ptr,45);
            Screen('TextFont',p.frame.ptr,'Calibri');
            Screen('TextStyle',p.frame.ptr,1);

            wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);

            
            % Present choices and points
            wordBound = Screen('TextBounds',p.frame.ptr,'1. Answer by yourself');
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,'1. Answer by yourself',p.mx-wordWidth/2,p.my+50-wordHeight/2,[255 255 255]);

            wordBound = Screen('TextBounds',p.frame.ptr,'2. Use saved pair');
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,'2. Use saved pair',p.mx-wordWidth/2,p.my+140-wordHeight/2,[255 255 255]);     
            
            %Present lost points
            Screen('TextSize',p.frame.ptr,35);
            Screen('TextFont',p.frame.ptr,'Calibri');
            Screen('TextStyle',p.frame.ptr,1);
            
            wordBound = Screen('TextBounds',p.frame.ptr,['-' num2str(p.helpLosePoints)]);
            wordWidth = wordBound(3)-wordBound(1);
            wordHeight = wordBound(4)-wordBound(2);
            Screen('DrawText',p.frame.ptr,['-' num2str(p.helpLosePoints)],p.mx-wordWidth/2,p.my+220-wordHeight/2,[255 255 255]);
            
                        
            offloadDrawPointBar(totalPoints,p); 
            Screen('Flip', p.frame.ptr);
            
            WaitSecs(p.showHelpLostDuration)
            
            if conditionRetrievalSequence(i,2)==1 % Offloading condition in encoding
                
                % 500 ms blank screen with cue word
                Screen('TextSize',p.frame.ptr,45);
                Screen('TextFont',p.frame.ptr,'Calibri');
                Screen('TextStyle',p.frame.ptr,1);

                wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
                wordWidth = wordBound(3)-wordBound(1);
                wordHeight = wordBound(4)-wordBound(2);
                Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
                offloadDrawPointBar(totalPoints,p); 
                Screen('Flip', p.frame.ptr);
                WaitSecs(0.5);
            
                % Present Cue word
                Screen('TextSize',p.frame.ptr,45);
                Screen('TextFont',p.frame.ptr,'Calibri');
                Screen('TextStyle',p.frame.ptr,1);
                
                wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
                wordWidth = wordBound(3)-wordBound(1);
                wordHeight = wordBound(4)-wordBound(2);
                Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
                offloadDrawPointBar(totalPoints,p); 
                
                % Recall task with hint
                [rec_string,terminatorChar,firstRT,completeRT] = GetEchoString_withRT(p.frame.ptr,['Answer:  ' wordRetrievalSequence{i,2}(1:p.hintLetterNum)],...
                    p.mx-200,p.my+70,[255 255 255],[0 0 0]);
                Screen('Flip', p.frame.ptr);

                % Give feedback
                if feedback
                   if strcmp(wordRetrievalSequence{i,2}((p.hintLetterNum+1):end),rec_string)
                       Screen('TextSize',p.frame.ptr,45);
                       Screen('TextFont',p.frame.ptr,'Calibri');
                       Screen('TextStyle',p.frame.ptr,1);
                       DrawFormattedText(p.frame.ptr,'Correct','center', p.my-50,[255 255 255]);
                       DrawFormattedText(p.frame.ptr,['+' num2str(p.correctAnswerPoints)],'center', p.my+50,[255 255 255]);
                       totalPoints = totalPoints + p.correctAnswerPoints;
                       offloadDrawPointBar(totalPoints,p); 
                       Screen('Flip', p.frame.ptr);
                       WaitSecs(p.recFeedbackDuration);                       
                   else
                       Screen('TextSize',p.frame.ptr,45);
                       Screen('TextFont',p.frame.ptr,'Calibri');
                       Screen('TextStyle',p.frame.ptr,1);
                       DrawFormattedText(p.frame.ptr,'Incorrect','center',p.my-50,[255 255 255]);
                       DrawFormattedText(p.frame.ptr,num2str(p.incorrectAnswerPoints),'center', p.my+50,[255 255 255]);
                       totalPoints = totalPoints + p.incorrectAnswerPoints;
                       offloadDrawPointBar(totalPoints,p); 
                       Screen('Flip', p.frame.ptr);
                       WaitSecs(p.recFeedbackDuration);                       
                   end
                end

                % Data recording
                results.retrieval{i,1} = wordRetrievalSequence{i,1}; % Cue word
                results.retrieval{i,2} = wordRetrievalSequence{i,2}; % Target word
                results.retrieval{i,3} = 'Help'; % Help/noHelp condition
                results.retrieval{i,4} = double(strcmp(wordRetrievalSequence{i,2}((p.hintLetterNum+1):end),rec_string)); % correct or incorrect in recall test
                results.retrieval{i,5} = rec_string; % the answer
                results.retrieval{i,6} = firstRT; % first-key RT
                results.retrieval{i,7} = completeRT; % complete RT
                results.retrieval{i,8} = 1; % help/no-help choice, 0 = no-help, 1 = help
                results.retrieval{i,9} = help_rt; % RT for help/no-help choice
                if results.retrieval{i,4}==1 % Points
                    results.retrieval{i,10} = p.correctAnswerPoints-p.helpLosePoints;
                else
                    results.retrieval{i,10} = p.incorrectAnswerPoints-p.helpLosePoints;
                end
                
            elseif conditionRetrievalSequence(i,2)==2 % noOffloading condition in encoding
                
                % 500 ms blank screen with cue word
                Screen('TextSize',p.frame.ptr,45);
                Screen('TextFont',p.frame.ptr,'Calibri');
                Screen('TextStyle',p.frame.ptr,1);

                wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
                wordWidth = wordBound(3)-wordBound(1);
                wordHeight = wordBound(4)-wordBound(2);
                Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
                offloadDrawPointBar(totalPoints,p); 
                Screen('Flip', p.frame.ptr);
                WaitSecs(0.5);

                % Recall task        
                Screen('TextSize',p.frame.ptr,45);
                Screen('TextFont',p.frame.ptr,'Calibri');
                Screen('TextStyle',p.frame.ptr,1);

                wordBound = Screen('TextBounds',p.frame.ptr,wordRetrievalSequence{i,1});
                wordWidth = wordBound(3)-wordBound(1);
                wordHeight = wordBound(4)-wordBound(2);
                Screen('DrawText',p.frame.ptr,wordRetrievalSequence{i,1},p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
                offloadDrawPointBar(totalPoints,p); 

                [rec_string,terminatorChar,firstRT,completeRT] = GetEchoString_withRT(p.frame.ptr,'Answer:  ',p.mx-200,p.my+70,[255 255 255],[0 0 0]);
                Screen('Flip', p.frame.ptr);

                % Give feedback
                if feedback
                   if strcmp(wordRetrievalSequence{i,2},rec_string)
                       Screen('TextSize',p.frame.ptr,45);
                       Screen('TextFont',p.frame.ptr,'Calibri');
                       Screen('TextStyle',p.frame.ptr,1);
                       DrawFormattedText(p.frame.ptr,'Correct','center', p.my-50,[255 255 255]);
                       DrawFormattedText(p.frame.ptr,['+' num2str(p.correctAnswerPoints)],'center', p.my+50,[255 255 255]);
                       totalPoints = totalPoints + p.correctAnswerPoints;
                       offloadDrawPointBar(totalPoints,p); 
                       Screen('Flip', p.frame.ptr);
                       WaitSecs(p.recFeedbackDuration);                   
                   else
                       Screen('TextSize',p.frame.ptr,45);
                       Screen('TextFont',p.frame.ptr,'Calibri');
                       Screen('TextStyle',p.frame.ptr,1);
                       DrawFormattedText(p.frame.ptr,'Incorrect','center',p.my-50,[255 255 255]);
                       DrawFormattedText(p.frame.ptr,num2str(p.incorrectAnswerPoints),'center', p.my+50,[255 255 255]);
                       totalPoints = totalPoints + p.incorrectAnswerPoints;
                       offloadDrawPointBar(totalPoints,p); 
                       Screen('Flip', p.frame.ptr);
                       WaitSecs(p.recFeedbackDuration);                   
                   end
                end

                % Data recording
                results.retrieval{i,1} = wordRetrievalSequence{i,1}; % Cue word
                results.retrieval{i,2} = wordRetrievalSequence{i,2}; % Target word
                results.retrieval{i,3} = 'Help'; % Help/noHelp condition
                results.retrieval{i,4} = double(strcmp(wordRetrievalSequence{i,2},rec_string)); % correct or incorrect in recall test
                results.retrieval{i,5} = rec_string; % the answer
                results.retrieval{i,6} = firstRT; % first-key RT
                results.retrieval{i,7} = completeRT; % complete RT
                results.retrieval{i,8} = 1; % help/no-help choice, 0 = no-help, 1 = help
                results.retrieval{i,9} = help_rt; % RT for help/no-help choice
                if results.retrieval{i,4}==1 % Points
                    results.retrieval{i,10} = p.correctAnswerPoints-p.helpLosePoints;
                else
                    results.retrieval{i,10} = p.incorrectAnswerPoints-p.helpLosePoints;
                end
            
            end
        end
    end
    
    if conditionRetrievalSequence(i,4)==1
        results.retrieval{i,13} = 'ConfAnswer';
    else
        results.retrieval{i,13} = 'ConfAsk';
    end
    results.retrieval{i,14} = conf;
    results.retrieval{i,15} = RT_conf;
end

results.retrievalTotalPoints = totalPoints;

% Add information about relatedness and offloading condition into retrieval data
for i=1:trialNum
    results.retrieval{i,11} = results.encoding{strcmp(results.encoding,results.retrieval{i,1}),3}; % relatedness
    results.retrieval{i,12} = results.encoding{strcmp(results.encoding,results.retrieval{i,1}),4}; % offloading condition
end