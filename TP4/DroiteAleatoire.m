function droite = DroiteAleatoire(pointObservateur, systeme)
    [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme)
    angleVertical = 10; %TODO: Assigner nombre aleatoire contenu dans le rangeVertical
    angleHorizontal = 10; %TODO: Assigner nombre aleatoire contenu dans le rangeHorizontal
    
    droite = Droite();
    droite.Point = pointObservateur;
    droite.Pente = Vecteur(0, 0, 0); %TODO: Calculer l'equation de la droite a partir des angles
end

function [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme)
    %TODO: Calculer le range de valeurs possibles
    rangeVertical = [20, 40];
    rangeHorizontal = [20, 40];
    Centre = systeme.CylindreTransparent.Centre;
    disp("centre du cylindre:");
    disp(Centre);
end