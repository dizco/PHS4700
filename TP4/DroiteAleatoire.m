function droite = DroiteAleatoire(pointObservateur, systeme)
    [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme);
    angleVertical = (rangeVertical(2)-rangeVertical(1)).*rand(1) + rangeVertical(1);
    angleHorizontal = (rangeHorizontal(2)-rangeHorizontal(1)).*rand(1) + rangeHorizontal(1);

%     disp("range vertical");
%     disp(rangeVertical);
%     disp("angleVertical aléatoire");
%     disp(angleVertical);
%     disp("range horizontal");
%     disp(rangeHorizontal);
%     disp("angleHorizontal aléatoire");
%     disp(angleHorizontal);

    droite = Droite();
    droite.Point = pointObservateur;
    
    angleHTest = 60;%degrés
    angleVTest = 40;%degrés
    xResolution = 0.01;
    composanteY = xResolution * tand(angleHTest);
    hypothenuseXY = sqrt(xResolution^2 + composanteY^2);
    composanteZ = hypothenuseXY / tand(angleVTest);
    droite.Pente = Vecteur(xResolution, composanteY, composanteZ);
    disp(droite.Pente);
    norme = sqrt(xResolution^2 + composanteY^2 + composanteZ^2);
    x = xResolution / norme;
    y = composanteY / norme;
    z = composanteZ / norme;
    disp(x);
    disp(y);
    disp(z);
    
    %TODO: Calculer l'equation de la droite a partir des angles
end

function [rangeVertical, rangeHorizontal] = IntervallesAnglesPossibles(pointObservateur, systeme)
    [angleZMin, angleZMax] = TrouverRangeVertical(pointObservateur, systeme);
    [angleXYMin, angleXYMax]  = TrouverRangeHorizontal(pointObservateur, systeme);
    rangeVertical = [angleZMin, angleZMax];
    rangeHorizontal = [angleXYMin, angleXYMax];
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