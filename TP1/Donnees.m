% On definit toutes les positions lorsque la navette est immobile sur la
% rampe de lancement

% Navette
mNavette = 109000;

basNavette = Cylindre();
basNavette.Rayon = 3.5;
basNavette.Hauteur = 27.93;
basNavette.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basNavette.Rayon, basNavette.Hauteur);


hautNavette = Cone();
hautNavette.Rayon = 3.5;
hautNavette.Hauteur = 9.31;
hautNavette.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautNavette.Rayon, hautNavette.Hauteur);

navette = FormeFusee(basNavette, hautNavette);
navette.CoordonneesBasMilieu(0, 0, 0);
navette.RepartirMasseUniforme(mNavette);

%Calcul de l'inertie totale de la navette
basNavette.Masse = mNavette * basNavette.CalculerVolume();
basNavette.Inertie = MomentInertie.InertieCylindre(basNavette.Masse, basNavette.Rayon, basNavette.Hauteur);
basNavette.InertieAjust = MomentInertie.InertieAjusteeCM(basNavette.Inertie, basNavette.Masse, basNavette.CentreDeMasse, navette.CentreDeMasse);

hautNavette.Masse = mNavette * hautNavette.CalculerVolume();
hautNavette.Inertie = MomentInertie.InertieCone(hautNavette.Masse, hautNavette.Rayon, hautNavette.Hauteur);
hautNavette.InertieAjust = MomentInertie.InertieAjusteeCM(hautNavette.Inertie, hautNavette.Masse, hautNavette.CentreDeMasse, navette.CentreDeMasse);

navette.Inertie = basNavette.InertieAjust + hautNavette.InertieAjust;


% Reservoir
basReservoir = Cylindre();
basReservoir.Rayon = 4.2;
basReservoir.Hauteur = 39.1;
basReservoir.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basReservoir.Rayon, basReservoir.Hauteur);

hautReservoir = Cone();
hautReservoir.Rayon = 4.2;
hautReservoir.Hauteur = 7.8;
hautReservoir.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautReservoir.Rayon, hautReservoir.Hauteur);

masseHydrogeneBasReservoir = 108000;
volumeOxygeneBasReservoir = pi * (4.2 ^ 2) * (39.1 - 46.9 * (2/3)); % pi * R^2 * h
masseOxygeneBasReservoir = 631000 * volumeOxygeneBasReservoir / (volumeOxygeneBasReservoir + hautReservoir.CalculerVolume());
masseOxygeneHautReservoir = 631000 - masseOxygeneBasReservoir;

cmCyl1 = CentreDeMasse.CentreDeMasseCylindre(basReservoir.Rayon, 46.9 * (2/3));
cmCyl2 = CentreDeMasse.CentreDeMasseCylindre(basReservoir.Rayon, 39.1 - 46.9 * (2/3));
cmCyl2(3) = cmCyl2(3) + 46.9 * (2/3);
basReservoir.CentreDeMasse = CentreDeMasse.CentreDeMasseObjets([cmCyl1; cmCyl2], [masseHydrogeneBasReservoir; masseOxygeneBasReservoir]);

reservoir = FormeFusee(basReservoir, hautReservoir);
reservoir.CoordonneesBasMilieu(0, basNavette.Rayon + basReservoir.Rayon, 0);
basReservoir.Masse = masseHydrogeneBasReservoir + masseOxygeneBasReservoir;
hautReservoir.Masse = masseOxygeneHautReservoir;

reservoir.RepartirMasseParComposante(basReservoir.Masse, hautReservoir.Masse);

%Calcul de l'inertie totale du réservoir
basReservoir.Inertie = MomentInertie.InertieCylindre(basReservoir.Masse, basReservoir.Rayon, basReservoir.Hauteur);
basReservoir.InertieAjust = MomentInertie.InertieAjusteeCM(basReservoir.Inertie, basReservoir.Masse, basReservoir.CentreDeMasse, reservoir.CentreDeMasse);

hautReservoir.Inertie = MomentInertie.InertieCone(hautReservoir.Masse, hautReservoir.Rayon, hautReservoir.Hauteur);
hautReservoir.InertieAjust = MomentInertie.InertieAjusteeCM(hautReservoir.Inertie, hautReservoir.Masse, hautReservoir.CentreDeMasse, reservoir.CentreDeMasse);

reservoir.Inertie = basReservoir.InertieAjust + hautReservoir.InertieAjust;

% Propulseur
mPropulseur = 469000;

basPropulseur = Cylindre();
basPropulseur.Rayon = 1.855;
basPropulseur.Hauteur = 39.9;
basPropulseur.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basPropulseur.Rayon, basPropulseur.Hauteur); % CM si le bas du cylindre est à l'origine

hautPropulseur = Cone();
hautPropulseur.Rayon = 1.855;
hautPropulseur.Hauteur = 5.6;
hautPropulseur.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautPropulseur.Rayon, hautPropulseur.Hauteur); % CM si le bas du cylindre est à l'origine

% Propulseur gauche
propulseurGauche = FormeFusee(copy(basPropulseur), copy(hautPropulseur));
propulseurGauche.CoordonneesBasMilieu(- (basReservoir.Rayon + basPropulseur.Rayon), basNavette.Rayon + basReservoir.Rayon, 0);
propulseurGauche.RepartirMasseUniforme(mPropulseur);

% Propulseur droit
propulseurDroit = FormeFusee(copy(basPropulseur), copy(hautPropulseur));
propulseurDroit.CoordonneesBasMilieu(basReservoir.Rayon + basPropulseur.Rayon, basNavette.Rayon + basReservoir.Rayon, 0);
propulseurDroit.RepartirMasseUniforme(mPropulseur);

%Calcul de l'inertie des propulseurs - étapes préliminaires
basPropulseur.Masse = mNavette * basPropulseur.CalculerVolume();
basPropulseur.Inertie = MomentInertie.InertieCylindre(basPropulseur.Masse, basPropulseur.Rayon, basPropulseur.Hauteur);

hautPropulseur.Masse = mNavette * hautPropulseur.CalculerVolume();
hautPropulseur.Inertie = MomentInertie.InertieCone(hautPropulseur.Masse, hautPropulseur.Rayon, hautPropulseur.Hauteur);

%Calcul de l'inertie du propulseur gauche
basPropulseur.InertieAjust = MomentInertie.InertieAjusteeCM(basPropulseur.Inertie, basPropulseur.Masse, propulseurGauche.Cylindre.CentreDeMasse, propulseurGauche.CentreDeMasse);
hautPropulseur.InertieAjust = MomentInertie.InertieAjusteeCM(hautPropulseur.Inertie, hautPropulseur.Masse, propulseurGauche.Cone.CentreDeMasse, propulseurGauche.CentreDeMasse);

propulseurGauche.Inertie = basPropulseur.InertieAjust + hautPropulseur.InertieAjust;

%Calcul de l'inertie du propulseur droit
basPropulseur.InertieAjust = MomentInertie.InertieAjusteeCM(basPropulseur.Inertie, basPropulseur.Masse, propulseurDroit.Cylindre.CentreDeMasse, propulseurDroit.CentreDeMasse);
hautPropulseur.InertieAjust = MomentInertie.InertieAjusteeCM(hautPropulseur.Inertie, hautPropulseur.Masse, propulseurDroit.Cone.CentreDeMasse, propulseurDroit.CentreDeMasse);

propulseurDroit.Inertie = basPropulseur.InertieAjust + hautPropulseur.InertieAjust;




