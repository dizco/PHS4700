function [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayon(nout, nin, positionPhoton, systeme, N, M, iBoucle, jBoucle)
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
        % Étape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OPÉRATIONS.
        % a. On trouve le range. (Angle max et Angle min)
        % b. On sélectionne N et M pour polaire et azimutal.
        % c. b) nous retourne les VARIATION comme valeurs.
        % d. On boucle tant que i < N et j < M, en boucles imbriquées.
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite à shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
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
                
                ptCollision = positionInterSectionBloc;
                
                disp(ptCollision);
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