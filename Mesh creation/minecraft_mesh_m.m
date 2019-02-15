function [Mesh_hex,k]=minecraft_mesh_m(Mesh_file,d,is_write_vtk)
% - Mesh_file = string with file of the mesh with Mesh.Tetra, Mesh.Nodes (in mm),
%   Mesh.mat (does not work at the moment), ex: 'Mesh.mat' 
% - d = size of the hex in mm
% - is_write_vtk, writes vtk if you want it with resulting counts of the
%   tetra in each hex


load(Mesh_file); %% Load fine tetrahedral mesh. Mesh.Tetra, Mesh.Nodes (in mm), Mesh.mat (does not work at the moment)
Mesh.Nodes=Mesh.Nodes(:,1:3)*1000;
%d=0.1; % size of the hex in mm

%--------- compute centres of all elements
cnts=(Mesh.Nodes(Mesh.Tetra(:,1),:)+Mesh.Nodes(Mesh.Tetra(:,2),:)+Mesh.Nodes(Mesh.Tetra(:,3),:)+Mesh.Nodes(Mesh.Tetra(:,4),:))./4;

%el_length =((Mesh.Nodes(Mesh.Tetra(:,1),:)-Mesh.Nodes(Mesh.Tetra(:,2),:)) + (Mesh.Nodes(Mesh.Tetra(:,1),:)-Mesh.Nodes(Mesh.Tetra(:,3),:)) + (Mesh.Nodes(Mesh.Tetra(:,1),:)-Mesh.Nodes(Mesh.Tetra(:,2),:)))/3;
%vol = sum(el_length.^2,2);
%--------- You can add a criteria for selectting here
%grey=Mesh.Tetra(Mesh.mat_ref==1,:); % material selection
%refine_cnt = [20,13.2,21];

%For Depth Probe tik1
%refine_cnt = [19.5,13.2,19.1];
%refine_cnt = [19.5,13.1,18.5];
% refine_cnt = [19.5,13.1,18.7];
% refine_ext = [2.5,2.6,2.5];


% %For Cortex tik1
refine_cnt = [21.5,9.8,20];
refine_ext = [3.5,2.6,4.5];

% %For tik0
% refine_cnt = [20,13.1,21];
% refine_ext = [4,6,5];

% %For Cortex tik1
refine_cnt = [21.5,9.8,20];
refine_ext = [3.5,2.6,4.5];


dist = cnts - repmat(refine_cnt, size(cnts,1),1);
ind_el = find(abs(dist(:,1)) < refine_ext(1) & abs(dist(:,2))<refine_ext(2) & abs(dist(:,3))<refine_ext(3));


%ind_vol = find(vol<0.5e-3);

%ind_el = setdiff(ind_ref,ind_vol);
%
% ind_el=find(cnts(:,3)>=14.5 & cnts(:,3)<27.5 & cnts(:,1)<=18 & cnts(:,2)
% <=17); % or geometrical selection
 grey=Mesh.Tetra(ind_el,:); 

%grey=Mesh.Tetra;
%ind_el=[1:length(Mesh.Tetra)];
g_cnts=(Mesh.Nodes(grey(:,1),:)+Mesh.Nodes(grey(:,2),:)+Mesh.Nodes(grey(:,3),:)+Mesh.Nodes(grey(:,4),:))./4;

%--------- Starting here with rounding the centres according to the hex
%size

Pnode=floor(g_cnts./d);

%--------- unique to find out all unique hex centres, and store the index
%to access the actual stuff
[Pcells, ~, ind]=unique(Pnode,'rows');  
n_e=size(Pcells,1);

%--------- You need to know this, right?
disp(['Number of hex = ' num2str(n_e)]);

%--------- Store the indeces of the tetra in each hex with cells, and count
%their occurence with k, just to be sure
cells=cell(n_e,1);
k=zeros(n_e,1);
mat =zeros(n_e,1);
for i=1:length(ind)
    cells{ind(i)}=[cells{ind(i)} ind_el(i)];
    k(ind(i))=k(ind(i))+1;
    mat(ind(i))= Mesh.Tetra(ind_el(i),5);
    if (mod(i,round(length(ind)/10))==0)
        disp (['processing:' num2str(round(100*i/length(ind))-5) '%' ]);
    end
end

%--------- This is all possible nodes
%node1=Pcells*d-repmat([0.5,0.5,0.5]*d,n_e,1);
node1=Pcells*d;
Nodes=[node1; ...
    node1+repmat([1,0,0]*d,n_e,1); ...
    node1+repmat([1,1,0]*d,n_e,1); ...
    node1+repmat([0,1,0]*d,n_e,1); ...
    node1+repmat([0,0,1]*d,n_e,1); ...
    node1+repmat([1,0,1]*d,n_e,1); ...
    node1+repmat([1,1,1]*d,n_e,1); ...
    node1+repmat([0,1,1]*d,n_e,1)];

%--------- Each hex will have 8 of them according to numbering in previous
%block
Hex =[(1:n_e)',(1:n_e)'+n_e,(1:n_e)'+n_e*2,(1:n_e)'+n_e*3,(1:n_e)'+n_e*4,(1:n_e)'+n_e*5,(1:n_e)'+n_e*6,(1:n_e)'+n_e*7];

%--------- But we only need unique nodes, we do not need duplicates, so
%fuck them
[Nodes,I,J]=unique(Nodes,'rows');
Hex=J(Hex);

%--------- If you need to check it



idx = find(mat == 4);
Hex(idx,:) = [];
cells(idx) = [];
mat(idx) = [];



Mesh_hex.Hex=Hex;
Mesh_hex.Nodes=Nodes;
Mesh_hex.cells=cells;
Mesh_hex.mat=mat;


if exist('is_write_vtk')
    writeVTKcell_hex([Mesh_file(1:end-4) '_hex_test'],Hex,Nodes/1000,mat,'material');
end


%--------- Saving your monster
save([Mesh_file(1:end-4) '_hex_' num2str(int32(d*1000)) 'um.mat'],'Mesh_hex'); %% Saving the Hex mesh
disp('done!');


