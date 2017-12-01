% � partir de SimulerRayon.m
% �tape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OP�RATIONS.
        % a. On trouve le range. (Angle max et Angle min)
        % b. On s�lectionne N et M pour polaire et azimutal. Pas ma partie?
        % c. b) nous retourne les VARIATION comme valeurs.
        % d. On boucle tant que i < N et j < M, en boucles imbriqu�es.
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite � shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
function droite = DroiteAleatoire(pointObservateur, systeme, N, M, n, m)

    % On initialise la droite avec le point.
    droite = Droite();
    droite.Point = pointObservateur;
    
    % a. On trouve le range. (Angle max et Angle min)
    [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme);
    % On calcule la variation
    [variationTheta, variationPhi] = VariationAngle(rangeVertical, rangeHorizontal, N, M)
    % On calcule l'angle � utiliser
    angleVertical = variationTheta * (2 * n - 1);
    angleHorizontal = variationPhi * (2 * m - 1);
    
    % TO-DO : REMOVE.
    % angleVerticalAleatoire = (rangeVertical(2)-rangeVertical(1)).*rand(1) + rangeVertical(1);
    % angleHorizontalAleatoire = (rangeHorizontal(2)-rangeHorizontal(1)).*rand(1) + rangeHorizontal(1);
    
    % On calcule la pente et on l'affecte � la droite.
    VecteurDirecteur(droite, angleVerticalAleatoire, angleHorizontalAleatoire);
end

