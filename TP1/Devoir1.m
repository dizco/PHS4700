function [pcmNL, INL, alphaNL]=Devoir1(AngRot,vangulaire,forces,posNL)

	Donnees();
    
    centresDeMasse = [ navette.CentreDeMasse; reservoir.CentreDeMasse; propulseurGauche.CentreDeMasse; propulseurDroit.CentreDeMasse ];
    masses = [ navette.Masse; reservoir.Masse; propulseurGauche.Masse; propulseurDroit.Masse ];
    objets = [ navette; reservoir; propulseurGauche; propulseurDroit ];
    
    disp('centres de masse');
    disp(centresDeMasse);
    
    pcmNL = CentreDeMasse.CentreDeMasseObjets(centresDeMasse, masses);
    disp('centre de masse syst');
    disp(pcmNL);
    
    
    INL = MomentInertie.InertieSysteme(objets, pcmNL);
	%INL = 0;
    disp('inertie syst');
    disp(INL);
	alphaNL = [0,0,0];
	
	if (AngRot ~= 0)
		% TODO: Cas 2
	end
	
	if (vangulaire ~= 0)
		% TODO: Cas 2
	end
    
end

