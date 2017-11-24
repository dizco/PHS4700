classdef Droite < matlab.mixin.Copyable
    properties
        Point
        Pente %En realite, il s'agit d'un vecteur de direction 
    end
    
    methods
        function obj = Droite()
            obj.Point = Vecteur(0, 0, 0);
            obj.Pente = Vecteur(0, 0, 0);
        end
        
        function y = OrdonneeAOrigine(obj)
            %On oublie la composante Z
            if (obj.PentePlanXY() == 0)
                y = obj.Point.Y;
                return;
            end
            
            steps = obj.Point.X / obj.PentePlanXY(); %Nb de fois que l'on doit repeter le vecteur direction afin d'arriver au point X
            y = obj.Point.Y - steps * obj.PentePlanXY(); %On recule jusqua lorigine
        end
        
        function z = ValeurZPourX0(obj)
            %On oublie la composante Y
            if (obj.PentePlanXZ() == 0)
                z = obj.Point.Z;
                return;
            end
            
            steps = obj.Point.X / obj.PentePlanXZ(); %Nb de fois que l'on doit repeter le vecteur direction afin d'arriver au point X
            z = obj.Point.Z - steps * obj.PentePlanXZ(); %On recule jusqua lorigine
        end
        
        function pente = PentePlanXY(obj)
            %Pente dans le plan X-Y
            pente = obj.Pente.Y / obj.Pente.X;
        end
        
        function pente = PentePlanXZ(obj)
            %Pente dans le plan X-Z
            pente = obj.Pente.Z / obj.Pente.X;
        end
    end
end