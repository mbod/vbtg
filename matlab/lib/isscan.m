function params = isscan(params)

scan = '';
while isempty(regexp(scan, '^[yn]$', 'once'))
    scan = input('Scanning session? [y|n]\n    ', 's');
end
if strcmp(scan, 'y')
    params.scan = true;
else
    params.scan = false;
end