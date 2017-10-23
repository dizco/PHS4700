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
%   coup 0 si coup reussi (atterit sur la table du c�t� oppos� au filet), 
%        1 si atterit cote joueur qui frappe en premier,
%        2 si frappe filet en premier,
%        3 si touche sol en premier (hors des bornes)
%   tf temps de la fin de la simulation (s)
%   rbf vecteur positions finales du cm de la balle (m)
%   vbf vecteur vitesse finale du cm de la balle (m/s)

    fonctionG = 'g1';
    if (option == 2)
        fonctionG = 'g2';
    end
    if (option == 3)
        fonctionG = 'g3';
    end

	systeme = Donnees(rbi, wbi);
    positionInitialeBalle = Vecteur.CreateFromArray(rbi);
    vitesseInitialeBalle = Vecteur.CreateFromArray(vbi);
    vitesseAngulaireInitialeBalle = Vecteur.CreateFromArray(wbi);
    
    pas = 0.00001; %variation de temps � chaque it�ration
    
    coup = 3;
    tf = 0;
    rbf = [0; 0; 0];
    vbf = [0; 0; 0];
    
    positionsX = [];
    positionsY = [];
    positionsZ = [];
    
    tempsEcoule = 0;
    
    qs = [vbi(1) vbi(2) vbi(3) rbi(1) rbi(2) rbi(3)];
    while 1 %Loop infinie jusqu'� collision
        
        qs = SEDRK4(qs, 0, tempsEcoule + pas, fonctionG, systeme.Balle);
        
        positionBalle = Vecteur.CreateFromArray([qs(4) qs(5) qs(6)]);
        positionsX(end + 1) = positionBalle.X; %Push positions pour affichage
        positionsY(end + 1) = positionBalle.Y;
        positionsZ(end + 1) = positionBalle.Z;
        
        c = etatCollision(systeme, positionInitialeBalle, positionBalle);
        if (c ~= 0)
            coup = c;
            tf = tempsEcoule + pas;
            rbf = positionBalle.GetHorizontalArray();
            vbf = qs(1, 1:3);
            break;
        end
        
        if (tempsEcoule > 10) %TODO: Remove
            disp('Error: Too many iterations. Simulation ended.');
            break;
        end

        tempsEcoule = tempsEcoule + pas;
    end
    
    hold on;
    %legende = int2str(option);
    %legende = "option" + legende;
    plot = plot3(positionsX, positionsY, positionsZ);
    hold on;
    legend(plot(option), option);
    hold on;
    dessinerSimulationVisuelle();
    %legend(trajetBalle, legende, 'Location', 'northeast', 'AutoUpdate','off');
    %legend = {'gravity only', 'viscosity and gravity', 'Magnus, viscosity and gravity'};
    %h = findobj(gca,'Type','line');
    %legend(h, legend, 'Location', 'northeast', 'AutoUpdate','off');
    disp('position finale');
    disp(rbf);

end

function dessinerSimulationVisuelle()
    hold on;
    grid on; %pour un d�cor quadrill�
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    %table verte
    vertFonce = [0  0.5  0]; 
    longueurTable = 2.74; largeurTable = 1.525; hauteurTable = 0.76;
    
    patch([0, longueurTable, longueurTable, 0], [0, 0, largeurTable, largeurTable], [hauteurTable, hauteurTable, hauteurTable, hauteurTable], vertFonce);
    hold on;
    %filet jaune
    jauneFonce = [0.8 0.8 0];
    hauteurFilet = 0.1525 + hauteurTable;
    xFilet = longueurTable/2;
    yDebordementFiletNegatif = -0.1525;
    yDebordementFiletPositif = 1.6775;
    patch([xFilet, xFilet, xFilet, xFilet], [yDebordementFiletNegatif, yDebordementFiletNegatif, yDebordementFiletPositif, yDebordementFiletPositif], [hauteurTable, hauteurFilet, hauteurFilet, hauteurTable], jauneFonce); 
    hold on;
    %axis equal;
    view([0, 0, hauteurTable * 2]);
end

function coup = etatCollision(systeme, positionDepart, positionBalle)

    % �tape 1
    respecteToleranceFilet = systeme.Filet.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceFilet) %Touche le filet!
        coup = 2;
        return;
    end
    
    % �tape 2
    respecteToleranceTable = systeme.Table.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceTable) %Touche la table!
        %D�terminer si c'est du c�t� du joueur ou de l'autre
        distInitiale = systeme.Filet.DistanceAuPoint(positionDepart);
        distFinale = systeme.Filet.DistanceAuPoint(positionBalle);
        
        if ((distInitiale < 0 && distFinale < 0) || (distInitiale > 0 && distFinale > 0))
            coup = 1;
        else
            coup = 2;
        end
        return;
    end
    
    % �tape 3
    respecteToleranceSol = systeme.Sol.RespecteBornesAvecTolerance(positionBalle, systeme.Balle.Rayon);
    if (respecteToleranceSol) %Touche le sol!
        coup = 3;
        return;
    end
    
    % �tape 4
    coup = 0;

end

