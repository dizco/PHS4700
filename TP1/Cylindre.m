classdef Cylindre < Solide
   
    properties 
        Rayon
        Hauteur
    end
    
    methods
        function cyl = Cylindre()
            cyl = cyl@Solide();
            cyl.Rayon = 0;
            cyl.Hauteur = 0;
        end
    end
    
end