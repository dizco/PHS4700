function systeme = Donnees()
    cylindre = CylindreTransparent();
    cylindre.Centre = Vecteur(0.04, 0.04, 0.11);
    cylindre.Rayon = 0.02;
    cylindre.Hauteur = 0.18;
    
    face1 = CreerFace([3, 3, 12], [-Inf, Inf; 3, 5; 12, 17], [-1, 0, 0], 'r'); %rouge
    face2 = CreerFace([4, 3, 12], [-Inf, Inf; 3, 5; 12, 17], [1, 0, 0], 'r'); %cyan
    face3 = CreerFace([3, 3, 12], [3, 4; -Inf, Inf; 12, 17], [0, -1, 0], 'r'); %vert
    face4 = CreerFace([3, 5, 12], [3, 4; -Inf, Inf; 12, 17], [0, 1, 0], 'r'); %jaune
    face5 = CreerFace([3, 3, 12], [3, 4; 3, 5; -Inf, Inf], [0, 0, -1], 'r'); %bleu
    face6 = CreerFace([3, 3, 17], [3, 4; 3, 5; -Inf, Inf], [0, 0, 1], 'r'); %magenta
    
    bloc = BlocRectangulaire();
    bloc.Faces = [face1 face2 face3 face4 face5 face6];
    
    systeme = Systeme();
    systeme.CylindreTransparent = cylindre;
    systeme.BlocRectangulaire = bloc;
end

function face = CreerFace(point, bornes, normale, codeCouleur)
    plan = Plan();
    plan.Point = Vecteur.CreateFromArray(point);
    plan.Normale = Vecteur.CreateFromArray(normale);
    plan.Bornes = bornes;
    
    face = Face();
    face.CodeCouleur = codeCouleur;
    face.Plan = plan;
end