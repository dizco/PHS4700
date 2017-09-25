clear;
clc;
clf;

disp('TP1')

% Cas 1
disp('---- CAS 1 ----');
[pcmNL, INL, alphaNL]=Devoir1(0,[0;0;0],[11000000; 8750000; 875000],[0;0;0]);
disp('==========');


% Cas 2
disp('---- CAS 2 ----');
[pcmNL, INL, alphaNL]=Devoir1(-(pi/3),[0;0;0],[11000000; 8750000; 0],[0; -19.6075; 50]);
