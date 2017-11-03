function [estCollision, point] = EtatCollision(autoA, autoB, positionA, positionB, tempsEcoule, tempsDebutRotationB)

    posA = Vecteur.CreateFromArray(positionA);
    posB = Vecteur.CreateFromArray(positionB);
    
    grid on;
    xlim([0 15]);
    ylim([0 15]);
    
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
    
    %hold on;
    %plot(coinsAjustesB(1,1),coinsAjustesB(1,2),'r*');
    %hold on;
    %plot(coinsAjustesB(2,1),coinsAjustesB(2,2),'r*');
    %hold on;
    %plot(coinsAjustesB(3,1),coinsAjustesB(3,2),'r*');
    %hold on;
    %plot(coinsAjustesB(4,1),coinsAjustesB(4,2),'r*');
    
    coinsTranslatesB = faireTranslationCoins(coinsAjustesB, posB);
    disp('coinsTranslatesB');
    disp(coinsTranslatesB);
    
    intersection = PointInclusDansSolide(coinsTranslatesA, coinsTranslatesB);
    
    estCollision = intersection;
    point = [0 0];
    

end


function intersection = PointInclusDansSolide(coinsSolideA, coinsSolideB)

    divisionExiste = true;

    for i = 1:(numel(coinsSolideA) / 2)
        indexDeuxiemeCoin = max(mod(i + 1, 5), 1); %On prend prochain, mais on retourne à 1 au lieu de 5
        normale = CalculerPlanSeparateur(coinsSolideA(i,:), coinsSolideA(indexDeuxiemeCoin,:));
        fprintf('normale plan A coins %i et %i', i, indexDeuxiemeCoin);
        disp(normale);
        
        
        for j = 1:(numel(coinsSolideB) / 2)
            
            distance = DistancePlanCoin(normale, coinsSolideA(i,:), coinsSolideB(j,:));
            fprintf('distance au point de B coin %i', j);
            disp(distance);
            if (distance <= 0)
                divisionExiste = false;
            end
            %TODO: interrompre des qu'une division est detectee, car il
            %n'est plus necessaire de calculer
            
        end
        
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
%disp('A');
%disp(normale);
%disp('B');
%disp((coinAutreSolide - pointPlan));
    distance = dot(normale, (coinAutreSolide - pointPlan));
end



function angle = angleAuto(auto, tempsDeRotation)
    %atan prend (Y, X);
    rotationInitiale = rad2deg(atan2(auto.Vitesse(2), auto.Vitesse(1))); %Auto alignée avec sa vitesse
    rotationAngulaire = rad2deg(auto.VitesseAngulaire * tempsDeRotation);
    
    angle = mod(rotationInitiale + rotationAngulaire, 360); %Modulo 360 degrés
end

function coinsAjustes = ajusterCoinsRotation(coins, rotationTotale)
    coinsAjustes = coins;
    matriceRotation = (MatriceRotationZ(deg2rad(rotationTotale))); %inv pour avoir la bonne orientation
    
    disp('matrice rotation');
    disp(matriceRotation);
    
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coin(3) = 0; %Ajouter composante Z
        
        coinAjuste = matriceRotation * transpose(coin);
        
        coinsAjustes(c,1) = coinAjuste(1); %Enlever composante Z
        coinsAjustes(c,2) = coinAjuste(2);
    end
    
end

function coins = getCoinsAutoSansRotation(auto)
    
    c1 = [- auto.Longueur / 2, + auto.Largeur / 2];
    c2 = [+ auto.Longueur / 2, + auto.Largeur / 2];
    c3 = [+ auto.Longueur / 2, - auto.Largeur / 2];
    c4 = [- auto.Longueur / 2, - auto.Largeur / 2];
    coins = [c1; c2; c3; c4];
    
end

function coinsTranslates = faireTranslationCoins(coins, positionCM)
    nouveauxCoins = [];
    cm = positionCM;
    if (isa(positionCM, 'Vecteur'))
        cm = positionCM.GetHorizontalArray();
    end
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coinsTranslates(c,:) = coin + cm;
    end
    
    hold on;
    plot(coinsTranslates(1,1),coinsTranslates(1,2),'b*');
    hold on;
    plot(coinsTranslates(2,1),coinsTranslates(2,2),'b*');
    hold on;
    plot(coinsTranslates(3,1),coinsTranslates(3,2),'b*');
    hold on;
    plot(coinsTranslates(4,1),coinsTranslates(4,2),'b*');
    
end