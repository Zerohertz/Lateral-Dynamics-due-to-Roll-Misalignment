function dydx = bvpfcn(x,y,region)
load SpanInfo.mat
load fittedFunctions.mat

dydx = zeros(4,1);

k = sqrt(T/(feval(f_ME, x)*I));

switch region
    case 1
        dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
    case 2
        dydx(1:4,1) = [y(2); y(3); y(4); k^2*y(3)];
end
end