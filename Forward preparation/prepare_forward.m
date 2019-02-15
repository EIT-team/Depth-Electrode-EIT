path = 'D:\Rat_055\Reconstruction\';
save_path = 'D:\Rat_055\Reconstruction\';

load([save_path 'Mesh\Mesh_rods_Rat_055']);
% pos = dlmread([path 'electrodes_for_depth_3mm.txt']);
% pos = pos/1000;
load([save_path 'pos_depth']);
pos_depth = pos;
load([save_path 'pos_cortex']);
pos_cortex = pos;
pos = [pos_depth;pos_cortex];

load([save_path 'Protocol_Rat_055_cortex_map']);

mname = 'mesh_Rat_055_cortex';

[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

%Reference electrode
pos(end+1,:) = [14.55,9.524,8.227]/1000;

%Compute ground position
%For general but in our case rat mesh has annoying extra bit
% y_gnd=min(Mesh.Nodes(:,2));
% x_gnd=Mesh.Nodes(Mesh.Nodes(:,2)==y_gnd,1);
% z_gnd=Mesh.Nodes(Mesh.Nodes(:,2)==y_gnd,2);
% x_gnd=x_gnd(1);
% z_gnd=y_gnd(end);
% gnd_pos = [x_gnd,y_gnd,z_gnd];

gnd_pos = [0.01662,0.008835,0.03113];

%Assign conductivity values
sigma=ones(length(Mesh.Tetra),1);
sigma(Mesh.Tetra(:,5)==1)= 1.75; 
sigma(Mesh.Tetra(:,5)==2)= 0.15; 
sigma(Mesh.Tetra(:,5)==3)= 0.3;
sigma(Mesh.Tetra(:,5)==4)= 0.03;

Protocol = Prot_map;
%Write protocol file
m = length(pos)-1;
n = 0;
rm = [];
for iPrt = 1:size(Protocol,1)
    for iR = 1:m
        prt(iR+n*m,1) = Protocol(iPrt,1);
        prt(iR+n*m,2) = Protocol(iPrt,2);
        prt(iR+n*m,3) = iR;
        prt(iR+n*m,4) = m+1;
        if ismember(iR,Protocol(iPrt,:))
            rm = [rm; iR+n*m];
        end
    end
    n=n+1;
end

keep = setdiff([1:length(prt)], rm);
save([save_path 'keep'], 'keep');

fid=fopen([save_path 'protocol_' mname], 'w');
fprintf(fid, '%d,%d,%d,%d\n',[prt(:,1),prt(:,2),prt(:,3),prt(:,4)]');
fclose(fid);


fid=fopen([save_path 'electrode_diameters_' mname], 'w');
fprintf(fid,'%d\n', 0.1*ones((length(pos)-1),1));
fprintf(fid,'%d\n', 4);
fclose(fid);

fid=fopen([save_path 'electrode_positions_' mname], 'w');
fprintf(fid,'%d,%d,%d\n', [pos(:,1), pos(:,2), pos(:,3)]');
fclose(fid);



dune_exporter(Mesh.Nodes(:,1:3), Mesh.Tetra(:,1:4),sigma, save_path, [mname '.dgf'], pos, gnd_pos, 'true');







