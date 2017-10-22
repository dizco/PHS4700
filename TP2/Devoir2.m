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
%   coup 0 si coup reussi (atterit sur la table du côté opposé au filet), 
%        1 si atterit cote joueur qui frappe en premier,
%        2 si frappe filet en premier,
%        3 si touche sol en premier (hors des bornes)
%   tf temps de la fin de la simulation (s)
%   rbf vecteur positions finales du cm de la balle (m)
%   vbf vecteur vitesse finale du cm de la balle (m/s)

    dessinerSimulationVisuelle();
	systeme = Donnees(rbi, option ~= 1); % Prendre en compte frottement sauf avec option 1
    positionInitialeBalle = Vecteur.CreateFromArray(rbi);
    vitesseInitialeBalle = Vecteur.CreateFromArray(vbi);
    vitesseAngulaireInitialeBalle = Vecteur.CreateFromArray(wbi);
    
    coup = 3;
    tf = 0;
    rbf = [0; 0; 0];
    vbf = [0; 0; 0];
    
    pas = 0.01;
    
    nTemporaire = 0; 
    while nTemporaire < 100 % Remplacer par la détection des collisions
        qs = SEDRK4(positionInitialeBalle.GetHorizontalArray(), 0, nTemporaire * pas, 'g1');
        nTemporaire = nTemporaire + 1;
    end
    
    disp('rk4');
    disp(qs);
    
    
end

function dessinerSimulationVisuelle()
    grid on; %pour un décor quadrillé
    
    %table verte
    vertFonce = [0  0.5  0]; 
    longueurTable = 2.74; largeurTable = 1.525; hauteurTable = 0.76;
    
    patch([0, longueurTable, longueurTable, 0], [0, 0, largeurTable, largeurTable], [hauteurTable, hauteurTable, hauteurTable, hauteurTable], vertFonce);
    %filet jaune
    jauneFonce = [0.8 0.8 0];
    hauteurFilet = 0.1525 + hauteurTable;
    xFilet = longueurTable/2;
    yDebordementFiletNegatif = -0.1525;
    yDebordementFiletPositif = 1.6775;
    patch([xFilet, xFilet, xFilet, xFilet], [yDebordementFiletNegatif, yDebordementFiletNegatif, yDebordementFiletPositif, yDebordementFiletPositif], [hauteurTable, hauteurFilet, hauteurFilet, hauteurTable], jauneFonce); 
end

