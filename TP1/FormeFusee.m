classdef FormeFusee < Solide 

    properties
        Cylindre
        Cone
    end
    
    methods
        function fusee = FormeFusee(cylindre, cone)
            fusee = fusee@Solide();
            fusee.Cylindre = cylindre;
            cone.CentreDeMasse(3) = cone.CentreDeMasse(3) + cylindre.Hauteur; % Offset le cm du cone avec la hauteur du cylindre 
            fusee.Cone = cone;
            fusee.CentreDeMasse = CentreDeMasse.CentreDeMasseObjets([cylindre.CentreDeMasse; cone.CentreDeMasse], [cylindre.Masse; cone.Masse]);
        end
        
        function CoordonneesBasMilieu(obj, x, y, z)
            obj.Cone.CentreDeMasse(1) = obj.Cone.CentreDeMasse(1) + x;
            obj.Cone.CentreDeMasse(2) = obj.Cone.CentreDeMasse(2) + y;
            obj.Cone.CentreDeMasse(3) = obj.Cone.CentreDeMasse(3) + z;
        
            obj.Cylindre.CentreDeMasse(1) = obj.Cylindre.CentreDeMasse(1) + x;
            obj.Cylindre.CentreDeMasse(2) = obj.Cylindre.CentreDeMasse(2) + y;
            obj.Cylindre.CentreDeMasse(3) = obj.Cylindre.CentreDeMasse(3) + z;        
        end
        
        function v = CalculerVolume(obj)
            v = obj.Cylindre.CalculerVolume() + obj.Cone.CalculerVolume();
        end
        
        function RepartirMasseUniforme(obj, masse)
            t = (obj.Cylindre.CalculerVolume() / obj.CalculerVolume()) * masse;
            disp('Masse cyl');
            disp(t);
            obj.Cylindre.Masse = (obj.Cylindre.CalculerVolume() / obj.CalculerVolume()) * masse;
            obj.Cone.Masse = (obj.Cone.CalculerVolume() / obj.CalculerVolume()) * masse;
        end
    end
    
end