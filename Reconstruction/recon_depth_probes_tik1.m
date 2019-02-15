type = 2;

%%
%%For simulation

if type ==1 
load('J_hex_200um_all_depth');
load('BV_all_depth');
BV0 = BV;
load('BV1_all_depth');
BV1 = BV;
load('Mesh_rods_Rat_055_hex_200um_depth');
element_size=200e-6;
load('EIT_depth_data', 'dZ_filt', 'T_filt', 'keep');

kd = [];
for i = 1:40
    ke = [1:32] +(i-1)*79;
    kd = [kd,ke];
end


J = J_hex(kd,:);
J = J(keep,:);

dV = BV1 - BV0;
dZ = dV(kd);
dZ = dZ(keep);



end

%%
%%For Depth alone
if type == 2
    
load('J_hex_200um_all_depth');
load('BV_all_depth');
load('Mesh_rods_Rat_055_hex_200um_depth');
element_size=200e-6;
load('EIT_Rat_055_depth_data', 'dZ_filt', 'T_filt', 'keep', 'BV_sorted');

kd = [];
for i = 1:40
    ke = [1:32] +(i-1)*79;
    kd = [kd,ke];
end

% idx = find(keep > 28*32);
% keep = keep(idx);
% keep2 = keep - (28*32);

J = J_hex(kd,:);
BV = BV(kd);

dZ = dZ_filt';
T = T_filt;

interval = find(T_filt>0 & T_filt<60);
 noise_interval = find(T>-400 & T<-250);
% 
 Noise = 1e-6*dZ(noise_interval,keep);
dZ = 1e-6*dZ(interval,keep);

% for i = 1:100
%      Noise(:,i) = 1e-6*randn(size(keep(:)));%+ BV0.*((mult/100)*rand(size(BV)));
% end
% Noise = Noise';

J = J(keep,:);
BV0 = BV(keep);

dZ(:,BV0<0) = -dZ(:,BV0<0);
Noise(:,BV0<0) = -Noise(:,BV0<0);

% 
% BV_exp = BV_sorted((keep));
% idx1 = find(BV0>1e-3);
% 
% idx2 = find(BV_exp>1e3);
%  idx = [idx1;idx2];
%  idx = unique(idx);
%  
%   dZ = dZ(:,idx);
%  J = J(idx,:);
%  Noise = Noise(:,idx);




end

%%
%%For Cortex alone
if type == 3
    
kc = [];
for i = 1:30
    ke = [33:79] +(i-1)*79;
    kc = [kc,ke];
end

load('J_hex_200um_cortex', 'J_hex');
J = J_hex(kc,:);

load('BV_cortex', 'BV');
BV = BV(kc,:);

load('EIT_Rat_055_cortex_data', 'dZ_filt', 'T_filt', 'keep');

load('Mesh_rods_Rat_055_hex_200um_cortex');
element_size=200e-6;




dZ = dZ_filt';
T = T_filt;

interval = find(T_filt>0 & T_filt<60);
noise_interval = find(T>-400 & T<-250);

Noise = 1e-6*dZ(noise_interval,keep);
dZ = 1e-6*dZ(interval,keep);

J = J(keep,:);
BV0 = BV(keep);

dZ(:,BV0<0) = -dZ(:,BV0<0);
Noise(:,BV0<0) = -Noise(:,BV0<0);



% BV_exp = BV_sorted((keep));
% idx1 = find(BV0>1e-3);
% 
% idx2 = find(BV_exp>1e3);
%  idx = [idx1;idx2];
%  idx = unique(idx);
%  
%   dZ = dZ(:,idx);
%  J = J(idx,:);
%  Noise = Noise(:,idx);



end
%% recon for ST

xyz = (Mesh_hex.Nodes(Mesh_hex.Hex(:,1),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,2),:) + ... 
    Mesh_hex.Nodes(Mesh_hex.Hex(:,3),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,4),:) + ... 
    Mesh_hex.Nodes(Mesh_hex.Hex(:,5),:) + Mesh_hex.Nodes(Mesh_hex.Hex(:,6),:))./6; %divide by 6 if HEX-mesh is in metres

L = gen_Laplacian_matrix(xyz,element_size);
disp('Laplacian Done');

% do the GSVD
[U,sm,X,~,~] = cgsvd(J,L);
disp('GSVD Done');
%%
% my lambda is usually: logspace(-15,10,3000)
% and I use either lambda(1300) or lambda(1400) for the reconstructions
% % once you have the GSVD you can do all reconstructions just with this one line




    
lambda_vec=logspace(-15,10,3000);   
[x_lambda,rho,eta] = tikhonov(U,sm,X,dZ(32,:)',lambda_vec);

%%

%lambda = lambda_vec(1150);

for iRecon = 1:size(Noise,1)
lambda_vec = logspace(-8,1,1000);

lambda = lambda_vec(590);
% 
%[X_recon{iRecon},rho{iRecon},eta{iRecon}] = tikhonov(U,sm,X,dZ(iRecon,:)',lambda_vec); % lambda can be single value or vector
[SD_recon(:,iRecon),rho,eta] = tikhonov(U,sm,X,Noise(iRecon,:)',lambda);
disp(['Recon done for ' num2str(iRecon)]);

end
SD = std(SD_recon,0,2);


for iRecon = 1:size(dZ,1)

lambda_vec=logspace(-8,1,1000);
lambda = lambda_vec(590);
% 
%[X_recon{iRecon},rho{iRecon},eta{iRecon}] = tikhonov(U,sm,X,dZ(iRecon,:)',lambda_vec); % lambda can be single value or vector
[X_recon(:,iRecon),rho,eta] = tikhonov(U,sm,X,dZ(iRecon,:)',lambda);
disp(['Recon done for ' num2str(iRecon)]);

end

save('recon_Rat_055_depth_tik1', 'x_lambda', 'X_recon', 'SD_recon', 'lambda', 'lambda_vec', '-v7.3');


% 

