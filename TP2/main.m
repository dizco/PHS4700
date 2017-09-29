clear;
clc;
clf;

disp('TP2');

for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    
    % Cas 1
    disp('---- ESSAI 1 ----');
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.5; 1.1], [4; 0; 0.8], [0; -70; 0]);
    disp('==========');

    % Cas 2
    disp('---- ESSAI 2 ----');
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.4; 1.14], [10; 1; 0.2], [0; 100; -50]);
    disp('==========');
    
    % Cas 3
    disp('---- ESSAI 3 ----');
    [coup, tf, rbf, vbf] = Devoir2(i, [2.74; 0.5; 1.14], [-5; 0; 0.2], [0; 100; 0]);
    disp('==========');
    
    % Cas 4
    disp('---- ESSAI 4 ----');
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0.3; 1], [10; -2; 0.2], [0; 10; -100]);
    disp('----------');
    fprintf('\n');
    
end


