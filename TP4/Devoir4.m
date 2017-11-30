function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    %positionPhoton = Vecteur.CreateFromArray(poso);
    
    %droite = DroiteAleatoire(pointObservateur, systeme);
    
    positionPhoton = Vecteur(0.03, 0.03, 0.05);
    
    droite = Droite();
    droite.Point = Vecteur(0.03, 0.03, 0.05);
    droite.Pente = Vecteur(0, 1, 0);
    
    AfficherSimulationVisuelle();
    AfficherCylindre(systeme.CylindreTransparent);
    
    [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent);
    
    hold on;
    plot3(positionIntersectionCylindre.X, positionIntersectionCylindre.Y, positionIntersectionCylindre.Z, '*b');
    hold on;
    plot3(droite.Point.X, droite.Point.Y, droite.Point.Z, '*g');
    
    nFois = 0;
    while nFois < 5
        [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayon(nout, nin, poso, systeme);
        if (collisionAvecBloc)
            xi = [xi, ptCollision(1)];
            yi = [yi, ptCollision(2)];
            zi = [zi, ptCollision(3)];

            %TO-DO : Dessiner le rayon lumineux
            %Fonction a ajouter : utilise la distance et la couleur.
            nFois = nFois + 1;
        end
    end

                
end

function AfficherSimulationVisuelle()
    figure;
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    xlim([0.01 0.07]);
    ylim([0.01 0.07]);
    zlim([0 0.22]);
    view(-45, 45);
    grid minor;
end

function AfficherCylindre(cylindre)
    hold on;
    plot3(cylindre.Centre.X, cylindre.Centre.Y, cylindre.Centre.Z, '*r');
    
    [X, Y, Z] = cylinder(cylindre.Rayon);
    Z(1, :) = cylindre.Centre.Z - cylindre.Hauteur / 2;
    Z(2, :) = cylindre.Centre.Z + cylindre.Hauteur / 2;
    X = X + cylindre.Centre.X;
    Y = Y + cylindre.Centre.Y;
    hold on;
    surf(X, Y, Z, 'EdgeColor', 'b', 'FaceAlpha', 0, 'EdgeAlpha', 0.9);
    hold off;
end

