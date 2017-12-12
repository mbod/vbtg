function cyberball

%% Parameters

% Initialize params
params = struct();

params.resol = [ 800 600 ];
params.skipsync = 1;
params.bgname = 'white';

% Timing params
params.disdelay     = 8.0;
params.fixdur       = 16.0;
params.rundur       = 178;
params.decdur       = [ 0.5 3.0 ];
params.framedur     = 0.15;
params.pausedur     = 0.45;
params.nstars       = 105;

% Path params
mfile = which('cyberball');
mpath = fileparts(mfile);
params.root         = mpath;
params.logdir       = sprintf('%s/log', params.root);

% Include utilities
addpath(sprintf('%s/../lib', params.root));

% Task params
params.maxtrials    = 128;
params.nfairtrials  = 8;
params.fixsiz       = 15;
params.fixcol       = [ 0 0 0 ];

% Star params
params.nsteps = 7;
params.points = [
    -200 -200
    200 -200
    0 200
    ];

% Position params
params.cnameoffx    = 300;
params.cnameoffy    = -50;
params.sceneoffy    = -50;
params.pnameoffy    = 100;
params.cfaceoffy    = -200;
params.msgoffy      = -175;

% Font params
params.deffont      = 'Helvetica';
params.deffontsize  = 30;

% Get keys
p1key = KbName('2@');
p3key = KbName('3#');
respkeys = [p1key p3key];

%% Log parameters

params = makelog(params);
params = isscan(params);

params.playname = input('Input MRI subject name\n', 's');
params.p1name = input('Input player 1 subject name\n', 's');
params.p2name = input('Input player 2 subject name\n', 's');

% Situation params
params = situation(params);

% PTB setup
params = ptbsetup(params);

%% Load images

DrawFormattedText(params.win, 'Loading...', ...
    'center', 'center', params.black);
Screen('Flip', params.win);

imgs = { ...
    '1to2' ...
    '1to3' ...
    '2to1' ...
    '2to3' ...
    '3to1' ...
    '3to2' ...
    'start' ...
    };
imgdir = sprintf('%s/imgs', params.root);

imgmat = struct();
imgtex = struct();

for imgidx = 1 : length(imgs)
    
    img = imgs{imgidx};
    imgname = sprintf('i%s', img);
    imgfiles = dir(sprintf('%s/%s/*.bmp', imgdir, img));
    imgfiles = {imgfiles.name};
    
    for frameidx = 1 : length(imgfiles)
    
        imgfile = sprintf('%s/%s/%s', imgdir, img, imgfiles{frameidx});
        [mtx map] = imread(imgfile);
        rgbmtx = nan([size(mtx, 1) size(mtx, 2) 3]);
        for rgbidx = 1 : 3
            rgbmtx(:, :, rgbidx) = reshape(map(mtx + 1, rgbidx), ...
                size(mtx, 1), size(mtx, 2));
        end
        
        imgmat.(imgname){frameidx} = rgbmtx;
        imgtex.(imgname){frameidx} = Screen('MakeTexture', ...
            params.win, imgmat.(imgname){frameidx} .* 255);
        
    end
    
end

starfile = sprintf('%s/ctrl/star.jpg', imgdir);
imgmat.star = imread(starfile);
imgtex.star = Screen('MakeTexture', params.win, imgmat.star);

%% Text box sizes

ts = struct();
ts.play = textsize(params, params.playname);
ts.p1 = textsize(params, params.p1name);
ts.p2 = textsize(params, params.p2name);

% Set keys
RestrictKeysForKbCheck(respkeys);

% Get session duration
params.sessdur = ...
    (params.nstars / params.nsteps) * (params.nsteps * params.framedur + params.pausedur) + ...
    (params.nstars / params.nsteps) * (params.nsteps * params.framedur + params.pausedur) + ...
    (params.nstars / params.nsteps) * (params.nsteps * params.framedur + params.pausedur) + ...
    (params.nstars / params.nsteps) * (params.nsteps * params.framedur + params.pausedur) + ...
    params.fixdur + ...
    params.rundur + 4.0 + ...
    params.fixdur + ...
    params.rundur + 4.0 + ...
    params.fixdur;
