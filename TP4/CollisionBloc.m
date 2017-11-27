function [intersectionBlocExiste, positionIntersectionBloc, faceTouchee] = CollisionBloc(droite, positionDepart)
    %TODO: Iterer sur chacune des faces pour voir si la droite intersecte
    
    intersectionBlocExiste = false;
    pointIntersectionLePlusProche = [Inf, Inf, Inf];
    positionIntersectionBloc = [0, 0, 0];
    faceTouchee = 0;
    
    for i = 1:6
        % Equation de la distance a un point : (ax + by + cz + d) / sqrt(a^2 + b^2 + c^2)
        planBloc = systeme.bloc.Faces(i).plan
        A = planBloc.Normale.X;
        B = planBloc.Normale.Y;
        C = planBloc.Normale.Z;
        D = -planBloc.Normale.X * planBloc.Point.X - planBloc.Normale.Y * planBloc.Point.Y - planBloc.Normale.Z * planBloc.Point.Z;
        
        %Valeur des parametre de l'equation parametrique d'une droite
        
        %point passant par la droite
        a0 = positionDepart.X;
        b0 = positionDepart.Y;
        c0 = positionDepart.Z;
        
        %direction de la droite
        a = droite.X
        b = droite.Y
        c = droite.Z
        
        %Formule de resolution du parametre d'intersection t
        %https://stackoverflow.com/questions/23975555/how-to-do-ray-plane-intersection
        
        %on verifie que la droite n'est pas parallele au plan
        determinant = A * a + B * b + C * c;
        if (determinant ~= 0)
            t = -(D + A * a0 + B * b0 + C * c0) / determinant;
        end
        
        %on resout les equations parametriques de la droite
        x = a * t + a0;
        y = b * t + b0;
        z = c * t + c0;
        
        %on verifie que le point est situe dans la face du bloc
        %(bornes hardcodes)
        if ((i == (1 || 2)) && ( x == (3 || 4) ) && (y >=3) && (y <= 5) && (z >= 12) && (z >=17))
            intersectionBlocExiste = true;
        elseif ((i == (3 || 4)) && ( y == (3 || 5) ) && (x >=3) && (x <= 4) && (z <= 12) && (z >=17))
            intersectionBlocExiste = true;   
        elseif ((i == (5 || 6)) && ( z == (12 || 17) ) && (x >=3) && (x <= 4) && (y <= 3) && (y >=5))
            intersectionBlocExiste = true;        
        end
        
        %on sauvegarde le point de collision le plus proche du point
        %d'origine
        if (intersectionBlocExiste)
            distanceAncientPoint = sqrt( (pointIntersectionLePlusProche(1) - positionDepart.X)^2 + (pointIntersectionLePlusProche(2) - positionDepart.Y)^2 + (pointIntersectionLePlusProche(3) - positionDepart.Z)^2);
            distanceNouveauPoint = sqrt( (x - positionDepart.X)^2 + (y - positionDepart.Y)^2 + (z - positionDepart.Z)^2);
            
            if (distanceNouveauPoint < distanceAncientPoint)
               pointIntersectionLePlusProche = [x, y, z];
               %on retourne la face pour se rappeller de la couleur
               faceTouchee = i;
            end           
        end
    end
    
    %on retourne le pointDintersectionLePlusProche
    if(intersectionBlocExiste)
       positionIntersectionBloc = pointIntersectionLePlusProche; 
    end
    
end