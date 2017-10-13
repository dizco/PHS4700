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
    
    %etape1 = Etape(Vecteur.CreateFromArray(rbi), Vecteur.CreateFromArray(vbi));
    
    %coup = 3;
    tf = 0;
    rbf = [0; 0; 0];
    vbf = [0; 0; 0];
    
    % Vf = Vi + a * delta_t

    %tempsPourVitesseZNulle = -vitesseInitialeBalle.Z / systeme.Acceleration.Z;
    tempsPourVitesseZNulle = -vitesseInitialeBalle.Z / systeme.Acceleration.Z;
    disp('temps vitesse nulle');
    disp(tempsPourVitesseZNulle);
    
    % delta_x = (Vi + Vf) * delta_t / 2
    hauteurBalleVitesseZNulle = (vitesseInitialeBalle.Z + 0) * tempsPourVitesseZNulle / 2;
    hauteurBalleVitesseZNulle = hauteurBalleVitesseZNulle + positionInitialeBalle.Z;
    disp('hauteur a vitesse z = 0');
    disp(hauteurBalleVitesseZNulle);
    
    % Temps pour que la balle retombe au niveau du filet
    % delta_x = Vi * delta_t + 1/2 * a * delta_t^2
    diffHauteurBalleFilet = (systeme.GetHauteurFilet() - hauteurBalleVitesseZNulle + systeme.Balle.Rayon); % Diff hauteur pour que le bas de la balle soit alignée avec le haut du filet
    tempsPourBalleNiveauFilet = max(roots([1/2 * systeme.Acceleration.Z, 0, -diffHauteurBalleFilet])); % Résout l'équation quadratique
    disp('temps balle hauteur du filet');
    disp(tempsPourBalleNiveauFilet);
    
    % Position lorsque la balle est à la hauteur du filet
    positionXLorsqueHauteurFilet = vitesseInitialeBalle.X * (tempsPourVitesseZNulle + tempsPourBalleNiveauFilet) + positionInitialeBalle.X;
    positionYLorsqueHauteurFilet = vitesseInitialeBalle.Y * (tempsPourVitesseZNulle + tempsPourBalleNiveauFilet) + positionInitialeBalle.Y;
    positionLorsqueHauteurFilet = Vecteur(positionXLorsqueHauteurFilet, positionYLorsqueHauteurFilet, systeme.GetHauteurFilet() + systeme.Balle.Rayon);
    distAuFiletLorsqueHauteurFilet = systeme.DistanceBalleAuFiletSurTable(positionLorsqueHauteurFilet);
    disp('position lorsque hauteur filet');
    disp(positionLorsqueHauteurFilet);
    
    % Temps pour que la balle retombe au niveau de la table
    % delta_x = Vi * delta_t + 1/2 * a * delta_t^2
    diffHauteurBalleTable = (systeme.GetHauteurTable() - positionLorsqueHauteurFilet.Z - systeme.Balle.Rayon); % On veut que la balle soit complètement sous la table
    tempsPourBalleNiveauTable = max(roots([1/2 * systeme.Acceleration.Z, 0, -diffHauteurBalleTable])); % Résout l'équation quadratique
    disp('temps balle hauteur de la table');
    disp(tempsPourBalleNiveauTable);    
    
    % Position lorsque la balle est a la hauteur de la table
    positionXLorsqueHauteurTable = vitesseInitialeBalle.X * (tempsPourVitesseZNulle + tempsPourBalleNiveauFilet + tempsPourBalleNiveauTable) + positionInitialeBalle.X;
    positionYLorsqueHauteurTable = vitesseInitialeBalle.Y * (tempsPourVitesseZNulle + tempsPourBalleNiveauFilet + tempsPourBalleNiveauTable) + positionInitialeBalle.Y;
    positionLorsqueHauteurTable = Vecteur(positionXLorsqueHauteurTable, positionYLorsqueHauteurTable, systeme.GetHauteurTable() - systeme.Balle.Rayon);
    distAuFiletLorsqueHauteurTable = systeme.DistanceBalleAuFiletSurTable(positionLorsqueHauteurTable);
    disp('position lorsque hauteur table');
    disp(positionLorsqueHauteurTable);
    
    % Étape 1
    bornesValides1 = systeme.Table.RespecteBornesAvecTolerance(positionLorsqueHauteurFilet, systeme.Balle.Rayon);
    bornesValides2 = systeme.Filet.RespecteBornesAvecTolerance(positionLorsqueHauteurFilet, systeme.Balle.Rayon);
    
    bornesValides3 = systeme.Filet.RespecteBornesAvecTolerance(positionLorsqueHauteurTable, systeme.Balle.Rayon); % On ne vérifie pas les bornes de la table, car le filet dépasse sur les côtés
    
    aToucheFilet = (bornesValides1 && bornesValides2 && bornesValides3 && distAuFiletLorsqueHauteurFilet <= 0 && distAuFiletLorsqueHauteurTable > 0);
    if (aToucheFilet)
        coup = 2;
        % TODO: Calculer temps pour se rendre au sol, afin de pouvoir
        % retourner tf, rbf et vbf
        return;
    end
    
    
    % Étape 2
    bornesValidesEtape2 = systeme.Table.RespecteBornesAvecTolerance(positionLorsqueHauteurTable, systeme.Balle.Rayon);
    if (~bornesValidesEtape2)
        coup = 3;
        % TODO: Calculer temps pour se rendre au sol, afin de pouvoir
        % retourner tf, rbf et vbf
        return;
    end
    
    % Étape 3
    if (distAuFiletLorsqueHauteurTable < 0)
        coup = 1;
        % TODO: Calculer temps pour toucher la table, afin de pouvoir
        % retourner tf, rbf et vbf
        return;
    end
    
    % Étape 4
    coup = 0;
    % TODO: Calculer temps pour toucher la table, afin de pouvoir
    % retourner tf, rbf et vbf
        
    
    % Thought process : 
    
    % 1. Si la balle est d'un côté du filet lorsque h = hauteur du filet, puis
    % qu'elle est de l'autre côté lorsque h = hauteur de la table, on sait
    % que la balle a touché le filet
    
    % 2. Si la balle est hors bornes lorsque h = hauteur de la table, on sait
    % que la balle est hors jeu
    
    % 3. Si la balle est en X < Xfilet lorsque h = hauteur de la table, on
    % sait que la balle atterit dans la zone du joueur qui a frappé
    
    % 4. Si aucun des cas précédents n'a été détecté, alors la balle est
    % valide
    
    
    
end

function dessinerSimulationVisuelle()
    grid on;
    A = 6;
    B = 4;
    C = 3;
    D = 2;

    x = [1 -1 -1 1];
    y = [1 1 -1 -1];
    z = -1/C*(A*x + B*y + D); 
    %table verte
    patch([0 2.74 2.74 0], [0 0 1.525 1.525], [0.76 0.76 0.76 0.76], [0  0.5  0]);
    %filet jaune 0.9125
    patch([1.37 1.37 1.37 1.37], [-0.1525 -0.1525 1.6775 1.6775], [0.76 0.9125 0.9125 0.76], [0.8 0.8 0]);
    %patch([1 -1 -1 1], [1 1 -1 -1], [0 0 0 0], [1 1 -1 -1])  

end

