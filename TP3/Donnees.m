function systeme = Donnees() 

    autoA = Auto();
    autoA.Masse = 1540;
    autoA.Longueur = 4.78;
    autoA.Largeur = 1.82;
    autoA.Hauteur = 1.8;
    
    autoB = Auto();
    autoB.Masse = 1010;
    autoB.Longueur = 4.23;
    autoB.Largeur = 1.6;
    autoB.Hauteur = 1.8;

    systeme = Systeme();
    systeme.AutoA = autoA;
    systeme.AutoB = autoB;

end