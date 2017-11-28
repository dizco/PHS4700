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
    
    % MONTE CARLO BABYYYY
    estInterieur = false; %initialement faux, pcq le rayon n'est pas à l'intérieur du cylindre
    rayonEstValide = true; %initialement vrai pour commencer la boucle
    collisionAvecBloc = false; % pour le bloc de couleurs
    nReflexionInterne = 0; % à l'intérieur du cylindre
    distance = 0;
    
    while rayonEstValide && collisionAvecBloc == false && nReflexionInterne < 100
        % Situation #1 : Le rayon n'est pas à l'intérieur du cylindre.
        if estInterieur == false
            rayonEstValide = false;
        % Étape 1.1 : On choisit l'angle de tir.
            %droite = DroiteAleatoire(poso, systeme);
        % Étape 1.2 : On shoot.
            %[intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent);
        % Étape 1.3 : On regarde la collision avec le cylindre transparent.
        if (intersectionCylindreExiste)
            distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);
            [ut, estRefracte] = Refraction(droite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nout, nin);
            % Condition 2 : Le rayon provenant de l’exterieur est reflechi par le bloc cylindrique transparent.
            if (~estRefracte)
                % Dans ce cas, le rayon est rejete.
            else
                rayonEstValide = true;
                estInterieur = true;
                positionPhoton = positionIntersectionCylindre;
                % Générer une nouvelle droite.
                nouvelleDroite = Droite();
                nouvelleDroite.Point = positionPhoton;
                nouvelleDroite.Pente = ut;
            end
        end
        
        % Situation #2 : Le rayon est à l'intérieur du cylindre
        else
            % Étape 2.1 : On regarde la collision avec le bloc de couleurs.
            %[intersectionBlocExiste, positionIntersectionBloc, faceTouchee] = CollisionBloc(nouvelleDroite, positionPhoton);
            if (intersectionBlocExiste)
                distance = distance + DistanceParcourue(nouvelleDroite.Point, positionIntersectionBloc);
                couleur = systeme.bloc.Faces(faceTouchee).CodeCouleur;
                collisionAvecBloc = true;
                
                % ON PUSH TOUTES LES NOUVELLES VALEURS DE POSITION DANS LE TABLEAU.
                xi = [xi, positionIntersectionBloc(1)];
                yi = [yi, positionIntersectionBloc(2)];
                zi = [zi, positionIntersectionBloc(3)];
                % TO-DO : Tester la couleur.
                break;
                
            % Étape 2.2 : Il n'y a pas eu de collisions avec le bloc de couleurs...
            else
                [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(nouvelleDroite, nouvelleDroite.Point, systeme.CylindreTransparent);
                if (intersectionCylindreExiste)
                    distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);
                    % ATTENTION : ON INVERSE LES INDICES DE RÉFRACTION
                    % PARCE QU'ON EST DANS LE CYLINDRE.
                    [ut, estRefracte] = Refraction(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nin, nout);
                    
                    % Étape 2.2a : Réflexion interne.
                    if (~estRefracte)
                        ur = Reflexion(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre);
                        
                        % Générer une nouvelle droite.
                        nouvelleDroite.Point = normaleIntersectionCylindre;
                        nouvelleDroite.Pente = ur;
                        
                        nReflexionInterne = nReflexionInterne + 1;
                    else % Étape 2.2b : Le rayon est sorti du cylindre;
                        rayonEstValide = false;
                    end
                end
            end
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

