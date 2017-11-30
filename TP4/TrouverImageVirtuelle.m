function posi = TrouverImageVirtuelle(poso, ptCollision, distance)
% Eq (7.40)
% Vecteur unitaire de la direction du rayon observe
u = (ptCollision - poso) / (norm(ptCollision - poso));

% En combinant avec la distance...
posi = poso + (distance * u);
end
