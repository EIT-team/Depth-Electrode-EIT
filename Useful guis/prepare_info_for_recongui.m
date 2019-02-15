load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rods_Rat_055_hex_200um_depth.mat');
load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rods_Rat_055.mat');

centre = (Mesh_hex.Nodes(Mesh_hex.Hex(:,1),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,2),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,3),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,4),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,5),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,6),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,7),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,8),:))./8;


[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);
srf = dubs3_2(Mesh.Tetra(:,1:4));
cnt_srf = (Mesh.Nodes(srf(:,1),:) + Mesh.Nodes(srf(:,2),:) + Mesh.Nodes(srf(:,3),:))/3;


load('D:\Rat_055\Mesh & Forward\Electrode Positions\pos_depth.mat')
info.cnt_el = mean(pos);
dist = abs(cnt_srf - repmat(info.cnt_el,size(cnt_srf,1),1));
%%
idx_srf = find(dist(:,1) < 3e-3 & dist(:,2) < 1.5e-3 & dist(:,3) < 2e-3);
figure;
trimesh(srf(idx_srf,:),Mesh.Nodes(:,1),Mesh.Nodes(:,2),Mesh.Nodes(:,3),'FaceAlpha',0.5);


%%
info.cnts = centre;
info.srf = srf;
info.idx_srf = idx_srf;
info.nodes = Mesh.Nodes;