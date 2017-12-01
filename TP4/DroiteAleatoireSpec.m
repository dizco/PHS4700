clc;
%test boîte noire, noir comme dans le cul d'un ours
%pour tester l'IntervalleAnglesPossibles
systeme = Donnees();
pointObservateur = Vecteur(0, 0, 0);
pointObs2 = Vecteur(0, 0, 0.05);
M = 69;
N = 88;
m = 8;
n = 8;

disp("---------observateur (0, 0, 0)----------");
droite1 = DroiteAleatoire(pointObservateur, systeme, N, M, n, m);
disp("--------observateur (0, 0, 0.05)---------");
droite2 = DroiteAleatoire(pointObs2, systeme, N, M, n, m);