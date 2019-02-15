function [inj_switch] = get_switching_time(EEG_fname, info)
%Finds data points where current injection pair changes
%Input - EEG_fname - output from sopen
%        info 
%Output - inj_switch - data points where injection pair changes

%Get time points of all triggers sent 
inj_switch = EEG_fname.EVENT.POS;

%Find triggers specific to switching of current injeciton pair ('S1')
for i=1:length(inj_switch)
    if ~strcmp([EEG_fname.EVENT.Desc{i}], ['S  1']);
        inj_switch(i) = 0;
    end
end

inj_switch(inj_switch==0)=[];
%One extra at very start when sending settings so remove 
inj_switch = inj_switch(2:end);
% temp = EEG_fname.EVENT.POS(48);
% inj_switch = [temp;inj_switch];

%Add an extra point on the end as need a starting and end time for each
%interval
inj_switch = [inj_switch; 2*inj_switch(end) - inj_switch(end-1)];
%inj_switch(end+1) = EEG_fname.EVENT.POS(end);

%Check that interval between switches detected is same as measurement time
interval = (inj_switch(2:end) - inj_switch(1:end-1))./info.Fs;
% check_int = find(round(interval) ~= info.Meas_time);
% if check_int
%     disp('%d injection times detected incorrectly', length(check_int))
% else
%     disp('All injection times detected consistent with measurement time');
% end

%Check that the number of injection switches is the same as the protocol
%length
if (info.Prt_size + 1 == size(inj_switch,1))
     disp('All data seemed to be there');
elseif (info.Prt_size + 1 > size(inj_switch,1))
     disp('Protocol size is bigger than the number of switches in the file');
else
     disp('Protocol size is smaller than the number of switches in the file!'); 
end