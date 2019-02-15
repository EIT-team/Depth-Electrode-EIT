load('Protocol_Rat_055_depth.mat')
Protocol(:,5:8) = Protocol(:,5:8)-16;

%%
load('injection_map_depth.mat');

for i = 1:size(Protocol,1)
    for j = 1:size(Protocol,2)
        Prot_map(i,j) = find(Protocol(i,j) == inj_map);
    end
end
%%

save('Protocol_Rat_055_depth_map', 'Prot_map', '-v7.3');





