function [ collisionAvecBloc, distance, couleur, ptCollision ] = SimulerRayonAlt(nout, nin, positionPhoton, systeme, N, M, n, m)
    % MONTE CARLO BABYYYY
    estInterieur = false; %initialement faux, pcq le rayon n'est pas � l'int�rieur du cylindre
    rayonEstValide = false; %initialement faux pour commencer la boucle
    collisionAvecBloc = false; % pour le bloc de couleurs
    nReflexionInterne = 0; % � l'int�rieur du cylindre
    distance = 0;
    couleur = ''; %Couleur par d�faut
    ptCollision = Vecteur(0, 0, 0); %Position par d�faut
    
    if (~isa(positionPhoton, 'Vecteur'))
        positionPhoton = Vecteur.CreateFromArray(positionPhoton);
    end
    
    % Valeurs de test.
    N = 1;
    M = 1;
    n = 1;
    m = 1;
    nout = 1;
    nin = 1;
    
    % droite = Droite();
    % Ne touche pas le bloc.
    % droite.Point = Vecteur(0, 0.025, 0.03);
    % droite.Pente = Vecteur.CreateFromArray([1, 0, 0]/norm([1, 0, 0]));
    
    % Situation #1 : Le rayon n'est pas � l'int�rieur du cylindre.
    droite = DroiteAleatoire(positionPhoton, systeme, N, M, n, m);
    % �tape 1.1 : 
	% NOTE IMPORTANTE : ORDRE DES OP�RATIONS.
	% a. On trouve le range. (Angle max et Angle min)
    % b. On s�lectionne N et M pour polaire et azimutal.
    % c. b) nous retourne les VARIATION comme valeurs.
    % d. On boucle tant que i < N et j < M, en boucles imbriqu�es.
    % e. On a besoin d'une fonction qui prend les VARIATIONS et i, j
    % elle nous retournera la droite � shooter.
    % �tape 1.2 : On shoot.
    [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionPhoton, systeme.CylindreTransparent);
    disp(intersectionCylindreExiste);
    % �tape 1.3 : On regarde la collision avec le cylindre transparent.
    if (intersectionCylindreExiste)
        distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);
        [ut, estRefracte] = Refraction(droite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nout, nin);

        % Condition 2 : Le rayon provenant de l�exterieur est r�fract� par le bloc cylindrique transparent.
        if (estRefracte)
            rayonEstValide = true;
            estInterieur = true;
            positionPhoton = positionIntersectionCylindre;

            % G�n�rer une nouvelle droite.
            disp('NOUVELLE DROITE');
            nouvelleDroite = Droite();
            nouvelleDroite.Point = positionPhoton;
            nouvelleDroite.Pente = Vecteur.CreateFromArray(ut);
        end
    end       
    
    while (rayonEstValide && collisionAvecBloc == false && nReflexionInterne < 100)  
    % Situation #2 : Le rayon est � l'int�rieur du cylindre
        % �tape 2.1 : On regarde la collision avec le bloc de couleurs.
        %disp(rayonEstValide);
        %disp(collisionAvecBloc);
        %disp(nReflexionInterne);
        %disp('Parametres de la droite');
        %disp(nouvelleDroite.Point);
        %disp(nouvelleDroite.Pente);
        [intersectionBlocExiste, positionIntersectionBloc, faceTouchee] = CollisionBloc(systeme, nouvelleDroite, positionPhoton);
        % disp(intersectionBlocExiste);
        if (intersectionBlocExiste)
            distance = distance + DistanceParcourue(nouvelleDroite.Point, positionIntersectionBloc);
            couleur = faceTouchee;
            collisionAvecBloc = true;

            ptCollision = positionIntersectionBloc;

            disp(ptCollision);
            %break;

        % �tape 2.2 : Il n'y a pas eu de collisions avec le bloc de couleurs...
        else
            %disp(nReflexionInterne);
            %disp('Pas de collision');
            %disp('point');
            %disp(nouvelleDroite.Point);
            %disp(nouvelleDroite.Pente);
            [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(nouvelleDroite, nouvelleDroite.Point, systeme.CylindreTransparent);
            disp(intersectionCylindreExiste);
            if (intersectionCylindreExiste)
                disp('Cylindre');
                distance = distance + DistanceParcourue(positionPhoton, positionIntersectionCylindre);

                % ATTENTION : ON INVERSE LES INDICES DE R�FRACTION
                % PARCE QU'ON EST DANS LE CYLINDRE.
                [ut, estRefracte] = Refraction(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre, nin, nout);

                % �tape 2.2a : R�flexion interne.
                if (~estRefracte)
                    disp('Allo');
                    ur = Reflexion(nouvelleDroite.Pente.GetHorizontalArray(), normaleIntersectionCylindre);

                    % G�n�rer une nouvelle droite.
                    nouvelleDroite.Point = normaleIntersectionCylindre;
                    nouvelleDroite.Pente = Vecteur.CreateFromArray(ur);

                    nReflexionInterne = nReflexionInterne + 1;
                else % �tape 2.2b : Le rayon est sorti du cylindre;
                    disp('rayon invalide');
                    rayonEstValide = false;
                end
            % Erreur : On n'a pas d'intersection avec le cylindre.
            else
                disp('On a pas dintersection avec le cylindre inside.');
                rayonEstValide = false;
            end
        end
    end
end