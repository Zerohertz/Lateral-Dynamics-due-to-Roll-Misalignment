function res = bcfcn(ya, yb)
load Span.mat
load fittedFunctions.mat
load status.mat

switch stats
    case 1 % No Slippage
        res = [ya(1,1) - 0;
        ya(2,1) - 0;
        yb(1,1) - ya(1,2);
        yb(2,1) - 0;
        ya(2,2) - 0;
        - feval(f_ME, La)*I*ya(3,2) + feval(f_ME, La)*I*yb(3,1);
    %     -ya(3,2) + Mr + yb(3,1);
        yb(2,2) - theL;
        yb(3,2) - 0];
    case 2 % Circumferential Slippage
        res = [ya(1,1) - 0;
        ya(2,1) - 0;
        yb(1,1) - ya(1,2);
        yb(2,1) - 0;
        ya(2,2) - 0;
        - feval(f_ME, La)*I*ya(3,2) + W*mur*F/4 + feval(f_ME, La)*I*yb(3,1);
    %     -ya(3,2) + Mr + yb(3,1);
        yb(2,2) - theL;
        yb(3,2) - 0];
    case 3 % Lateral Slippage
        res = [ya(1,1) - 0;
        ya(2,1) - 0;
        yb(1,1) - ya(1,2);
        yb(2,1) - ya(2,2);
        - feval(f_ME, La)*I*ya(4,2) - mul*F + feval(f_ME, La)*I*yb(4,1);
        - feval(f_ME, La)*I*ya(3,2) + W*mur*F/4 + feval(f_ME, La)*I*yb(3,1);
    %     -ya(3,2) + Mr + yb(3,1);
        yb(2,2) - theL;
        yb(3,2) - 0];
end
end