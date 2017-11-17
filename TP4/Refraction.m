% donne le vecteur unitaire sortant (ut) de la r�fraction
% ui : vecteur unitaire entrant
% i : vecteur unitaire normal � la surface du plan
% ni : indice de r�fraction du milieu i
% nt : indice de r�fraction du milieu t

function ut = Refraction(ui, i, ni, nt)

%vecteurs unitaires
ui = ui / norm(u);
i = i / norm(i);

angleCritique = abs(asin(nt/ni));

% Eq (7.10)
j = cross(ui, i);
% Eq (7.11)
k = cross(n, j);

% Eq (7.30)
sini = dot(ui, k);
% Angle d'incidence
anglei = asin(sini);

    if -angleCritique <= anglei && anglei <= angleCritique
        % Eq (7.31)
        sint = ni/n2 * sini;
        
        % cos^2 + sin^2 = 1
        % cos = (1 - sin^2)^(1/2)
        
        % Eq (7.36)
        ut = -i * (1 - sint^2)^(1/2) + k * sint;
    else
        ut = [0 0 0]';
    end
end
