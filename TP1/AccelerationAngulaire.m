classdef AccelerationAngulaire
    methods(Static)
        
        %%fonction calculant l'acceleration angulaire d'un systeme
        %%autour de son centre de masse
        %   positionDeForce : vecteur position où est appliqué la force
        %   force : vecteur représentant la force sur l'objet
        %   centreDeMasse : position du centre de masse de l'objet
        %   momentInertie : moment d'inertie de l'objet
        %   vitesseAngulaire : vecteur (colonne) de la vitesse angulaire initiale de l'objet
		function [accelerationAngulaire] = AccelerationAngulaire(positionDeForce, force, centreDeMasse, momentInertie, vitesseAngulaire)
            %tau(t)
			momentDeForce = MomentDeForce(positionDeForce, centreDeMasse, force);
            
            %L(t) = I(t) * omega(t)
            momentCinetique = momentInertie * vitesseAngulaire;
            
            %a(t) = I(t)^-1 * (tau(t) + L(t) x omega(t)
            accelerationAngulaire = inv(momentInertie) * (momentDeForce + cross(momentCinetique, vitesseAngulaire));
        end
        
        %fonction calculant le moment de force causé par une force à un point p
        %   positionDeForce : vecteur position auquel on applique une force
        %   centreDeMasse : centre de masse de l'objet auquel on applique un force
        %   force : vecteur représentant la force appliqué sur l'objet
        function [ momentDeForce ] = MomentDeForce( positionDeForce, centreDeMasse, force)
            %tau(t) = (r(t) - rc(t)) x F(t)
            momentDeForce = cross((positionDeForce- centreDeMasse), force);
        end
    end
end