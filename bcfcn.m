function res = bcfcn(ya, yb)%, yc)
load SpanInfo.mat % E, I, theL1, theL2, status

switch status
    case 1 % No Slippage
        res = [ya(1,1) - 0; % (1)
        ya(2,1) - theL1; % (2)
        yb(1,1) - ya(1,2); % (3)
        yb(2,1) - 0; % (4)
        ya(2,2) - 0; % (5)
        - E*I*ya(3,2) + E*I*yb(3,1); % (6)
        ya(1,3) - yb(1,2); % (7)
        ya(2,3) - 0; % (8)
        yb(2,2) - 0; % (9)
        - E*I*yb(3,2) + E*I*ya(3,3); % (10)
        yb(2,3) - theL2; % (11)
        yb(3,3) - 0; % (12)
        ];
end
end