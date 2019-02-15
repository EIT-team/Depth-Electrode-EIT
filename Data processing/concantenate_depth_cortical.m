%%
ndepth = 32;
ncortex = 47;
nPrt = 40;


load('EIT_Rat_055_depth_data.mat');
BV_sorted_d = BV_sorted;
dZ_filt_d = dZ_filt;
keep_d = keep;

load('EIT_Rat_055_cortex_data.mat');
BV_sorted_c = BV_sorted;
dZ_filt_c = dZ_filt;
keep_c = keep;

dZ_filt_all = [];
BV_all = [];
keep_all = [];

for iPrt = 1:nPrt
    dZ_add = dZ_filt_d(1+ndepth*(iPrt-1):ndepth*(iPrt),:);
    BV_add = BV_sorted_d(1+ndepth*(iPrt-1):ndepth*(iPrt));
    idx = find(keep_d >= 1+ndepth*(iPrt-1) & keep_d <= ndepth*(iPrt));
    keep_add = keep_d(idx) + ncortex*(iPrt-1);
    
    BV_all = [BV_all;BV_add];
    dZ_filt_all = [dZ_filt_all; dZ_add];
    keep_all = [keep_all; keep_add];
    
    clear dZ_add keep_add idx BV_add
    
    dZ_add = dZ_filt_c(1+ncortex*(iPrt-1):ncortex*(iPrt),:);
    BV_add = BV_sorted_c(1+ncortex*(iPrt-1):ncortex*(iPrt));
    idx = find(keep_c >= 1+ncortex*(iPrt-1) & keep_c <= ncortex*(iPrt));
    keep_add = keep_c(idx) + ndepth*(iPrt);
    
    BV_all = [BV_all;BV_add];
    dZ_filt_all = [dZ_filt_all; dZ_add];
    keep_all = [keep_all; keep_add];
    
    clear dZ_add keep_add idx
end

save('EIT_Rat_055_data_all_data', 'dZ_filt_all', 'BV_all', 'keep_all', '-v7.3');
%%

for iPrt = 1:nPrt
    idx = find(keep_all >= 1+ (ndepth+ncortex)*(iPrt-1) & keep_all <= (ndepth+ncortex)*(iPrt));
     plot(T_filt,dZ_filt_all(keep_all(idx(25:end)),:)', 'k');
    hold on;
    plot(T_filt,dZ_filt_all(keep_all(idx(1:24)),:)', 'b');
    hold off;
    waitforbuttonpress;
end
        
    

