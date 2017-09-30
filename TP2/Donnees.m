function systeme = Donnees(cmBalle, prendreEnCompteFrottement) 
    table = Table();
    table.Normale = [0; 0; 1];
    table.Point = [0; 0; 0.76];
    table.Bornes = [0, 2.74; 0, 1.525; -Inf, Inf]; % Épaisseur négligeable en Z, donc en ne se préoccupe pas des bornes
    
    filet = Filet();
    filet.Normale = [1; 0; 0];
    filet.Point = [2.74 / 2; 0; 0.76];
    filet.Bornes = [-Inf, Inf; -0.1525, 1.6775; 0.76, 0.1525]; % Épaisseur négligeable en X
    
    balle = Balle();
    balle.CentreDeMasse = cmBalle;
    balle.Rayon = 1.99 / 100;
    balle.Masse = 2.74 / 1000;    
    
    sol = Plan(); % Bornes infinies par défaut
    sol.Normale = [0; 0; 1];
    sol.Point = [0; 0; 0];

    systeme = Systeme();
    systeme.Table = table;
    systeme.Filet = filet;
    systeme.Balle = balle;
    systeme.Sol = sol;
    acceleration = [0; 0; -9.8];
    if (prendreEnCompteFrottement)
        acceleration(1) = -1; % TODO: Calculer frottement visqueux
        acceleration(2) = -1; % TODO:
        acceleration(3) = -9; % TODO:
    end
    systeme.Acceleration = acceleration;

end