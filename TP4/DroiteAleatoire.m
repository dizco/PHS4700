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
    
    phiMin = rangeHorizontal(1);
    phiMax = rangeHorizontal(2);
    thetaMin = rangeVertical(1);
    thetaMax = rangeVertical(2);
    
    phiM = phiMin + ( ( (phiMax - phiMin) / (2 * M) ) * (2 * m - 1) );
    thetaN = thetaMin + ( ( (thetaMax - thetaMin) / (2 * N) ) * (2 * n - 1) );
end

function [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme)
    [angleZMin, angleZMax] = TrouverRangeVertical(pointObservateur, systeme);
    [angleXYMin, angleXYMax]  = TrouverRangeHorizontal(pointObservateur, systeme);
    rangeVertical = [angleZMin, angleZMax];
    rangeHorizontal = [angleXYMin, angleXYMax];
end

function [x, y, z] =VecteurDirecteurUnitaire(angleVertical, angleHorizontal)
    xResolution = 0.01;
    composanteY = xResolution * tand(angleHorizontal);
    hypothenuseXY = sqrt(xResolution^2 + composanteY^2);
    composanteZ = hypothenuseXY / tand(angleVertical);
    
    norme = sqrt(xResolution^2 + composanteY^2 + composanteZ^2);
    x = xResolution / norme;
    y = composanteY / norme;
    z = composanteZ / norme;
end

function [angleZMin, angleZMax] = TrouverRangeVertical(pointObservateur, systeme)
    rayon = systeme.CylindreTransparent.Rayon;
    demiHauteur = systeme.CylindreTransparent.Hauteur / 2;
    centre = systeme.CylindreTransparent.Centre;
    coinVertical1 = [centre.X - rayon      centre.Y - rayon    centre.Z - demiHauteur];
    coinVertical2 = [centre.X + rayon      centre.Y + rayon    centre.Z - demiHauteur];
    coinVertical3 = [centre.X - rayon      centre.Y - rayon    centre.Z + demiHauteur];
    coinVertical4 = [centre.X + rayon      centre.Y + rayon    centre.Z + demiHauteur];
    segmentVertical1 = [coinVertical1(1) - pointObservateur.X coinVertical1(2) - pointObservateur.Y coinVertical1(3) - pointObservateur.Z];
    segmentVertical2 = [coinVertical2(1) - pointObservateur.X coinVertical2(2) - pointObservateur.Y coinVertical2(3) - pointObservateur.Z];
    segmentVertical3 = [coinVertical3(1) - pointObservateur.X coinVertical3(2) - pointObservateur.Y coinVertical3(3) - pointObservateur.Z];
    segmentVertical4 = [coinVertical4(1) - pointObservateur.X coinVertical4(2) - pointObservateur.Y coinVertical4(3) - pointObservateur.Z];
    segments = [segmentVertical1; segmentVertical2; segmentVertical3; segmentVertical4];
    %segments est de dimension 4x3 => 4 vecteurs horizontaux
    
    angles = [0 0 0 0];
    for i = 1:4
        if segments(i, 3) < 0
            rapportTan = abs(segments(i, 3) / segments(i, 1));
            angles(i) = 90 + atand(rapportTan);
        else
            rapportTan = segments(i, 1) / segments(i, 3);
            angles(i) = atand(rapportTan);
        end
    end
    angleZMin = angles(1);
    angleZMax = angles(1);
    for i = 2:4
        if angles(i) < angleZMin
            angleZMin = angles(i);
        end
        if angles(i) > angleZMax
            angleZMax = angles(i);
        end
    end
end

function [angleXYMin, angleXYMax] = TrouverRangeHorizontal(pointObservateur, systeme)
    rayon = systeme.CylindreTransparent.Rayon;
    centre = systeme.CylindreTransparent.Centre;
    segment = [centre.X - pointObservateur.X centre.Y - pointObservateur.Y centre.Z - pointObservateur.Z];
    longueurXYSegment = sqrt(segment(1)^2 + segment(2)^2);
    
    rapport = segment(2) / segment(1);
    angleSegment = atand(rapport);
    
    ecartAngleCercle = atand(rayon / longueurXYSegment);
    angleXYMin = angleSegment - ecartAngleCercle;
    angleXYMax = angleSegment + ecartAngleCercle;
end