classdef Cone < Solide
   
    properties 
        Rayon
        Hauteur
    end
    
    methods
        function cone = Cone()
            cone = cone@Solide();
            cone.Rayon = 0;
            cone.Hauteur = 0;
        end
        
        function v = CalculerVolume(obj) 
            v = 1/3 * pi * obj.Rayon ^ 2 * obj.Hauteur;
        end
    end
    
end