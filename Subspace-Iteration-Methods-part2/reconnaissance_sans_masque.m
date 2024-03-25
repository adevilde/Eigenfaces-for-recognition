clear;
close all;

load eigenfaces_part3;

% Tirage aléatoire d'une image de test :
personne = randi(nb_personnes)
posture = randi(nb_postures)
% si on veut tester/mettre au point, on fixe l'individu
%personne = 10
%posture = 6

ficF = strcat('./Data/', liste_personnes{personne}, liste_postures{posture}, '-300x400.gif')
img = imread(ficF);
image_test = double(transpose(img(:)));
 
% Choix du nombre de voisins
K = 1;

% Nombre q de composantes principales à prendre en compte 
q = 5;

% dans un second temps, q peut être calculé afin d'atteindre le pourcentage
% d'information avec q valeurs propres (contraste)
% Pourcentage d'information 
% per = 0.75;



% Données d'apprentissage (connues)
DataA = X_centre * W(:,1:q);

% Initialisation du vecteur des classes
ListeClassePersonnes = 1:nb_personnes_base;
ListeClassePostures = 1:nb_postures_base;

% Labels des données d'apprentissage    
LabelAPersonnes = repelem(ListeClassePersonnes,nb_postures_base); 
LabelAPostures = repmat(ListeClassePostures,1,nb_personnes_base);

% Données de test (on veut trouver leur label)
DataT = image_test - individu_moyen;
DataT = DataT * W(:,1:q);

% Nombre d'images test
Nt_test = 1;

[PartitionPersonnes] = kppv(DataA, LabelAPersonnes, DataT, Nt_test, K, ListeClassePersonnes);
[PartitionPostures] = kppv(DataA, LabelAPostures, DataT, Nt_test, K, ListeClassePostures);

% [personne_proche,posture_proche] = bayesien(DataA,DataT,nb_postures_base,nb_personnes_base);

% individu pseudo-résultat pour l'affichage
personne_proche = PartitionPersonnes;
posture_proche = PartitionPostures;


figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.8*L,0.5*H]);

subplot(1, 2, 1);
% Affichage de l'image de test :
colormap gray;
imagesc(img);
title({['Individu de test : posture ' num2str(posture) ' de ', liste_personnes{personne}]}, 'FontSize', 20);
axis image;

ficF = strcat('./Data/', liste_personnes_base{personne_proche}, liste_postures{posture_proche}, '-300x400.gif')
img = imread(ficF);
        
subplot(1, 2, 2);
imagesc(img);
title({['Individu la plus proche : posture ' num2str(posture_proche) ' de ', liste_personnes_base{personne_proche}]}, 'FontSize', 20);
axis image;


% Matrice de confusion

image_predite = double(transpose(img(:)));
Matrice_confusion = confusionmat(image_test,image_predite)
