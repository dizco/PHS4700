clc;

%pour tester l'IntervalleAnglesPossibles
systeme = Donnees();
pointObservateur = Vecteur(0, 0, 0);
pointObs2 = Vecteur(0, 0, 0.05);
disp("---------observateur (0, 0, 0)----------");
droite1 = DroiteAleatoire(pointObservateur, systeme);
% disp("--------observateur (0, 0, 0.05)---------");
% droite2 = DroiteAleatoire(pointObs2, systeme);
%-------------