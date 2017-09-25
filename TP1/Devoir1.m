function [pcmNL, INL, alphaNL]=Devoir1(AngRot,vangulaire,forces,posNL)

	Donnees();
    
    centresDeMasse = [ navette.CentreDeMasse; reservoir.CentreDeMasse; propulseurGauche.CentreDeMasse; propulseurDroit.CentreDeMasse ];
    masses = [ navette.Masse; reservoir.Masse; propulseurGauche.Masse; propulseurDroit.Masse ];
    objets = [ navette; reservoir; propulseurGauche; propulseurDroit ];
    
    disp('centres de masse');
    disp(centresDeMasse);
    
    pcmNLCalcul = CentreDeMasse.CentreDeMasseObjets(centresDeMasse, masses);
    pcmNL = Rotation(AngRot, pcmNLCalcul);
    pcmNL = pcmNL + posNL;
    disp('centre de masse syst');
    disp(pcmNL);
    
    %Ajustement de l'inertie par rapport au centre de masse
    navette.AjusterInertie(pcmNL);
    reservoir.AjusterInertie(pcmNL);
    propulseurGauche.AjusterInertie(pcmNL);
    propulseurDroit.AjusterInertie(pcmNL);
    
    %Somme de toutes les inerties
    INLCalcul = MomentInertie.InertieSysteme(objets, AngRot);
    INL = Rotation(AngRot, INLCalcul);
    disp('inertie syst');
    disp(INL);
    
    
	%alphaNL = [0,0,0];
    %alphaNL = AccelerationAngulaire( angRot, momentInertie, vitesseAngulaire, forces)
   
    
    alphaNL = AccelerationAngulaire( AngRot, pcmNL, INL, vangulaire, forces );
    disp('acceleration angulaire');
    disp(alphaNL);
    
end

