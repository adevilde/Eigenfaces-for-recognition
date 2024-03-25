% fonction permettant d'identifier la personne la plus vraisemblable 
% de la représentation compacte de l'image requête en utilisant 
% la classification bayésienne

% entrées: - C matrice de la représentation compacte des images de données
%          - C_requete matrice de la représentation compacte de l'image requête

% sortie: personne et posture la plus vraisemblable dans la base de données


function [personne_proche,posture_proche] = bayesien(C, C_requete,nb_postures_base,nb_personnes_base)

%     Pmax = 0;
%     [nb_personnes_base,~] = size(C);
% 
%     for i = 1:nb_personnes_base
%         image_compacte_i = C(i,:);
% 
%         [mu, sigma] = estimation_mu_Sigma(image_compacte_i');
%         P = gaussienne(C_requete, mu, sigma);
% 
%         if P >= Pmax
%             Pmax = P;
%             posture_proche = mod(i,6);
%             if posture_proche == 0
%                 posture_proche = 6;
%             end
%             personne_proche = fix(i/6) + 1;
%         end
% 
%     end

    mu = zeros(2,size(C,1));
    for i=1:size(C,1)
        [mu(:,i),sigma] = estimation_mu_Sigma(C(i,:));
    end
    P_indice = zeros(1,size(C,1));
    % Calcul des probabilités p(c(x)| w) 
    for i=1:size(C,1)
        P_indice(i) = gaussienne(C_requete, mu(:,i), sigma);
    end
    % Recherche de l'indice du maximum des probabilités
    [~,indicemax] = max(P_indice);

    for i = 1 : length(indicemax)
        if rem(indicemax(i),nb_postures_base) == 0
            posture_proche(i) = nb_postures_base;
            personne_proche(i) = floor(indicemax(i)/nb_postures_base);
    
        else
            posture_proche(i) = rem(indicemax(i),nb_postures_base);
            personne_proche(i) = floor(indicemax(i)/nb_postures_base) + 1;
        end  
    end
    
end