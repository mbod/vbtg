function params = mritrigger(params)

try

    % Set up serial port
    PORT = 1;
    
    % Close serial port
    SerialComm('close', PORT);
    
    % Open serial port
    SerialComm('open',PORT,'9600,n,8,1');
    
    % Flush buffers
    SerialComm('purge', PORT);

    % Serial trigger
    SerialComm('write', PORT, 255);
    
    % Close serial port
    SerialComm('close', PORT);
    
catch
    
    warning('Couldn''t trigger serial port');
    
end

% Log trigger time
if isfield(params, 'triggertime')
    params.triggertime = horzcat(params.triggertime, GetSecs);
else
    params.triggertime = GetSecs;
end