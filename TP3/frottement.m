function g = frottement (q0, t0, auto)

    mu = 0;
    masse = auto.Masse; 
    
    if( norm(q0(1,1:3)) < 50 )
        mu = 0.15 * ( 1 - ( norm(q0(1,1:3)) / 100));
    else
        mu = 0.075;
    end
    
    %F = ma
    accelerationFrottement = (- mu * norm(q0(1,1:3)) * masse * 9.8 * (q0(1,1:3)/norm(q0(1,1:3)))) / masse;
    g = [accelerationFrottement(1) accelerationFrottement(2) 0 q0(1) q0(2) 0];
    disp("mu")
    disp(mu);
    disp("force");
    disp((- mu * norm(q0(1,1:3)) * masse * 9.8 * (q0(1,1:3)/norm(q0(1,1:3)))));
    disp("Q0");
    disp( q0);
    %disp(accelerationFrottement);

end

