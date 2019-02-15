load('F:\Users\Mayo\Documents\Chapter 6 - Depth Electrode EIT\Mesh_VPM_RH\Mesh_RH_VPM.mat');
load('F:\Users\Mayo\Documents\Code\electrode array generation\pos_figures.mat');

pos = pos2;
[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

srf = dubs3_2(Mesh.Tetra(:,1:4));
srf_nds=unique([srf(:,1);srf(:,2);srf(:,3)],'rows');

R_ref = 2e-3;
R_cor = 250e-6;


for iEl = 1:length(pos)
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;
    dist = sum(dist,2);
    nodes{iEl} = srf_nds(dist<R_cor^2,:);
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')

end


el_nds = [];
for iEl = 1:length(pos) %Don't want to plot the reference electrode
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

writeVTKcell('electrode_nodes_cortex2',Mesh.Tetra(ind_tetra,1:4),Mesh.Nodes(:,1:3),Mesh.Tetra(ind_tetra,5));
