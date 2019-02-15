load('cortical_pos1.mat');
load('cortical_pos2.mat');

pos = [pos2;pos1];

save('pos_cortex', 'pos', '-v7.3');
