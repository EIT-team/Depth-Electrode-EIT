type = 1;
    
%% Depth Alone
if type == 1

kd = [];
for i = 1:40
    ke = [1:32] +(i-1)*79;
    kd = [kd,ke];
end

load('J_hex_110um_all_depth', 'J_hex');
J_hex = J_hex(kd,:);

load('BV_all_depth', 'BV');
BV = BV(kd,:);

load('EIT_Rat_055_depth_data', 'dZ_filt', 'T_filt', 'keep', 'BV_sorted');
 
end

%% Cortex Alone
if type == 2

kc = [];
for i = 1:40
    ke = [33:79] +(i-1)*79;
    kc = [kc,ke];
end

load('J_hex_110um_cortex', 'J_hex');
J_hex = J_hex(kc,:);

load('BV_cortex', 'BV');
BV = BV(kc,:);

load('EIT_Rat_055_cortex_data', 'dZ_filt', 'T_filt', 'keep', 'BV_sorted');
 
end

%% Depth followed by Cortex
if type == 3
kd = [];
for i = 1:40
    ke = [1:32] +(i-1)*79;
    kd = [kd,ke];
end

kc = [];
for i = 1:40
    ke = [33:79] +(i-1)*79;
    kc = [kc,ke];
end

load('J_hex_110um_all_depth', 'J_hex');
J_hex_d = J_hex(kd,:);

load('J_hex_110um_cortex', 'J_hex');
J_hex_c = J_hex(kc,:);

J_hex = [J_hex_d; J_hex_c];

load('BV_all_depth', 'BV');
BV_d = BV(kd,:);

load('BV_cortex', 'BV');
BV_c = BV(kc,:);

BV = [BV_d; BV_c];

load('EIT_Rat_055_depth_data', 'dZ_filt', 'T_filt', 'keep');
dZ_filt_d = dZ_filt;
keep_d = keep;

load('EIT_Rat_055_cortex_data', 'dZ_filt', 'keep');
dZ_filt_c = dZ_filt;
keep_c = keep;

dZ_filt = [dZ_filt_d;dZ_filt_c];
keep = [keep_d;(keep_c + size(dZ_filt_d,1))];
 
end


%% Depth and Cortex Together
if type == 4
load('J_hex_110um_all_depth', 'J_hex');
J_hex_d = J_hex;


load('J_hex_110um_cortex', 'J_hex');
J_hex_c = J_hex;

J_hex = [J_hex_d + J_hex_c];

load('BV_all_depth', 'BV');
BV_d = BV;

load('BV_cortex', 'BV');
BV_c = BV;

BV = BV_d + BV_c;

load('EIT_Rat_055_all_data', 'dZ_filt_all', 'T_filt' ,'keep_all');

keep = keep_all;
dZ_filt = dZ_filt_all;

end

%%

J = J_hex;

dZ = dZ_filt';
T = T_filt;
interval = find(T_filt>0 & T_filt<60);
noise_interval = find(T>-400 & T<-200);   

Noise = 1e-6*dZ(noise_interval,keep);
dZ  = 1e-6*dZ(interval,keep(:));

 J = J(keep(:),:);


BV0=BV(keep(:));
%BV0 = BV;
    
% plot(dZ)
% drawnow;
dZ(:,BV0<0) = -dZ(:,BV0<0);
Noise(:,BV0<0) = -Noise(:,BV0<0);

    
plot(dZ)
drawnow;

 
%%
n_T = size(dZ,1);
n_N = size(Noise,1);
n_J = size(J,1);
x=dZ;
y=Noise;

%%
tic
[U,S,V] = svd(J,'econ');
disp(sprintf('SVD done: %.2f min.',toc/60))
% lambda = logspace(-10,4,4000);
lambda = logspace(-16,-2,4000);
%   val = 3000;
%   lambda = lambda(val);

[X,cv_error] = tikhonov_CV(J,x',lambda,n_J,U,S,V);
disp(sprintf('X done: %.2f min.',toc/60))

UtNoise = U'*y';
sv = diag(S);
% 
% opt = zeros(size(cv_error,2),1);
% for i=1:size(cv_error,2)
%      e = cv_error(:,i);
%      f = (e(1:end-2)>=e(2:end-1))&(e(3:end)>e(2:end-1));
%      %if any(f)
%          %opt(i) = find(f,1,'last')+1;
%      %else
%          [m,opt(i)] = min(e);
%      %end
% end

opt = zeros(size(cv_error,2),1);
for i=1:size(cv_error,2)
    e = cv_error(:,i);
    f = (e(1:end-2)>=e(2:end-1))&(e(3:end)>e(2:end-1));
    nf = size(find(f),1);
    if any(f)
        val = find(f);
        [~,idx] = min(e(val));
        opt(i) = val(idx);
    else
        [m,opt(i)] = min(e);
    end
end
    
% 
%     
% %Finds the standard deviation of all time points and reconstructs the
% %conductivity at the lamba at each time point in interval
% %N.B. the size of noise interval only influences the number considered
% %in the std
%%
SD = zeros(size(X));
for i=1:size(SD,2)
     sv_i = sv+lambda(opt(i))./sv;
     SD(:,i) = std(V*(diag(1./sv_i)*UtNoise),0,2);
     disp(num2str([i,toc/60]))
end

save(['recon_Rat_055_depth_tik0.mat'],'X','cv_error','lambda','SD','interval', 'opt','val','-v7.3');
   

