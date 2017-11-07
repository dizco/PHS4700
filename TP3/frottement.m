function g = frottement (q0, t0, auto)


    masse = auto.Masse; 
    vitesse = q0(1,1:3);
    
    %evite des erreurs de vitesses
    for i = 1:2
        if (vitesse(i) < 0.5 && vitesse(i) > -0.5)
            vitesse(i) = 0;
        end
    end
    
    vitesseScalaire = norm(vitesse);
    
    if (vitesseScalaire < 50)
        mu = 0.15 * ( 1 - (vitesseScalaire / 100));
    else
        mu = 0.075;
    end
    
    
    force = - mu * masse * 9.8 * (vitesse / vitesseScalaire);
    
    %F = ma
    accelerationFrottement = force / masse;
    g = [accelerationFrottement(1) accelerationFrottement(2) 0 vitesse(1) vitesse(2) 0];
    display("Result");
 
    display(g);
    %fprintf('mu : %i\n', mu);
    %fprintf('vitesse scalaire : %i\n', vitesseScalaire);
    %disp("vitesse");
    %disp(vitesse);
    %disp("force");
    %disp(force);
    %disp('acceleration');
    %disp(accelerationFrottement);
    %disp('g');
    %disp(g);

end

