clear;
clc;
clf;

disp('TP1')

Donnees();
disp(navette);
%disp(navette.CentreDeMasse);
disp(navette.Cylindre);
disp(navette.Cone);

disp(propulseurGauche.CentreDeMasse);
disp(propulseurDroit.CentreDeMasse);

% Cas 1
[pcmNL, INL, alphaNL]=Devoir1(0,0,[11000000, 8750000, 875000],[0,0,0]);

