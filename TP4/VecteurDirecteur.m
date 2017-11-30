function [x, y, z] = VecteurDirecteur(droite, angleVertical, angleHorizontal)
    xResolution = 0.01;
    composanteY = xResolution * tand(angleHorizontal);
    hypothenuseXY = sqrt(xResolution^2 + composanteY^2);
    composanteZ = hypothenuseXY / tand(angleVertical);
    
    norme = sqrt(xResolution^2 + composanteY^2 + composanteZ^2);
    x = xResolution / norme;
    y = composanteY / norme;
    z = composanteZ / norme;
    droite.Pente = Vecteur(x, y, z);
end