classdef Systeme < handle
    properties
        Table
        Filet
        Balle
        Sol
        Acceleration
    end
    
    methods
        function obj = Systeme()
            obj.Acceleration = Vecteur(0, 0, 0);
        end
        
        function hauteur = GetHauteurTable(obj)
            hauteur = obj.Table.Point.Z;
        end
    end
end