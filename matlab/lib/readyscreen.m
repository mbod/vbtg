function readyscreen(params, txtcol, waittime, txtsize)

% Default arguments
if nargin < 2 || isempty(txtcol)
    txtcol = [255 255 255];
end
if nargin < 3 || isempty(waittime)
    waittime = 1;
end
if nargin < 4 || isempty(txtsize)
    txtsize = 36;
end

% Listen for spacebar
spacekey = KbName('space');
keys = RestrictKeysForKbCheck(spacekey);

% Set text size
oldtxtsize = Screen('TextSize', params.win, txtsize);

% Draw ready screen
DrawFormattedText(params.win, 'Ready...', ...
    'center', 'center', txtcol);
Screen('Flip', params.win);
KbWait(-1);

% Flip
Screen('Flip', params.win);

% Wait
WaitSecs(waittime);

% Reset responses
RestrictKeysForKbCheck(keys);

% Reset text size
Screen('TextSize', params.win, oldtxtsize);