if params.scan
    params.sessdur = params.sessdur + ...
        params.disdelay;
end

% Initialize trials
trials = {};

% Show ready screen
readyscreen(params, params.black);

% Trigger scanner
params = mritrigger(params);
tic
% Present disdaq interval
if params.scan
    showfix(params);
    Screen('Flip', params.win);
    WaitSecs(params.disdelay - ...
        (GetSecs - params.triggertime));
end

ctrlfair = [ 
    1.0 0.5 0.5
    0.5 1.0 0.5
    0.5 0.5 1.0
    ];
ctrlunfair = [ 
    1 0.9 0.1
    0.9 1 0.1
    0.5 0.5 1
    ];

% Star
[trials{1} nextidx] = ctrltrial(ctrlfair, 1);
[trials{2} nextidx] = ctrltrial(ctrlunfair, nextidx);
[trials{3} nextidx] = ctrltrial(ctrlfair, nextidx);
trials{4} = ctrltrial(ctrlunfair, nextidx);

% Save state
save(params.savename, 'trials', 'params');

% Fixation
secs = GetSecs;
showfix(params);
Screen('Flip', params.win);
WaitSecs(params.fixdur - (GetSecs - secs));

% Save state
save(params.savename, 'trials', 'params');

% Fixation
secs = GetSecs;
showfix(params);
Screen('Flip', params.win);
WaitSecs(params.fixdur - (GetSecs - secs));

% Fair
t0fair = GetSecs;
trials{5} = cybertrial('fair', 1);

% Save state
save(params.savename, 'trials', 'params');

% Fixation
secs = GetSecs;
showfix(params);
Screen('Flip', params.win);
WaitSecs((params.rundur + params.fixdur) - ...
    (GetSecs - t0fair));

% Unfair
trials{6} = cybertrial('unfair', 2);

% Save state
save(params.savename, 'trials', 'params');

% Fixation
secs = GetSecs;
showfix(params);
Screen('Flip', params.win);
WaitSecs((params.sessdur) - ...
    (GetSecs - params.triggertime));
toc

% Save state
save(params.savename, 'trials', 'params');

% toplay = [];
% for trialidx = 1 : length(trials{6})
%     toplay(trialidx) = trials{6}{trialidx}.toplay;
% end
% lastfair = find(toplay == 2, 1, 'last');
% disp(trials{6}{lastfair + 1});

%%

% Cleanup
ptbcleanup;

%%

function [ctrltrials nextidx] = ctrltrial(xprob, nextidx)
    
    ctrltrials = {};
    
    begtime = GetSecs;
    
    for stepidx = 1 : params.nstars
        
        modidx = mod(stepidx - 1, 7) + 1;
        
        % Get direction
        if modidx == 1
            curridx = nextidx;
            nextidx = setdiff(1 : 3, curridx);
            nextidx = nextidx((rand > xprob(curridx, nextidx(1))) + 1);
        end
        
        % Get star coords
        pos = params.points(curridx, :) + ...
            (params.points(nextidx, :) - params.points(curridx, :)) .* ...
            ((modidx - 1) / params.nsteps);
        
        % Get star rect
        rct = getscrct(imgmat.star, params.centerx + pos(1), ...
            params.centery + pos(2), 100, -1);
        
        % Draw star
        Screen('DrawTexture', params.win, imgtex.star, [], rct);
        
        % Flip
        secs = Screen('Flip', params.win);
        
        % Pause
        if modidx == 1
            WaitSecs(params.framedur + params.pausedur - ...
                (GetSecs - begtime));
        else
            WaitSecs(params.framedur - ...
                (GetSecs - begtime));
        end
        
        % Log trial
        ctrltrials{stepidx} = struct( ...
            'secs', secs, ...
            'onset', secs - params.triggertime, ...
            'type', 'star', ...
            'pos', pos ...
            );
        
        begtime = GetSecs;
        
    end
    
