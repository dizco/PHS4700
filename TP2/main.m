clear;
clc;
clf;
close all;

disp('TP2');

i = 1;

% Cas 1
disp('---- ESSAI 1 ----');
for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.5; 1.1], [4; 0; 0.8], [0; -70; 0]);  
end
disp('==========');
fprintf('\n');

% Cas 2
figure;
disp('---- ESSAI 2 ----');
for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.4; 1.14], [10; 1; 0.2], [0; 100; -50]); 
end
disp('==========');
fprintf('\n'); 

% Cas 3
figure;
disp('---- ESSAI 3 ----');
for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    [coup, tf, rbf, vbf] = Devoir2(i, [2.74; 0.5; 1.14], [-5; 0; 0.2], [0; 100; 0]);  
end
disp('==========');
fprintf('\n'); 

% Cas 4
figure;
disp('---- ESSAI 4 ----');
for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.3; 1], [10; -2; 0.2], [0; 10; -100]);
end
disp('==========');
fprintf('\n'); 




