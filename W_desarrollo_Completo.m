%% UBICACIÓN DE LAS MUESTRAS + CONTRASTE %%
Base;

%% DILATAR IMAGEN %% (uso de la función imdilate)
for j=1:length(vi_e) 
    S_bin{j}=im2bw(vi{j});
%     figure;
%     imshow(S_bin{j})
%     imshowpair(vi{j},S_bin{j},'montage')
end
for j=1:length(vi_e) 
    elemento_estructural = strel('disk',5);
    S_bin_dil{j}=imdilate(S_bin{j},elemento_estructural);
%     figure;
%     imshow(S_bin_dil{j})
%     imshowpair(S_bin{j},S_bin_dil{j},'montage')
end
 
 %% SACAR BORDES %% (uso de la función edge)
for j=1:length(vi_e)
    S_canny{j}=edge(S_bin_dil{j},'canny',[], 1);
%     figure;
%     imshow(S_canny{j})
end
 
 %% CONVEXHULL + OBTENCIÓN BORDES DE LA MÁSCARA %% (colorea de blanco el area mayor, el resto lo deja negro)
for j=1:length(vi_e)
    S_canny_rellenas{j}=bwconvhull(S_canny{j},'objects',8);
%     S_canny_rellenas{j}=bwconvhull(S_canny{j}); %descomentar si uso la biblioteca de imagenes
%     figure; 
%     imshow(S_canny_rellenas{j}) 
end
 
for j=1:length(vi_e)
    [Mask_area_rellena{j},properties{j}]=funcionArea(S_canny_rellenas{j});
%     figure;
%     imshow(Mask_area_rellena{j})
    Mask_area_rellena_edges{j} = edge(Mask_area_rellena{j},'canny',[], 1);
%     figure;
%     imshow(Mask_area_rellena_edges{j})
end

%% ASIGNACIÓN DE ELEMENTOS DE LAS MATRICES %% (por si necesitamos elegir áreas manualmente)
S_canny_rellenas_1=S_canny_rellenas{1};
S_canny_rellenas_2=S_canny_rellenas{2};
S_canny_rellenas_3=S_canny_rellenas{3};
S_canny_rellenas_4=S_canny_rellenas{4};
S_canny_rellenas_5=S_canny_rellenas{5};
S_canny_rellenas_6=S_canny_rellenas{6};
S_canny_rellenas_7=S_canny_rellenas{7};

%% CONVEXHULL %%
for j=1:length(vi_e)
    Mask_edges_convexHull{j}=bwconvhull(Mask_area_rellena_edges{j});
%     figure; 
%     imshow(Mask_edges_convexHull{j}) 
end

%% SACAR BORDES DE CONVEXHULL %% (se queda solo con los bordes)
for j=1:length(vi_e)
    Mask_edges_convexHull_canny{j} = edge(Mask_edges_convexHull{j},'canny',[]);
%     figure;
%     imshow(Mask_edges_convexHull_canny{j});
end

%% TRANSFORMADA DE HOUGH %%
for j=1:length(vi_e)
    [H,T,R] = hough(Mask_edges_convexHull_canny{j});
    H_valores(j).valor=H;
    T_valores(j).valor=T;
    R_valores(j).valor=R;
    
% CREATE HOUGH TRANSFORM
%     figure();
%     imshow(H_valores(j).valor,[],'XData',T_valores(j).valor,'YData',R_valores(j).valor,'InitialMagnification','fit');
%     colormap(gca,pink);
%     xlabel('\theta'),ylabel('\rho');
%     axis on, axis normal, hold on;

% FIND PEAKS IN THE HOUGH TRANSFORM 
    P = houghpeaks(H_valores(j).valor,10,'threshold',ceil(0.3*max(H_valores(j).valor(:))));
    P_valores(j).valor=P;
    x = T_valores(j).valor(P_valores(j).valor(:,2)); x_valores(j).valor=x;
    y = R_valores(j).valor(P_valores(j).valor(:,1)); y_valores(j).valor=y;
%     plot(x_valores(j).valor,y_valores(j).valor,'s','color','white');

% FIND LINES AND PLOT THEM (une los trozos de lineas que forman los bordes y se queda con las líneas mas importantes de cada borde)
    lines= houghlines(Mask_edges_convexHull_canny{j}, T_valores(j).valor, R_valores(j).valor, P_valores(j).valor, 'FillGap', 150, 'MinLength',270); %cambiar MinLength si uso la biblioteca de imagenes
    lines_valores(j).valor=lines;
%     figure()
%     imshow(Mask_edges_convexHull_canny{j}); 
%     title('Señalización de líneas');
%     hold on
    for k=1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        xy_valores(k).valor=xy;
%         plot(xy_valores(k).valor(:,1),xy_valores(k).valor(:,2),'LineWidth',2,'Color','green');
%         plot(xy_valores(k).valor(1,1),xy_valores(k).valor(1,2),'x','LineWidth',2,'Color','yellow');
%         plot(xy_valores(k).valor(2,1),xy_valores(k).valor(2,2),'x','LineWidth',2,'Color','red');
    end
    
