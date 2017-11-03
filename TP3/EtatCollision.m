function [estCollision, collisionSphereEnglobante, point] = EtatCollision(autoA, autoB, positionA, positionB, tempsEcoule, tempsDebutRotationB)
    %Utilise une stratégie mixte : On teste en premier si les solides sont
    %en collision avec leurs sphères englobantes, si non, alors on passe à
    %la méthode des plans de division

    point = [0 0];

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
    
    
    [collisionSphereEnglobante] = InteresectionSpheresEnglobantes(autoA, autoB, positionA, positionB);
    if (~collisionSphereEnglobante)
        disp('aucune collision entre les spheres englobantes!');
        estCollision = false;
        return;
    end
    
    
    angleA = angleAuto(autoA, tempsEcoule); %Auto A commence a tourner des le debut
    coinsA = getCoinsAutoSansRotation(autoA);
    coinsAjustesA = ajusterCoinsRotation(coinsA, angleA);
    
    coinsTranslatesA = faireTranslationCoins(coinsAjustesA, posA);
    AfficherVehicule(coinsTranslatesA);
    disp('coinsTranslatesA');
    disp(coinsTranslatesA);
    
    
    angleB = angleAuto(autoB, max(tempsEcoule - tempsDebutRotationB, 0)); %Auto B ne commence a tourner qu'au temps tb
    coinsB = getCoinsAutoSansRotation(autoB);
    coinsAjustesB = ajusterCoinsRotation(coinsB, angleB);
    
    
    coinsTranslatesB = faireTranslationCoins(coinsAjustesB, posB);
    %AfficherVehicule(coinsTranslatesB);
    disp('coinsTranslatesB');
    disp(coinsTranslatesB);

    [estCollision, point] = IntersectionDeuxSolides(coinsTranslatesA, coinsTranslatesB);

end


function [estCollision, point] = IntersectionDeuxSolides(coinsSolideA, coinsSolideB)
    %Determine si deux solides sont en collision
    
    estCollision = false;
    point = [0 0];
    for i = 1:(numel(coinsSolideB) / 2)
        pointInclus = PointInclusDansSolide(coinsSolideB(i,:), coinsSolideA);
        if (pointInclus)
            disp('point intersection trouve');
            disp(coinsSolideB(i,:));
            point = coinsSolideB(i,:); %Return ce point
            estCollision = true;
        else
            fprintf('Point B%i pas inclus dans A\n', i);
        end
    end
        
    for i = 1:(numel(coinsSolideA) / 2)
        pointInclus = PointInclusDansSolide(coinsSolideA(i,:), coinsSolideB);
        if (pointInclus)
            disp('point intersection trouve');
            disp(coinsSolideA(i,:));
            point = coinsSolideA(i,:); %Return ce point
            estCollision = true;
        else 
            fprintf('Point A%i pas inclus dans B\n', i);
        end
    end

end

function index = GetProchainIndexAvecLoop(indexActuel, minVal, maxVal)
    %ex (1, 1, 4), va retourner 2
    %ex (4, 1, 4), va retourner 1
    index = max(mod(indexActuel + 1, (maxVal + 1)), minVal);
end

function interieur = PointInclusDansSolide(point, coinsSolide)
    %Determine si un point est inclus dans un solide
    
    interieur = true;

    indexMax = (numel(coinsSolide) / 2);
    for i = 1:indexMax
        indexDeuxiemeCoin = GetProchainIndexAvecLoop(i, 1, indexMax); %On prend prochain, mais on retourne à 1 au lieu de 5
        normale = CalculerPlanSeparateur(coinsSolide(i,:), coinsSolide(indexDeuxiemeCoin,:));
        
        distance = DistancePlanCoin(normale, coinsSolide(i,:), point);
            
        if (distance > 0)
            interieur = false;
        end
        
    end
end

function [intersection] = InteresectionSpheresEnglobantes(autoA, autoB, cmA, cmB)
    %Définit une sphère qui englobe chacune des autos, puis détermine s'il
    %y a collision entre les sphères
    
    rayonA = ((autoA.Longueur / 2) ^ 2 + (autoA.Largeur / 2) ^ 2)^(1/2); %Pythagore pour trouver rayon de la sphere englobante
    rayonB = ((autoB.Longueur / 2) ^ 2 + (autoB.Largeur / 2) ^ 2)^(1/2);
    
    distance = pdist([cmA; cmB]);
    intersection = (distance < (rayonA + rayonB));
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