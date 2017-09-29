classdef Balle < Objet

    properties
        CentreDeMasse
        Masse
        Rayon
        Vitesse
    end
    
    methods
        function obj = Balle()
            obj = obj@Objet();
            obj.CentreDeMasse = [0 0 0];
            obj.Masse = 0;
            obj.Rayon = 0;
            obj.Vitesse = [0 0 0];
        end
    end
end