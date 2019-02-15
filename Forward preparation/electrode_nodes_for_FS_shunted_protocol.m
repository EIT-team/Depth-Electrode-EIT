load('D:\Rat_055\Reconstruction\Mesh\Mesh_rods_Rat_055.mat');
load('D:\Rat_055\Reconstruction\Protocol_Rat_055_depth.mat')
%load('F:\Users\Mayo\Documents\Chapter 6 - Recovery\Depth Electrode Simulations\Mesh_square_refinement\Rat_050\Protocol_Rat_050.mat')

load('D:\Rat_055\Reconstruction\pos_depth.mat');
pos_depth = pos;

load('D:\Rat_055\Reconstruction\pos_cortex.mat');
pos_cortex = pos;

pos = [pos_depth;pos_cortex];


%Prot_map = Protocol;
mname = 'mesh_Rat_055';

[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

srf = dubs3_2(Mesh.Tetra(:,1:4));
srf_nds=unique([srf(:,1);srf(:,2);srf(:,3)],'rows');

figure;
trimesh(srf,Mesh.Nodes(:,1),Mesh.Nodes(:,2),Mesh.Nodes(:,3),'FaceAlpha',0.5);

%Position of reference electrode at back of neck
pos(end+1,:) = [14.55,9.524,8.227]/1000;



%%
R_DV = 150e-6;
R_ML = 15e-6;
R_AP = 15e-6;
%R_AP = 15e-6;
%Diameter of reference electrode
R_ref = 2e-3;
R_cor = 250e-6;


figure;
trimesh(srf,Mesh.Nodes(:,1),Mesh.Nodes(:,2),Mesh.Nodes(:,3),'FaceAlpha',0.5);

hold on


for iEl = 1:length(pos_depth)
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;

%Only want electrodes facing one direction
    sign_AP = sign(Mesh.Nodes(srf_nds,3) - repmat(pos(iEl,3), size(Mesh.Nodes(srf_nds,:),1),1));

%Want electrodes on each probe facing toward centre and eachother
    if iEl <=16
        nodes{iEl} = srf_nds(find(dist(:,1)<R_ML^2 & dist(:,2) < R_DV^2 & dist(:,3) < R_AP^2));
    else
        nodes{iEl} = srf_nds(find(dist(:,1)<R_ML^2 & dist(:,2) < R_DV^2 & dist(:,3) < R_AP^2));
    end
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')

end
daspect([1,1,1]);

for iEl = length(pos_depth)+1:(length(pos_cortex) + length(pos_depth))
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;
    dist = sum(dist,2);
    nodes{iEl} = srf_nds(dist<R_cor^2,:);
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')
%     fprintf(elecnodfile,'%d,',nodes{iEl}(1:end-1));
%     fprintf(elecnodfile,'%d\n',nodes{iEl}(end));
end

for iEl = length(pos)
    dist = (Mesh.Nodes(srf_nds,1:3) - repmat(pos(iEl,:), size(Mesh.Nodes(srf_nds,:),1),1)).^2;
    dist = sum(dist,2);
    nodes{iEl} = srf_nds(dist<R_ref^2,:);
    scatter3(Mesh.Nodes(nodes{iEl},1),Mesh.Nodes(nodes{iEl},2),Mesh.Nodes(nodes{iEl},3),50,'filled')
end

%%
for iPrt = 1:size(Prot_map,1)
    nodes_temp = cell(1,33);
    count1 = 1;
    count2 = 1;
    elec_inj1 = [];
    elec_inj2 = [];
    
    for iPos = 1:length(pos)
        if ismember(iPos,Prot_map(iPrt,1:4))% && iPos <= 16
            if count1 == 1
             inj1 = iPos;
             count1 = 0;
            end
            elec_inj1 = [elec_inj1,iPos];
            nodes_temp{1,inj1} = [nodes_temp{1,inj1};nodes{1,iPos}];
            
            if iPos~= inj1
            nodes_temp{1,iPos} = [];
            end
        elseif ismember(iPos,Prot_map(iPrt,5:8))% && iPos > 16
            if count2 == 1
                inj2 = iPos;
                count2 = 0;
            end
            elec_inj2 = [elec_inj2,iPos];
            nodes_temp{1,inj2} = [nodes_temp{1,inj2};nodes{1,iPos}];
            if iPos ~= inj2
                nodes_temp{1,iPos} = [];
            end
        else
            nodes_temp{1,iPos} = nodes{1,iPos};
        end
    end
    
    nodes_prt = nodes_temp(~cellfun('isempty',nodes_temp));
    inj = [inj1,inj2];
    inj_fwd = [inj1,inj2-3];
    [max_n,idx] = sort(cellfun('length',nodes_prt(1:26)),'descend');
    
    inj_fwd2 = sort(idx(1:2));
    
    if inj_fwd ~= inj_fwd2
        display(['Forward protocol not consistent prt' num2str(iPrt)]);
    end
    
    rm = setdiff(Prot_map(iPrt,:), inj);
    elec_idx = setdiff([1:length(pos)-1],rm);
    elec_inj = [elec_inj1,elec_inj2];
    
     elecnodfile = fopen(['electrode_nodes_' mname '_prt' num2str(iPrt)],'w');
     for iEl = 1:size(nodes_prt,2) 
        fprintf(elecnodfile,'%d,',nodes_prt{iEl}(1:end-1));
        fprintf(elecnodfile,'%d\n',nodes_prt{iEl}(end));
     end
     fclose(elecnodfile);
    
    save(['prt' num2str(iPrt) '_inj_idx'], 'inj','inj_fwd2', 'elec_idx', 'elec_inj', '-v7.3');    
    
    elec_pos = pos(elec_idx,:);
    
     save(['pos_prt' num2str(iPrt)], 'elec_pos', '-v7.3');    
    
    protocol_all(iPrt,:) = inj;
    
  figure;
    for i = 1:26
    if size(nodes_prt{i},1) > 60
        scatter3(Mesh.Nodes(nodes_prt{i},1),Mesh.Nodes(nodes_prt{i},2),Mesh.Nodes(nodes_prt{i},3),50,'filled', 'k')
    else
        scatter3(Mesh.Nodes(nodes_prt{i},1),Mesh.Nodes(nodes_prt{i},2),Mesh.Nodes(nodes_prt{i},3),50,'filled', 'r')
    end
    hold on;
    end
    waitforbuttonpress;
end

save('shunted_protocol_for_forward', 'protocol_all','-v7.3');




                

%%
% %Find electrode nodes
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

writeVTKcell('electrode_nodes',Mesh.Tetra(ind_tetra,1:4),Mesh.Nodes(:,1:3),Mesh.Tetra(ind_tetra,5));






