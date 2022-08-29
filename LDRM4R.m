classdef LDRM4R < handle
    properties (SetAccess = private)
        E = 2e9; % Elastic modulus [Pa]
        w = 0.258; % Web width [m]
        h = 1.2e-5; % Height [m]

        mur = 0.2; % Coefficient of rotational friction between web and roller
        mul = 0.2; % Coefficient of lateral friction between web and roller
        
        T = 2.7*9.81; % Operating tension [N]
        
        La = 0.5; % Length of section A [m]
        Lb = 0.5; % Length of section B [m]
        Lc = 0.5; % Length of section C [m]

        a1 = 90; % Wrap angle of idle roller 1 [deg]
        a2 = 90; % Wrap angle of idle roller 2 [deg]

        I; % Moment of inertia
        k; % A parameter, constant for a given operating condition

        F1; % Normal force on idle roller 1 [N]
        F2; % Normal force on idle roller 2 [N]

        status = 1; % Slip condition

        theL1 = 0; % Misaligned angle of misaligned roll
        theL2 = 0; % Misaligned angle of EPC

        sol; % Solution of LDRM4R
    end
    methods (Access = public)
        function obj = LDRM4R()
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
            obj.La = L(1);
            obj.Lb = L(2);
            obj.Lc = L(3);
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
            save("SpanInfo.mat", "k", "E", "I", "mr1", "mr2", "nr1", "nr2", "theL1", "theL2", "status")
            xmesh_1 = 0:dL:obj.La;
            xmesh_2 = obj.La:dL:obj.La + obj.Lb;
            xmesh_3 = obj.La + obj.Lb:dL:obj.La + obj.Lb + obj.Lc;
            xmesh = [xmesh_1 xmesh_2 xmesh_3];
            solinit = bvpinit(xmesh, [0; 0; 0; 0]);
            obj.sol = bvp5c(@(x,y,r) bvpfcn(x,y,r), @bcfcn, solinit);
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
            axis equal
            xlim([-(obj.La + obj.Lb + obj.Lc)/10 obj.La + obj.Lb + obj.Lc + (obj.La + obj.Lb + obj.Lc)/10])
            set(gca, 'FontSize', 20)
            obj.plotRoll(0, "Misaligned Roll", obj.theL1)
            obj.plotRoll(obj.La, "Idle Roller 1", 0)
            obj.plotRoll(obj.La + obj.Lb, "Idle Roller 2", 0)
            obj.plotRoll(obj.La + obj.Lb + obj.Lc, "EPC", obj.theL2)
            datatip(p1, obj.La + obj.Lb + obj.Lc, 0);
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
            lor = (obj.La + obj.Lb + obj.Lc)/15;
            loh = obj.w*1.5;
            roll = polyshape([AA - lor / 2 AA - lor / 2 AA + lor / 2 AA + lor / 2], [BB - loh / 2 BB + loh / 2 BB + loh / 2 BB - loh / 2]);
            roll = rotate(roll, theL, [AA BB]);
            plot(roll, 'FaceColor', '#dddddd', 'FaceAlpha', 1);
            [xc,yc] = centroid(roll);
            p = text(xc, yc + obj.w, sprintf(rollName, xc, yc), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 18);
%             p = text(xc, yc, sprintf(rollName, xc, yc), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 14);
%             set(p, 'Rotation', -90 + theL)
        end
    end
end
