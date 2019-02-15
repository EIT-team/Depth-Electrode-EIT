load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rods_Rat_055.mat');
[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);
srf_d = dubs3_2(Mesh.Tetra(:,1:4));
cnt_srf = (Mesh.Nodes(srf_d(:,1),:) + Mesh.Nodes(srf_d(:,2),:) + Mesh.Nodes(srf_d(:,3),:))/3;

load('D:\Rat_055\Mesh & Forward\Electrode Positions\pos_depth.mat')
cnt_d =  mean(pos);
dist = abs(cnt_srf - repmat(cnt_d,size(cnt_srf,1),1));
idx_srf_d = find(dist(:,1) < 1.6e-3 & dist(:,2) < 1.5e-3 & dist(:,3) < 1.6e-3);

info.orig_d = cnt_d;
info.srf_d = srf_d;
info.idx_d = idx_srf_d;
info.nodes_d = Mesh.Nodes;

%%
load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_Rat_055.mat');
[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);
idx = find(Mesh.Tetra(:,5) == 3);
srf_a = dubs3_2(Mesh.Tetra(idx,1:4));
cnt_srf = (Mesh.Nodes(srf_a(:,1),:) + Mesh.Nodes(srf_a(:,2),:) + Mesh.Nodes(srf_a(:,3),:))/3;
idx_srf_a = find(cnt_srf(:,3) > 0.0155 & cnt_srf(:,3) < 0.0245 & cnt_srf(:,1) > 0.018 &  cnt_srf(:,2) < 0.0132);
cnt_a = mean(cnt_srf(idx_srf_a,:));

info.orig_a = cnt_a;
info.srf_a = srf_a;
info.idx_a = idx_srf_a;
info.nodes_a = Mesh.Nodes;

%%
load('F:\Users\Mayo\Documents\Mesh\Rat Mesh Cortical Layers\Mesh_layers.mat');
[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

idx1 = find(Mesh.Tetra(:,5) == 1);
srf1 = dubs3_2(Mesh.Tetra(idx1,1:4));
cnt_srf1 = (Mesh.Nodes(srf1(:,1),:) + Mesh.Nodes(srf1(:,2),:) + Mesh.Nodes(srf1(:,3),:))/3;

idx2 = find(Mesh.Tetra(:,5) == 2);
srf2 = dubs3_2(Mesh.Tetra(idx2,1:4));
cnt_srf2 = (Mesh.Nodes(srf2(:,1),:) + Mesh.Nodes(srf2(:,2),:) + Mesh.Nodes(srf2(:,3),:))/3;


idx3 = find(Mesh.Tetra(:,5) == 3);
srf3 = dubs3_2(Mesh.Tetra(idx3,1:4));
cnt_srf3 = (Mesh.Nodes(srf3(:,1),:) + Mesh.Nodes(srf3(:,2),:) + Mesh.Nodes(srf3(:,3),:))/3;


idx4 = find(Mesh.Tetra(:,5) == 4);
srf4 = dubs3_2(Mesh.Tetra(idx4,1:4));
cnt_srf4 = (Mesh.Nodes(srf4(:,1),:) + Mesh.Nodes(srf4(:,2),:) + Mesh.Nodes(srf4(:,3),:))/3;


idx5 = find(Mesh.Tetra(:,5) == 5);
srf5 = dubs3_2(Mesh.Tetra(idx5,1:4));
cnt_srf5 = (Mesh.Nodes(srf5(:,1),:) + Mesh.Nodes(srf5(:,2),:) + Mesh.Nodes(srf5(:,3),:))/3;

srf_c = [srf1;srf2;srf3;srf4;srf5];
cnt_srf = [cnt_srf1;cnt_srf2;cnt_srf3;cnt_srf4;cnt_srf5];
%%
AP1 = 0.018;
AP2 = 0.0183;
ML1 = 0.018;
DV1 = 0.0135;

idx_srf_c = find(cnt_srf(:,3) > AP1 & cnt_srf(:,3) < AP2 & cnt_srf(:,1) > ML1 &  cnt_srf(:,2) < DV1);

cnt_c = mean(cnt_srf(idx_srf_c,:));

info.orig_c = cnt_c;
info.srf_c = srf_c;
info.idx_c = idx_srf_c;
info.nodes_c = Mesh.Nodes;



%%
load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rods_Rat_055_hex_200um_depth.mat');

centre = (Mesh_hex.Nodes(Mesh_hex.Hex(:,1),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,2),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,3),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,4),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,5),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,6),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,7),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,8),:))./8;


info.cnts = centre;