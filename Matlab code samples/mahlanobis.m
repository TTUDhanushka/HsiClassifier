
dataSet = [0.23, 61.5, 326;
            0.21, 59.8, 326;
            0.23, 56.9, 327;
            0.29, 62.4, 334;
            0.31, 63.3, 335];
        
mu = mean(dataX);

x_minus_mu = dataSet(1, :) - mu;

x_minus_mu_T = x_minus_mu';

cov_dataSet = cov(dataSet);
inv_cov = inv(cov_dataSet);
mahla = sqrt((x_minus_mu /cov_dataSet) * x_minus_mu_T)

d2 = mahal(dataSet, dataSet);


%%

sum = 0;

for i = 1:500
    sum = sum + dataX(i, 3);
end

mu_col_1 = sum / 500 