% � partir de SimulerRayon.m
% �tape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OP�RATIONS.
        % a. On trouve le range. (Angle max et Angle min) V
        % b. On s�lectionne N et M pour polaire et azimutal. N
        % c. b) nous retourne les VARIATION comme valeurs. V
        % d. On boucle tant que i < N et j < M, en boucles imbriqu�es. N
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite � shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
            
function [variationTheta, variationPhi] = VariationAngle(rangeVertical, rangeHorizontal, N, M)
    phiMin = rangeHorizontal(1);
    phiMax = rangeHorizontal(2);
    thetaMin = rangeVertical(1);
    thetaMax = rangeVertical(2);
    
    variationPhi = phiMin + ( (phiMax - phiMin) / (2 * M) );
    variationTheta = thetaMin + ( (thetaMax - thetaMin) / (2 * N) );
end