classdef Auto < Objet
    properties
        Masse
        Longueur
        Largeur
        Hauteur
        Vitesse
        VitesseAngulaire
    end
    
    methods 
        function obj = Auto()
            obj.Vitesse = [0 0];
            obj.VitesseAngulaire = 0;
        end
    end
end