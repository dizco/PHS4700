function [Coll, tf, raf, vaf, rbf, vbf] = Devoir3(rai, vai, rbi, vbi, tb)
    % DEVOIR3 Executer le devoir3
    
	systeme = Donnees(rai, vai, rbi, vbi);
    
    pas = 0.1; %variation de temps � chaque it�ration  
    
    tf = 0;
    raf = [0, 0];
    vaf = [0, 0, 0]; 
    rbf = [0, 0];
    vbf = [0, 0, 0];
    Coll = 1;
    
    tempsEcoule = 0;
    
    positionsA = [];
    positionsB = [];
    
    
    qsA = [systeme.AutoA.Vitesse(1) systeme.AutoA.Vitesse(2) 0 systeme.AutoA.Position(1) systeme.AutoA.Position(2) 0];
    qsB = [systeme.AutoB.Vitesse(1) systeme.AutoB.Vitesse(2) 0 systeme.AutoB.Position(1) systeme.AutoB.Position(2) 0];
   
    while 1 %Loop infinie jusqu'� collision
        
        qsA = SEDRK4(qsA, tempsEcoule, pas, 'frottement', systeme.AutoA);
      
%         if(tempsEcoule >= tb) %L'auto B commence � glisser au temps tb
%             qsB = SEDRK4(qsB, tempsEcoule, pas, 'frottement', systeme.AutoB);
%         else 
%             qsB = SEDRK4(qsB, tempsEcoule, pas, 'rouler', systeme.AutoB);
%         end        
        
        positionA = Vecteur.CreateFromArray([qsA(4) qsA(5)]);
        
        %disp('qsA');
        %disp(qsA);
        
        %disp('positonA');
        %disp(positionA);
        
        coinsA = CalculerCoinsVehicule(systeme.AutoA, positionA, tempsEcoule); %TODO: Enlever cette ligne
        AfficherVehicule(coinsA, 'b'); %TODO: Enlever cette ligne
        
        %positionB = Vecteur.CreateFromArray([qsB(4) qsB(5)]);
        positionB = Vecteur.CreateFromArray(systeme.AutoB.Position);

        positionsA(end + 1,:) = [positionA.X positionA.Y]; %Push positions pour affichage
        positionsB(end + 1,:) = [positionB.X positionB.Y]; %Push positions pour affichage
        
        
        [estCollision, collisionSphereEnglobante, pointCollision] = EtatCollision(systeme.AutoA, systeme.AutoB, positionA, positionB, tempsEcoule, tb);
        if (estCollision)
            tf = tempsEcoule;
            %rbf = positionBalle.GetHorizontalArray();
            %vbf = qs(1, 1:3);
            break;
        elseif (collisionSphereEnglobante)
            %TODO: Reduire pas
        end
        
        if (tempsEcoule > 30) %TODO: Remove
            disp('Error: Too many iterations. Simulation ended.');
            break;
        end
        
        tempsEcoule = tempsEcoule + pas;
        
    end
    
    AficherSimulationVisuelle(systeme, positionsA, positionsB, tf, tb);
end

function AficherSimulationVisuelle(systeme, positionsA, positionsB, tf, tb)    
    grid on; %pour un d�cor quadrill�
    xlabel('X (m)');
    ylabel('Y (m)');
    
    xlim([0 100]);
    ylim([0 100]);
    xticks(0:5:100)
    yticks(0:5:100)
    
    hold on;    
    AffichagePositionsFinales(systeme, positionsA(end,:), positionsB(end,:), tf, tb);
    hold on;
    courbeA = plot(positionsA(:,1), positionsA(:,2), 'color', 'b');
    hold on;
    courbeB = plot(positionsB(:,1), positionsB(:,2), 'color', 'r');
    hold off;
    
    legend([courbeA courbeB], 'Auto A', 'Auto B');
end

function AffichagePositionsFinales(systeme, posA, posB, tempsEcoule, tb)
    %Affiche la position de chacun des v�hicules

    coinsA = CalculerCoinsVehicule(systeme.AutoA, posA, tempsEcoule); %Auto A commence a tourner des le debut
    AfficherVehicule(coinsA, 'b');
    coinsB = CalculerCoinsVehicule(systeme.AutoB, posB, max(tempsEcoule - tb, 0)); %Auto B ne commence a tourner qu'au temps tb
    AfficherVehicule(coinsB, 'r');
end
