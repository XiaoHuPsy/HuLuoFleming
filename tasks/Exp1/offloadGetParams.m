function p = offloadGetParams

%% Personal information
p.subID = inputdlg('Please Enter SubjectID','SubjectID');
p.age = inputdlg('Age? ','Age');
p.gender = inputdlg('Gender? M/F','Gender');
p.hand = inputdlg('Handedness? R/L ','Hand');

%% Filename information
p.filename = ['offloadData' p.subID{1} '.mat'];

if IsWin
    dataDir = [pwd '\offloadData\'];
else
    dataDir = [pwd '/offloadData/'];
end
if ~exist('offloadData')
    mkdir offloadData
end

p.filename = [dataDir p.filename];

%% Confidence scale information
p.sittingDist = 40;

p.stim.VASwidth_inDegrees = 20;
p.stim.VASheight_inDegrees = 2;
p.stim.VASoffset_inDegrees = 0;
p.stim.arrowWidth_inDegrees = 0.5;

p.stim.VASwidth_inPixels = degrees2pixels(p.stim.VASwidth_inDegrees, p.sittingDist);
p.stim.VASheight_inPixels = degrees2pixels(p.stim.VASheight_inDegrees, p.sittingDist);
p.stim.VASoffset_inPixels = degrees2pixels(p.stim.VASoffset_inDegrees, p.sittingDist);
p.stim.arrowWidth_inPixels = degrees2pixels(p.stim.arrowWidth_inDegrees, p.sittingDist);

p.times.confDuration_inSecs = 3;
p.times.confFBDuration_inSecs = 0.5;

%% Screen information
p.windowsize=[];
p.BackgroundColor=0;

p.frame = OpenDisplay(p.windowsize,p.BackgroundColor);

[p.mx,p.my] = getScreenMidpoint(p.frame.ptr);

%% Memory paradigm information
p.blockNum = 3;
p.studyDuration = 3;

p.hintLetterNum = 2;

p.recFeedbackDuration = 1.5;

p.correctAnswerPoints = 20;
p.incorrectAnswerPoints = -20;
p.helpLosePoints = 3;

p.onePointLength = 0.4;

p.showHelpLostDuration = 0.8;




p.arithTaskDuration = 180;