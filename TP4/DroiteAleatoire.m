% À partir de SimulerRayon.m
% Étape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OPÉRATIONS.
        % a. On trouve le range. (Angle max et Angle min) V
        % b. On sélectionne N et M pour polaire et azimutal. Pas ma partie?
        % c. b) nous retourne les VARIATION comme valeurs.
        % d. On boucle tant que i < N et j < M, en boucles imbriquées.
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite à shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
function droite = DroiteAleatoire(pointObservateur, systeme, M, N, m, n)
    droite = Droite();
    droite.Point = pointObservateur;
    
    [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme);
    angleVerticalAleatoire = (rangeVertical(2)-rangeVertical(1)).*rand(1) + rangeVertical(1);
    angleHorizontalAleatoire = (rangeHorizontal(2)-rangeHorizontal(1)).*rand(1) + rangeHorizontal(1);
    droite.Pente = VecteurDirecteurUnitaire(angleVerticalAleatoire, angleHorizontalAleatoire);
end

function [x, y, z] = VecteurDirecteurUnitaire(angleVertical, angleHorizontal)
    xResolution = 0.01;
    composanteY = xResolution * tand(angleHorizontal);
    hypothenuseXY = sqrt(xResolution^2 + composanteY^2);
    composanteZ = hypothenuseXY / tand(angleVertical);
    
    norme = sqrt(xResolution^2 + composanteY^2 + composanteZ^2);
    x = xResolution / norme;
    y = composanteY / norme;
    z = composanteZ / norme;
end