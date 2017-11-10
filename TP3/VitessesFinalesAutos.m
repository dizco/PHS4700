classdef VitessesFinalesAutos
   methods(Static)
       function vitessesFinales = vitessesFinales(AutoA, AutoB, pointDeCollision, normale)
           %normale
           normale(3)=0;
           normale = normale / norm(normale);
           
           %position et vitesse du point ou la force est appliqué
           rAp = AutoA.Position - pointDeCollision;
           rAp(3) = 0;
           rBp = AutoA.Position - pointDeCollision;
           rBp(3) = 0;
           vAp = AutoA.Vitesse;
           vAp(3) = 0;
           vBp = AutoB.Vitesse;
           vBp(3) = 0;
           
           %Inertie
           InertieA = [1 0 0 ; 0 1 0; 0 0 1];
           InertieA(1,1) = AutoA.Masse * (AutoA.Hauteur^2 + AutoA.Largeur^2) / 12;
           InertieA(2,2) = AutoA.Masse * (AutoA.Hauteur^2 + AutoA.Longueur^2) / 12;
           InertieA(3,3) = AutoA.Masse * (AutoA.Largeur^2 + AutoA.Longueur^2) / 12;
           
           InertieB = [1 0 0 ; 0 1 0; 0 0 1];
           InertieB(1,1) = AutoB.Masse * (AutoB.Hauteur^2 + AutoB.Largeur^2) / 12;
           InertieB(2,2) = AutoB.Masse * (AutoB.Hauteur^2 + AutoB.Longueur^2) / 12;
           InertieB(3,3) = AutoB.Masse * (AutoB.Largeur^2 + AutoB.Longueur^2) / 12;
           
           %Facteur Ga et Gb
           Ga = dot(normale,  InertieA \ (cross(cross(rAp, normale), rAp))');
           Gb = dot(normale,  InertieB \ (cross(cross(rBp, normale), rBp))');
           
           %Vitesse relative avant
           vitesseRelativeAvant = dot(normale, vAp - vBp);
           
           %Facteur j
           e = 0.8;
           alpha = 1 / ((1 / AutoA.Masse) + (1 / AutoB.Masse) + Ga + Gb);
           j = -alpha * (1 + e) * vitesseRelativeAvant;
           
           %Vitesse Angulaire Finale
           wAf = AutoA.VitesseAngulaire + j * InertieA \ transpose(cross(rAp, normale));
           wBf = AutoB.VitesseAngulaire + j * InertieB \ transpose(cross(rBp, normale));

           %Vitesse Finales
           vAf = vAp + j * ((normale / AutoA.Masse) + cross((InertieA \ cross(rAp, normale)'), rAp));
           vBf = vBp + j * ((normale / AutoB.Masse) + cross((InertieB \ cross(rBp, normale)'), rBp));
           
           vitessesFinales = [vAf(1, 1:2) wAf(1) vBf(1, 1:2), wBf(1)];
           
           
           
       end
       
   end
end
