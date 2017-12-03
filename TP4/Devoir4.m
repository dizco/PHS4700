function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    AfficherSimulationVisuelle(poso, systeme.CylindreTransparent.Centre.GetHorizontalArray());
    AfficherCylindre(systeme.CylindreTransparent);
    
    % Valeurs à choisir ici :
    N = 250; n = 0;
    M = 100; m = 0;
    
    while n < N
        while m < M
            [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayon(nout, nin, poso, systeme, N, M, n, m);
            if (collisionAvecBloc)
                % On conserve les parametres du photon.
                xi = [xi, ptCollision(1)];
                yi = [yi, ptCollision(2)];
                zi = [zi, ptCollision(3)];
                face = [face, couleur];

                % On trouve son image virtuelle.
                posi = TrouverImageVirtuelle(poso, ptCollision, distance);

                % On dessine.                
                AfficherImage(posi, couleur); 
            end
            m = m + 1;
        end
        n = n + 1;
        m = 0;
    end

                
end

function AfficherSimulationVisuelle(positionCamera, positionTarget)
    figure;
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    %campos(positionCamera);
    %camtarget(positionTarget);
    xlim([0.0 0.08]);
    ylim([0.0 0.08]);
    zlim([0 0.24]);
    view(-45, 45);
    grid minor;
end

function AfficherCylindre(cylindre)
    hold on;
    
    [X, Y, Z] = cylinder(cylindre.Rayon);
    Z(1, :) = cylindre.Centre.Z - cylindre.Hauteur / 2;
    Z(2, :) = cylindre.Centre.Z + cylindre.Hauteur / 2;
    X = X + cylindre.Centre.X;
    Y = Y + cylindre.Centre.Y;
    hold on;
    surf(X, Y, Z, 'EdgeColor', 'b', 'FaceAlpha', 0, 'EdgeAlpha', 0.9);
    hold off;
end