end

function cybertrials = cybertrial(cybertype, roundidx)
    
    % Initialize trials
    cybertrials = {};
    
    t0 = GetSecs;
    
    % Show round number
    cybershow('istart', 1, 2.0, GetSecs, ...
        sprintf('Round %d', roundidx));
    cybershow('istart', 1, 2.0, GetSecs);
    
    player = 1;
    npcidx = 1;
    
    fairbase = repmat([0 1], 1, 4);
    fairshare = [];
    while length(fairshare) < params.maxtrials
        fairshare = horzcat(fairshare, ...
            fairbase(randperm(length(fairbase))));
    end
    
    for throwidx = 1 : inf
        
        tstart = GetSecs;
        if (tstart - t0) >= (params.rundur - 5)
            break;
        end
        
        if player == 2
            
            % Wait for response
            [secs keycode] = KbWaitUntil(-1, 0, ...
                params.rundur - 5 - (GetSecs - t0));
            if find(keycode, 1) == p1key
                toplay = 1;
                rt = secs - tstart;
            elseif find(keycode, 1) == p3key
                toplay = 3;
                rt = secs - tstart;
            else
                break;
            end
            
            cyberthrow(player, toplay);
            fromplay = player;
            player = toplay;
            
        else
            
            % Get decision duration
            decdur = params.decdur(1) ...
                + (params.decdur(2) - params.decdur(1)) ...
                * rand;
            rt = decdur;
            WaitSecs(decdur);
            
            % Get recipient
            if fairshare(npcidx) == 0 || ...
                    (strcmp(cybertype, 'unfair') && ...
                    throwidx > params.nfairtrials)
                toplay = setdiff([1 3], player);
            else
                toplay = 2;
            end
            
            % Throw to recipient
            cyberthrow(player, toplay);
            fromplay = player;
            player = toplay;
            
            npcidx = npcidx + 1;
            
        end
        
        % Log trial
        cybertrials{throwidx} = struct( ...
            'secs', tstart, ...
            'time', datestr(clock), ...
            'onset', tstart - params.triggertime, ...
            'rt', rt, ...
            'type', 'cyberball', ...
            'fairness', cybertype, ...
            'fromplay', fromplay, ...
            'toplay', toplay ...
            );
        
    end
    
    WaitSecs(params.rundur - (GetSecs - t0));
    
end

function cyberthrow(fromplay, toplay)
    
    anim = sprintf('i%dto%d', fromplay, toplay);
    begtime = GetSecs;
    
    for frameidx = 1 : length(imgtex.(anim))
        
        begtime = cybershow(anim, frameidx, params.framedur, begtime);
        
    end
    
end

function endtime = cybershow(anim, frameidx, dur, begtime, msg)
    
    % Get destination rectangle
    dstrct = [0 0 size(imgmat.(anim){1}, 2) size(imgmat.(anim){1}, 1)];
    dstrct = CenterRectOnPoint(dstrct, params.centerx, ...
        params.centery + params.sceneoffy);
    
    % Draw scene
    Screen('DrawTexture', params.win, ...
        imgtex.(anim){frameidx}, [], dstrct);
    
    % Draw names
    DrawFormattedText(params.win, params.playname, 'center', ...
        params.centery + params.pnameoffy);
    DrawFormattedText(params.win, params.p1name, ...
        params.centerx - params.cnameoffx - ts.p1(1) / 2, ...
        params.centery + params.cnameoffy);
    DrawFormattedText(params.win, params.p2name, ...
        params.centerx + params.cnameoffx - ts.p2(1) / 2, ...
        params.centery + params.cnameoffy);
    
    if nargin > 4
        DrawFormattedText(params.win, msg, 'center', ...
            params.centery + params.msgoffy);
    end
    
%     % Draw fixation
%     showfix(params);
    
    Screen('Flip', params.win);
    endtime = WaitSecs(dur - (GetSecs - begtime));
    
end

end