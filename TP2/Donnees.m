function systeme = Donnees(cmBalle, prendreEnCompteFrottement) 
    table = Table();
    table.Normale = Vecteur(0, 0, 1);
    table.Point = Vecteur(0, 0, 0.76);
    table.Bornes = [0, 2.74; 0, 1.525; 0.76, 0.76]; % �paisseur n�gligeable en Z
    
    filet = Filet();
    filet.Normale = Vecteur(1, 0, 0);
    filet.Point = Vecteur(2.74 / 2, 0, 0.76);
    filet.Bornes = [2.74 / 2, 2.74 / 2; -0.1525, 1.83 - 0.1525; 0.76, 0.76 + 0.1525]; % �paisseur n�gligeable en X
    
    balle = Balle();
    balle.CentreDeMasse = Vecteur.CreateFromArray(cmBalle);
    balle.Rayon = 1.99 / 100;
    balle.Masse = 2.74 / 1000;    
    
    sol = Plan();
    sol.Normale = Vecteur(0, 0, 1);
    sol.Point = Vecteur(0, 0, 0);
    sol.Bornes = [-Inf, Inf; -Inf, Inf; 0, 0]; % �paisseur n�gligeable en Z

    systeme = Systeme();
    systeme.Table = table;
    systeme.Filet = filet;
    systeme.Balle = balle;
    systeme.Sol = sol;
    
    acceleration = Vecteur(0, 0, -9.8);%Force.gravitationel(systeme.Balle.Masse);
    if (prendreEnCompteFrottement)
        acceleration = acceleration + Force.frottementVisqueux(systeme.Balle.Rayon, system.Balle.Vitesse);
    end
    systeme.Acceleration = acceleration;

end