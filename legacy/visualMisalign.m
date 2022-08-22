function [] = visualMisalign(sol, tit, theL, I, La, Lb, W, dT)
load fittedFunctions.mat

ya = sol.y(1,:);
xa = sol.x;
E = feval(f_ME, sol.x);
ma = -E'.*I.*sol.y(3,:);

y = 0 * xa;

subplot(1,3,2)

title([tit, append("\theta_L [deg]: ", string(theL))])

subplot(1,3,1)

p1 = plot(y, xa, 'Color', 'black');
hold on
p2 = plot(y + W, xa, 'Color', 'black');
y_1 = [y; xa];
y_2 = [y+W; xa];
yzz = [y_1 flip(y_2,2)];
p3 = fill(yzz(1,:), yzz(2,:), 'black', 'FaceAlpha', .5);

subplot(1,3,1)
p4 = plot(ya, xa, 'Color', 'black');

hold on

p5 = plot(ya+W, xa, 'Color', 'black');

ya_1 = [ya; xa];
ya_2 = [ya+W; xa];

yaa = [ya_1 flip(ya_2,2)];

p6 = fill(yaa(1,:), yaa(2,:), 'r', 'FaceAlpha', .3);

ylim([-(La)/10 La + Lb + (La)/10])
% xlim([min(ya)-W max(ya+W)+W])
xlim([-1 2.5])

grid on
axis equal

xlabel("CMD [m]")
ylabel("MD [m]")

set(gca, 'FontSize', 20)

subplot(1,3,2)

p7 = plot(ma, xa, 'Color', 'r', 'LineWidth', 2);

hold on
grid on

xlabel("Moment [Nm]")
ylabel("MD [m]")

ylim([-(La)/10 La + Lb + (La)/10])

m = min([min(ma)]); 
M = max([max(ma)]);
% xlim([m - (M-m)/10 M + (M-m)/10])
xlim([-9 6])

set(gca, 'FontSize', 20)

subplot(1,3,3)

na = -E'.*I.*sol.y(4,:);

p8 = plot(na, xa, 'Color', 'r', 'LineWidth', 2);

hold on
grid on
ylim([-(La)/10 La + Lb + (La)/10])
xlim([-5 4])

xlabel("Shear [N]")
ylabel("MD [m]")
set(gca, 'FontSize', 20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(1,3,1)

AA = 0 + W/2;
BB = 0;

lor = 3;
loh = 0.5;

roll1 = polyshape([AA - lor / 2 AA - lor / 2 AA + lor / 2 AA + lor / 2], [BB - loh / 2 BB + loh / 2 BB + loh / 2 BB - loh / 2]);

p9 = plot(roll1, 'FaceColor', 'black');

[xc,yc] = centroid(roll1);
p10 = text(xc, yc, sprintf('Roll 1', xc, yc), 'HorizontalAlignment','center', 'VerticalAlignment','middle', 'Color','white', 'FontSize', 16)

AA = W/2;
BB = La;

roll2 = polyshape([AA - lor / 2 AA - lor / 2 AA + lor / 2 AA + lor / 2], [BB - loh / 2 BB + loh / 2 BB + loh / 2 BB - loh / 2]);

p11 = plot(roll2, 'FaceColor', 'black');

[xc,yc] = centroid(roll2);
p12 = text(xc, yc, sprintf('Roll 2', xc, yc), 'HorizontalAlignment','center', 'VerticalAlignment','middle', 'Color','white', 'FontSize', 16)

AA = W/2;
BB = La + Lb;

roll3 = polyshape([AA - lor / 2 AA - lor / 2 AA + lor / 2 AA + lor / 2], [BB - loh / 2 BB + loh / 2 BB + loh / 2 BB - loh / 2]);
roll3 = rotate(roll3, -theL, [AA BB])

p13 = plot(roll3, 'FaceColor', 'black');

[xc,yc] = centroid(roll3);
p14 = text(xc, yc, sprintf('Roll 3', xc, yc), 'HorizontalAlignment','center', 'VerticalAlignment','middle', 'Color','white', 'FontSize', 16)
set(p14, 'Rotation', -theL)

pause(dT)

delete(p1)
delete(p2)
delete(p3)
delete(p4)
delete(p5)
delete(p6)
delete(p7)
delete(p8)
delete(p9)
delete(p10)
delete(p11)
delete(p12)
delete(p13)
delete(p14)
end

