function RotZ = Rotation(angRot, matrice)
    rotation = [cos(angRot), -sin(angRot), 0; sin(angRot), cos(angRot), 0; 0, 0, 1];
    RotZ = rotation * transpose(matrice);
end