function [Coll, tf, raf, vaf, rbf, vbf] = Devoir3(rai, vai, rbi, vbi, tb)

% DEVOIR3 Executer le devoir3
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

    fonctionG = 'g1';
    
	systeme = Donnees();
    
    pas = 0.01; %variation de temps à chaque itération
    
    % Input les vitesses initiales
    systeme.AutoA.Position = [rai(1) rai(2)];
  
    
    systeme.AutoB.Position = [rbi(1) rbi(2)];
    systeme.AutoA.Vitesse = [vai(1) vai(2)];
    systeme.AutoA.VitesseAngulaire = vai(3);
    systeme.AutoB.Vitesse = [vbi(1) vbi(2)];
    systeme.AutoB.VitesseAngulaire = vbi(3);
  
    
    tf = 0;
    raf = [0; 0];
    vaf = [0; 0; 0]; 
    rbf = [0; 0];
    vbf = [0; 0; 0];
    Coll = 1;
    
    tempsEcoule = 0;
    
    
    qsA = [systeme.AutoA.Vitesse(1) systeme.AutoA.Vitesse(2) 0 systeme.AutoA.Position(1) systeme.AutoA.Position(2) 0];
    qsB = [systeme.AutoB.Vitesse(1) systeme.AutoB.Vitesse(2) 0 systeme.AutoB.Position(1) systeme.AutoB.Position(2) 0];
   
    while 1 %TODO: Loop infinie jusqu'à collision
        qsA = SEDRK4(qsA, 0, tempsEcoule + pas, 'frottement', systeme.AutoA);
        if(tempsEcoule >= tb)
            qsB = SEDRK4(qsB, 0, tempsEcoule + pas, 'frottement', systeme.AutoB);
        else 
            qsB = SEDRK4(qsB, 0, tempsEcoule + pas, 'rouler', systeme.AutoB);
        end    
        % TODO: Runge kutta pour A et B
        
        
        positionA = Vecteur.CreateFromArray([qsA(4) qsA(5)]);
        %positionB = Vecteur.CreateFromArray([qsB(4) qsB(5)]);
        positionB = [0 0];

        %positionsA(end + 1) = [positionA.X positionA.Y]; %Push positions pour affichage
        %positionsB(end + 1) = [positionB.X positionB.Y]; %Push positions pour affichage
       
        [estCollision, pointCollision] = EtatCollision(systeme.AutoA, systeme.AutoB, positionA, positionB, tempsEcoule, tb);
        if (estCollision)
            tf = tempsEcoule + pas;
            %rbf = positionBalle.GetHorizontalArray();
            %vbf = qs(1, 1:3);
            %break;
        end
        
        if (tempsEcoule > 10) %TODO: Remove
            disp('Error: Too many iterations. Simulation ended.');
            break;
        end

        tempsEcoule = tempsEcoule + pas;
    end
    print('Simulation');
    
    %AutoA = Auto();
    %coinsA = getCoinsAutoSansRotation(AutoA, rai)
    %dessinerSimulationVisuelle([], [] ,rai, rbi);
end

function dessinerSimulationVisuelle(coinsAjustesA, coinsAjustesB, ra, rb)    
    grid on; %pour un décor quadrillé
    xlabel('X (m)');
    xlim([-3 3]);
    ylabel('Y (m)');
    ylim([-3 3]);
    rouge = [1 0 0];
    bleu = [0 0 1];
    
    patch([],[],[],[]);
    hold on;
    %TODO: Plot A
    %TODO: Plot B
    %legend(plot, {nom});
    hold off;
end

