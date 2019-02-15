load('D:\Rat_055\Reconstruction\Mesh\Mesh_rods_Rat_055.mat');
%Actual coordinates of electrodes pfrom experiments
act_pos = [1.5,7.8,2.89;
           1.38,7.8,1.87;
           1.18,7.8,0.69]*1e-3;

%Take away bregma from everything so that bregma is (0,0) in ML and AP
AP = 0.02748; %%%z
AP = AP - 5.3e-3;
ML = 0.01658; %%%x

Mesh.Nodes(:,1) = Mesh.Nodes(:,1) - ML;
Mesh.Nodes(:,3) = Mesh.Nodes(:,3) - AP;

vtx = Mesh.Nodes(:,1:3);
srf = dubs3_2(Mesh.Tetra(:,1:4));
cnts = (vtx(srf(:,1),:) + vtx(srf(:,2),:) + vtx(srf(:,3),:))/3;
eps=mean((sum((vtx(srf(:,1),:)-vtx(srf(:,2),:)).^2,2)).^0.5)*0.8;

D = 0.5e-3;
hole_distance_x = 1.13e-3;
hole_distance_y = 1.2e-3;

      
        
%In case the location you have is not the centre
% act_pos(:,1) = act_pos(:,1) + 0.25e-3;
% act_pos(:,3) = act_pos(:,3) + 0.25e-3;
        

first = act_pos(1,:);
       
%Define vector along axis of electrode       
v1 = [act_pos(3,1) - act_pos(2,1), 7.8/1000, act_pos(3,3) - act_pos(2,3)];
%v1 = [act_pos(2,1) - act_pos(1,1), 7.8/1000, act_pos(2,3) - act_pos(1,3)];
%Define vector from surface to bottom of brain
v2 = [0, 20/1000,0];

%Find vector orthogonal, i.e vector that will describe plane in direction
%of electrode
C = cross(v1,v2);
%Make plane pass through location of first known electrode
o = dot(first,C);

%Find distance from all points to plane
for i = 1:length(cnts)
    dist(i) = abs(C(1)*cnts(i,1) + C(2)*cnts(i,2) + C(3)*cnts(i,3) - o)/norm(C);
end

%Only keep elements that are within distance eps from plane
p = find(dist<eps);
sel = cnts(p,:);

%Define first electrode position on surface of mesh
dist=(sum((sel-repmat(first,length(sel),1)).^2,2)).^0.5;
[~,p]=min(dist);

first = sel(p,:);

%% ONLY if first electrode is actually first electrode
electrodes(1,:) = first;
n = 2;
next = first;

%Otherwise find its position (as don't have coordinate for first electrode
%by numbering find this first)
% dist=(sum((sel-repmat(next,size(sel,1),1)).^2,2)).^0.5;
% p=find(dist>hole_distance_x-eps & dist<hole_distance_x+eps & sel(:,3)>next(3));
% next=sel(p,:);
% next=mean(next,1);
% electrodes(1,:)=next;
% n = 2;

%Find remaining electrodes in first row by finding elements seperated by
%hole_distance_x
while(n<5)
    dist=(sum((sel-repmat(next,size(sel,1),1)).^2,2)).^0.5;
    p=find(dist>hole_distance_x-eps & dist<hole_distance_x+eps & sel(:,3)<next(3));

    next=sel(p,:);
    next=mean(next,1);
    electrodes(n,:)=next;
    n=n+1;
end


%Find vector orthogonal to initial plane, therefore define plane for search direction along
%each column
C2 = cross(C,v2);

% Number of electrodes in each rows
rows = [5,6,7,2];
    
% For each AP position place electrodes in ML direction
for ielec = 1:length(electrodes)
    
    %Make plane pass through position of each electrode
    o2 = dot(electrodes(ielec,:),C2);
     
    %Find plane
     for i = 1:length(cnts)
          dist(i) = abs(C2(1)*cnts(i,1) + C2(2)*cnts(i,2) + C2(3)*cnts(i,3)-o2)/norm(C2);
     end
           
     p=find(dist<eps);
     sel=cnts(p,:);
     next = electrodes(ielec,:);
     next=mean(next,1);
     first = next;
     
     %Now find electrodes that are seperated by hole_distance_y along plane
     %direction
     n = 2;
     elec{ielec}(1,:) = next;
     while(n<rows(ielec)+1)
           dist=(sum((sel-repmat(next,size(sel,1),1)).^2,2)).^0.5;
           p=find(dist>hole_distance_y-eps & dist<hole_distance_y+eps & sel(:,1)>next(1));
           next=sel(p,:);
           next=mean(next,1);
           elec{ielec}(n,:) = next;
           n = n+1;
      end
           
end

    electro_L = cell2mat(elec');     
    %%
    srf_el_L = [];
    for i = 1:length(electro_L)
        dist = (sum((cnts-repmat(electro_L(i,:),size(cnts,1),1)).^2,2)).^0.5;
        srf_elec = find(dist < (ones(length(cnts),1))*D/2);

        srf_el_L = [srf_el_L; srf_elec];
    end

    pos_L = electro_L;
    
    srf_el = srf_el_L;


figure, title('electrodes');
    trimesh(srf,vtx(:,1),vtx(:,2),vtx(:,3));
    colormap([0 0 0]);
    daspect([1 1 1]);

    hold on;
    axis image;
    set(gcf,'Colormap',[0.6 0.7 0.9]);

    grid off
    view(3);
    
    for u = 1:size(srf_el)
    paint_electrodes(srf_el(u),srf,vtx);
    end
  

pos2(:,1) = pos_L(:,1) + ML;
pos2(:,3) = pos_L(:,3) + AP;

save('cotical_pos2', 'pos2', '-v7.3');

