clear;
clc;
clf;
close all;

disp('Devoir 4');

%Cas 1
nout = 1;
nin  = 1;
poso = [0, 0, 5];
[xi, yi, zi, face] = Devoir4(nout, nin, poso);

% disp(xi);
% disp(yi);
% disp(zi);
% disp(face);

%Cas 2
nout = 1;
nin  = 1.5;
poso = [0, 0, 5];
%[xi, yi, zi, face] = Devoir4(nout, nin, poso);

%Cas 3
nout = 1;
nin  = 1.5;
poso = [0, 0, 0];
%[xi, yi, zi, face] = Devoir4(nout, nin, poso);

%Cas 4
nout = 1.2;
nin  = 1;
poso = [0, 0, 5];
%[xi, yi, zi, face] = Devoir4(nout, nin, poso);
