classdef (Abstract) Solide 
    properties
       CentreDeMasse 
       Masse
    end
    
    methods 
        function solide = Solide()
            solide.CentreDeMasse = [0 0 0];
            solide.Masse = 0;
        end
    end
    
    methods (Abstract) 
        v = CalculerVolume(obj)
    end
end