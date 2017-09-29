clear;
clc;
clf;

disp('TP2');

for i = 1:3
    fprintf('---- OPTION %d ----\n', i);
    
    % Cas 1
    disp('---- ESSAI 1 ----');
    [coup, tf, rbf, vbf] = Devoir2(i, [0; 0; 0], [0; 0; 0], [0; 0; 0]);
    disp('==========');

    % Cas 2
    disp('---- ESSAI 2 ----');
    [coup, tf, rbf, vbf] = Devoir2(1, [0; 0; 0], [0; 0; 0], [0; 0; 0]);
    disp('==========');
    
    % Cas 3
    disp('---- ESSAI 2 ----');
    [coup, tf, rbf, vbf] = Devoir2(1, [0; 0; 0], [0; 0; 0], [0; 0; 0]);
    disp('==========');
    
    % Cas 4
    disp('---- ESSAI 2 ----');
    [coup, tf, rbf, vbf] = Devoir2(1, [0; 0; 0], [0; 0; 0], [0; 0; 0]);
    disp('----------');
    fprintf('\n');
    
end


