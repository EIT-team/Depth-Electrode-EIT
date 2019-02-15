function [avg_EP, avg_dZ_abs, avg_dZ_rel, avg_dZ_std, BV0, idx] = compute_averages(EP, dZ, BV, T, N_bin, N_chan)
%function [avg_dZ_abs] = compute_averages(dZ, T, N_bin, N_chan, x)
%Averages over each trial to give average EP and dZ over current injetion
%period
%Input - EP - EP data for each trial
%        dZ - dZ data for each trial
%        BV - boundary volatge for each trial
%        T - time
%        N_bin - number of data points in each trial
%        N_chan - number of channels
%Output - avg_EP - average EP one each channel over current injection time
%         avg_dZ_abs - average dZ over current injection time
%         avg_dZ_rel - average dZ in percent
%         avg_dZ_std - average standard deviation in dZ
%         BV0 - average voltage on channels over current injection time
% 
avg_EP = zeros(N_bin,N_chan);
avg_dZ_abs = zeros(N_bin,N_chan);
%avg_dZ_ph = zeros(N_bin,N_chan);
avg_dZ_std = zeros(N_bin,N_chan);
avg_dZ_rel = zeros(N_bin,N_chan);
BV0 = zeros(N_chan);

%x = [1:60];
% 
% for i = 1:N_chan
% id = [];
% for j = 1:size(dZ{1},2)
% test = find(abs(dZ{i}(:,j)) > 700);
% if test
% id  = [id;j];
% end
% end
% idx{i} = id;
% end


%Finds period before stimulation that is used for baseline correction/time
%difference
%t0 = find(T>-4 & T<-2);
t0 = find(T>-250 & T<-10);

    for iChan = 1:N_chan
        %keep = setdiff([1:size(dZ{1},2)], idx{iChan});
        keep = [1:size(dZ{1},2)];
        %keep = [(1:108),(110:size(dZ{1},2))];
        ep = EP{iChan}(:,keep);
        dz = dZ{iChan}(:,keep);
        %p = P{iChan}(:,:);
        bv = repmat(BV{iChan}(1,keep),N_bin,1); 
        
        %Takes mean of all trials and takes away baseline
        avg_EP(:,iChan) = mean(ep,2)-mean(reshape(ep(t0,:),[],1));
        avg_dZ_abs(:,iChan) = mean(dz,2)-mean(reshape(dz(t0,:),[],1));
%           avg_EP(:,iChan) = detrend(mean(ep,2));%-mean(reshape(ep(t0,:),[],1));
%         avg_dZ_abs(:,iChan) = detrend(mean(dz,2));%-mean(reshape(dz(t0,:),[],1));
        %avg_dZ_ph(:,iChan) = mean(p,2)-mean(reshape(p(t0,:),[],1));
        
        %Standard deviation
        avg_dZ_std(:,iChan) = std(dz,0,2);
        
        %Calculates the percentage change in dZ, does this by dividing by
        %the standing voltage on each channel
        avg_dZ_rel(:,iChan) = 100*mean(dz./bv,2);            
        %avg_dZ_rel(:,iChan) = avg_dZ_rel(:,iChan)-mean(avg_dZ_rel(t0,iChan));  
        
        %Boundary voltage
        BV0(iChan) = mean(mean(bv,2));
        
        %A way to evaluate the sign on each channel??
        %Finds the row with the maximum data point in channel 1
%         [~,mm]=max(Data(:,1));
%         %Looks at sign of each channel in this row and uses this sign to 
%         %assign sign to standing voltage (BV) on each channel
%         invert = Data(mm,:)<0;
%         
%         if (~invert(iChan))
%             BV0(iChan)=mean(mean(bv,2)); 
%         else
%             BV0(iChan)=-mean(mean(bv,2));
%         end
        
    end