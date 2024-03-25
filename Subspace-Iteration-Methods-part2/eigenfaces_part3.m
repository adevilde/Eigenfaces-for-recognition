clear all;
close all;

%% CHOIX DES DONNÉES

% liste des différentes personnes
liste_personnes = {
 'f01', 'f02', 'f03', 'f04', 'f05', 'f06', 'f07', 'f08', 'f09', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16', 'm01', 'm02', 'm03', 'm04', 'm05', 'm06', 'm07', 'm08', 'm09', 'm10', 'm11', 'm12', 'm13', 'm14', 'm15', 'm16'
                  };
nb_personnes = length(liste_personnes);

% liste des différentes postures 
liste_postures = {'v1e1', 'v3e1', 'v1e2', 'v3e2', 'v1e3', 'v3e3'};
nb_postures = length(liste_postures);

nb_lignes = 400;
nb_colonnes = 300;

% personnes constituant la base d'apprentissage (À FAIRE EVOLUER)
% liste_personnes_base = {'f01', 'f03', 'f05', 'f07', 'f10', 'm10', 'm08' , 'm06', 'm04', 'm02'};
liste_personnes_base = liste_personnes;
%liste_personnes_base = {'f01', 'f10', 'm10', 'm08'} % clusters séparés
%       personnes          1     10     17     24     
nb_personnes_base = length(liste_personnes_base); 

% postures de la base d'apprentissage (À FAIRE EVOLUER)
liste_postures_base = [1 2 3 4 5 6];
nb_postures_base = length(liste_postures_base);

%% LECTURE DES DONNÉES SANS MASQUE

X = [];
liste_base = [];

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Personnes','Position',[0,0,0.80*L,0.80*H]);
colormap(gray(256));

% Affichage des images sous forme de planche-contact 
% (une personne par ligne, une posture par colonne) :
for j = 1:nb_personnes_base,
    no_posture = 0;
	for k = liste_postures_base,
        no_posture = no_posture + 1;
        
        ficF = strcat('./Data/', liste_personnes_base{j}, liste_postures{k}, '-300x400.gif')
        liste_base = [liste_base ; ficF];
        img = imread(ficF);
        % Remplissage de la matrice X :
        X = [X ; double(transpose(img(:)))];
        
        % Affichage
		subplot(nb_personnes_base, nb_postures_base, (j-1)*nb_postures_base + no_posture);
		imagesc(img);
		hold on;
		axis image;
		title(['Personne ' liste_personnes_base{j} ', posture ' num2str(k)]);
        
	end
end

%% CALCUL ET AFFICHAGE DES EIGENFACES SANS MASQUE

% Calcul de l'individu moyen :
n = size(X,1);
individu_moyen = ones(1,n)*X/n;

% Centrage de la matrice X (extension automatique de individu_moyen) :
X_centre = X - individu_moyen;

% Calcul de la matrice de covariance (impossible à calculer ainsi à cause de sa taille) :
% Sigma = X_centre'*X_centre/n;

% Calcul de la matrice résultant du calcul alternatif :
Sigma2 = X_centre*X_centre'/n;

% Calcul des vecteurs/valeurs propres de la matrice Sigma2 :

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOUS POUVEZ REMPLACER L'APPEL À EIG PAR UN APPEL À L'UNE DE VOS FONCTIONS
% SUBSPACE ITERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = 15;
percentage = 0.7;
p = 5;
eps = 1e-5;
maxit = 1000;

[ D, V_2] = subspace_iter_v3( Sigma2, m, p, percentage, eps, maxit);
%[V_2,D] = eig(Sigma2);

D = real(D);
V_2 = real(V_2);

% Tri par ordre décroissant des valeurs propres de Sigma2 :
[lambda, indices] = sort(diag(D), 'descend');

% Les vecteurs propres de Sigma (les eigenfaces) se déduisent de ceux de Sigma2 :
V = X_centre'*V_2;

% Tri des eigenfaces dans l'ordre des valeurs propres correspondantes 
% (on enlève la dernière eigenface, qui appartient au noyau de Sigma) :
W = V(:, indices);
W = W(:, 1:end-1);

% Normalisation des eigenfaces (qui ne le sont pas par construction) :
W = normalize(W, 'norm');

% Affichage de l'individu moyen et des eigenfaces sous la forme de "pseudo-images" 
% (leurs coordonnées sont interpretées comme des niveaux de gris) :
figure('Name','Individu moyen et eigenfaces', 'Position', [0,0,0.67*L,0.67*H]);
colormap(gray(256)); 
img = reshape(individu_moyen, nb_lignes, nb_colonnes);
subplot(nb_personnes_base, nb_postures_base, 1)
imagesc(img); 
hold on;  
axis image; 
title(['Individu moyen']);
for k = 1:n-1
	img = reshape(W(:,k), nb_lignes,nb_colonnes);
	subplot(nb_personnes_base, nb_postures_base,k+1);
	imagesc(img); 
	hold on; 
	axis image; 
	title(['Eigenface ', num2str(k)]);
