function res = bcfcn(ya, yb)
load SpanInfo.mat % E, I, mr1, mr2, nr1, nr2, theL1, theL2, status
res = [ya(1) - 0; ya(2) - theL1; yb(2) - theL2; yb(3) - 0];
end