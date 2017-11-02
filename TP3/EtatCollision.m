function [estCollision, point] = EtatCollision(autoA, autoB, positionA, positionB, tempsEcoule, tempsDebutRotationB)

    posA = Vecteur.CreateFromArray(positionA);
    posB = Vecteur.CreateFromArray(positionB);
    
    grid on;
    xlim([0 50]);
    ylim([0 15]);
    
    disp('autoA');
    disp(autoA);
    angleA = angleAuto(autoA, tempsEcoule); %Auto A commence a tourner des le debut
    disp('angleA');
    disp(angleA);
    coinsA = getCoinsAutoSansRotation(autoA);
    disp('coinsA');
    disp(coinsA);
    coinsAjustesA = ajusterCoinsRotation(coinsA, angleA);
    disp('coinsAjustesA');
    disp(coinsAjustesA);
    
    coinsTranslatesA = faireTranslationCoins(coinsAjustesA, posA);
    disp('coinsTranslatesA');
    disp(coinsTranslatesA);
    
    
    disp('autoB');
    disp(autoB);
    angleB = angleAuto(autoB, max(tempsEcoule - tempsDebutRotationB, 0)); %Auto B ne commence a tourner qu'au temps tb
    disp('angleB');
    disp(angleB);
    coinsB = getCoinsAutoSansRotation(autoB);
    disp('coinsB');
    disp(coinsB);
    coinsAjustesB = ajusterCoinsRotation(coinsB, angleB);
    disp('coinsAjustesB');
    disp(coinsAjustesB);
    
    coinsTranslatesB = faireTranslationCoins(coinsAjustesB, posB);
    disp('coinsTranslatesB');
    disp(coinsTranslatesB);
    
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
    matriceRotation = inv(MatriceRotationZ(deg2rad(rotationTotale))); %inv pour avoir la bonne orientation
    disp('matriceRotation');
    disp(matriceRotation);
    
    for c = 1:(numel(coins) / 2)
        coin = coins(c,:);
        coin(3) = 0; %Ajouter composante Z
        
        coinAjuste = matriceRotation * transpose(coin);
        
        coinsAjustes(c,1) = coinAjuste(1); %Enlever composante Z
        coinsAjustes(c,2) = coinAjuste(2);
    end
    
    %hold on;
    %plot(coinsAjustes(1,1),coinsAjustes(1,2),'b*');
    %hold on;
    %plot(coinsAjustes(2,1),coinsAjustes(2,2),'b*');
    %hold on;
    %plot(coinsAjustes(3,1),coinsAjustes(3,2),'b*');
    %hold on;
    %plot(coinsAjustes(4,1),coinsAjustes(4,2),'b*');
end

function coins = getCoinsAutoSansRotation(auto)
    
    c1 = [- auto.Longueur / 2, + auto.Largeur / 2];
    c2 = [+ auto.Longueur / 2, + auto.Largeur / 2];
    c3 = [+ auto.Longueur / 2, - auto.Largeur / 2];
    c4 = [- auto.Longueur / 2, - auto.Largeur / 2];
    coins = [c1; c2; c3; c4];
    
    %hold on;
    %plot(c1(1),c1(2),'r*');
    %hold on;
    %plot(c2(1),c2(2),'r*');
    %hold on;
    %plot(c3(1),c3(2),'r*');
    %hold on;
    %plot(c4(1),c4(2),'r*');
end

function coinsTranslates = faireTranslationCoins(coins, positionCM)
    nouveauxCoins = [];
    cm = positionCM;
    if (isa(positionCM, 'Vecteur'))
        cm = positionCM.GetHorizontalArray();
    end
    
    disp('cm');
    disp(cm);
    
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