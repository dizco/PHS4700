function [pcmNL, INL, alphaNL]=Devoir1(AngRot,vangulaire,forces,posNL)


cmCylindre = CentreDeMasse.CentreDeMasseCylindre(3.5, 27.93);
cmCone = CentreDeMasse.CentreDeMasseCone(3.5, 9.31);
cmCone(3) = cmCone(3) + 27.93;

pcmNL = CentreDeMasse.CentreDeMasseObjets([cmCylindre; cmCone], [98103; 10900]);

%pcmNL = [0,0,0];
INL = 0;
alphaNL = [0,0,0];
    
end

