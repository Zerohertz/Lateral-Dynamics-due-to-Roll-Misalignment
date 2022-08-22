%%

endAngle = 10;
delAngle = 0.01;

[sims, tit] = simLatRealTime(endAngle, delAngle);

%%

W = 0.258;
h = 1.2e-5;
I = 1/12*(h*W^3);
L = 13.6;
La = 5.7;
Lb = L - La;

theL = 0:delAngle:endAngle;

%%

fig = figure
set(gcf, 'Color', 'white')
set(fig, 'Position', [2500 300 1800 1200])

pause(10)

xlabel('Time [sec]')
ylabel('Web Tension [kgf]')
set(gca, 'FontSize', 16)

for i = 1:710
    visualMisalign(sims{i}, tit(i), theL(i), I, La, Lb, W, 0.01)
end

%%

theL = 4.167

[sims, tit] = simLat(theL);

%%


visualMisalign(sims, tit, theL, I, La, Lb, W, 20)