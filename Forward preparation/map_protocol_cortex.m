%%
load('Protocol_Rat_055_cortex.mat')
load('injection_map_cortex.mat');

for i = 1:size(Protocol,1)
for j = 1:size(Protocol,2)
    Prot_map(i,j) = find(Protocol(i,j) == map);
end
end

Prot_map = Prot_map + 32;

save('Protocol_Rat_055_cortex_map', 'Prot_map', '-v7.3');
