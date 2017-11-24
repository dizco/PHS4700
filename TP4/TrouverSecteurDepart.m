function [rangeVertical, rangeHorizontal] = TrouverSecteurDepart(pointObservateur, systeme)
    rangeVertical = TrouverRangeVertical(pointObservateur, systeme);
    rangeHorizontal = TrouverRangeHorizontal(pointObservateur, systeme);
end

function [angleZMin, angleZMax] = TrouverRangeVertical(pointObservateur, systeme)
    rayon = systeme.CylindreTransparent.Rayon;
    demiHauteur = systeme.CylindreTransparent.Hauteur / 2;
    centre = systeme.CylindreTransparent.Centre;
    coinVertical1 = [centre(1) - rayon      centre(2) - rayon    centre(3) - demiHauteur];
    coinVertical2 = [centre(1) + rayon      centre(2) + rayon    centre(3) - demiHauteur];
    coinVertical3 = [centre(1) - rayon      centre(2) - rayon    centre(3) + demiHauteur];
    coinVertical4 = [centre(1) + rayon      centre(2) + rayon    centre(3) + demiHauteur];
    segmentVertical1 = [coinVertical1(1) - pointObservateur.X; coinVertical1(2) - pointObservateur.Y; coinVertical1(3) - pointObservateur.Z];
    segmentVertical2 = [coinVertical2(1) - pointObservateur.X; coinVertical2(2) - pointObservateur.Y; coinVertical2(3) - pointObservateur.Z];
    segmentVertical3 = [coinVertical3(1) - pointObservateur.X; coinVertical3(2) - pointObservateur.Y; coinVertical3(3) - pointObservateur.Z];
    segmentVertical4 = [coinVertical4(1) - pointObservateur.X; coinVertical4(2) - pointObservateur.Y; coinVertical4(3) - pointObservateur.Z];
    if segmentVertical1(3) < 0
        rapport1 = abs(segmentVertical1(3) / segmentVertical1(1));
        angle1 = 90 + atand(rapport1);
    else
        rapport1 = segmentVertical1(1) / segmentVertical1(3);
        angle1 = atand(rapport1);
    end
    if segmentVertical2(3) < 0
        rapport2 = abs(segmentVertical2(3) / segmentVertical2(1));
        angle2 = 90 + atand(rapport2);
    else
        rapport2 = segmentVertical2(1) / segmentVertical2(3);
        angle2 = atand(rapport2);
    end
    if segmentVertical3(3) < 0
        rapport3 = segmentVertical3(3) / segmentVertical3(1);
        angle3 = 90 + atand(rapport3);
    else
        rapport3 = segmentVertical3(1) / segmentVertical3(3);
        angle3 = atand(rapport3);
    end
    if segmentVertical4(3) < 0
        rapport4 = segmentVertical4(3) / segmentVertical4(1);
        angle4 = 90 + atand(rapport4);
    else
        rapport4 = segmentVertical4(1) / segmentVertical4(3);
        angle4 = atand(rapport4);
    end
    angles = [angle1 angle2 angle3 angle4];
    disp(angles);
    angleZMin = angles(1);
    angleZMax = 0;
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