classdef VitessesFinalesAutos
   methods(Static)
       function f = vitesse(AutoA, AutoB, pointDeCollision);
           %normale
           vecteurNormal = pointDeCollision - AutoA.Position;
           normale = vecteurNormal / norm(vecteurNormal);
           
           %position et vitesse du point ou la force est appliqué
           rAp = AutoA.Position - pointDeCollision;
           rBp = AutoA.Position - pointDeCollision;
           vAp = AutoA.Vitesse;
           vBp = AutoB.Vitesse;
           
           %Inertie
           InertieA = [1 0 0 ; 0 1 0; 0 0 1];
           InertieA(1,1) = AutoA.Masse * (AutoA.Hauteur^2 + AutoA.Longueur^2) / 3;
           InertieA(2,2) = AutoA.Masse * (AutoA.Hauteur^2 + AutoA.Largeur^2) / 3;
           InertieA(3,3) = AutoA.Masse * (AutoA.Largeur^2 + AutoA.Longueur^2) / 3;
           
           InertieB = [1 0 0 ; 0 1 0; 0 0 1];
           InertieB(1,1) = AutoB.Masse * (AutoB.Hauteur^2 + AutoB.Longueur^2) / 3;
           InertieB(2,2) = AutoB.Masse * (AutoB.Hauteur^2 + AutoB.Largeur^2) / 3;
           InertieB(3,3) = AutoB.Masse * (AutoB.Largeur^2 + AutoB.Longueur^2) / 3;
           
           %Facteur Ga et Gb
           Ga = dot(normale,  InertieA \ cross(cross(rAp, normale), rAp));
           Gb = dot(normale,  InertieB \ cross(cross(rBp, normale), rBp));
           
           %Vitesse relative avant
           vitesseRelativeAvant = dot(normale, vAp - vBp);
           
           %Facteur j
           e = 0.8;
           alpha = 1 / ((1 / AutoA.Masse) + (1 / AutoB.Masse) + Ga + Gb);
           j = -alpha * (1 + e) * vitesseRelativeAvant;
           
           %Vitesse Angulaire Finale
           wAf = AutoA.VitesseAngulaire + j * InertieA \ cross(rAp, normale);
           wBf = AutoB.VitesseAngulaire + j * InertieB \ cross(rBp, normale);
           
           %Vitesse Finales
           vAf = vAp + j * ((normale / AutoA.Masse) + cross((InertieA \ cross(rAp, normale)), rAp));
           vBf = vBp + j * ((normale / AutoB.Masse) + cross((InertieB \ cross(rBp, normale)), rBp));
           
          
           
       end
       
   end
end