% ROTAR LA IMAGEN SEGUN EL VALOR DE THETA 
    
    for l=1:length(lines_valores(j).valor)
        if (lines_valores(j).valor(l).theta > 80)
            Mask_edges_convexHull_canny_rotadas{j}=imrotate(Mask_edges_convexHull_canny{j},(-lines_valores(j).valor(l).theta+88));
        elseif (lines_valores(j).valor(l).theta < -80)
            Mask_edges_convexHull_canny_rotadas{j}=imrotate(Mask_edges_convexHull_canny{j},lines_valores(j).valor(l).theta+90);
        else
            Mask_edges_convexHull_canny_rotadas{j}=imrotate(Mask_edges_convexHull_canny{j},lines_valores(j).valor(l).theta);
        end
    end
    
%     figure();
%     imshow(Mask_edges_convexHull_canny_rotadas{j}); title('Imagen rotada');
%     imshowpair(Mask_edges_convexHull_canny{j},Mask_edges_convexHull_canny_rotadas{j},'montage')
end

%% ASIGNACION DE ELEMENTOS %%
Mask_edges_convexHull_canny_rotadas_1=Mask_edges_convexHull_canny_rotadas{1};
Mask_edges_convexHull_canny_rotadas_2=Mask_edges_convexHull_canny_rotadas{2};
Mask_edges_convexHull_canny_rotadas_3=Mask_edges_convexHull_canny_rotadas{3};
Mask_edges_convexHull_canny_rotadas_4=Mask_edges_convexHull_canny_rotadas{4};
Mask_edges_convexHull_canny_rotadas_5=Mask_edges_convexHull_canny_rotadas{5};
Mask_edges_convexHull_canny_rotadas_6=Mask_edges_convexHull_canny_rotadas{6};
Mask_edges_convexHull_canny_rotadas_7=Mask_edges_convexHull_canny_rotadas{7};

%% RELLENAR EL AREA ENCERRADA %%
for j=1:length(vi_e)
    Mask_edges_convexHull_canny_rotadas_rellenas{j}=bwconvhull(Mask_edges_convexHull_canny_rotadas{j});
%     figure; 
%     imshow(Mask_edges_convexHull_canny_rotadas_rellenas{j}); title('Área encerrada rellena');
end

%% ROTACIÓN DE LA IMAGEN ORIGINAL %%
for j=1:length(vi_e)
    for l=1:length(lines_valores(j).valor)
        if (lines_valores(j).valor(l).theta > 80)
            vi_rotadas{j}=imrotate(vi{j},(-lines_valores(j).valor(l).theta+88));
        elseif (lines_valores(j).valor(l).theta < -80)
            vi_rotadas{j}=imrotate(vi{j},lines_valores(j).valor(l).theta+90);
        else
            vi_rotadas{j}=imrotate(vi{j},lines_valores(j).valor(l).theta);
        end
    end
    
%     figure();
%     imshow(vi_rotadas{j});
%     imshowpair(vi{j},vi_rotadas{j},'montage');
end

%% ELIMINACIÓN DE RUIDO DE LA IMAGEN ORIGINAL %%
for j=1:length(vi_e)
    vi_rotadas_orig{j}=vi_rotadas{j}.*(uint16(Mask_edges_convexHull_canny_rotadas_rellenas{j}));
%     figure;
%     imshow(vi_rotadas_orig{j})
end

%% COMPARACIÓN DEL INICIO Y EL FIN DEL PROCESAMIENTO %% (antes de normalizar el tamaño de las imágenes) 
% for j=1:length(vi_e)
%     figure;
%     imshowpair(vi{j},vi_rotadas_orig{j},'montage')
%     title('Comparación entre la imagen original y la procesada');
% end

%% USANDO REGIONPROPS -> BOUNDINGBOX %%
for j=1:length(vi_e)    
    bound(j)=regionprops(Mask_edges_convexHull_canny_rotadas_rellenas{j},'BoundingBox'); 
end

%% USANDO IMCROP CON BOUNDINGBOX DE REGIONPROPS + IMRESIZE %%
for j=1:length(vi_e)
%     figure;
%     imshow(vi_rotadas_orig{j});
    vi_rotadas_orig_redim{j}=imcrop(vi_rotadas_orig{j},[bound(j).BoundingBox(1) bound(j).BoundingBox(2) bound(j).BoundingBox(3) bound(j).BoundingBox(4)]);
    vi_rotadas_orig_redim_patron{j}=imresize(vi_rotadas_orig_redim{j},[980,980]);
    Mask_edges_convexHull_canny_rotadas_rellenas_redim{j}=imcrop(Mask_edges_convexHull_canny_rotadas_rellenas{j},[bound(j).BoundingBox(1) bound(j).BoundingBox(2) bound(j).BoundingBox(3) bound(j).BoundingBox(4)]);
    Mask_edges_convexHull_canny_rotadas_rellenas_redim_patron{j}=imresize(Mask_edges_convexHull_canny_rotadas_rellenas_redim{j},[980,980]);
