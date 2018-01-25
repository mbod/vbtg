function params = ptbsetup(params)

% Get screen index
params.scridx = 0;

% Get color indices
params.white = WhiteIndex(params.scridx);
params.black = BlackIndex(params.scridx);
if strcmp(params.bgname, 'white')
    params.bgcol = params.white;
elseif strcmp(params.bgname, 'black')
    params.bgcol = params.black;
else
    params.bgcol = params.black;
end

% Set resolution
if isfield(params, 'resol')
    Screen('Resolution', params.scridx, ...
        params.resol(1), params.resol(2));
end

% Set sync test
if isfield(params, 'skipsync')
    Screen('Preference', 'SkipSyncTests', ...
        params.skipsync);
end

% Open window
params.win = Screen('OpenWindow', params.scridx, params.bgcol);
Screen('BlendFunction', params.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Get flip interval
params.flipint = Screen('GetFlipInterval', params.win);

% Get screen dimensions
[scrw scrh] = Screen('WindowSize', params.win);
params.centerx = scrw / 2;
params.centery = scrh / 2;

% Set font
if isfield(params, 'deffontsize')
    Screen('TextSize', params.win, params.deffontsize);
end
if isfield(params, 'deffont')
    Screen('TextFont', params.win, params.deffont);
end

% Hide cursor
HideCursor;