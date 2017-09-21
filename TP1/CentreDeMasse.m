classdef CentreDeMasse
    methods(Static)

function [centre] = CentreDeMasseCylindre(rayon, hauteur)
% x, y, z
 
centre = [0, 0, hauteur/2];

end

function [centre] = CentreDeMasseCone(rayon, hauteur)

centre = [0, 0, hauteur/4];

end


function [centre] = CentreDeMasseObjets(cm, masses)
    
masseTotale = sum(masses);

centre = [0;0;0];

for i = 1:numel(masses)
    x = cm(i, 1);
    y = cm(i, 2);
    z = cm(i, 3);
    centreI = [x ; y ; z];
    poids = masses(i) / masseTotale;
    centreI = centreI * poids;
    
    centre = centre + centreI;
end

end

    end
end