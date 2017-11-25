function [rangeVertical, rangeHorizontal] = TrouverSecteurDepart(pointObservateur, systeme)
    rangeVertical = TrouverRangeVertical(pointObservateur, systeme);
    rangeHorizontal = TrouverRangeHorizontal(pointObservateur, systeme);
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
    disp(segments);
    disp(segments(1,3));
    rapports = [0 0 0 0];
    angles = [0 0 0 0];
    for i = 1:4
        if segments(i, 3) < 0
            rapports(i) = abs(segments(i, 3) / segments(i, 1));
            angles(i) = 90 + atand(rapports(i));
        else
            rapports(i) = segments(i, 1) / segments(i, 3);
            angles(i) = atand(rapports(i));
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
    disp("angle vertical min :");
    disp(angleZMin);
    disp("angle vertical max :");
    disp(angleZMax);
end

function [angleHMin, angleHMax] = TrouverRangeHorizontal(pointObservateur, systeme)
%     angles = [angle1 angle2 angle3 angle4];
    angleHMin = 0;%angles(1);
    angleHMax = 0;
end