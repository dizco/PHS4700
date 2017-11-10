function angle = angleAuto(auto, tempsDeRotation)
    %Calcule l'angle total de rotation de l'auto
    %Retourne un angle en DEGR�S

    %atan prend (Y, X);
    rotationInitiale = rad2deg(atan2(auto.Vitesse(2), auto.Vitesse(1))); %Auto align�e avec sa vitesse
    rotationAngulaire = rad2deg(auto.VitesseAngulaire * tempsDeRotation);
    
    angle = mod(rotationInitiale + rotationAngulaire, 360); %Modulo 360 degr�s
end