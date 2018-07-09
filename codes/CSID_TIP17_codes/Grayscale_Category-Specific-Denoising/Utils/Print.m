function  z= Print(X, x, par, nSig)
        
    z = reconstruct(X, x, par);
    PSNR= 10*log10(1/mean((z(:)-double(x(:))).^2));

    fprintf( 'nSig = %2.2f, PSNR = %2.2f\n', nSig, PSNR);
%     figure; imshow(z,[]);
end