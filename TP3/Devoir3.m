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
    
    pas = 0.0001; %variation de temps à chaque itération
    
    % Input les vitesses initiales
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
    
    positionsA = [];
    positionsB = [];
    
    tempsEcoule = 0;
    
    [estCollision, point] = etatCollision(systeme.AutoA, systeme.AutoB, [0 0], [0 0], 0);
    disp('Etat Collision');
    disp(estCollision);
    disp(point);
    
    qs = [vbi(1) vbi(2) rbi(1) rbi(2)];
    while 0 %TODO: Loop infinie jusqu'à collision
        
        qs = SEDRK4(qs, 0, tempsEcoule + pas, fonctionG);
        
        % TODO: Runge kutta pour A et B
        
        positionA = Vecteur.CreateFromArray([qs(3) qs(4)]);
        positionB = Vecteur.CreateFromArray([qs(3) qs(4)]);
        positionsA(end + 1) = [positionA.X positionA.Y]; %Push positions pour affichage
        positionsB(end + 1) = [positionB.X positionB.Y]; %Push positions pour affichage
        
        [estCollision, pointCollision] = etatCollision(systeme.AutoA, systeme.AutoB, positionA, positionB, tempsEcoule);
        if (estCollision)
            tf = tempsEcoule + pas;
            %rbf = positionBalle.GetHorizontalArray();
            %vbf = qs(1, 1:3);
            break;
        end
        
        if (tempsEcoule > 100) %TODO: Remove
            disp('Error: Too many iterations. Simulation ended.');
            break;
        end

        tempsEcoule = tempsEcoule + pas;
    end
    print('Simulation');
    
    AutoA = Auto();
    coinsA = getCoinsAutoSansRotation(AutoA, rai)
    dessinerSimulationVisuelle([], [] ,rai, rbi);
end

function dessinerSimulationVisuelle(coinsAjustesA, coinsAjustesB, ra, rb)    
    grid on; %pour un décor quadrillé
    xlabel('X (m)');
    xlim([-2 102]);
    ylabel('Y (m)');
    ylim([-33 46]);
    rouge = [1 0 0];
    bleu = [0 0 1];
    
    patch([],[],[],[]);
    hold on;
    %TODO: Plot A
    %TODO: Plot B
    %legend(plot, {nom});
    hold off;
end

function [estCollision, point] = etatCollision(autoA, autoB, positionA, positionB, temps)

    posA = Vecteur.CreateFromArray(positionA);
    %posB = Vecteur.CreateFromArray(positionB);
    
    disp('autoA');
    disp(autoA);
    %Calcer la position des coins de A
    angleA = angleAuto(autoA, temps);
    disp('angleA');
    disp(angleA);
    coinsA = getCoinsAutoSansRotation(autoA, posA);
    disp('coinsA');
    disp(coinsA);
    coinsAjustesA = ajusterCoinsRotation(coinsA, angleA);
    disp('coinsAjustesA');
    disp(coinsAjustesA);
    
    %TODO: Pour auto B, calculer le temps de rotation avec temps de debut
    %du glissement
    
    estCollision = false;
    point = [0 0];
    

end

function angle = angleAuto(auto, tempsDeRotation)
    %atan prend (Y, X);
    rotationInitiale = rad2deg(atan2(auto.Vitesse(2), auto.Vitesse(1))); %Auto alignée avec sa vitesse
    rotationAngulaire = rad2deg(auto.VitesseAngulaire * tempsDeRotation);
    
    angle = mod(rotationInitiale + rotationAngulaire, 360); %Modulo 360 degrés
end

function coinsAjustes = ajusterCoinsRotation(coins, rotationTotale)
    coinsAjustes = coins;
    disp('coinsAjustes');
    disp(coinsAjustes);
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coin(3) = 0; %Ajouter composante Z
        coinAjuste = Rotation(rotationTotale, coin);
        
        coinsAjustes(c,1) = coinAjuste(1); %Enlever composante Z
        coinsAjustes(c,2) = coinAjuste(2);
        fprintf('coinsAjustes(%i)', c);
        disp(coinsAjustes(c,:));
    end
end

function coins = getCoinsAutoSansRotation(auto, positionCM)
    cm = positionCM;
    if (~isa(positionCM, 'Vecteur'))
        cm = Vecteur.CreateFromArray(positionCM);
    end
    
    c1 = [cm.X - auto.Longueur / 2, cm.Y + auto.Largeur / 2];
    c2 = [cm.X + auto.Longueur / 2, cm.Y + auto.Largeur / 2];
    c3 = [cm.X + auto.Longueur / 2, cm.Y - auto.Largeur / 2];
    c4 = [cm.X - auto.Longueur / 2, cm.Y - auto.Largeur / 2];
    coins = [c1; c2; c3; c4];
end

