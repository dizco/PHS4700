function [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, cylindre)
    %On considere le cylindre comme un tas de cercles empiles de facon continue
    %Donc on commence par resoudre la position (x, y) du point d'intersection s'il y a lieu
    %Comme on a calcule cette position, on est en mesure de retrouver la position en Z a l'aide des equations de la droite

    positionIntersectionCylindre = Vecteur(0, 0, 0);
    normaleIntersectionCylindre = Vecteur(0, 0, 0);
    intersectionCylindreExiste = true;
    
    [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre);
    if (~intersectionExiste)
        intersectionCylindreExiste = false;
        return;
    end
    
    if (droite.EstVertical())
        [intersectionExiste, y] = ComposanteYCollisionVertical(droite, positionDepart, cylindre);
        if (~intersectionExiste)
            intersectionCylindreExiste = false;
            return;
        end
        z = ComposanteZCollisionAvecY(droite, y);
    else
        y = ComposanteYCollision(droite, x);
        z = ComposanteZCollisionAvecX(droite, x);
    end
    
    if (z > cylindre.GetBorneSuperieureZ() || z < cylindre.GetBorneInferieureZ())
        intersectionCylindreExiste = false;
        return;
    end
    
    positionIntersectionCylindre = Vecteur(x, y, z);
    normaleIntersectionCylindre = CalculerNormaleIntersection(positionIntersectionCylindre, cylindre);
end

function [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre) 
    %Equation 1 : (x-h)^2 + (y-k)^2 = r^2
    %Equation 2 : y = ax + b, on néglige ici la composante Z puisque le cylindre est orienté vers le haut. 
    %En d'autres mots, on applatit la situation dans la plan XY, pour avoir un cercle et une ligne
    
    if (droite.EstVertical())
        x = positionDepart.X;
        intersectionExiste = true;
        return;
    end
    
    [a, b, c] = CoefficientsEquationQuadratique(droite, cylindre);
    [x1, x2] = ResoudreEquationQuadratique(a, b, c);
    
    [intersectionExiste, x] = SelectionnerValeurComposanteValide(x1, x2, positionDepart.X, droite.Pente.X);
end

function [intersectionExiste, valeur] = SelectionnerValeurComposanteValide(c1, c2, cPositionDepart, cPente)
    intersectionExiste = true;
    valeur = 0;
    
    c1Valide = ComposanteValide(c1, cPositionDepart, cPente);
    c2Valide = ComposanteValide(c2, cPositionDepart, cPente);
    
    if (c1Valide && c2Valide)
        %Les 2 valeurs sont valides, on prend le x pour lequel on a un step positif
        stepsC1 = (c1 - cPositionDepart) / cPente;
        stepsC2 = (c2 - cPositionDepart) / cPente;

        if (stepsC1 > 0 && stepsC1 < stepsC2)
            valeur = c1;
        else
            valeur = c2;
        end
    elseif (c1Valide)
        valeur = c1;
    elseif (c2Valide)
        valeur = c2;
    else
        intersectionExiste = false;
    end 
end

function valide = ComposanteValide(x, xDepart, xDirection)
    %Permet de valider n'importe quelle composante
    valide = isreal(x) && ((x > xDepart && xDirection > 0) || (x < xDepart && xDirection < 0));
end

function [a, b, c] = CoefficientsEquationQuadratique(droite, cylindre)
    penteXY = droite.PentePlanXY();
    ordonneeAOrigine = droite.OrdonneeAOrigine();
    a = 1 + power(penteXY, 2);
    b = - (2 * cylindre.Centre.X) + 2 * penteXY * (ordonneeAOrigine - cylindre.Centre.Y);
    c = power(cylindre.Centre.X, 2) + power(ordonneeAOrigine - cylindre.Centre.Y, 2) - power(cylindre.Rayon, 2);
end

function [a, b, c] = CoefficientsEquationQuadratiqueVertical(droite, cylindre)
    %Pour une droite verticale, la situation se simplifie comme suit :
    %Equation 1 : (x-h)^2 + (y-k)^2 = r^2
    %Equation 2 : x = x0
    %On trouve donc :
    % (x0-h)^2 + (y-k)^2 - r^2= 0
    % y^2 - 2ky + k^2 + (x0-h)^2 - r^2 = 0
    
    a = 1; %y^2
    b = - (2 * cylindre.Centre.Y); %-2ky
    c = power(cylindre.Centre.Y, 2) + power(droite.Point.X - cylindre.Centre.X, 2) - power(cylindre.Rayon, 2); %k^2 + (x0-h)^2 - r^2
end

function y = ComposanteYCollision(droite, x)
    %y = ax+b
    y = droite.PentePlanXY() * x + droite.OrdonneeAOrigine();
end

function [intersectionExiste, y] = ComposanteYCollisionVertical(droite, positionDepart, cylindre) 
    %Même principe que ComposanteYCollision
    
    [a, b, c] = CoefficientsEquationQuadratiqueVertical(droite, cylindre);
    [y1, y2] = ResoudreEquationQuadratique(a, b, c);
    
    [intersectionExiste, y] = SelectionnerValeurComposanteValide(y1, y2, positionDepart.Y, droite.Pente.Y);
end

function z = ComposanteZCollisionAvecX(droite, x)
    %z = ax+b
    z = droite.PentePlanXZ() * x + droite.ValeurZPourX0();
end

function z = ComposanteZCollisionAvecY(droite, y)
    %z = ax+b
    z = droite.PentePlanYZ() * y + droite.ValeurZPourY0();
end

function  [x1, x2] = ResoudreEquationQuadratique(a, b, c)
    %x = (-b +- (b^2 - 4ac)^(1/2)) / 2a
    
    x1 = (-b + sqrt(power(b, 2) - 4*a*c)) / (2*a);
    x2 = (-b - sqrt(power(b, 2) - 4*a*c)) / (2*a);
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