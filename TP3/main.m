clear;
clc;
clf;
close all;

disp('TP3');

% Tir 2
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [20 0 2], [100 100], [0 -20 -1], 0.0);
print(Coll, tf, raf, vaf, rbf, vbf, 1);

% Tir 2
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [30 0 2], [100 100], [0 -30 -1], 0.0);
print(Coll, tf, raf, vaf, rbf, vbf, 2);

%Tir 3
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [20 0 2], [100 50], [0 -10 0], 1.6);
print(Coll, tf, raf, vaf, rbf, vbf, 3);

% Tir 4
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [10 10 1], [25 10], [10 0 0], 0.0);
print(Coll, tf, raf, vaf, rbf, vbf, 4);

%Tir 5
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [20 0 2], [100 50], [0 -10 0], 0.0);
print(Coll, tf, raf, vaf, rbf, vbf, 5);

%Tir 6
figure;
[Coll, tf, raf, vaf, rbf, vbf] = Devoir3([0 0], [20 2 2], [100 10], [10 0 5], 1.0);
print(Coll, tf, raf, vaf, rbf, vbf, 6);


function print(Coll, tf, raf, vaf, rbf, vbf, i)
    affichage = ['-----TIR ', num2str(i), '------'];
    disp(affichage);
    fprintf('Collision = %s\n', stringCollision(Coll));
    fprintf('Temps = %d\n', tf);
    
    fprintf('PositionA = [%i %i]\n', raf(1), raf(2));
    fprintf('VitesseA = [%i %i %i]\n', vaf(1), vaf(2), vaf(3));
    
    fprintf('PositionB = [%i %i]\n', rbf(1), rbf(2));
    fprintf('VitesseB = [%i %i %i]\n', vbf(1), vbf(2), vbf(3));
    
    disp('-----');
    fprintf('\n');
end

function str = stringCollision(coll)
    if (coll == 1)
        str = 'Faux';
    else
        str = 'Vrai';
    end
end


