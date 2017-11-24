function [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, centreCylindre)
    %TODO: Utiliser la positionDepart pour resoudre quel des 2 points de collision doit etre retourne (utiliser distance)
    
    intersectionCylindreExiste = true;
    positionIntersectionCylindre = [0, 0, 0];
    normaleIntersectionCylindre = [0, 0, 0]; %TODO: Utiliser la position (x, y) du centre du cylindre afin de déterminer la normale
    
    %On considere le cylindre comme un tas de cercles empiles de facon
    %continue
    %Donc on commence par resoudre la position (x, y) du point
    %d'intersection s'il y a lieu
    %Comme on a calcule cette position, on est en mesure de retrouver la
    %position en Z a l'aide des equations de la droite
    
    
    
end