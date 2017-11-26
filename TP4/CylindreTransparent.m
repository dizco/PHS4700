classdef CylindreTransparent < handle
    properties
        Centre
        Hauteur
        Rayon
    end
    
    methods
        function obj = CylindreTransparent()
        end
        
        function borne = GetBorneInferieureZ(obj)
            borne = obj.Centre.Z - obj.Hauteur / 2;
        end
        
        function borne = GetBorneSuperieureZ(obj)
            borne = obj.Centre.Z + obj.Hauteur / 2;
        end
    end
end