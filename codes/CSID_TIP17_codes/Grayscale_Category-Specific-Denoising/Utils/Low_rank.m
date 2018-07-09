function  X   =   Low_rank( Y, c1, nsig)
%  MY = mean(Y);
%  Y = bsxfun(@minus, Y, MY);
[U0,Sigma0,V0]    =   svd(full(Y),'econ');
Sigma0            =   diag(Sigma0);

S                 =   max( Sigma0.^2/(size(Y,2))-nsig^2, 0 );
thr               =   (c1*(nsig^2)./ ( sqrt(S) + eps ));   
S                 =   soft(Sigma0, thr);
r                 =   sum( S>0 );
U                 =   U0(:,1:r);
V                 =   V0(:,1:r);
X                 =   U*diag(S(1:r))*V';



% X = bsxfun(@plus, X, MY);

X = X(:,1);

% if r==size(Y,1)
%     wei           =   1/size(Y,1);
% else
%     wei           =   (size(Y,1)-r)/size(Y,1);
% end
% W                 =   wei*ones( size(X) );
% X                 =   X*wei;
return;

