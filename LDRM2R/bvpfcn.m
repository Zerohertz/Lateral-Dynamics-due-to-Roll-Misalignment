function dydx = bvpfcn(x,y)
load SpanInfo.mat % k

dydx = zeros(4,1);
dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
end