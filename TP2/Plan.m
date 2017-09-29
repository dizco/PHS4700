classdef Plan < Objet
    % Reference http://mathworld.wolfram.com/Plane.html
    % Equation d'un plan : ax + by + cz + d = 0, ou (a, b, c) est la normale et (x, y, z) un point du plan
    
    properties
        Normale
        Point
        Bornes
    end
    
    methods
        function obj = Plan()
            obj = obj@Objet();
            obj.Normale = [0; 0; 0];
            obj.Point = [0; 0; 0; 0];
            obj.Bornes = [-Inf, Inf; -Inf, Inf; -Inf, Inf];
        end
        
        function distance = DistanceAuPoint(obj, point)
            % Equation de la distance a un point : (ax + by + cz + d) / sqrt(a^2 + b^2 + c^2)
            d = -obj.Normale(1) * obj.Point(1) - obj.Normale(2) * obj.Point(2) - obj.Normale(3) * obj.Point(3);
            distance = (obj.Normale(1) * point(1) + obj.Normale(2) * point(2) + obj.Normale(3) * point(3) + d) / sqrt(obj.Normale(1)^2 + obj.Normale(2)^2 + obj.Normale(3)^2);
        end
        
        function respecteBornes = RespecteBornes(obj, point)
            % Indique si le point donné est contenu à l'intérieur des bornes du plan
            
            respecteBornes = true;
            if (obj.Bornes(1, 1) > point(1) || obj.Bornes(1, 2) < point(1))
                respecteBornes = false;
            end
            
            if (obj.Bornes(2, 1) > point(2) || obj.Bornes(2, 2) < point(2))
                respecteBornes = false;
            end
            
            if (obj.Bornes(3, 1) > point(3) || obj.Bornes(3, 2) < point(3))
                respecteBornes = false;
            end
        end
        
        function respecteBornes = RespecteBornesAvecTolerance(obj, point, tolerance)
            % Indique si le point donné est contenu à l'intérieur des bornes du plan
            % La tolerance sert lorsqu'on a une balle et que le point fourni est le centre de masse
            
            respecteBornes = true;
            if (obj.Bornes(1, 1) > (point(1) + tolerance) || obj.Bornes(1, 2) < (point(1) - tolerance))
                respecteBornes = false;
            end
            
            if (obj.Bornes(2, 1) > (point(2) + tolerance) || obj.Bornes(2, 2) < (point(2) - tolerance))
                respecteBornes = false;
            end
            
            if (obj.Bornes(3, 1) > (point(3) + tolerance) || obj.Bornes(3, 2) < (point(3) - tolerance))
                respecteBornes = false;
            end
        end
    end
end