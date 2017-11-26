clc;

%pour tester l'IntervalleAnglesPossibles
systeme = Donnees();
pointObservateur = Vecteur(0, 0, 0);
pointObs2 = Vecteur(0, 0, 0.05);
droite1 = DroiteAleatoire(pointObservateur, systeme);
droite2 = DroiteAleatoire(pointObs2, systeme);
%DroiteAleatoire(pointObservateur, systeme);
%-------------