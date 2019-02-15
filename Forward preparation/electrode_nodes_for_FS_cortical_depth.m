load('D:\Rat_055\Reconstruction\Mesh\Mesh_rods_Rat_055.mat');

load('D:\Rat_055\Reconstruction\pos_depth.mat');
pos_depth = pos;

load('D:\Rat_055\Reconstruction\pos_cortex.mat');
pos_cortex = pos;

pos = [pos_depth;pos_cortex];

mname = 'mesh_Rat_055_cortex';

[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

srf = dubs3_2(Mesh.Tetra(:,1:4));
srf_nds=unique([srf(:,1);srf(:,2);srf(:,3)],'rows');

%Position of reference electrode at back of neck
pos(end+1,:) = [14.55,9.524,8.227]/1000;



%%
R_DV = 150e-6;
R_ML = 15e-6;
R_AP = 15e-6;
%Diameter of reference electrode
R_ref = 2e-3;
R_cor = 250e-6;


%Find nodes associated with electrodes and write to file for PEITS forward
%solver
elecnodfile = fopen(['electrode_nodes_' mname],'w');

figure;
hold on

for iEl = 1:length(pos_depth)
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;

%Only want electrodes facing one direction
    sign_AP = sign(Mesh.Nodes(srf_nds,3) - repmat(pos(iEl,3), size(Mesh.Nodes(srf_nds,:),1),1));

%Want electrodes on each probe facing toward centre and eachother
    if iEl <=16
        nodes{iEl} = srf_nds(find(dist(:,1)<R_ML^2 & dist(:,2) < R_DV^2 & dist(:,3) < R_AP^2));% & sign_AP > 0));
    else
        nodes{iEl} = srf_nds(find(dist(:,1)<R_ML^2 & dist(:,2) < R_DV^2 & dist(:,3) < R_AP^2));% & sign_AP < 0));
    end
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')
    fprintf(elecnodfile,'%d,',nodes{iEl}(1:end-1));
    fprintf(elecnodfile,'%d\n',nodes{iEl}(end));
end

for iEl = length(pos_depth)+1:(length(pos_cortex) + length(pos_depth))
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;
    dist = sum(dist,2);
    nodes{iEl} = srf_nds(dist<R_cor^2,:);
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')
    fprintf(elecnodfile,'%d,',nodes{iEl}(1:end-1));
    fprintf(elecnodfile,'%d\n',nodes{iEl}(end));
end


for iEl = length(pos)
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;
    dist = sum(dist,2);
    nodes{iEl} = srf_nds(dist<R_ref^2,:);
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')
    fprintf(elecnodfile,'%d,',nodes{iEl}(1:end-1));
    fprintf(elecnodfile,'%d\n',nodes{iEl}(end));
end

fclose(elecnodfile);
%%
%Find electrode nodes
el_nds = [];
for iEl = 1:length(pos) - 1 %Don't want to plot the reference electrode
    el_nds = [el_nds; nodes{1,iEl}];
end

%Find electrode tetra for visualisation
el_tetra = ismember(Mesh.Tetra(:,1:4), el_nds);
ind_tetra = [];
for iT = 1:4
    T = find(el_tetra(:,iT) == 1);
    ind_tetra = [ind_tetra;T];
end
ind_tetra = unique(ind_tetra);

writeVTKcell('electrode_nodes_cortex',Mesh.Tetra(ind_tetra,1:4),Mesh.Nodes(:,1:3),Mesh.Tetra(ind_tetra,5));






