function [ts tb] = textsize(params, txtstr, varargin)

if nargin >= 3
    xcoord = varargin{1};
else
    xcoord = 0;
end
if nargin >= 4
    ycoord = varargin{2};
else
    ycoord = 0;
end

[nx ny tb] = DrawFormattedText(params.win, txtstr, xcoord, ycoord);
ts = [
    tb(3) - tb(1)
    tb(4) - tb(2)
    ];
Screen('FillRect', params.win, params.bgcol);