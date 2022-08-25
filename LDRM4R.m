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
            theL1 = obj.theL1 / 180 * pi;
            theL2 = obj.theL2 / 180 * pi;
            status = obj.status;
            save("SpanInfo.mat", "k", "E", "I", "theL1", "theL2", "status")
            xmesh_1 = 0:dL:obj.La;
            xmesh_2 = obj.La:dL:obj.La + obj.Lb;
            xmesh_3 = obj.La + obj.Lb:dL:obj.La + obj.Lb + obj.Lc;
            xmesh = [xmesh_1 xmesh_2 xmesh_3];
            solinit = bvpinit(xmesh, [0; 0; 0; 0]);
            obj.sol = bvp5c(@(x,y,r) bvpfcn(x,y,r), @bcfcn, solinit);
        end
        function obj = plotLD(obj)
            plot(obj.sol.x, obj.sol.y(1,:))
        end
    end
    methods (Access = private)
        function obj = UpdateBC(obj)
            obj.I = 1/12*(obj.h*obj.w^3);
            obj.k = sqrt(obj.T/(obj.E*obj.I));
            obj.F1 = 2*obj.T*sin(((obj.a1)/180*pi)/2);
            obj.F2 = 2*obj.T*sin(((obj.a2)/180*pi)/2);
        end
    end
end
