%Calcul le vecteur g de la force de viscosité d'une balle de ping-pong pour l'algorithme de Runge-Kutta .
%massBall: La masse de la balle
%rayon: Le rayon de la balle
    function g = frottementVisqueux(q0, t0)
        rayon = 0.0199;
        masse = 0.00274;
        rho = 1.2;
        C = 0.5;
        aire = pi * rayon ^ 2;
        g = [- rho * C * aire / 2 * norm(q0(1,1:3)) * q0(1,1:3) / masse q0(1,1:3)];
    end

