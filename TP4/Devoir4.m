function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    % MONTE CARLO BABYYYY
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    positionPhoton = Vecteur.CreateFromArray(poso);
    
    droite = DroiteAleatoire(pointObservateur, systeme);
    
    [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent.Centre);
    if (intersectionCylindreExiste)
        [nouvelleDroite, estRefracte] = Refraction(droite.Pente, normaleIntersectionCylindre, nout, nin);
        if (~estRefracte)
            %TODO: Drop sauf sil est a linterieur
        end
    end
    
    
end

