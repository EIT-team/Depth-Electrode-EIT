mname = 'Rat_055';

Nodes = csvread(['Mesh_' mname '_vertices.csv']);
Tetra = csvread(['Mesh_' mname '_tetra.csv']);
Mesh.Nodes = Nodes;
Mesh.Tetra = Tetra;

save(['Mesh_' mname], 'Mesh', '-v7.3');
writeVTKcell(['Mesh_' mname],  Mesh.Tetra(:,1:4), Mesh.Nodes, Mesh.Tetra(:,5));