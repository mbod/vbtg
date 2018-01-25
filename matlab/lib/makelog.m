function params = makelog(params, varargin)

if nargin >= 2
    apptxt = varargin{1};
else
    apptxt = '';
end

% Get subject name
params.subjname = input('Input subject ID\n    ', 's');

% Check log directory
if ~exist(params.logdir, 'dir')
    mkdir(params.logdir);
end

% Get log name
savenum = 1;
params.savename = sprintf('%s/%s%s_%d.mat', ...
    params.logdir, params.subjname, apptxt, savenum);
while exist(params.savename, 'file') == 2
    savenum = savenum + 1;
    params.savename = sprintf('%s/%s%s_%d.mat', ...
        params.logdir, params.subjname, apptxt, savenum);
end