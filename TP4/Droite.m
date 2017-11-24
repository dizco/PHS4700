classdef Droite < matlab.mixin.Copyable
    properties
        Point
        Pente
    end
    
    methods
        function obj = Droite()
            obj.Point = Vecteur(0, 0, 0);
            obj.Pente = Vecteur(0, 0, 0);
        end
    end
end