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
    end
    
end