end



%% LECTURE DES DONNEES AVEC MASQUES


% Dimensions du masque
ligne_min = 200;
ligne_max = 350;
colonne_min = 60;
colonne_max = 290;

%%%%%%%% LECTURE DES DONNES ET AJOUT DU MASQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_masque = [];

figure('Name','Personnes avec Masque','Position',[0,0,0.67*L,0.67*H]);
colormap(gray(256));

for j = 1:nb_personnes_base,
    no_posture = 0;
	for k = liste_postures_base,
        no_posture = no_posture + 1;
        
        ficF = strcat('./Data/', liste_personnes_base{j}, liste_postures{k}, '-300x400.gif')
        img = imread(ficF);
        
        % Degradation de l'image
        img(ligne_min:ligne_max,colonne_min:colonne_max) = 0;
        % Remplissage de la matrice X_masque :
        X_masque= [X_masque; double(transpose(img(:)))];
        
        % Affichage
		subplot(nb_personnes_base, nb_postures_base, (j-1)*nb_postures_base + no_posture);
		imagesc(img);
		hold on;
		axis image;
		title(['Personne ' liste_personnes_base{j} ', posture ' num2str(k)]);
        
	end
end

%%%%%% REFAIRE LE CALCUL ET L'AFFICHAGE DES EIGENFACES AVEC MASQUE

% % Calcul de l'individu moyen :
X_hors_masque = X_masque;
n = size(X_masque,1);
% for i = 1:n
%     tmp = X_masque(i,:);
%     X_hors_masque = [X_hors_masque;tmp(tmp ~= 0)];
% end 
individu_moyen_masque = sum(X_hors_masque) / n;

% Centrage de la matrice X :
X_centre_masque = X_hors_masque - individu_moyen_masque;

% Calcul de la matrice de covariance (impossible a calculer ainsi a cause de sa taille) :
% Sigma = (X_centre'*X_centre)/n;

% Calcul de la matrice resultant du calcul commuté (voir annexe du sujet) :
Sigma2 = (X_centre_masque*X_centre_masque')/n;

% Calcul des vecteurs/valeurs propres de la matrice Sigma2 :
m = 15;
percentage = 0.7;
p = 5;
eps = 1e-5;
maxit = 1000;

[ D, V_2] = subspace_iter_v3( Sigma2, m, p, percentage, eps, maxit);

D = real(D);
V_2 = real(V_2);

% [W2,D2] = eig(Sigma2);

% Les vecteurs propres de Sigma (les eigenfaces) se deduisent de ceux de Sigma2 :
W1 = X_centre_masque'*V_2;

% Tri par ordre decroissant des valeurs propres de Sigma2 :
[vp_trie, indice] = sort(diag(D),'descend');


% Tri des eigenfaces dans le meme ordre 
% (on enleve la derniere eigenface, qui appartient au noyau de Sigma) :
W_masque = W1(:, indice);

% Normalisation des eigenfaces :
for i = 1:n
    W_masque(:,i) = W_masque(:,i)/norm(W_masque(:,i));
end


%Affichage de l'individu moyen et des eigenfaces sous la forme de "pseudo-images" 
%(leurs coordonnees sont interpretees comme des niveaux de gris) :
figure('Name','Individu moyen et eigenfaces', 'Position', [0,0,0.67*L,0.67*H]);
colormap(gray(256)); 
img = reshape(individu_moyen_masque, nb_lignes, nb_colonnes);
subplot(nb_personnes_base, nb_postures_base, 1)
imagesc(img); 
hold on; 
axis image; 
title(['Individu moyen']);
for k = 1:n-1
	img = reshape(W_masque(:,k), nb_lignes,nb_colonnes);
	subplot(nb_personnes_base, nb_postures_base,k+1);
	imagesc(img); 
	hold on; 
	axis image; 
	title(['Eigenface ', num2str(k)]);
end


%% Sauvegarde des variables nécessaires pour la suite
save('eigenfaces_part3.mat', 'individu_moyen', 'lambda', 'W', 'X_centre', 'W_masque', 'X_centre_masque', 'nb_personnes', 'nb_postures', 'nb_personnes_base', 'nb_postures_base', ...
    'liste_personnes_base', 'liste_personnes', 'liste_postures', 'L', 'H');
