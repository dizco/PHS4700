function systeme = Donnees()
    cylindre = CylindreTransparent();
    cylindre.Centre = Vecteur(0.04, 0.04, 0.11);
    cylindre.Rayon = 0.02;
    cylindre.Hauteur = 0.18;

    face1 = CreerFace([0.03, 0.03, 0.12], [-Inf, Inf; 0.03, 0.05; 0.12, 0.17], [-1, 0, 0], 1, 'r'); %rouge
    face2 = CreerFace([0.04, 0.03, 0.12], [-Inf, Inf; 0.03, 0.05; 0.12, 0.17], [1, 0, 0], 2, 'r'); %cyan
    face3 = CreerFace([0.03, 0.03, 0.12], [0.03, 0.04; -Inf, Inf; 0.12, 0.17], [0, -1, 0], 3, 'r'); %vert
    face4 = CreerFace([0.03, 0.05, 0.12], [0.03, 0.04; -Inf, Inf; 0.12, 0.17], [0, 1, 0], 4, 'r'); %jaune
    face5 = CreerFace([0.03, 0.03, 0.12], [0.03, 0.04; 0.03, 0.05; -Inf, Inf], [0, 0, -1], 5, 'r'); %bleu
    face6 = CreerFace([0.03, 0.03, 0.17], [0.03, 0.04; 0.03, 0.05; -Inf, Inf], [0, 0, 1], 6, 'r'); %magenta
    
    bloc = BlocRectangulaire();
    bloc.Faces = [face1 face2 face3 face4 face5 face6];
    
    systeme = Systeme();
    systeme.CylindreTransparent = cylindre;
    systeme.BlocRectangulaire = bloc;
end

function face = CreerFace(point, bornes, normale, indice, codeCouleur)
    plan = Plan();
    plan.Point = Vecteur.CreateFromArray(point);
    plan.Normale = Vecteur.CreateFromArray(normale);
    plan.Bornes = bornes;
    
    face = Face();
    face.Indice = indice;
    face.CodeCouleur = codeCouleur;
    face.Plan = plan;
end