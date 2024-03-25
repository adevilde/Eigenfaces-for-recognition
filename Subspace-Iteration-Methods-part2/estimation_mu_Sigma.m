function [mu, sigma] = estimation_mu_Sigma(X)

n = length(X);

mu = mean(X',1);

sigma = (1/n) * (X-mu')' * (X-mu');

end
