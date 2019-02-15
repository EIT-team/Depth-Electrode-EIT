load('Mesh_Rat_055');
pos = dlmread('electrodes_for_depth_Rat_055_3mm.txt');
mname = 'Rat_055';

cnts = zeros(size(Mesh.Tetra,1),3);
for i = 1:4
    cnts = cnts+Mesh.Nodes(Mesh.Tetra(:,i),1:3)/4;
end

%Define new mesh as we will remove the tetra that are part of the rod
Mesh_new = Mesh;

%Define the electrodes that belong to each shank
rod{1} = [1:4];
rod{2} = [5:8];
rod{3} = [9:12];
rod{4} = [13:16];
rod{5} = [17:20];
rod{6} = [21:24];
rod{7} = [25:28];
rod{8} = [29:32];

%Height of column around electrode that you sweep
delta = 150e-6;
%Radius of column around electrode that you sweep 
%This should be the radius of the shank
radius = 30e-6;
radius_AP = 50e-6;
radius_ML = 50e-6;


for iR = 1:length(rod)
    r = rod{iR};
    
    for iEl = 1:length(r) - 1
        
        axis = [pos(r(iEl),:);pos(r(iEl+1),:)];
        %Find the vector between two adjacent electrodes on rod
        dist = axis(2,:) - axis(1,:);
        %Find abs distance plus the extra delta that you want to sweep
        dist = 2*delta+sum(dist.^2).^0.5;
        %Number of steps along axis that you take
        sweep = round(dist/(radius/2))+1;
        
        for iS =1:sweep 
                u = axis(2,:)-axis(1,:);
                %Norm vector to define the direction you want to move in
                u = u/sum(u.^2).^0.5;
                %New centre position that you want to sweep around
                %Start from delta below the first electrode and go up to
                %delta above the second electrode
                cent = axis(1,:)-delta*u + iS*(axis(2,:)-axis(1,:)+2*delta*u)/sweep;
                %Find distance between centre of all tetra and the cent
                %position we are examining
                sp = cnts-repmat(cent,size(cnts,1),1);
                %sp = sum(sp.^2,2);
                
                sign_AP = sign(sp(:,3));
                sp = sp.^2;
                if iR <=4
                    rm = find(sp(:,1)<radius_ML^2 & sp(:,2) < radius_ML^2 & sp(:,3) < radius_AP^2 & sign_AP > 0);
                else
                    rm = find(sp(:,1)<radius_ML^2 & sp(:,2) < radius_ML^2 & sp(:,3) < radius_AP^2 & sign_AP < 0);
                end
                 
             
                %Remove all tetra that have centres within radius of the
                %position we are looking in as these will be part of the
                %shank
                %Mesh_new.Tetra(sp<radius^2,:)=[];
                Mesh_new.Tetra(rm,:)=[];
                %Remove also from cnts
                %cnts(sp<radius^2,:)=[];
                cnts(rm,:)=[];
               
        end
    end
        disp(['Finished rod ' num2str(iR) ' of ' num2str(length(rod)) ' rods'])
end
    
        
    %Mesh without rods
    writeVTKcell(['Mesh_rods_' mname],Mesh_new.Tetra(:,1:4),Mesh_new.Nodes(:,1:3),Mesh_new.Tetra(:,5));
 
    %The removed rods
    [~,rods] = setdiff(Mesh.Tetra, Mesh_new.Tetra, 'rows');
    writeVTKcell(['rods_' mname],Mesh.Tetra(rods,1:4),Mesh.Nodes(:,1:3),Mesh.Tetra(rods,5));
    
    Mesh = Mesh_new;
    save(['Mesh_rods_' mname],'Mesh');
    
    
    
        
        
        
    





