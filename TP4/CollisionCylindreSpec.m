clc; 

droite = Droite();
droite.Point = Vecteur(0.03, 0.04, 0);
droite.Pente = Vecteur.CreateFromArray([0.01, 0, 0.01]);

positionDepart = droite.Point;

systeme = Donnees();

[intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, systeme.CylindreTransparent);

fprintf('\n\n');
fprintf('intersection : %d\n', intersectionCylindreExiste);
fprintf('position : [%d %d %d]\n', positionIntersectionCylindre.X, positionIntersectionCylindre.Y, positionIntersectionCylindre.Z);
fprintf('normale : [%d %d %d]\n', normaleIntersectionCylindre(1), normaleIntersectionCylindre(2), normaleIntersectionCylindre(3));