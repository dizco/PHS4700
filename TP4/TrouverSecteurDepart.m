function TrouverSecteurDepart(pointObservateur, systeme)
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
    rapport1 = segmentVertical1(1) / segmentVertical1(3);
    rapport2 = segmentVertical2(1) / segmentVertical2(3);
    rapport3 = segmentVertical3(1) / segmentVertical3(3);
    rapport4 = segmentVertical4(1) / segmentVertical4(3);
    angle1 = atand(rapport1);
    angle2 = atand(rapport2);
    angle3 = atand(rapport3);
    angle4 = atand(rapport4);
    angles = [angle1 angle2 angle3 angle4];
    angleZMin = angles(1);
    angleZMax = 0;
    for i = 2:4
        if angles(i) < angleZMin
            angleZMin = angles(i);
        else
            angleZMax = angles(i);
        end
    end
    disp("angle min :");
    disp(angleZMin);
    disp("angle max :");
    disp(angleZMax);
end

function trouverAngle()
    
end

function trouverSecteurHorizontal()
    
end