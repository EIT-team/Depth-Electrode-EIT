load('D:\Rat_055\Reconstructions\Pos and Protocols\Protocol_Rat_055_cortex_map.mat');
load('cortex_recording_map.mat');

bad_inj = [];
Prt = size(EIT_avg,2);
n = Prt - size(bad_inj,2);

n_chan = 64;

BV = [];
for i = 1:Prt
    if ~ismember(i, bad_inj)
    BV_temp = EIT_avg{1,i}.BV0(1:32,1);
    BV = [BV; BV_temp];
    end
end

clear BV_temp

BV_sorted = [];
for  i = 1:n
BV_temp = BV((i-1)*n_chan + 1: i*n_chan);
BV_temp = BV_temp(map);
BV_sorted = [BV_sorted; BV_temp];
end

dZ = [];
for i = 1:Prt
if ~ismember(i, bad_inj)
dZ_temp = EIT_avg{1,i}.dZ_avg(:,1:32);
dZ = [dZ, dZ_temp];
end
end
dZ = dZ';

clear dZ_temp

dZ_sorted = [];
for  i = 1:n
dZ_temp = dZ((i-1)*n_chan + 1: i*n_chan,:);
dZ_temp = dZ_temp(map,:);
dZ_sorted = [dZ_sorted; dZ_temp];
end

clear dZ_temp;

% dZ_per = [];
% for i = 1:Prt
% if ~ismember(i, bad_inj)
% dZ_temp = EIT_avg{1,i}.dZ_per(:,:);
% dZ_per = [dZ_per, dZ_temp];
% end
% end
% dZ_per = dZ_per';
% 
% clear dZ_temp
% 
% dZ_per_sorted = [];
% for  i = 1:n
% dZ_temp = dZ_per((i-1)*n_chan + 1: i*n_chan,:);
% dZ_temp = dZ_temp(map,:);
% dZ_per_sorted = [dZ_per_sorted; dZ_temp];
% end
% 
% clear dZ_temp;
% 
% std = [];
% for i = 1:Prt
% if ~ismember(i, bad_inj)
% std_temp = EIT_avg{1,i}.dZ_std(:,:);
% std = [std, std_temp];
% end
% end
% std = std';
% 
% clear std_temp
% 
% std_sorted = [];
% for  i = 1:n
% std_temp = std((i-1)*n_chan + 1: i*n_chan,:);
% std_temp = std_temp(map,:);
% std_sorted = [std_sorted; std_temp];
% end
% 
% clear std_temp
% 
% 
% EP = [];
% for i = 1:Prt
% if ~ismember(i, bad_inj)
% EP_temp = EIT_avg{1,i}.EP_avg(:,:);
% EP = [EP, EP_temp];
% end
% end
% EP = EP';
% 
% clear EP_temp
% 
% EP_sorted = [];
% for  i = 1:n
% EP_temp = EP((i-1)*n_chan + 1: i*n_chan,:);
% EP_temp = EP_temp(map,:);
% EP_sorted = [EP_sorted; EP_temp];
% end
% 
% clear EP_temp;


for i = 1:n

rm = [];
rm = [rm, Prot_map(i,:)];
keep{1,i} = setdiff([1:length(map)],rm);
end

keep_sorted = [];
for i = 1:n
    keep_temp = (keep{1,i} + (i-1)*length(map))';
    keep_sorted = [keep_sorted;keep_temp];
end


