%%
test_std = std(dZ_sorted(:,1000:14500),0,2);
idx = find(test_std(keep_sorted) <0.5);

figure; plot(detrend(dZ_sorted(keep_sorted(idx),:)'))
%%
keep_sorted = keep_sorted(idx);


