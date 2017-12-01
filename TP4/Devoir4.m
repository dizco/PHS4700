function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    AfficherSimulationVisuelle();
    AfficherCylindre(systeme.CylindreTransparent);
    
    % Valeurs à choisir ici :
    N = 2; n = 0;
    M = 2; m = 0;
    
    while n < N
        while m < M
            [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayon(nout, nin, poso, systeme, N, M, n, m);
            disp('Je rentre ici');
            if (collisionAvecBloc)
                % On conserve les parametres du photon.
                xi = [xi, ptCollision(1)];
                yi = [yi, ptCollision(2)];
                zi = [zi, ptCollision(3)];
                face = [face, couleur];

                % On trouve son image virtuelle.
                posi = TrouverImageVirtuelle(poso, ptCollision, distance);

                % TO-DO : On dessine.
            end
            m = m + 1;
        end
        n = n + 1;
        m = 0;
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

