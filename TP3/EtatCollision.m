function [estCollision, point] = EtatCollision(autoA, autoB, positionA, positionB, tempsEcoule, tempsDebutRotationB)

    if (~isa(positionA, 'Vecteur'))
        posA = Vecteur.CreateFromArray(positionA);
    else
        posA = positionA;
    end
    
    if (~isa(positionB, 'Vecteur'))
        posB = Vecteur.CreateFromArray(positionB);
    else
        posB = positionB;
    end
    
    grid minor;
    xlim([0 150]);
    ylim([0 150]);
    
    disp('autoA');
    disp(autoA);
    angleA = angleAuto(autoA, tempsEcoule); %Auto A commence a tourner des le debut
    %disp('angleA');
    %disp(angleA);
    coinsA = getCoinsAutoSansRotation(autoA);
    %disp('coinsA');
    %disp(coinsA);
    coinsAjustesA = ajusterCoinsRotation(coinsA, angleA);
    %disp('coinsAjustesA');
    %disp(coinsAjustesA);
    
    coinsTranslatesA = faireTranslationCoins(coinsAjustesA, posA);
    AfficherVehicule(coinsTranslatesA);
    disp('coinsTranslatesA');
    disp(coinsTranslatesA);
    
    
    disp('autoB');
    disp(autoB);
    angleB = angleAuto(autoB, max(tempsEcoule - tempsDebutRotationB, 0)); %Auto B ne commence a tourner qu'au temps tb
    %disp('angleB');
    %disp(angleB);
    coinsB = getCoinsAutoSansRotation(autoB);
    %disp('coinsB');
    %disp(coinsB);
    coinsAjustesB = ajusterCoinsRotation(coinsB, angleB);
    %disp('coinsAjustesB');
    %disp(coinsAjustesB);
    
    
    coinsTranslatesB = faireTranslationCoins(coinsAjustesB, posB);
    %AfficherVehicule(coinsTranslatesB);
    disp('coinsTranslatesB');
    disp(coinsTranslatesB);
    
    intersection = IntersectionDeuxSolides(coinsTranslatesA, coinsTranslatesB);
    
    estCollision = intersection;
    point = [0 0];
    

end


function [intersection] = IntersectionDeuxSolides(coinsSolideA, coinsSolideB)

    divisionExiste = false;

    for i = 1:(numel(coinsSolideA) / 2)
        indexDeuxiemeCoin = max(mod(i + 1, 5), 1); %On prend prochain, mais on retourne à 1 au lieu de 5
        normale = CalculerPlanSeparateur(coinsSolideA(i,:), coinsSolideA(indexDeuxiemeCoin,:));
        %fprintf('normale plan A coins %i et %i', i, indexDeuxiemeCoin);
        %disp(normale);
        
        estPlanDivision = true;
        
        for j = 1:(numel(coinsSolideB) / 2)
            
            distance = DistancePlanCoin(normale, coinsSolideA(i,:), coinsSolideB(j,:));
            %fprintf('distance au point de B coin %i', j);
            %disp(distance);
            if (distance <= 0)
                estPlanDivision = false;
            end
            %TODO: interrompre des qu'une division est detectee, car il
            %n'est plus necessaire de calculer
            
        end
        
        if (estPlanDivision)
            divisionExiste = true;
        end
        
        fprintf('plan division pour i = %i et j = %i : %i \n', i, j, estPlanDivision);
        
    end
    
    intersection = ~divisionExiste;

end

function normale = CalculerPlanSeparateur(coin1, coin2)
    %Par convention, on s'assure que les coins sont disposés en sens antihoraire
    %Lorsqu'on regarde la face définie par les coins 1 et 2, on veut que le
    %coin 1 soit à droite et le coin 2 à gauche. On crée ensuite
    %dynamiquement un coin 3 situé sous le coin 2. Vue de face :
    % 2---1
    % |   |
    % |   |
    % 3---
    
    coin1(3) = 1;
    coin2(3) = 1;
    
    coin3 = coin2;
    coin3(3) = 0; %On met le coin 3 en dessous du coin 2, la valeur de Z n'est pas importante pour le calcul de la normale
    
    pk1 = coin1 - coin2;
    pk2 = coin1 - coin3;
    
    normale = cross(pk1, pk2) / norm(cross(pk1, pk2));
    normale = [normale(1) normale(2)]; %Exclure la dimension Z
end

function distance = DistancePlanCoin(normale, pointPlan, coinAutreSolide)
    %Applique la formule de distance entre le plan qui contient qk1 et un coin rij
    %di,j,k = nk ·(ri,j ? qk,1) (p. 113 Manuel de référence)
    
    distance = dot(normale, (coinAutreSolide - pointPlan));
end


function angle = angleAuto(auto, tempsDeRotation)
    %Calcule l'angle total de rotation de l'auto
    %Retourne un angle en DEGRÉS

    %atan prend (Y, X);
    rotationInitiale = rad2deg(atan2(auto.Vitesse(2), auto.Vitesse(1))); %Auto alignée avec sa vitesse
    rotationAngulaire = rad2deg(auto.VitesseAngulaire * tempsDeRotation);
    
    angle = mod(rotationInitiale + rotationAngulaire, 360); %Modulo 360 degrés
end

function coinsAjustes = ajusterCoinsRotation(coins, rotationTotale)
    %Applique une matrice de rotation sur les coins
    %Il faut s'assurer d'appeler cette fonction AVANT d'appliquer une translation
    %rotationTotale doit être en DEGRÉS
    
    coinsAjustes = coins;
    matriceRotation = MatriceRotationZ(deg2rad(rotationTotale)); %Convertir en rad  
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coin(3) = 0; %Ajouter composante Z
        
        coinAjuste = matriceRotation * transpose(coin);
        
        coinsAjustes(c,1) = coinAjuste(1); %Enlever composante Z
        coinsAjustes(c,2) = coinAjuste(2);
    end
    
end

function coins = getCoinsAutoSansRotation(auto)
    %Nous donne la disposition des coins de l'auto si on ne considère ni la
    %rotation ni la translation (donc, CM à [0 0])
    
    c1 = [- auto.Longueur / 2, + auto.Largeur / 2];
    c2 = [+ auto.Longueur / 2, + auto.Largeur / 2];
    c3 = [+ auto.Longueur / 2, - auto.Largeur / 2];
    c4 = [- auto.Longueur / 2, - auto.Largeur / 2];
    coins = [c1; c2; c3; c4];
    
end

function coinsTranslates = faireTranslationCoins(coins, positionCM)
    %Applique une translation sur tous les coins du véhicule

    coinsTranslates = [];
    cm = positionCM;
    if (isa(positionCM, 'Vecteur'))
        cm = positionCM.GetHorizontalArray();
    end
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coinsTranslates(c,:) = coin + cm;
    end
    
end

function AfficherVehicule(coins)
    %Affiche les coins et les arêtes du véhicule

    hold on;
    plot(coins(1,1),coins(1,2),'b.');
    hold on;
    plot(coins(2,1),coins(2,2),'b.');
    hold on;
    plot(coins(3,1),coins(3,2),'b.');
    hold on;
    plot(coins(4,1),coins(4,2),'b.');
    
    hold on;
    plot([coins(1,1) coins(2,1)], [coins(1,2) coins(2,2)], 'r');
    hold on;
    plot([coins(2,1) coins(3,1)], [coins(2,2) coins(3,2)], 'r');
    hold on;
    plot([coins(3,1) coins(4,1)], [coins(3,2) coins(4,2)], 'r');
    hold on;
    plot([coins(4,1) coins(1,1)], [coins(4,2) coins(1,2)], 'r');
end