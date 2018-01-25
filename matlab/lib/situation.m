function params = situation(params)

params.time = datestr(clock);
params.comp = computer;
if isunix
    params.user = getenv('USER');
else
    params.user = getenv('username');
end