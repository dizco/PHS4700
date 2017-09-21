% On définit toutes les positions lorsque la navette est immobile sur la
% rampe de lancement

% Navette
basNavette = Cylindre();
basNavette.Rayon = 3.5;
basNavette.Hauteur = 27.93;
basNavette.Masse = 98103;
basNavette.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basNavette.Rayon, basNavette.Hauteur);

hautNavette = Cone();
hautNavette.Rayon = 3.5;
hautNavette.Hauteur = 9.31;
hautNavette.Masse = 10900;
hautNavette.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautNavette.Rayon, hautNavette.Hauteur);

navette = FormeFusee(basNavette, hautNavette);
navette.CoordonneesBasMilieu(0, 0, 0);

% Reservoir
basReservoir = Cylindre();
basReservoir.Rayon = 4.2;
basReservoir.Hauteur = 39.1;
basReservoir.Masse = 0; % TODO
basReservoir.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basReservoir.Rayon, basReservoir.Hauteur);

hautReservoir = Cone();
hautReservoir.Rayon = 4.2;
hautReservoir.Hauteur = 7.8;
hautReservoir.Masse = 0; % TODO
hautReservoir.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautReservoir.Rayon, hautReservoir.Hauteur);

reservoir = FormeFusee(basReservoir, hautReservoir);
reservoir.CoordonneesBasMilieu(0, basNavette.Rayon + basReservoir.Rayon, 0);

% Propulseur
basPropulseur = Cylindre();
basPropulseur.Rayon = 1.855;
basPropulseur.Hauteur = 39.9;
basPropulseur.Masse = 0; % TODO
basPropulseur.CentreDeMasse = CentreDeMasse.CentreDeMasseCylindre(basPropulseur.Rayon, basPropulseur.Hauteur); % CM si le bas du cylindre est à l'origine

hautPropulseur = Cone();
hautPropulseur.Rayon = 1.855;
hautPropulseur.Hauteur = 5.6;
hautPropulseur.Masse = 0; % TODO
hautPropulseur.CentreDeMasse = CentreDeMasse.CentreDeMasseCone(hautPropulseur.Rayon, hautPropulseur.Hauteur); % CM si le bas du cylindre est à l'origine

% Propulseur gauche
propulseurGauche = FormeFusee(basPropulseur, hautPropulseur);
propulseurGauche.CoordonneesBasMilieu(- (basReservoir.Rayon + basPropulseur.Rayon), basNavette.Rayon + basReservoir.Rayon, 0);

% Propulseur droit
propulseurDroit = FormeFusee(basPropulseur, hautPropulseur);
propulseurDroit.CoordonneesBasMilieu(basReservoir.Rayon + basPropulseur.Rayon, basNavette.Rayon + basReservoir.Rayon, 0);




