%% UBICACIÓN DE LAS MUESTRAS + CONTRASTE %%
BibliotecaImagenes;

%% DILATAR IMAGEN %% (uso de la función imdilate)
for j=1:10%length(vi_e) 
    S_bin{j}=im2bw(vi_rotadas_orig_redim_patron{j});
%     figure;
%     imshow(S_bin{j})
%     imshowpair(vi_rotadas_orig_redim_patron{j},S_bin{j},'montage')
end
for j=1:10&length(vi_e) 
    elemento_estructural = strel('disk',5);
    S_bin_dil{j}=imdilate(S_bin{j},elemento_estructural);
%     figure;
%     imshow(S_bin_dil{j})
%     imshowpair(S_bin{j},S_bin_dil{j},'montage')
end
 
 %% SACAR BORDES %% (uso de la función edge)
for j=1:10%length(vi_e)
    S_canny{j}=edge(S_bin_dil{j},'canny',[], 1);
%     figure;
%     imshow(S_canny{j})
end
 
 %% CONVEXHULL + OBTENCIÓN BORDES DE LA MÁSCARA %% (colorea de blanco el area mayor, el resto lo deja negro)
for j=1:10%length(vi_e)
%     S_canny_rellenas{j}=bwconvhull(S_canny{j},'objects',8);
    S_canny_rellenas{j}=bwconvhull(S_canny{j});
%     figure; 
%     imshow(S_canny_rellenas{j}) 
end
 
for j=1:10%length(vi_e)
    [Mask_area_rellena{j},properties{j}]=funcionArea(S_canny_rellenas{j});
%     figure;
%     imshow(Mask_area_rellena{j})
    Mask_area_rellena_edges{j} = edge(Mask_area_rellena{j},'canny',[], 1);
end

%% ASIGNACIÓN DE ELEMENTOS DE LAS MATRICES %% (por si necesitamos elegir áreas manualmente)
S_canny_rellenas_1=S_canny_rellenas{1};
S_canny_rellenas_2=S_canny_rellenas{2};
S_canny_rellenas_3=S_canny_rellenas{3};
S_canny_rellenas_4=S_canny_rellenas{4};
S_canny_rellenas_5=S_canny_rellenas{5};
S_canny_rellenas_6=S_canny_rellenas{6};
S_canny_rellenas_7=S_canny_rellenas{7};

%% CONVEXHULL %% (colorea de blanco el area mayor, el resto lo deja negro)
for j=1:10%length(vi_e)
    Mask_edges_convexHull{j}=bwconvhull(Mask_area_rellena_edges{j});
%     figure; 
%     imshow(Mask_edges_convexHull{j}) 
end
  
 %% SACAR BORDES %% (uso de la función edge)
for j=1:10%length(vi_e)
    Mask_edges_convexHull_canny{j} = edge(Mask_edges_convexHull{j},'canny',[]);
%     figure;
%     imshow(Mask_edges_convexHull_canny{j})
end

%% GRAYTHRESH %%
for j=1:10%length(vi_e)
    level(j)= graythresh(vi_rotadas_orig_redim_patron{j});
    vi_rotadas_orig_redim_patron_gray{j}= imbinarize(vi_rotadas_orig_redim_patron{j},level(j));
%     figure;
% %     imshowpair(vi_rotadas_orig_redim_patron{j},vi_rotadas_orig_redim_patron_gray{j},'montage');
%     imshow(vi_rotadas_orig_redim_patron_gray{j})
    
    vi_bnInvertidos{j}= imcomplement(vi_rotadas_orig_redim_patron_gray{j})
%     figure;
%     imshow((vi_bnInvertidos{j}));
      vi_bnInvertidos_areaCelula{j}=vi_bnInvertidos{j}.*Mask_edges_convexHull{j};
%       figure;
%       imshow(vi_bnInvertidos_areaCelula{j});
end

%% GRAYTHRESH * ORIGINAL + MEDFILT2  +  IM2BW% %% 
for j=1:10%length(vi_e)
    vi_rotadas_orig_redim_patron_gray_final{j}=(vi_rotadas_orig_redim_patron{j}).*(uint8(vi_rotadas_orig_redim_patron_gray{j}));
    figure;
    imshow(vi_rotadas_orig_redim_patron_gray_final{j});

    vi_rotadas_orig_redim_patron_gray_final_medfilt{j}=medfilt2(vi_rotadas_orig_redim_patron_gray_final{j},[2 2]);
    vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}=im2bw(vi_rotadas_orig_redim_patron_gray_final_medfilt{j});
%     figure;
%     imshowpair(vi_rotadas_orig_redim_patron_gray_final_medfilt{j},vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j},'montage')
end

%% CONTAR PIXELES BLANCOS Y FRACCION DE DEFECTOS %% 
for j=1:10%length(vi_e)
    vi_aux1{j}=Mask_edges_convexHull{j}.*vi_bnInvertidos_areaCelula{9};
    vi_aux2{j}=vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}.*vi_bnInvertidos_areaCelula{9};
    num_pix_imagen(j)=numel(vi_aux1{j});
    num_pix_blancos_area_total(j)=sum(vi_aux1{j}(:));
    num_pix_negros_area_total(j)=num_pix_imagen(j)-num_pix_blancos_area_total(j);
    num_pix_blancos_original(j)=sum(vi_aux2{j}(:));
    num_pix_negros_original(j)=num_pix_imagen(j)-num_pix_blancos_original(j);
    
    frac_defectos(j)=((num_pix_negros_original(j)-num_pix_negros_area_total(j))/num_pix_imagen(j))*100
end

%% HISTOGRAMA DE LAS IMAGENES PROCESADAS %%
% for j=1:10%length(vi_e)
%     figure;
%     imhist(vi_rotadas_orig_redim_patron{j});
%     figure;
%     imagesc(vi_rotadas_orig_redim_patron{j});
%     title (['Histograma correspondiente a la imagen ',num2str(j)]); 
% end

%% COLOREAR DEFECTOS %%
for j=1:10%length(vi_e)  
    GreenAndBlueChannel(j).valor = 255 * uint8(vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}+vi_bnInvertidos_areaCelula{9});
    RedChannel(j).valor= 255 * ones(size(vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}+vi_bnInvertidos_areaCelula{9}), 'uint8');
    vi_defectoscolor_previo{j}= cat(3, RedChannel(j).valor, GreenAndBlueChannel(j).valor, GreenAndBlueChannel(j).valor);
%     figure;
%     imshow(vi_defectoscolor_previo{j})

    vi_defectoscolor{j}=((vi_defectoscolor_previo{j}).*(uint8(Mask_edges_convexHull{j})));
    figure;
%     imshowpair(vi_rotadas_orig_redim_patron{j},vi_defectoscolor{j},'montage')
    imshow(vi_defectoscolor{j})
%     title('defectos en color');
end

% for j=9:9%length(vi_e)  
% level_multi(j).valor=multithresh(vi_rotadas_orig_redim_patron{j},2);
% im_segmentada{j} = imquantize(vi_rotadas_orig_redim_patron{j},level_multi(j).valor);
% im_defectos_multi{j}= label2rgb(im_segmentada{j});    
% figure;
% imshow(im_defectos_multi{j})
% figure;
% imhist(vi_rotadas_orig_redim_patron{j});
% end
