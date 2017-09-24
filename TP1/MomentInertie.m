classdef MomentInertie
    methods(Static)
        
        function [inertie] = InertieCone( masse, rayon, hauteur )
            %matrice de base
            inertie = [1 0 0 ;0 1 0;0 0 1];
            
            %Ic,xx = m(12r^2+3h^2)/80
            Ic_xx = (masse/80) * (12 * (rayon^2) + 3 * (hauteur^2));
                
            %Ic,yy = %Ic,xx = m(12r^2+3h^2)/80
            Ic_yy = Ic_xx;
                
            %Ic,zz = m(3r^2/10)
            Ic_zz = (masse/10) * (3*(rayon^2));
            
            inertie(1,1) = Ic_xx;
            inertie(2,2) = Ic_yy;
            inertie(3,3) = Ic_zz;
        end
        
        function [inertie] = InertieCylindre( masse, rayon, hauteur )
            %matrice de base
            inertie = [1 0 0 ;0 1 0;0 0 1];
            
            %Ic,xx = (m/4)*(r^2) + (m/12)*(l^2)
            Ic_xx = ((masse/4) * (rayon^2)) + ((masse/12) * (hauteur^2));
                
            %Ic,yy = %Ic,xx = (m/4)*(r^2) + (m/12)*(l^2)
            Ic_yy = Ic_xx;
                
            %Ic,zz = (m/2)*(r^2)
            Ic_zz = (masse/2) * (rayon^2);
            
            inertie(1,1) = Ic_xx;
            inertie(2,2) = Ic_yy;
            inertie(3,3) = Ic_zz;
        end 
   
        function [inertieAjustee] = InertieAjusteeCM( inertieObjet, masseObjet, cmObjet, cmGlobal )
                
                dx = cmGlobal(1) - cmObjet(1);
                dy = cmGlobal(2) - cmObjet(2);
                dz = cmGlobal(3) - cmObjet(3);
                
                dx_2 = dx^2;
                dy_2 = dy^2;
                dz_2 = dz^2;
                
                inertieAjustee = [0 0 0 ;0 0 0;0 0 0];
                
                inertieAjustee(1,1) = inertieObjet(1,1) + (dy_2 + dz_2)*masseObjet;
                inertieAjustee(1,2) = inertieObjet(1,2) - (dx * dy)*masseObjet;
                inertieAjustee(1,3) = inertieObjet(1,3) - (dx * dz)*masseObjet;

                inertieAjustee(2,1) = inertieObjet(2,1) - (dy * dx)*masseObjet;
                inertieAjustee(2,2) = inertieObjet(2,2) + (dx_2 + dz_2)*masseObjet;
                inertieAjustee(2,3) = inertieObjet(2,3) - (dy * dz)*masseObjet;

                inertieAjustee(3,1) = inertieObjet(3,1) - (dz * dx)*masseObjet;
                inertieAjustee(3,2) = inertieObjet(3,2) - (dz * dy)*masseObjet;
                inertieAjustee(3,3) = inertieObjet(3,3) + (dx_2 + dy_2)*masseObjet;
                
        end
        
        function [inertieTotale] = InertieSysteme( obj, cmGlobal )
            inertieTotale = [0 0 0 ;0 0 0;0 0 0];
            
            for i = 1:numel(obj)
				%x = element numero 1, y = element numero 2, z = element numero 3;
				inertieAjustee = MomentInertie.InertieAjusteeCM(obj(i).Inertie, obj(i).Masse, obj(i).CentreDeMasse, cmGlobal);
                
				inertieTotale = inertieTotale + inertieAjustee;
			end %fin boucle for
        end
        
    end
end