%     figure;
%     imshow(vi_rotadas_orig_redim_patron{j});
%     figure;
%     imshow(Mask_edges_convexHull_canny_rotadas_rellenas_redim_patron{j});
end

%% GRAYTHRESH %%
for j=1:length(vi_e)
    level(j)= graythresh(vi_rotadas_orig_redim_patron{j});
    vi_rotadas_orig_redim_patron_gray{j}= imbinarize(vi_rotadas_orig_redim_patron{j},level(j));
%     figure;
% %     imshowpair(vi_rotadas_orig_redim_patron{j},vi_rotadas_orig_redim_patron_gray{j},'montage');
%     imshow(vi_rotadas_orig_redim_patron_gray{j});
end

%% GRAYTHRESH * ORIGINAL + MEDFILT2  +  IM2BW% %% 
for j=1:length(vi_e)
    vi_rotadas_orig_redim_patron_gray_final{j}=(vi_rotadas_orig_redim_patron{j}).*(uint16(vi_rotadas_orig_redim_patron_gray{j}));
%     figure;
%     imshow(vi_rotadas_orig_redim_patron_gray_final{j});

    vi_rotadas_orig_redim_patron_gray_final_medfilt{j}=medfilt2(vi_rotadas_orig_redim_patron_gray_final{j},[2 2]);
    vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}=im2bw(vi_rotadas_orig_redim_patron_gray_final_medfilt{j});
%     figure;
%     imshowpair(vi_rotadas_orig_redim_patron_gray_final_medfilt{j},vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j},'montage')
end

%% CONTAR PIXELES BLANCOS Y FRACCION DE DEFECTOS %% 
for j=1:length(vi_e)
    num_pix_imagen(j)=numel(Mask_edges_convexHull_canny_rotadas_rellenas_redim_patron{j});
    num_pix_blancos_area_total(j)=sum(Mask_edges_convexHull_canny_rotadas_rellenas_redim_patron{j}(:));
    num_pix_negros_area_total(j)=num_pix_imagen(j)-num_pix_blancos_area_total(j);
    num_pix_blancos_original(j)=sum(vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}(:));
    num_pix_negros_original(j)=num_pix_imagen(j)-num_pix_blancos_original(j);
    
    frac_defectos(j)=((num_pix_negros_original(j)-num_pix_negros_area_total(j))/num_pix_imagen(j))*100
end

%% HISTOGRAMA DE LAS IMAGENES PROCESADAS %%
% for j=1:length(vi_e)
%     figure;
%     imhist(vi_rotadas_orig_redim_patron{j});
%     title (['Histograma correspondiente a la imagen ',num2str(j)]); 
% end

%% COLOREAR DEFECTOS %%
for j=1:length(vi_e)  
    GreenAndBlueChannel = 255 * uint8(vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j});
    GBChannel(j).valor=GreenAndBlueChannel;
    RedChannel= 255 * ones(size(vi_rotadas_orig_redim_patron_gray_final_medfilt_bin{j}), 'uint8');
    RChannel(j).valor=RedChannel;
    vi_defectoscolor_previo{j}= cat(3, RChannel(j).valor, GBChannel(j).valor, GBChannel(j).valor);
%     figure;
%     imshow(vi_defectoscolor_previo{j})

    vi_defectoscolor{j}=vi_defectoscolor_previo{j}.*(uint8(Mask_edges_convexHull_canny_rotadas_rellenas_redim_patron{j}));
    figure;
    imshow(vi_defectoscolor{j})
    title('defectos en color');
end

%% DEFECTOS COLOREADOS EN LA ORIGINAL (SE PIERDE INFORMACION, QUIZA MEJOR NO USARLO) %%
% for j=1:length(vi_e)
%     vi_defectoscolor_orig{j}= vi_rotadas_orig_redim_patron{j}.*(uint16(vi_defectoscolor{j}));
%     figure;
% %     imshow(vi_defectoscolor_orig{j})
%     imshowpair(vi_defectoscolor{j},vi_defectoscolor_orig{j},'montage')
% end

%% COMPARACIÓN DEL INICIO Y EL FIN DEL PROCESAMIENTO + DEFECTOS COLOREADOS %% 
% for j=1:length(vi_e)
%     figure;
%     subplot(1,2,1);
%     imshow(vi{j})
%     title('Imagen original');
%     subplot(1,2,2);
%     imshow(vi_defectoscolor{j})
%     title('Imagen procesada');
% end

%% ASIGNACION DE ELEMENTOS %%
vi_rotadas_orig_1=vi_rotadas_orig{1};
vi_rotadas_orig_2=vi_rotadas_orig{2};
vi_rotadas_orig_3=vi_rotadas_orig{3};
vi_rotadas_orig_4=vi_rotadas_orig{4};
vi_rotadas_orig_5=vi_rotadas_orig{5};
vi_rotadas_orig_6=vi_rotadas_orig{6};
vi_rotadas_orig_7=vi_rotadas_orig{7};
