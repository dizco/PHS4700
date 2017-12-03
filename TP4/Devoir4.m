function [xi, yi, zi, face] = Devoir4(nout, nin, poso)
    xi = 0;
    yi = 0;
    zi = 0;
    face = 0;
    
    systeme = Donnees();
    
    AfficherSimulationVisuelle(poso, systeme.CylindreTransparent.Centre.GetHorizontalArray());
    AfficherCylindre(systeme.CylindreTransparent);
    
    % Valeurs � choisir ici :
    N = 250;
    M = 100;
    
    for n = 1:N
        for m = 1:M
            [ collisionAvecBloc, distance, couleur, ptCollision, omega ] = SimulerRayon(nout, nin, poso, systeme, N, M, n, m);
            if (collisionAvecBloc)
                % On conserve les parametres du photon.
                xi = [xi, ptCollision(1)];
                yi = [yi, ptCollision(2)];
                zi = [zi, ptCollision(3)];
                face = [face, couleur];

                % On trouve son image virtuelle.
                % posi = TrouverImageVirtuelle(poso, ptCollision, distance);
                posi = TrouverImageVirtuelle(poso, omega, distance);

                % On dessine.                
                AfficherImage(posi, couleur); 
            end
        end
    end

                
end

function AfficherSimulationVisuelle(positionCamera, positionTarget)
    figure;
    xlabel('X (cm)');
    ylabel('Y (cm)');
    zlabel('Z (cm)');
    
    %campos(positionCamera);
    %camtarget(positionTarget);
    xlim([0 8]);
    ylim([0 8]);
    zlim([0 24]);
    view(-45, 45);
    
    % Ajuste la taille des axes
    %daspect([3 3 1]);
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

