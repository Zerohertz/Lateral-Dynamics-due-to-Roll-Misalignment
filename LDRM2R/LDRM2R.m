classdef LDRM2R < handle
    properties (SetAccess = private)
        E = 13120e6; % Elastic modulus [Pa]
        w = 0.542; % Web width [m]
        h = 164e-6; % Height [m]

        mur = 0.2; % Coefficient of rotational friction between web and roller
        mul = 0.2; % Coefficient of lateral friction between web and roller
        
        T = 40; % Operating tension [N]
        
        La = 0.6; % Length of section A [m]
        
        a1 = 90; % Wrap angle of idle roller 1 [deg]
        a2 = 90; % Wrap angle of idle roller 2 [deg]

        I; % Moment of inertia
        k; % A parameter, constant for a given operating condition

        F1; % Normal force on idle roller 1 [N]
        F2; % Normal force on idle roller 2 [N]

        status = 1; % Slip condition

        theL1 = 0; % Misaligned angle of misaligned roll
        theL2 = 0; % Misaligned angle of EPC
        
        Lat = 0 %7.5e-3

        sol; % Solution of LDRM4R
    end
    methods (Access = public)
        function obj = LDRM2R()
            obj.UpdateBC();
        end
        function obj = ChangeBC_E(obj, E)
            obj.E = E;
            obj.UpdateBC();
        end
        function obj = ChangeBC_w(obj, w)
            obj.w = w;
            obj.UpdateBC();
        end
        function obj = ChangeBC_h(obj, h)
            obj.h = h;
            obj.UpdateBC();
        end
        function obj = ChangeBC_mu(obj, mu)
            obj.mul = mu(1);
            obj.mur = mu(2);
            obj.UpdateBC();
        end
        function obj = ChangeBC_T(obj, T)
            obj.T = T;
            obj.UpdateBC();
        end
        function obj = ChangeBC_L(obj, L)
            obj.La = L;
            obj.UpdateBC();
        end
        function obj = ChangeBC_a(obj, a)
            obj.a1 = a(1);
            obj.a2 = a(2);
            obj.UpdateBC();
        end
        function obj = ChangeBC_theL(obj, the)
            obj.theL1 = the(1);
            obj.theL2 = the(2);
        end
        function obj = ChangeSC(obj, s)
            obj.status = s;
        end
        function obj = simLD(obj, dL)
            k = obj.k;
            E = obj.E;
            I = obj.I;
            mr1 = obj.w * obj.mur * obj.F1 / 4; % Moment transfer on idle roller 1
            mr2 = obj.w * obj.mur * obj.F2 / 4; % Moment transfer on idle roller 2
            nr1 = obj.mul * obj.F1; % Shear transfer on idle roller 1
            nr2 = obj.mul * obj.F2; % Shear transfer on idle roller 2
            theL1 = obj.theL1 / 180 * pi;
            theL2 = obj.theL2 / 180 * pi;
            status = obj.status;
            Lat = obj.Lat;
            save("SpanInfo.mat", "k", "E", "I", "mr1", "mr2", "nr1", "nr2", "theL1", "theL2", "status", "Lat")
            xmesh = 0:dL:obj.La;
            solinit = bvpinit(xmesh, [0; 0; 0; 0]);
            obj.sol = bvp5c(@(x,y) bvpfcn(x,y), @bcfcn, solinit);
        end
        function obj = plotLD(obj)
            fig = figure;
            set(gcf, 'Color', 'white')
            set(fig, 'Position', [0 100 1800 1200])
            x = obj.sol.y(1,:);
            y = obj.sol.x;
            W = obj.w; % Web width
            p1 = plot(y, x, 'Color', 'black');
            hold on
            p2 = plot(y, x + W, 'Color', 'black');
            y_1 = [y; x];
            y_2 = [y; x + W];
            yzz = [y_1 flip(y_2,2)];
            p3 = fill(yzz(1,:), yzz(2,:), 'black', 'FaceAlpha', .5);
            xlabel("MD [m]")
            ylabel("CMD [m]")
            grid on
%             axis equal
            xlim([-(obj.La)/4 obj.La + (obj.La)/4])
            set(gca, 'FontSize', 20)
            obj.plotRoll(0, "Guider Roll 1", obj.theL1)
%             obj.plotRoll(obj.La, "Idle Roller 1", 0)
%             obj.plotRoll(obj.La + obj.Lb, "Idle Roller 2", 0)
            obj.plotRoll(obj.La, "Guider Roll 2", obj.theL2)
            datatip(p1, obj.La, 0);
        end
        function maxLD = returnLD(obj)
            maxLD = obj.sol.y(1, end);
        end
    end
    methods (Access = private)
        function obj = UpdateBC(obj)
            obj.I = 1/12*(obj.h*obj.w^3);
            obj.k = sqrt(obj.T/(obj.E*obj.I));
            obj.F1 = 2*obj.T*sin(((obj.a1)/180*pi)/2);
            obj.F2 = 2*obj.T*sin(((obj.a2)/180*pi)/2);
        end
        function obj = plotRoll(obj, MD, rollName, theL)
            AA = MD;
            BB = obj.w/2;
            lor = (obj.La)/15;
            loh = obj.w*1.5;
            roll = polyshape([AA - lor / 2 AA - lor / 2 AA + lor / 2 AA + lor / 2], [BB - loh / 2 BB + loh / 2 BB + loh / 2 BB - loh / 2]);
            roll = rotate(roll, theL, [AA BB]);
            plot(roll, 'FaceColor', '#dddddd', 'FaceAlpha', 1);
            [xc,yc] = centroid(roll);
            p = text(xc, yc + obj.w / 1.2, sprintf(rollName, xc, yc), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 18);
%             p = text(xc, yc, sprintf(rollName, xc, yc), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 14);
%             set(p, 'Rotation', -90 + theL)
        end
    end
end
