function [conf, RT] = collectConfidence_selfPaced_withCue_noPoint_GreenRed(window,p,cueWord,confCondition)
KbName('UnifyKeyNames');
curWindow = window;
center = [p.mx p.my];
keys = [KbName('LeftArrow') KbName('RightArrow');];


% Read old textstyle
oldTextsize = Screen('TextSize',p.frame.ptr);
oldTextfont = Screen('TextFont',p.frame.ptr);
oldTextStyle = Screen('TextStyle',p.frame.ptr);


%% Initialise VAS scale
VASwidth=p.stim.VASwidth_inPixels;
VASheight=p.stim.VASheight_inPixels;
VASoffset=p.stim.VASoffset_inPixels;
arrowwidth=p.stim.arrowWidth_inPixels;
arrowheight=arrowwidth*2;

% Collect rating
start_time = GetSecs;
secs = start_time;
max_x = center(1) + VASwidth/2;
min_x = center(1) - VASwidth/2;
range_x = max_x - min_x;
xpos = center(1) + 0.12.*((rand.*VASwidth)-VASwidth/2);
while true
    WaitSecs(.01);
    [keyIsDown,response_time,keyCode] = KbCheck;
    secs = GetSecs;
    if sum(keyCode)==1
        direction = find(keyCode(keys));
        
        if direction == 1
            xpos = xpos - 8;
        elseif direction == 2
            xpos = xpos + 8;
        end
        
        if xpos > max_x
            xpos = max_x;
        elseif xpos < min_x
            xpos = min_x;
        end
        
        if keyCode(KbName('Return')) == 1 % press Enter bar
            break;
        end
    end
    
    
    % Cue word presentation
    Screen('TextSize',p.frame.ptr,45);
    Screen('TextFont',p.frame.ptr,'Calibri');
    Screen('TextStyle',p.frame.ptr,1);
    
    wordBound = Screen('TextBounds',p.frame.ptr,cueWord);
    wordWidth = wordBound(3)-wordBound(1);
    wordHeight = wordBound(4)-wordBound(2);
    Screen('DrawText',p.frame.ptr,cueWord,p.mx-wordWidth/2,p.my-100-wordHeight/2,[255 255 255]);
    
        
    % Draw line
    Screen('DrawLine',curWindow,[255 255 255],center(1)-VASwidth/2,center(2)+VASoffset,center(1)+VASwidth/2,center(2)+VASoffset);
    % Draw left major tick
    Screen('DrawLine',curWindow,[255 255 255],center(1)-VASwidth/2,center(2)+VASoffset+20,center(1)-VASwidth/2,center(2)+VASoffset);
    % Draw right major tick
    Screen('DrawLine',curWindow,[255 255 255],center(1)+VASwidth/2,center(2)+VASoffset+20,center(1)+VASwidth/2,center(2)+VASoffset);
    
    % % Draw minor ticks
    tickMark = center(1) + linspace(-VASwidth/2,VASwidth/2,6);
    Screen('TextSize', curWindow, 35);
    tickLabels = {'1','2','3','4','5','6'};
    for tick = 1:length(tickLabels)
        Screen('DrawLine',curWindow,[255 255 255],tickMark(tick),center(2)+VASoffset+10,tickMark(tick),center(2)+VASoffset);
        DrawFormattedText(curWindow,tickLabels{tick},tickMark(tick)-10,center(2)+VASoffset-60,[255 255 255]);
    end
    
    % Draw confidence text
    if confCondition == 1
        DrawFormattedText(curWindow,'Confidence WITHOUT hint?','center',center(2)+VASoffset+100,[0 255 0]);
    else
        DrawFormattedText(curWindow,'Confidence WITH hint?','center',center(2)+VASoffset+100,[255 0 0]);
    end
    
    % Update arrow
    arrowPoints = [([-0.75 0 0.75]'.*arrowwidth)+xpos ([1.5 0 1.5]'.*arrowheight)+center(2)+VASoffset];
    Screen('FillPoly',curWindow,[255 255 255],arrowPoints);
    
    Screen('Flip', curWindow);
end

conf = ((xpos-center(1))./range_x.*5)+3.5;
RT = secs - start_time;

% Recover old textstyle
Screen('TextSize',p.frame.ptr,oldTextsize);
Screen('TextFont',p.frame.ptr,oldTextfont);
Screen('TextStyle',p.frame.ptr,oldTextStyle);