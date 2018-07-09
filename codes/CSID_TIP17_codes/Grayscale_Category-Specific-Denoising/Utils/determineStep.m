function ParS = determineStep(x)
    
    h = size(x,1);
    r = size(x,2); 
    ParS.win1 = ceil(h/2);
    ParS.win2 = ceil(r/2);
    ParS.Nsteph = floor(ParS.win1/2)- mod(h,2);
    ParS.Nstepw = round(ParS.win2/2)- mod(r,2);

end