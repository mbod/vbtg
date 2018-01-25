function rct = getscrct(mat, cx, cy, nx, ny)

x0 = size(mat, 2);
y0 = size(mat, 1);

if nx == -1
    nx = x0 * (ny / y0);
end
if ny == -1
    ny = y0 * (nx / x0);
end

rct = [0 0 nx ny];
rct = CenterRectOnPoint(rct, cx, cy);