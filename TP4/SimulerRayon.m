function [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayon(nout, nin, positionPhoton, systeme, N, M, iBoucle, jBoucle)
    % MONTE CARLO BABYYYY
    estInterieur = false; %initialement faux, pcq le rayon n'est pas � l'int�rieur du cylindre
    rayonEstValide = true; %initialement vrai pour commencer la boucle
    collisionAvecBloc = false; % pour le bloc de couleurs
    nReflexionInterne = 0; % � l'int�rieur du cylindre
    distance = 0;
    
    while rayonEstValide && collisionAvecBloc == false && nReflexionInterne < 100
        % Situation #1 : Le rayon n'est pas � l'int�rieur du cylindre.
        if estInterieur == false
            rayonEstValide = false;
        % �tape 1.1 : 
        % NOTE IMPORTANTE : ORDRE DES OP�RATIONS.
        % a. On trouve le range. (Angle max et Angle min)
        % b. On s�lectionne N et M pour polaire et azimutal.
        % c. b) nous retourne les VARIATION comme valeurs.
        % d. On boucle tant que i < N et j < M, en boucles imbriqu�es.
        % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
        % elle nous retournera la droite � shooter.
            %droite = DroiteAleatoire(positionPhoton, systeme);
        % �tape 1.2 : On shoot.
            %[intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent);
        % �tape 1.3 : On regarde la collision avec le cylindre transparent.
        if (intersectionCylindreExiste)
            distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);
            [ut, estRefracte] = Refraction(droite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nout, nin);
            % Condition 2 : Le rayon provenant de l�exterieur est reflechi par le bloc cylindrique transparent.
            if (~estRefracte)
                % Dans ce cas, le rayon est rejete.
            else
                rayonEstValide = true;
                estInterieur = true;
                positionPhoton = positionIntersectionCylindre;
                % G�n�rer une nouvelle droite.
                nouvelleDroite = Droite();
                nouvelleDroite.Point = positionPhoton;
                nouvelleDroite.Pente = ut;
            end
        end
        
        % Situation #2 : Le rayon est � l'int�rieur du cylindre
        else
            % �tape 2.1 : On regarde la collision avec le bloc de couleurs.
            %[intersectionBlocExiste, positionIntersectionBloc, faceTouchee] = CollisionBloc(nouvelleDroite, positionPhoton);
            if (intersectionBlocExiste)
                distance = distance + DistanceParcourue(nouvelleDroite.Point, positionIntersectionBloc);
                couleur = systeme.bloc.Faces(faceTouchee).CodeCouleur;
                collisionAvecBloc = true;
                
                ptCollision = positionInterSectionBloc;
                
                disp(ptCollision);
                break;
                
            % �tape 2.2 : Il n'y a pas eu de collisions avec le bloc de couleurs...
            else
                [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(nouvelleDroite, nouvelleDroite.Point, systeme.CylindreTransparent);
                if (intersectionCylindreExiste)
                    distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);
                    % ATTENTION : ON INVERSE LES INDICES DE R�FRACTION
                    % PARCE QU'ON EST DANS LE CYLINDRE.
                    [ut, estRefracte] = Refraction(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nin, nout);
                    
                    % �tape 2.2a : R�flexion interne.
                    if (~estRefracte)
                        ur = Reflexion(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre);
                        
                        % G�n�rer une nouvelle droite.
                        nouvelleDroite.Point = normaleIntersectionCylindre;
                        nouvelleDroite.Pente = ur;
                        
                        nReflexionInterne = nReflexionInterne + 1;
                    else % �tape 2.2b : Le rayon est sorti du cylindre;
                        rayonEstValide = false;
                    end
                end
            end
        end
    end
end