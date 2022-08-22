function [Sol, tit] = simLat(theL)
W = 0.258;
T = 2.7*9.81; %
F = 2*T*sin(((45)/180*pi)/2); %
mur = 0.2; %
mul = 0.08; %
h = 1.2e-5;
I = 1/12*(h*W^3);
L = 13.6;
La = 5.7;
Lb = L - La;
% K=sqrt(T/(E*I));

save("SpanInfo.mat", "T", "I")

load fittedFunctions.mat

K = sqrt(T/(feval(f_ME, La)*I));

Q1 = (mul * F) / (K * T);
Q2 = (W * mur * F) / (4 * T);

the_M = (Q2*K*(cosh(K*Lb)-1)) / (sinh(K*Lb)) /pi*180
the_ML = [Q1*(cosh(K*Lb)-1) + Q2*sinh(K*La)] * (K*(cosh(K*Lb)-1)) / (cosh(K*L) - cosh(K*Lb)) /pi*180

if theL < the_M
    stats = 1
    tit = "No Slippage";
    save("status.mat", "stats");
elseif the_M < theL && theL < the_ML
    stats = 2
    tit = "Circumferential Slippage";
    save("status.mat", "stats");
elseif the_ML < theL
    stats = 3
    tit = "Lateral Slippage";
    save("status.mat", "stats");
else
    stats = 4
    save("status.mat", "stats");
end

xmesh_1 = 0:0.1:La;
xmesh_2 = La:0.1:La+Lb;

xmesh_fin = [xmesh_1 xmesh_2];
solinit = bvpinit(xmesh_fin, [0; 0; 0; 0]);

theL = theL / 180*pi
save("Span.mat", "theL", "W", "F", "mur", "mul", "I", "La")

Sol = bvp5c(@(x,y,r) bvpfcn(x,y,r), @bcfcn, solinit);
end