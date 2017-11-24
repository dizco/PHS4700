clear;
clc;
clf;
close all;

%pour tester l'IntervalleAnglesPossibles
systeme = Donnees();
pointObservateur = Vecteur(0, 0, 0);
pointObs2 = Vecteur(0, 0, 0.05);
ranges1 = TrouverSecteurDepart(pointObservateur, systeme);
ranges2 = TrouverSecteurDepart(pointObs2, systeme);
%DroiteAleatoire(pointObservateur, systeme);
%-------------