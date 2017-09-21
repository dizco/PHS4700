classdef Solide 
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
end