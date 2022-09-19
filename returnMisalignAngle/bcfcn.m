function res = bcfcn(ya, yb)
load SpanInfo.mat % E, I, mr1, mr2, nr1, nr2, theL1, theL2, status

switch status
    case 1 % No Slippage
        res = [ya(1,1) - Lat; % (1)
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
    case 2 % Circumferential Slippage: Idle roller 1
        res = [ya(1,1) - Lat; % (1)
        ya(2,1) - theL1; % (2)
        yb(1,1) - ya(1,2); % (3)
        yb(2,1) - 0; % (4)
        ya(2,2) - 0; % (5)
        - E*I*ya(3,2) + E*I*yb(3,1) + mr1; % (6)
        ya(1,3) - yb(1,2); % (7)
        ya(2,3) - 0; % (8)
        yb(2,2) - 0; % (9)
        - E*I*yb(3,2) + E*I*ya(3,3); % (10)
        yb(2,3) - theL2; % (11)
        yb(3,3) - 0; % (12)
        ];
    case 3 % Circumferential Slippage: Idle roller 2
        res = [ya(1,1) - Lat; % (1)
        ya(2,1) - theL1; % (2)
        yb(1,1) - ya(1,2); % (3)
        yb(2,1) - 0; % (4)
        ya(2,2) - 0; % (5)
        - E*I*ya(3,2) + E*I*yb(3,1); % (6)
        ya(1,3) - yb(1,2); % (7)
        ya(2,3) - 0; % (8)
        yb(2,2) - 0; % (9)
        - E*I*yb(3,2) + E*I*ya(3,3) + mr2; % (10)
        yb(2,3) - theL2; % (11)
        yb(3,3) - 0; % (12)
        ];
    case 4 % Lateral Slippage: Idle roller 1
        res = [ya(1,1) - Lat; % (1)
        ya(2,1) - theL1; % (2)
        yb(1,1) - ya(1,2); % (3)
        yb(2,1) - ya(2,2); % (4)
        - E*I*ya(4,2) + E*I*yb(4,1) - nr1; % (5)
        - E*I*ya(3,2) + E*I*yb(3,1) + mr1; % (6)
        ya(1,3) - yb(1,2); % (7)
        ya(2,3) - 0; % (8)
        yb(2,2) - 0; % (9)
        - E*I*yb(3,2) + E*I*ya(3,3); % (10)
        yb(2,3) - theL2; % (11)
        yb(3,3) - 0; % (12)
        ];
    case 5 % Lateral Slippage: Idle roller 2
        res = [ya(1,1) - Lat; % (1)
        ya(2,1) - theL1; % (2)
        yb(1,1) - ya(1,2); % (3)
        yb(2,1) - 0; % (4)
        ya(2,2) - 0; % (5)
        - E*I*ya(3,2) + E*I*yb(3,1); % (6)
        ya(1,3) - yb(1,2); % (7)
        ya(2,3) - yb(2,2); % (8)
        - E*I*yb(4,2) + E*I*ya(4,3) - nr1; % (9)
        - E*I*yb(3,2) + E*I*ya(3,3) + mr2; % (10)
        yb(2,3) - theL2; % (11)
        yb(3,3) - 0; % (12)
        ];
end
end