function dydx = bvpfcn(x,y,region)
load SpanInfo.mat % k

dydx = zeros(4,1);

switch region
    case 1 % La
        dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
    case 2 % Lb
        dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
    case 3 % Lc
        dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
end
end