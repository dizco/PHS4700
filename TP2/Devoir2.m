function [coup, tf, rbf, vbf] = Devoir2(option, rbi, vbi, wbi)
% DEVOIR2 Executer le devoir2
%   INPUT
%   option 1: gravite, 
%          2: gravite + frottement, 
%          3: gravite + frottement + Magnus
%   rbi vecteur positions initiales du cm de la balle (m)
%   vbi vecteur vitesse initiale du cm de la balle (m/s)
%   wbi vecteur vitesse angulaire de la balle autour de son cm (rad/s)
%   OUTPUT
%   coup 0 si coup reussi, 
%        1 si atterit cote joueur qui frappe en premier,
%        2 si frappe filet en premier,
%        3 si touche sol en premier
%   tf temps de la fin de la simulation (s)
%   rbf vecteur positions finales du cm de la basse (m)
%   vbf vecteur vitesse finale du cm de la basse (m/s)


	Donnees();
    
    coup = 3;
    tf = 0;
    rbf = [0; 0; 0];
    vbf = [0; 0; 0];
    
    
end

