
clear all;
format long;

%%%%%%%%%%%%
% PARAMÈTRES
%%%%%%%%%%%%

% taille de la matrice symétrique
n = 200;

% type de la matrice (voir matgen_csad)
% imat == 1 valeurs propres D(i) = i
% imat == 2 valeurs propres D(i) = random(1/cond, 1) avec leur logarithmes
%                                  uniformément répartie, cond = 1e10
% imat == 3 valeurs propres D(i) = cond**(-(i-1)/(n-1)) avec cond = 1e5
% imat == 4 valeurs propres D(i) = 1 - ((i-1)/(n-1))*(1 - 1/cond) avec cond = 1e2
imat = 1;

% tolérance
eps = 1e-5;
% nombre d'itérations max pour atteindre la convergence
maxit = 1000;

% on génère la matrice (1) ou on lit dans un fichier (0)
genere = 1;


% méthode de calcul
v = 3; % subspace iteration v3

% taille du sous-espace (V1, v2, v3)
m = 50;

% pourcentage de la trace que l'on veut atteindre (v1, v2, v3)
percentage = .4;

genere = 0;


    time3 = cputime;
    [W, V, flag] = eigen_2022(imat, n, v, m, eps, maxit, percentage, 10, genere);
    time3 = cputime - time3;

% méthode de calcul
v = 2; % subspace iteration v2

% nombre de valeurs propres cherchées (v1)
m = 50;

% pourcentage de la trace que l'on veut atteindre (v1, v2, v3)
percentage = .4;

    time2 = cputime;
    [W, V, flag] = eigen_2022(imat, n, v, m, eps, maxit, percentage, 10, genere);
    time2 = cputime - time2;



figure
plot(time2)
hold on
plot(time3)
title("Evolution du temps de calcul en fonction de p")
xlabel("p")
ylabel("Temps de calcul (en secondes)")
legend('Temps de calcul de subspace\_v3', 'Temps de calcul de subspace\_v2')