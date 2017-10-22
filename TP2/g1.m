function g = g1 (q0, t0)
<<<<<<< HEAD
%disp('g q0')
%disp(q0);
%disp('g t0');
%disp(t0);

%f = Calculs.gravite(balle);
%a = f / balle.Masse;
%a = [0; 0; -9.8]; %TODO: Calculer accélération
%g = [q0(1) q0(2) q0(3)]; %TODO: Appliquer ici gravité
=======
>>>>>>> fb8a0fd2263cd0cd1833c44b8b80e2275670ee25

g = [0 0 -9.8 q0(1) q0(2) q0(3)];