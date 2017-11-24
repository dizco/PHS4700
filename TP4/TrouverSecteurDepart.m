function TrouverSecteurDepart(pointObservateur, systeme)
    rayon = systeme.CylindreTransparent.Rayon;
    hauteur = systeme.CylindreTransparent.Hauteur;
    centre = systeme.CylindreTransparent.Centre;
    coinVertical1 = [2 2 2];
    coinVertical2 = [6 6 2];
    coinVertical3 = [2 2 20];
    coinVertical4 = [6 6 20];
    segmentVertical1 = [coinVertical1(1) - pointObservateur.X; coinVertical1(2) - pointObservateur.Y; coinVertical1(3) - pointObservateur.Z];
    segmentVertical2 = [coinVertical2(1) - pointObservateur.X; coinVertical2(2) - pointObservateur.Y; coinVertical2(3) - pointObservateur.Z];
    segmentVertical3 = [coinVertical3(1) - pointObservateur.X; coinVertical3(2) - pointObservateur.Y; coinVertical3(3) - pointObservateur.Z];
    segmentVertical4 = [coinVertical4(1) - pointObservateur.X; coinVertical4(2) - pointObservateur.Y; coinVertical4(3) - pointObservateur.Z];
    disp(segmentVertical1);
    disp(segmentVertical2);
    disp(segmentVertical3);
    disp(segmentVertical4);
    angle1 = coinVertical1(1) / coinVertical1(3);
    angle2 = coinVertical2(1) / coinVertical2(3);
    angle3 = coinVertical3(1) / coinVertical3(3);
    angle4 = coinVertical4(1) / coinVertical4(3);
    angle1 = atand(angle1);
    angle2 = atand(angle2);
    angle3 = atand(angle3);
    angle4 = atand(angle4);
    disp("angle");
    disp(angle1);
    disp(angle2);
    disp(angle3);
    disp(angle4);
    angleZMin = 0;
    if angle1 < angle2
        angleZMin = angle1;
    else
        angleZMin = angle2;
    end
    disp(angleZMin);
    angleZMax = 0;
    disp(angleZMax);
end

function trouverAngle()
    
end

function trouverSecteurHorizontal()
    
end