function [Coll, tf, raf, vaf, rbf, vbf] = Devoir3(rai, vai, rbi, vbi, tb)
    % DEVOIR3 Executer le devoir3
    
	systeme = Donnees(rai, vai, rbi, vbi);
    
    pasInitial = 0.01;
    pasMin = 0.00001;
    pas = pasInitial; %variation de temps � chaque it�ration
    
    tf = 0;
    raf = [0, 0, 0];
    vaf = [0, 0, 0]; 
    rbf = [0, 0, 0];
    vbf = [0, 0, 0];
    Coll = 1;
    
    tempsEcoule = 0;
    
    positionsA = [systeme.AutoA.Position(1) systeme.AutoA.Position(2)];
    positionsB = [systeme.AutoB.Position(1) systeme.AutoB.Position(2)];
    
    qsA = [systeme.AutoA.Vitesse(1) systeme.AutoA.Vitesse(2) 0 systeme.AutoA.Position(1) systeme.AutoA.Position(2) 0];
    qsB = [systeme.AutoB.Vitesse(1) systeme.AutoB.Vitesse(2) 0 systeme.AutoB.Position(1) systeme.AutoB.Position(2) 0];
   
    while 1 %Loop infinie jusqu'� collision
        
        qsA = SEDRK4(qsA, tempsEcoule, pas, 'frottement', systeme.AutoA);
      
        if(tempsEcoule >= tb) %L'auto B commence � glisser au temps tb
            qsB = SEDRK4(qsB, tempsEcoule, pas, 'frottement', systeme.AutoB);
        else 
            qsB = SEDRK4(qsB, tempsEcoule, pas, 'rouler', systeme.AutoB);
        end        
        
        positionA = Vecteur.CreateFromArray([qsA(4) qsA(5)]);
        normeVitesseA = norm(qsA(1,1:2));
        positionB = Vecteur.CreateFromArray([qsB(4) qsB(5)]);
        normeVitesseB = norm(qsA(1,1:2));
        
%         if (normeVitesseA >= systeme.SeuilVitesseMinimale)
%             coinsA = CalculerCoinsVehicule(systeme.AutoA, positionA, tempsEcoule); %TODO: Enlever cette ligne
%             AfficherVehicule(coinsA, 'b'); %TODO: Enlever cette ligne
%         end
%         
%         if (normeVitesseB >= systeme.SeuilVitesseMinimale)
%             coinsB = CalculerCoinsVehicule(systeme.AutoB, positionB, max(tempsEcoule - tb, 0)); %TODO: Enlever cette ligne
%             AfficherVehicule(coinsB, 'r'); %TODO: Enlever cette ligne
%         end

        positionsA(end + 1,:) = [positionA.X positionA.Y]; %Push positions pour affichage
        positionsB(end + 1,:) = [positionB.X positionB.Y]; %Push positions pour affichage
        
        [estCollision, collisionSphereEnglobante, pointCollision, normale] = EtatCollision(systeme.AutoA, systeme.AutoB, positionA, positionB, tempsEcoule, tb);
        if (estCollision)
            tf = tempsEcoule;
            Coll = 1;
            raf(1, 1:2) = positionA.GetHorizontalArray();
            rbf(1, 1:2) = positionB.GetHorizontalArray();
            vaf = qsA(1, 1:3);
            vbf = qsB(1, 1:3);
            vitessesFinales = VitessesFinalesAutos.vitessesFinales(systeme.AutoA, systeme.AutoB, pointCollision, normale);
            vaf = vitessesFinales(1, 1:3);
            vbf = vitessesFinales(1, 4:6);
            disp("vitesse finales");
            disp(vitessesFinales);
            disp(vaf);
            disp(vbf);
            
            
            break;
        elseif (collisionSphereEnglobante && pas ~= pasMin)
            %TODO: Reduire pas
            pas = pasMin;
        elseif (pas ~= pasInitial)
            pas = pasInitial;
        end
        
       
        
        if (normeVitesseA < systeme.SeuilVitesseMinimale && normeVitesseB < systeme.SeuilVitesseMinimale)
            %TODO: Finir simulation sans collision
            tf = tempsEcoule;
            Coll = 0;
            raf(1, 1:2) = positionA.GetHorizontalArray();
            rbf(1, 1:2) = positionB.GetHorizontalArray();
            vaf = qsA(1, 1:3);
            vbf = qsB(1, 1:3);
            break;
        end
        
        if (tempsEcoule > 20) %TODO: Remove
            disp('Error: Too many iterations. Simulation ended.');
            break;
        end
        
        tempsDebutRotationB = tb;
        raf(3) = deg2rad(angleAuto(systeme.AutoA, tempsEcoule));
        rbf(3) = deg2rad(angleAuto(systeme.AutoB, max(tempsEcoule - tempsDebutRotationB, 0)));
        
        tempsEcoule = tempsEcoule + pas;
        
    end
    
    AficherSimulationVisuelle(systeme, positionsA, positionsB, tf, tb);
end

function AficherSimulationVisuelle(systeme, positionsA, positionsB, tf, tb)    
    grid on; %pour un d�cor quadrill�
    xlabel('X (m)');
    ylabel('Y (m)');
    
    xlim([-10 150]);
    ylim([-10 150]);
    xticks(-10:10:150)
    yticks(-10:10:150)
    
    hold on;
    AffichagePositionsInitiales(systeme);
    hold on;    
    AffichagePositionsFinales(systeme, positionsA(end,:), positionsB(end,:), tf, tb);
    hold on;
    courbeA = plot(positionsA(:,1), positionsA(:,2), 'color', 'b');
    hold on;
    courbeB = plot(positionsB(:,1), positionsB(:,2), 'color', 'r');
    hold off;
    
    legend([courbeA courbeB], 'Auto A', 'Auto B');
end

function AffichagePositionsInitiales(systeme)
    %Affiche la position de chacun des v�hicules

    coinsA = CalculerCoinsVehicule(systeme.AutoA, systeme.AutoA.Position, 0);
    AfficherVehicule(coinsA, 'b');
    coinsB = CalculerCoinsVehicule(systeme.AutoB, systeme.AutoB.Position, 0);
    AfficherVehicule(coinsB, 'r');
end

function AffichagePositionsFinales(systeme, posA, posB, tempsEcoule, tb)
    %Affiche la position de chacun des v�hicules

    coinsA = CalculerCoinsVehicule(systeme.AutoA, posA, tempsEcoule); %Auto A commence a tourner des le debut
    AfficherVehicule(coinsA, 'b');
    coinsB = CalculerCoinsVehicule(systeme.AutoB, posB, max(tempsEcoule - tb, 0)); %Auto B ne commence a tourner qu'au temps tb
    AfficherVehicule(coinsB, 'r');
end
