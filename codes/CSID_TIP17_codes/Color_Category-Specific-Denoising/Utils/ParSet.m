function [par] = ParSet(sigma)
    
    if sigma <= 20
        par.win1 = 9;
        par.win2 = 9;
        par.tao      = 4.2;
        par.tot_iter = 1;
    elseif sigma <= 50
        par.win1 = 12;
        par.win2 = 9;
        par.tao      = 4.7;
        par.tot_iter = 1;
    elseif sigma <= 60
        par.win1 = 12;
        par.win2 = 12;
        par.tao       = 5.0;
        par.tot_iter  = 1;
    else
        par.win1 = 12;
        par.win2 = 12;
        par.tao       = 5.2;
        par.tot_iter  = 1;
    end
    
end

