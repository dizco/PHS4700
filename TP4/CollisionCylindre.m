function [intersectionCylindreExiste, positionIntersectionCylindre, normaleIntersectionCylindre] = CollisionCylindre(droite, positionDepart, cylindre)
    %TODO: Utiliser la positionDepart pour resoudre quel des 2 points de collision doit etre retourne (utiliser distance)
    
    intersectionCylindreExiste = true;
    positionIntersectionCylindre = [0, 0, 0];
    normaleIntersectionCylindre = [0, 0, 0]; %TODO: Utiliser la position (x, y) du centre du cylindre afin de déterminer la normale
    
    %On considere le cylindre comme un tas de cercles empiles de facon continue
    %Donc on commence par resoudre la position (x, y) du point d'intersection s'il y a lieu
    %Comme on a calcule cette position, on est en mesure de retrouver la position en Z a l'aide des equations de la droite
    
    [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre);
    disp('intersection avec cylindre existe');
    disp(intersectionExiste);
    
    y = ComposanteYCollision(droite, x);
    
    z = ComposanteZCollision(droite, x);
    
    disp('composante X collision');
    disp(x);
    disp('composante Y collision');
    disp(y);
    disp('composante Z collision');
    disp(z);
    
end

function [intersectionExiste, x] = ComposanteXCollision(droite, positionDepart, cylindre) 
    intersectionExiste = true;
    x = 0;
    
    penteXY = droite.PentePlanXY();
    ordonneeAOrigine = droite.OrdonneeAOrigine();
    a = 1 + power(penteXY, 2);
    b = - (2 * cylindre.Centre.X) + 2 * penteXY * (ordonneeAOrigine - cylindre.Centre.Y);
    c = power(cylindre.Centre.X, 2) + power(ordonneeAOrigine - cylindre.Centre.Y, 2) - power(cylindre.Rayon, 2);
%     disp('cyl centre');
%     disp(cylindre.Centre.Y);
%     disp('ord or');
%     disp(ordonneeAOrigine);
%     disp('c1');
%     disp(power(ordonneeAOrigine - cylindre.Centre.Y, 2));
%     
%     disp('a');
%     disp(a);
%     disp('b');
%     disp(b);
%     disp('c');
%     disp(c);
    
    [x1, x2] = ResoudreEquationQuadratique(a, b, c);
%     disp('eq quad');
%     disp(x1);
%     disp(x2);
    
    x1Valide = isreal(x1) && ((x1 > positionDepart.X && droite.Pente.X > 0) || (x1 < positionDepart.X && droite.Pente.X < 0));
    x2Valide = isreal(x2) && ((x2 > positionDepart.X && droite.Pente.X > 0) || (x2 < positionDepart.X && droite.Pente.X < 0));
    
    if (x1Valide && x2Valide)
        %Les 2 valeurs sont valides, on prend le x pour lequel on a un step positif
        stepsX1 = (x1 - positionDepart.X) / droite.PentePlanXY();
        %stepsX2 = (x2 - positionDepart.X) / droite.PentePlanXY();
%         disp('steps x1 et x2');
%         disp(stepsX1);
%         disp(stepsX2);
        if (stepsX1 > 0)
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