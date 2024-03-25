clear variables;clc

% tolerance relative minimum pour l'ecart entre deux iteration successives 
% de la suite tendant vers la valeur propre dominante 
% (si |lambda-lambda_old|/|lambda_old|<eps, l'algo a converge)
eps = 1e-8;
% nombre d iterations max pour atteindre la convergence 
% (si i > kmax, l'algo finit)
imax = 5000; 

% Generation d une matrice rectangulaire aleatoire A de taille n x p.
% On cherche le vecteur propre et la valeur propre dominants de AA^T puis
% de A^TA
n = 1500; p = 500;
m = 5;
A = 5*randn(n,p);

% AAt, AtA sont deux matrices carrees de tailles respectives (n x n) et 
% (p x p). Elles sont appelees "equations normales" de la matrice A
AAt = A*A'; AtA = A'*A;

%% Methode de la puissance iteree pour la matrice AAt de taille nxn
% Point de depart de l'algorithme de la puissance iteree : un vecteur
% aleatoire, normalise
V = normc(ones(p,m));

cv = false;
iv1 = 0;        % pour compter le nombre d'iterations effectuees
t_v1 = cputime; % pour calculer le temps d execution de l'algo
err1 = 0;       % indication que le calcul est satisfaisant
                % on stoppe quand err1 < eps 

beta = diag(V'*AtA*V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L'ALGORITHME DE LA PUISSANCE ITEREE POUR LA MATRICE AtA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while(~cv)
    
    V = AtA*V;
    V = normc(V);
    mu = beta;
    beta = diag(V'*AtA*V);

    iv1 = iv1 + 1;
    cv = (abs(mu-beta)/abs(mu) < eps | iv1 > imax);
end
t_v1 = cputime-t_v1; % t_version1 : temps d execution de l algo de la 
                     % puissance iteree pour la matrice AtA
V_conv = V