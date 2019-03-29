function offloadDrawPointBar(totalPoints,p)
%

% Read old textstyle
oldTextsize = Screen('TextSize',p.frame.ptr);
oldTextfont = Screen('TextFont',p.frame.ptr);
oldTextStyle = Screen('TextStyle',p.frame.ptr);

% Draw totalPoints number
Screen('TextSize',p.frame.ptr,30);
Screen('TextFont',p.frame.ptr,'Calibri');
Screen('TextStyle',p.frame.ptr,0);

wordBound = Screen('TextBounds',p.frame.ptr,num2str(totalPoints));
wordWidth = wordBound(3)-wordBound(1);
wordHeight = wordBound(4)-wordBound(2);
Screen('DrawText',p.frame.ptr,num2str(totalPoints),p.mx+totalPoints*p.onePointLength-wordWidth/2,p.my+300-wordHeight/2,[255 255 255]);

% Draw line
Screen('DrawLine',p.frame.ptr,[255 255 255],p.mx+totalPoints*p.onePointLength,p.my+305+wordHeight/2,...
    p.mx+totalPoints*p.onePointLength,p.my+350+wordHeight/2,2);

% Draw zero line
Screen('DrawLine',p.frame.ptr,[255 255 255],p.mx,p.my+305+wordHeight/2,...
    p.mx,p.my+350+wordHeight/2,2);

% Draw bar between the two lines
Screen('FillRect',p.frame.ptr,[255 255 255],[min(p.mx+totalPoints*p.onePointLength,p.mx) p.my+310+wordHeight/2 ...
    max(p.mx+totalPoints*p.onePointLength,p.mx) p.my+345+wordHeight/2]);

% Recover old textstyle
Screen('TextSize',p.frame.ptr,oldTextsize);
Screen('TextFont',p.frame.ptr,oldTextfont);
Screen('TextStyle',p.frame.ptr,oldTextStyle);