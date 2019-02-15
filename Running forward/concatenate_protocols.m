saving.path = '/home/mayo/Documents/Rat_055/';

fname = dir([saving.path, 'BV_prt*']);
fname = {fname.name};
nFiles = length(fname);

BV_all = [];
J_hex_all = [];
dV_all = [];
keep_all = [];



for iFile = 1:nFiles
   load([saving.path 'BV_prt' num2str(iFile)]);
   load([saving.path 'J_hex_200_prt' num2str(iFile)]);
    %load([saving.path 'dV_prt' num2str(iFile)]);
    %load([saving.path 'keep_prt' num2str(iFile)]);
    
    
    BV_all = [BV_all;BV];
    J_hex_all = [J_hex_all; J_hex];
    %dV_all = [dV_all; dV];
    %keep_all = [keep_all,keep];
    
    clear BV J_hex dV keep;
end
% 
 J_hex = J_hex_all;
BV = BV_all;
%dV = dV_all;
 %keep = keep_all;
% 
 save([saving.path 'J_hex_200um_all_depth'], 'J_hex', '-v7.3');
save([saving.path 'BV_all_depth'], 'BV', '-v7.3');
%save([saving.path 'dV_all'], 'dV', '-v7.3');
%save([saving.path 'keep_all_depth'], 'keep', '-v7.3');
