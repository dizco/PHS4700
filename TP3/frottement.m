function g = frottement (q0, auto)

    mu = 0;
    masse = auto.Masse; 
    
    if( norm(q0(1,1:2)) < 50 )
        mu = 0.15 * ( 1 - ( norm(q0(1,1:2)) / 100));
    else
        mu = 0.075;
    end
    
    frottement = - mu * norm(q0(1,1:2)) * masse * 9.8 * (q0(1,1:2)/norm(q0(1,1:2)));
    g = frottement;

end

