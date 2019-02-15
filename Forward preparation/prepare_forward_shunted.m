path = 'D:\Rat_055\Reconstruction\Mesh\';
save_path = 'D:\Rat_055\Reconstruction\Mesh\';

%load([path 'Mesh_square_rods']);
load([path 'Mesh_rods_Rat_055']);

mname = 'mesh_Rat_055';

[Mesh.Nodes,Mesh.Tetra]=removeisolatednode(Mesh.Nodes(:,1:3),Mesh.Tetra);

gnd_pos = [0.01662,0.008835,0.03113];

%Assign conductivity values
sigma=ones(length(Mesh.Tetra),1);
sigma(Mesh.Tetra(:,5)==1)= 1.75; 
sigma(Mesh.Tetra(:,5)==2)= 0.15; 
sigma(Mesh.Tetra(:,5)==3)= 0.3;
sigma(Mesh.Tetra(:,5)==4)= 0.03;

dune_exporter(Mesh.Nodes(:,1:3), Mesh.Tetra(:,1:4),sigma, save_path, [mname '.dgf'], [], gnd_pos, 'true');
%%

fname = dir([save_path 'pos_prt*.mat']);
fname = {fname.name};
nFiles = length(fname);

for iFile = 1:nFiles
    load([save_path 'pos_prt' num2str(iFile)]);
    load([save_path 'prt' num2str(iFile) '_inj_idx']);


%Reference electrode
elec_pos(end+1,:) = [14.55,9.524,8.227]/1000;

%Write protocol file
m = length(elec_pos)-1;
n = 0;
rm = [];
    for iR = 1:m
        prt(iR+n*m,1) = inj_fwd2(1);
        prt(iR+n*m,2) = inj_fwd2(2);
        prt(iR+n*m,3) = iR;
        prt(iR+n*m,4) = m+1;
    end


fid=fopen([save_path 'protocol_' mname '_prt' num2str(iFile)], 'w');
fprintf(fid, '%d,%d,%d,%d\n',[prt(:,1),prt(:,2),prt(:,3),prt(:,4)]');
fclose(fid);
% 
fid=fopen([save_path 'electrode_diameters_' mname], 'w');
fprintf(fid,'%d\n', 0.1*ones((length(elec_pos)-1),1));
fprintf(fid,'%d\n', 4);
fclose(fid);
% 
fid=fopen([save_path 'electrode_positions_' mname '_prt' num2str(iFile)], 'w');
fprintf(fid,'%d,%d,%d\n', [elec_pos(:,1), elec_pos(:,2), elec_pos(:,3)]');
fclose(fid);
end










