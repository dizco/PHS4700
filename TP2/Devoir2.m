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

    
	systeme = Donnees(rbi, option ~= 1); % Prendre en compte frottement sauf avec option 1
    dessinerSimulationVisuelle();
    positionInitialeBalle = Vecteur.CreateFromArray(rbi);
    vitesseInitialeBalle = Vecteur.CreateFromArray(vbi);
    vitesseAngulaireInitialeBalle = Vecteur.CreateFromArray(wbi);
    
    coup = 3;
    tf = 0;
    rbf = [0; 0; 0];
    vbf = [0; 0; 0];
    
    pas = 0.01;    
    
    positionsX = [];
    positionsY = [];
    positionsZ = [];
    
    n = 0; 
    while 1 %Loop infinie jusqu'à collision
        qs = SEDRK4(positionInitialeBalle.GetHorizontalArray(), 0, n * pas, 'g1');

        positionBalle = Vecteur.CreateFromArray(qs);
        positionsX(end + 1) = positionBalle.X; %Push positions pour affichage
        positionsY(end + 1) = positionBalle.Y;
        positionsZ(end + 1) = positionBalle.Z;
        
        c = etatCollision(systeme, positionInitialeBalle, positionBalle);
        if (c ~= 0)
            coup = c;
            tf = n * pas;
            rbf = qs;
            break;
        end
        
        if (n > 100) %TODO: Remove
            break;
        end

        n = n + 1;
    end
    
    patch(positionsX, positionsY, positionsZ, 'red');
    
    disp('rk4');
    disp(rbf);

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

function coup = etatCollision(systeme, positionDepart, positionBalle)

    % Étape 1
    respecteToleranceFilet = systeme.Filet.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceFilet) %Touche le filet!
        coup = 2;
        return;
    end
    
    % Étape 2
    respecteToleranceTable = systeme.Table.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceTable) %Touche la table!
        %Déterminer si c'est du côté du joueur ou de l'autre
        distInitiale = systeme.Filet.DistanceAuPoint(positionDepart);
        distFinale = systeme.Filet.DistanceAuPoint(positionBalle);
        
        if ((distInitiale < 0 && distFinale < 0) || (distInitiale > 0 && distFinale > 0))
            coup = 1;
        else
            coup = 2;
        end
        return;
    end
    
    % Étape 3
    respecteToleranceSol = systeme.Sol.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceSol) %Touche le sol!
        coup = 3;
        return;
    end
    
    % Étape 4
    coup = 0;

end

