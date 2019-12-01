cd e;
f=dir('*.TIF');
files={f.name};
for k=1:numel(files)
    vi_e{k}=imread(files{k});
end
cd ..
cd o;
g=dir('*.TIF');
giles={g.name};
for l=1:numel(giles)
    vi_o{l}=imread(giles{l});
end
cd ..
for k=1:length(vi_e)
    vi_e{k}=imadjust(vi_e{k});
end
for l=1:length(vi_o)
    vi_o{l}=imadjust(vi_o{l});
end
for j=1:length(vi_e)
    vi{j}=vi_e{j}-vi_o{j};
end
for j=1:length(vi_e)
    vi{j}=imadjust(vi{j});
end
for j=1:length(vi_e)
    vi{j}=vi{j}-vi_e{j};
end
for j=1:length(vi_e)
    vi{j}=imadjust(vi{j});
end
% for j=1:length(vi_e)
%     figure;
%     imshow(vi{j}), title('Imagen con imadjust');
% end
