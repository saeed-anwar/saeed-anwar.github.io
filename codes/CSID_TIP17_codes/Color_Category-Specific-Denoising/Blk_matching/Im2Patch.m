function  [Y, SigmaArr]  =  Im2Patch(E_Img, N_Img, par )
% code written Saeed Anwar 
 Y   = im2colstep(E_Img, [par.win1 ,par.win2], [1,1]);
 N_Y = im2colstep(N_Img, [par.win1 ,par.win2], [1,1]);
 
 SigmaArr = par.siglamda*sqrt(abs(repmat(par.nSig^2,1,size(Y,2))-mean((N_Y.*255-Y.*255).^2)));    %Estimated Local Noise Level

end
