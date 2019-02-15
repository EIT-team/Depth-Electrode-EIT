%Make electrode positions according to how they are in experiments. 1-16 is
%first electrode closer to bregma. 17-32 is second eletrode further away
%from bregma but also flipped to reflect actual arrangement in brain
%ELECTRODE CLOSEST TO BREGMA                 ELECTRODE FURTHER FROM BREGMA
% 1   5   9   13                             29  25  21  17
% 2   6   10  14                             30  26  22  18
% 3   7   11  15                             31  27  23  19
% 4   8   12  16                             32  28  24  20

load('F:\Users\Mayo\Documents\Mesh\Rat Mesh\Mesh_tetra.mat');

%N.B ML and AP of most medial anterior probe
exp_ML = 1.95;
exp_DV = 7;
exp_DV_surf = exp_DV - 1.5 - 0.4; %assuming skull thickness of 0.4 mm and distance from tip to middle of first electrode is 1.5mm 
exp_AP = -2.16;

%These are ML and AP location of bregma in Mesh_tetra
AP = 0.02748; %%%z
AP = AP - 5.3e-3;
ML = 0.01658; %%%x

Mesh.Nodes(:,1) = Mesh.Nodes(:,1) - ML;
Mesh.Nodes(:,3) = Mesh.Nodes(:,3) - AP;

vtx = Mesh.Nodes(:,1:3);
srf = dubs3_2(Mesh.Tetra(:,1:4));
cnts = (vtx(srf(:,1),:) + vtx(srf(:,2),:) + vtx(srf(:,3),:))/3;


first = [exp_ML,7.8,exp_DV]/1000;
dist=(sum((cnts-repmat(first,length(cnts),1)).^2,2)).^0.5;
[~,p]=min(dist);

surf_elec = cnts(p,:);

DV_elec = surf_elec(2) + exp_DV_surf/1000; 
ML_elec = first(1);
AP_elec = first(3);


elec1 = [ML_elec,DV_elec,AP_elec];
elec2 = [elec1(1) + 1500e-6,elec1(2), elec1(3) - 3000e-6];

n = 1;
for iC = 1:4
    for iR = 1:4
        el_pos1(n,:) = [elec1(1)+(iC-1)*500e-6, elec1(2)+ (iR-1)*400e-6, elec1(3)];
        el_pos2(n,:) = [elec2(1)-(iC-1)*500e-6, elec2(2)+ (iR-1)*400e-6, elec2(3)];
        n = n+1;
    end
end

pos = [el_pos1;el_pos2];

pos_exp = pos;
pos_exp(:,1) = pos(:,1) + ML;
pos_exp(:,3) = pos(:,3) + AP;


%shift the posterior probe by 0.5 mm due to misalignment in holder in
%Rat_055
pos_exp(17:32,1) = pos_exp(17:32,1) + 0.5e-3;
pos(17:32,1) = pos(17:32,1) + 0.5e-3;

dlmwrite('electrodes_for_depth_Rat_055_3mm.txt', pos_exp);


%%
%%create loads of positions for mesher
pos = pos_exp*1000;


pos_all = [];
for iShank = 1:8
%     max_depth = pos(1,2)+200e-3;
%     min_depth = pos(4,2)-200e-3;
    
    max_depth = pos(4,2)+200e-3;
    min_depth = pos(1,2)-200e-3;
    step = (max_depth-min_depth)/100;
    
    depth_steps = [min_depth:step:max_depth];
    
    for iD = 1:length(depth_steps)    
    pos_temp(iD,:) = [pos(1+(iShank-1)*4,1), depth_steps(iD), pos(1+(iShank-1)*4,3)];
    end
    
    pos_all = [pos_all;pos_temp];
end

% pos_all(:,1) = pos_all(:,1) + ML*1000;
% pos_all(:,3) = pos_all(:,3) + AP*1000;

dlmwrite('electrodes_for_depth_Rat_055_3mm_small_intervals.txt', pos_all);




