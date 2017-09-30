function systeme = Donnees(cmBalle, prendreEnCompteFrottement) 
    table = Table();
    table.Normale = Vecteur(0, 0, 1);
    table.Point = Vecteur(0, 0, 0.76);
    table.Bornes = [0, 2.74; 0, 1.525; -Inf, Inf]; % �paisseur n�gligeable en Z, donc en ne se pr�occupe pas des bornes
    
    filet = Filet();
    filet.Normale = Vecteur(1, 0, 0);
    filet.Point = Vecteur(2.74 / 2, 0, 0.76);
    filet.Bornes = [-Inf, Inf; -0.1525, 1.6775; 0.76, 0.1525]; % �paisseur n�gligeable en X
    
    balle = Balle();
    balle.CentreDeMasse = Vecteur.CreateFromArray(cmBalle);
    balle.Rayon = 1.99 / 100;
    balle.Masse = 2.74 / 1000;    
    
    sol = Plan(); % Bornes infinies par d�faut
    sol.Normale = Vecteur(0, 0, 1);
    sol.Point = Vecteur(0, 0, 0);

    systeme = Systeme();
    systeme.Table = table;
    systeme.Filet = filet;
    systeme.Balle = balle;
    systeme.Sol = sol;
    acceleration = Vecteur(0, 0, -9.8);
    if (prendreEnCompteFrottement)
        acceleration.X = -1; % TODO: Calculer frottement visqueux
        acceleration.Y = -1; % TODO:
        acceleration.Z = -9; % TODO:
    end
    systeme.Acceleration = acceleration;

end