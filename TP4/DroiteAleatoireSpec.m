clear;
clc;
clf;
close all;

%pour tester l'IntervalleAnglesPossibles
systeme = Donnees();
pointObservateur = Vecteur(0, 0, 0);
pointObs2 = Vecteur(0, 0, 0.05);
TrouverSecteurDepart(pointObservateur, systeme);
TrouverSecteurDepart(pointObs2, systeme);
%DroiteAleatoire(pointObservateur, systeme);
%-------------