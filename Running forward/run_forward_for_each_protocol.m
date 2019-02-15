forward_settings.path = '/home/mayo/PEITS_root/PEITS/';
saving.path = '/home/mayo/Documents/Rat_055/';
output.path = '/home/mayo/PEITS_root/PEITS/output/Rat_055_depth/';
mesh.path = '/home/mayo/Documents/Rat_055/';

load([mesh.path 'Mesh_rods_Rat_055_hex_200um_depth.mat']);
%If you are adding perturbations for simulations
%load([mesh.path 'dS.mat']);

fname = dir([forward_settings.path, 'data', filesep, 'electrode_nodes_mesh_Rat_055*']);
fname = {fname.name};
nFiles = length(fname);

for iFile = 1:nFiles
    tic
    %update parameter file with new protocol
    movefile([forward_settings.path, 'data',filesep,'parameter'],[forward_settings.path, 'data',filesep,'parameter~']);
    oldfile_param = fopen([forward_settings.path, 'data',filesep,'parameter~'], 'r');
    newfile_param = fopen([forward_settings.path, 'data',filesep,'parameter'], 'w');
    
    tline=fgetl(oldfile_param);
    while ischar(tline)
   
        if strfind(tline, 'current.protocol:')
            fprintf(newfile_param, '%s\n', ['current.protocol: ../data/protocol_mesh_Rat_055_prt',num2str(iFile)]);
            tline=fgetl(oldfile_param);
        continue
        end
    
 	fprintf(newfile_param, '%s\n', tline);
    tline=fgetl(oldfile_param);
    end

    % close both files
    fclose(oldfile_param);
    fclose(newfile_param);
    
    %%updat mesh parameter file with new node assignment
    movefile([forward_settings.path, 'data',filesep,'param_mesh_Rat_055'],[forward_settings.path, 'data',filesep,'param_mesh_Rat_055~']);
    oldfile_param_mesh = fopen([forward_settings.path, 'data',filesep,'param_mesh_Rat_055~'], 'r');
    newfile_param_mesh = fopen([forward_settings.path, 'data',filesep,'param_mesh_Rat_055'], 'w');
    
    tline=fgetl(oldfile_param_mesh);
    while ischar(tline)
   
        if strfind(tline, 'electrode.positions:')
            fprintf(newfile_param_mesh, '%s\n', ['electrode.positions: ../data/electrode_positions_mesh_Rat_055_prt',num2str(iFile)]);
            tline=fgetl(oldfile_param_mesh);
        continue
        end
        
        if strfind(tline, 'electrode.nodes:')
            fprintf(newfile_param_mesh, '%s\n', ['electrode.nodes: ../data/electrode_nodes_mesh_Rat_055_prt',num2str(iFile)]);
            tline=fgetl(oldfile_param_mesh);
        continue
        end
    
 	fprintf(newfile_param_mesh, '%s\n', tline);
    tline=fgetl(oldfile_param_mesh);
    end

    % close both files
    fclose(oldfile_param_mesh);
    fclose(newfile_param_mesh);
    
    [status,cmout] = system(['mpirun -np ', num2str(1), ' ', forward_settings.path, 'src/dune_peits']);
% %     
    disp(['Finished forward for protocol ', num2str(iFile)]);
%     
    b = dir([output.path,'electrodevoltages*.bin']);
    [~,index] = max([b.datenum]);
    BV_temp = load_electrode_voltages_binary([output.path,b(index).name]);
    %BV_temp = load_electrode_voltages_binary([output.path,b(iFile).name]);
    
    d = dir([output.path,'sigmavector*.bin']);
    [~,index] = max([d.datenum]);
    id = load_sigma_vector_binary([output.path,d(index).name]);
  %  id = load_sigma_vector_binary([output.path,d(iFile).name]);
% %     
    j = dir([output.path,'jacobian*.bin']);
   [~,index] = max([j.datenum]);
    [J_hex_temp] = load_jacobian_binary_in_steps([output.path,j(index).name], id, Mesh_hex);
   %[J_hex_temp] = load_jacobian_binary_in_steps([output.path,j(iFile).name], id, Mesh_hex);
   
   %If you are doing simulations
    %[J_hex_temp,dV_temp] = load_jacobian_binary_in_steps_and_BVpert([output.path,j(iFile).name], id, Mesh_hex, dS);
%     
    load([saving.path 'prt' num2str(iFile) '_inj_idx.mat']);
    n_elec = 79;
%     
    BV = zeros(n_elec,1);
    BV(elec_idx) = BV_temp;
% %     
% When doing multiple simulations
%       dV = zeros(n_elec,size(dS,2));
%       dV(elec_idx,:) = dV_temp;
%     
     J_hex = zeros(n_elec, size(J_hex_temp,2));
     J_hex(elec_idx,:) = J_hex_temp;
%     
%     rm = sort([setdiff([1:n_elec],elec_idx),inj]);
%     keep = setdiff([1:n_elec],rm);
%     
    save([saving.path 'BV_prt' num2str(iFile)], 'BV', '-v7.3');
    %save([saving.path 'dV_prt' num2str(iFile)], 'dV', '-v7.3');
    save([saving.path 'J_hex_200_prt' num2str(iFile)], 'J_hex', '-v7.3');
    %save([saving.path 'keep_prt' num2str(iFile)], 'rm', 'keep', '-v7.3');   
    toc
    
    clear J_hex_temp BV_temp J_hex BV rm keep dV_temp dV
end
    
    
    
    
    
    
    
    
    
    
    
    

    
    