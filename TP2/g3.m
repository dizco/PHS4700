%Calcul le vecteur g de la force de Magnus d'une balle de ping-pong pour l'algorithme de Runge-Kutta .
%massBall: La masse de la balle
%rayon: Le rayon de la balle
%vitesseAngulaire: La vitesse angulaire de la balle
    function g = forceMagnus(q0, t0, vitesseAngulaire)
        rayon = 0.0199;
        masse = 0.00274;
        rho = 1.2;
        coefficientDeMagnus = 0.29;
        aire = pi * rayon ^ 2;
        g = [4 * pi * ((rayon)^3) * coefficientDeMagnus * rho * cross(vitesseAngulaire, q0(1,4:6))/masse q0(1,1:3)];
    end
  
