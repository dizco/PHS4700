classdef MomentInertie
    methods(Static)

		% x, y, z
		function [inertie] = MomentInertie( masse, rayon, longueur, largeur, hauteur, forme)
			
			%matrice de base
			moment = [1 0 0 ;0 1 0;0 0 1];

			switch(forme)

			case Forme.Cone

				%Ic,xx = m(12r^2+3h^2)/80
            	moment(1,1) = (masse/80) * (12*(power(rayon,2) + 3*power(hauteur,2)));

            	%Ic,yy = %Ic,xx= m(12r^2+3h^2)/80 
            	moment(2,2) = moment(1,1);

            	%Ic,zz = m(3r^2/10)
            	moment(3,3) = (masse/10) * 3(power(rayon,2);

            case Forme.CylindrePlein

            	%Ic,xx = (m/4)*(r^2) + (m/12)*(l^2)
            	moment(1,1) = (masse/4) * power(rayon,2) + (masse/12)*(power(longueur,2));

            	%Ic,yy = %Ic,xx = (m/4)*(r^2) + (m/12)*(l^2)
            	moment(2,2) = moment(1,1);

            	%Ic,zz = (m/2)*(r^2)
            	moment(3,3) = (masse / 2) * power(rayon,2);

            

        case Forme.CylindreCreux

            %Ic,zz = (m)*(r^2)
            moment(3,3) = masse * power(rayon,2);

            %Ic,xx = Ic,yy = (m/2)*(r^2) + (m/12)*(l^2)
            moment(1,1) = (masse/2) * power(rayon,2) + (masse/12)*(power(longueur,2));
            moment(2,2) = moment(1,1);


		end
		
		
		
		
		function [centreTotal] = CentreDeMasseObjets(centreObjets, massesObjets)
			
			masseTotale = sum(massesObjets);
            
			centreTotal = [0, 0, 0];
		
			for i = 1:numel(massesObjets)
				%x = element numero 1, y = element numero 2, z = element numero 3;
				centreObjetPondere = [centreObjets(i, 1) , centreObjets(i, 2) , centreObjets(i, 3)] * massesObjets(i);
				centreTotal = centreTotal + centreObjetPondere;
			end %fin boucle for
			centreTotal = centreTotal / masseTotale;
		
		end

    end
end