
function x_Sigma=estimate_noise(Y, N_Y, par )

% [H, W] = size(X_new);
% X_Sigma = (1/(H*H))*abs(X_noisy-X_new).^2;
x_Sigma = par.siglamda*sqrt(abs(repmat(par.nSig^2, size(Y,1), size(Y,2))- ((N_Y.*255-Y.*255).^2)));    %Estimated Local Noise Level
  
 
end