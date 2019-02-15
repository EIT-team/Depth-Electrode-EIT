%Fs = 50000;
Fs = 16384;

for i = 1:size(dZ_sorted,1)
dZ_decim(i,:) = decimate(dZ_sorted(i,:), 5);
end
%%
[b,a] = butter(5, 500/(Fs/(10*2)), 'low');
for i = 1:size(dZ_sorted,1)
dZ_filt(i,:) = filtfilt(b,a,dZ_decim(i,:));
end


 T = ([1:size(dZ_sorted,2)] - size(dZ_sorted,2)/2)./Fs;
 T = T*1e3;
 T_filt = ([1:size(dZ_filt,2)] - size(dZ_filt,2)/2)./(Fs/5);
 T_filt = T_filt*1e3;

 
 %%
 keep = keep_sorted;
 %BV = BV_sorted;
 
 save('EIT_Rat_055_depth_data', 'dZ_filt', 'T_filt', 'BV_sorted', 'keep', 'T','-v7.3');
  %save('EIT_Rat_055_cortex_data', 'dZ_filt', 'T_filt', 'BV_sorted', 'keep', 'T','-v7.3');
 
 
 