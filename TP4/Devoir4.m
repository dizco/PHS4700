function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    % MONTE CARLO BABYYYY
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    positionPhoton = poso;
    
    droite = DroiteAleatoire(pointObservateur, systeme);
    
    [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent.Centre);
    if (intersectionCylindreExiste)
        [nouvelleDroite, estRefracte] = Refraction(droite.Pente, normaleIntersectionCylindre, nout, nin);
        if (~estRefracte)
            %TODO: Drop sauf sil est a linterieur
        end
    end
    
    
end

function [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, centreCylindre)
    %TODO: Utiliser la positionDepart pour resoudre quel des 2 points de collision doit etre retourne (utiliser distance)
    
    intersectionCylindreExiste = true;
    positionIntersectionCylindre = [0, 0, 0];
    normaleIntersectionCylindre = [0, 0, 0]; %TODO: Utiliser la position (x, y) du centre du cylindre afin de déterminer la normale
    
end

function [intersectionBlocExiste, positionIntersectionBloc, normaleIntersectionBloc] = CollisionBloc(droite, positionDepart)
    %TODO: Iterer sur chacune des faces pour voir si la droite intersecte
    
    intersectionBlocExiste = false;
    positionIntersectionBloc = [0, 0, 0];
    normaleIntersectionBloc = [0, 0, 0];
end
