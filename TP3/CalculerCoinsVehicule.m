function coins = CalculerCoinsVehicule(auto, cm, tempsRotation)

    angle = angleAuto(auto, tempsRotation); %Calculer l'angle actuel du v�hicule
    coinsOrigine = getCoinsAutoSansRotation(auto); %Calculer les coins du v�hicule � l'origine
    coinsAjustes = ajusterCoinsRotation(coinsOrigine, angle); %Ajuster la rotation du v�hicule
    
    coins = faireTranslationCoins(coinsAjustes, cm); %Ajuster la translation du v�hicule
end

function angle = angleAuto(auto, tempsDeRotation)
    %Calcule l'angle total de rotation de l'auto
    %Retourne un angle en DEGR�S

    %atan prend (Y, X);
    rotationInitiale = rad2deg(atan2(auto.Vitesse(2), auto.Vitesse(1))); %Auto align�e avec sa vitesse
    rotationAngulaire = rad2deg(auto.VitesseAngulaire * tempsDeRotation);
    
    angle = mod(rotationInitiale + rotationAngulaire, 360); %Modulo 360 degr�s
end

function coinsAjustes = ajusterCoinsRotation(coins, rotationTotale)
    %Applique une matrice de rotation sur les coins
    %Il faut s'assurer d'appeler cette fonction AVANT d'appliquer une translation
    %rotationTotale doit �tre en DEGR�S
    
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
    %Nous donne la disposition des coins de l'auto si on ne consid�re ni la
    %rotation ni la translation (donc, CM � [0 0])
    
    c1 = [- auto.Longueur / 2, + auto.Largeur / 2];
    c2 = [+ auto.Longueur / 2, + auto.Largeur / 2];
    c3 = [+ auto.Longueur / 2, - auto.Largeur / 2];
    c4 = [- auto.Longueur / 2, - auto.Largeur / 2];
    coins = [c1; c2; c3; c4];
    
end

function coinsTranslates = faireTranslationCoins(coins, positionCM)
    %Applique une translation sur tous les coins du v�hicule

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