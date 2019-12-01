cd biblioteca_imagenes;
f=dir('*.png');
files={f.name};
for k=1:numel(files)
    vi_rotadas_orig_redim_patron{k}=imread(files{k});
    vi_e{k}=vi_rotadas_orig_redim_patron{k};
end
cd ..

for j=1:20%length(vi_e)
    vi_rotadas_orig_redim_patron{j}=imadjust(vi_rotadas_orig_redim_patron{j});
end

% for j=1:20%length(vi_e)
%     figure;
%     imshow(vi_rotadas_orig_redim_patron{j}), title('Imagen con imadjust');
% end
