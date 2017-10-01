classdef Force
    %Regroupe les forces à prendre en compte
    % Option 1: Force gravitationnel
    % Option 2: Force de frottement visqueux
    % Option 3: Force de Magnus
    
    methods(Static)
        function f = gravitationnel(obj)
            %Formule de la force gravitationnel
            f = [0; 0; obj.Masse * -9.81];
        end
        
        function f = frottementVisqueux(obj)
            %Formule du frottement visqueux
            cAire = 0.5;
            p = 1.2;
            f = - pi * (2 * obj.Rayon) ^ 2 / 8 * p * cAire * norm(obj.Vitesse) * obj.Vitesse;
        end
        
        function f = magnus(obj)
            %Formule du frottement visqueux
            coefficientDeMagnus = 0.29;
            p = 1.2;
            f = (4 * pi * ((obj.Rayon)^3) * p * coefficientDeMagnus * cross(obj.VitesseAngulaire, obj.Vitesse)); 
        end
        
    end
    
end

