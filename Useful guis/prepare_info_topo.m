%%

load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rat_055.mat');
[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);
idx = find(Mesh.Tetra(:,5) == 3);
srf = dubs3_2(Mesh.Tetra(idx,1:4));
cnt_srf = (Mesh.Nodes(srf(:,1),:) + Mesh.Nodes(srf(:,2),:) + Mesh.Nodes(srf(:,3),:))/3;
AP_mid = mean(Mesh.Nodes(:,3),1);
%%

seg1 = find(cnt_srf(:,3) > AP_mid & cnt_srf(:,3) < 0.025 & cnt_srf(:,1) > 0.017 &  cnt_srf(:,2) < 0.0142);
seg2 = find(cnt_srf(:,3) <= AP_mid & cnt_srf(:,3) > 0.0152 & cnt_srf(:,1) > 0.017  &  cnt_srf(:,2) < 0.0142);
seg3 = find(cnt_srf(:,3) >= 0.025 & cnt_srf(:,3) < 0.026 & cnt_srf(:,1) > 0.017 &  cnt_srf(:,2) < 0.0142);


origin1 = [0.018,0.012,0.021];
origin2 = [0.018, 0.0135 ,mean(cnt_srf(seg2,3),1)];
origin3 = [0.018,0.013,0.0255];



rad1 = sum((cnt_srf(seg1,:) - repmat(origin1, length(seg1),1)).^2,2).^0.5;
rad2 = sum((cnt_srf(seg2,:) - repmat(origin2, length(seg2),1)).^2,2).^0.5;
rad3 = sum((cnt_srf(seg3,:) - repmat(origin3, length(seg3),1)).^2,2).^0.5;

idx1 = find(rad1 > 0.0044);
idx2 = find(rad2> 0.00575);
idx3 = find(rad3 > 0.0012);

rm = find(cnt_srf(seg3(idx3),1) < 0.0173 & cnt_srf(seg3(idx3),2) > 0.013 & cnt_srf(seg3(idx3),2) < 0.0268 );

idx3(rm) = [];

idx_srf = [seg1(idx1); seg2(idx2); seg3(idx3)];

figure; scatter3(cnt_srf(idx_srf,1), cnt_srf(idx_srf,2), cnt_srf(idx_srf,3))
%%
load('D:\code for depth\gui\cortex_pos_map.mat');
load('D:\Rat_055\Whisker All\Topoplot\EP_mua.mat');
load('D:\Rat_055\Mesh & Forward\Electrode Positions\pos_cortex.mat');
%%

for iEl = 1:length(pos)
    dist_el = sum((cnt_srf(idx_srf,:) - repmat(pos(iEl,:), length(idx_srf),1)).^2,2).^0.5;
    [~,idx_el(iEl,1)] = min(dist_el);
end

idx_el = idx_srf(idx_el);
%%
idx_ROI = [];
for iEl = 1:length(pos)
    
    dist_el = sum((cnt_srf(idx_srf,:) - repmat(cnt_srf(idx_el(iEl),:), length(idx_srf),1)).^2,2).^0.5;
    idx_temp = find(dist_el < 1.5e-3);
    idx_ROI = [idx_ROI;idx_temp];
end
idx_ROI = unique(idx_ROI);

idx_nROI = setdiff([1:length(idx_srf)], idx_ROI);

%%
t = find(T_d> 0 & T_d < 60);

%EP_seg = EP_d(t,33:end);
EP_seg = EP_d(t,:);
V_lfp = EP_seg(:,map);
%V_lfp(:,27) = 0;
%V_lfp(:,34) = 0;
%%
for iT = 1:length(t)

F = scatteredInterpolant(cnt_srf(idx_el,1),cnt_srf(idx_el,2),cnt_srf(idx_el,3),V_lfp(iT,:)', 'natural');

Vq_lfp(:,iT) = F(cnt_srf(idx_srf,1),cnt_srf(idx_srf,2),cnt_srf(idx_srf,3));
Vq_lfp(idx_nROI,iT) = 0;
end


%%
%mua_seg = mua_d(t,33:end);
mua_seg = mua_d(t,:);
V_mua = mua_seg(:,map);
%V_mua(:,27) = 0;
V_mua(:,[3,14]) = 0;
%%
for iT = 1:length(t)

F = scatteredInterpolant(cnt_srf(idx_el,1),cnt_srf(idx_el,2),cnt_srf(idx_el,3),V_mua(iT,:)', 'natural');

Vq_mua(:,iT) = F(cnt_srf(idx_srf,1),cnt_srf(idx_srf,2),cnt_srf(idx_srf,3));
Vq_mua(idx_nROI,iT) = 0;
end

%%
% for iT = 1:length(t)
% patch(S.ax2,'Faces',srf(idx_srf,:),'Vertices',Mesh.Nodes(:,1:3), 'FaceVertexCData', Vq(:,iT),...
%        'FaceColor', 'flat', 'EdgeColor', 'none');
% hold on; scatter3(S.ax2,pos(:,1),pos(:,2),pos(:,3), 40, 'k', 'filled')
% colorbar
% caxis([-100,100]);
% daspect([1,1,1])
% view(S.ax2,49,-2);
% axis off;
% waitforbuttonpress;
% end



topo.srf = srf;
topo.idx_srf = idx_srf;
topo.Vq_mua = Vq_mua;
topo.mua = V_mua;
topo.lfp = V_lfp;
topo.Vq_lfp = Vq_lfp;
topo.T = T_d(t);
topo.pos = pos;
topo.Nodes = Mesh.Nodes;

clearvars -except topo

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

topo.orig_c = cnt_c;
topo.srf_c = srf_c;
topo.idx_c = idx_srf_c;
topo.nodes_c = Mesh.Nodes;

%%
load('D:\Rat_055\Mesh & Forward\Mesh\Mesh_rods_Rat_055_hex_110um.mat');
% for i = 1:size(Mesh_hex.Hex,1)
% centre(i,:) = mean(Mesh_hex.Nodes(Mesh_hex.Hex(i,:),:),1);
% end

centre = (Mesh_hex.Nodes(Mesh_hex.Hex(:,1),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,2),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,3),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,4),:) + ...
Mesh_hex.Nodes(Mesh_hex.Hex(:,5),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,6),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,7),:)+ Mesh_hex.Nodes(Mesh_hex.Hex(:,8),:))./8;

topo.cnts_c = centre;

