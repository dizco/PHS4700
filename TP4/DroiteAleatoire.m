% � partir de SimulerRayon.m
% �tape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OP�RATIONS.
        % a. On trouve le range. (Angle max et Angle min) V
        % b. On s�lectionne N et M pour polaire et azimutal. Pas ma partie?
        % c. b) nous retourne les VARIATION comme valeurs.
        % d. On boucle tant que i < N et j < M, en boucles imbriqu�es.
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite � shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
function droite = DroiteAleatoire(pointObservateur, systeme, N, M, n, m)
    droite = Droite();
    droite.Point = pointObservateur;
    
    [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme);
    angleVerticalAleatoire = (rangeVertical(2)-rangeVertical(1)).*rand(1) + rangeVertical(1);
    angleHorizontalAleatoire = (rangeHorizontal(2)-rangeHorizontal(1)).*rand(1) + rangeHorizontal(1);
    VecteurDirecteur(droite, angleVerticalAleatoire, angleHorizontalAleatoire);
end

