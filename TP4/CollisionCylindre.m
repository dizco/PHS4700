function [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, cylindre)
    %On considere le cylindre comme un tas de cercles empiles de facon continue
    %Donc on commence par resoudre la position (x, y) du point d'intersection s'il y a lieu
    %Comme on a calcule cette position, on est en mesure de retrouver la position en Z a l'aide des equations de la droite

    positionIntersectionCylindre = Vecteur(0, 0, 0);
    normaleIntersectionCylindre = Vecteur(0, 0, 0);
    
    [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre);
    intersectionCylindreExiste = intersectionExiste;
    if (~intersectionExiste)
        return;
    end
    
    y = ComposanteYCollision(droite, x);
    z = ComposanteZCollision(droite, x);
    
    if (z > cylindre.GetBorneSuperieureZ() || z < cylindre.GetBorneInferieureZ())
        intersectionCylindreExiste = false;
        return;
    end
    
    positionIntersectionCylindre = Vecteur(x, y, z);
    normaleIntersectionCylindre = CalculerNormaleIntersection(positionIntersectionCylindre, cylindre);
end


function normale = CalculerNormaleIntersection(positionIntersection, cylindre)
    %Utiliser la position (x, y) du centre du cylindre afin de déterminer la normale
    pos2D = copy(positionIntersection);
    pos2D = pos2D.GetHorizontalArray();
    pos2D(3) = 0;
    
    centre2D = copy(cylindre.Centre);
    centre2D = centre2D.GetHorizontalArray();
    centre2D(3) = 0;
    
    vecteurDirecteur = pos2D - centre2D;
    normale = vecteurDirecteur / norm(vecteurDirecteur);
end


function [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre) 
    %Equation 1 : (x-h)^2 + (y-k)^2 = r^2
    %Equation 2 : y = ax + b, on néglige ici la composante Z puisque le cylindre est orienté vers le haut. 
    %En d'autres mots, on applatit la situation dans la plan XY, pour avoir un cercle et une ligne
    
    intersectionExiste = true;
    x = 0;
    
    penteXY = droite.PentePlanXY();
    ordonneeAOrigine = droite.OrdonneeAOrigine();
    a = 1 + power(penteXY, 2);
    b = - (2 * cylindre.Centre.X) + 2 * penteXY * (ordonneeAOrigine - cylindre.Centre.Y);
    c = power(cylindre.Centre.X, 2) + power(ordonneeAOrigine - cylindre.Centre.Y, 2) - power(cylindre.Rayon, 2);
    
    [x1, x2] = ResoudreEquationQuadratique(a, b, c);
    
    x1Valide = isreal(x1) && ((x1 > positionDepart.X && droite.Pente.X > 0) || (x1 < positionDepart.X && droite.Pente.X < 0));
    x2Valide = isreal(x2) && ((x2 > positionDepart.X && droite.Pente.X > 0) || (x2 < positionDepart.X && droite.Pente.X < 0));
    
    if (x1Valide && x2Valide)
        %Les 2 valeurs sont valides, on prend le x pour lequel on a un step positif
        stepsX1 = (x1 - positionDepart.X) / droite.Pente.X;
        stepsX2 = (x2 - positionDepart.X) / droite.Pente.X;

        if (stepsX1 > 0 && stepsX1 < stepsX2)
            x = x1;
        else
            x = x2;
        end
    elseif (x1Valide)
        x = x1;
    elseif (x2Valide)
        x = x2;
    else
        intersectionExiste = false;
    end
    
end


function y = ComposanteYCollision(droite, x)
    %y = ax+b
    y = droite.PentePlanXY() * x + droite.OrdonneeAOrigine();
end

function z = ComposanteZCollision(droite, x)
    %z = ax+b
    z = droite.PentePlanXZ() * x + droite.ValeurZPourX0();
end

function  [x1, x2] = ResoudreEquationQuadratique(a, b, c)
    %x = (-b +- (b^2 - 4ac)^(1/2)) / 2a
    
    x1 = (-b + sqrt(power(b, 2) - 4*a*c)) / (2*a);
    x2 = (-b - sqrt(power(b, 2) - 4*a*c)) / (2*a);
end