function y_den = reconstruct(X, x, par)

[height, width] = size(x);
y_den = zeros([height, width] );
weight_total = zeros([height, width]);

Nstep = 1;
i=1;

for col = 1:Nstep:width-par.win2+1
    for row = 1:Nstep:height-par.win1+1
        rec_ref = reshape(X(:,i), [par.win1, par.win2]);
        weight = 1;
        y_den(row:row+par.win1-1, col:col+par.win2-1) = y_den(row:row+par.win1-1, col:col+par.win2-1) + rec_ref * weight;
        weight_total(row:row+par.win1-1, col:col+par.win2-1) = weight_total(row:row+par.win1-1, col:col+par.win2-1) + weight;
        i = i + 1;
    end
end

y_den = y_den(1:height,1:width)./weight_total(1:height,1:width);

end