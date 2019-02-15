 %%
path_n = 'D:\Rat_056\All';
EIT_n = 'EIT_2.bdf';

fname = fullfile(path_n, EIT_n);
% log_fname = ([fname(1:end-4) '_log.mat']);
% load(log_fname);
load('depth_stim_prt1_log.mat');

HDR=sopen(fname,'r',[],['OVERFLOWDETECTION:OFF','BDF:[4]']);
N_elec=size(HDR.InChanSelect,1); %number of electrodes
%create HDR again, but with correct number of electrodes, Im not exactly
%sure why it doesnt load it properly first
HDR=sopen(fname,'r',1:N_elec,['OVERFLOWDETECTION:OFF','BDF:[4]']);


info.Prt = ExpSetup.Protocol;
info.Prt_size = 23;
info.Prt_rpt = 8;

info.T_window = (ExpSetup.StimulatorTriggerTime/1000);
info.Meas_time = ExpSetup.MeasurementTime/1000;
info.Fc = ExpSetup.Freq;
info.Fs = HDR.SampleRate;


info.EP_low = 1000;
info.EP_high = 5;
info.dZ_high = 40;
info.N_butter_EP_low = 3;
info.N_butter_EP_high = 3;
info.N_butter_dZ_high = 5;
info.dZ_BW = 500;
info.N_butter_dZ = 5;

%% Load the triggers
%View Triggers
ScouseTom_TrigView( HDR);

trignum = 8;
StatusChn=dec2bin(HDR.BDF.Trigger.TYP)-'0';%convert into binary vector
StatusChn=StatusChn(:,end-(trignum-1):end); % take only last 8 bits

StatusChn=fliplr(StatusChn); %sort into LSB
TrigPos=HDR.BDF.Trigger.POS;
%% Injection Triggers
inj_switch = TrigPos;
inj_switch(StatusChn(:,1) == 0) = [];
inj_switchT = inj_switch./info.Fs;

%inj_switch = inj_switch(2:end);
%Add one extra for the end
%inj_switch = [inj_switch; 2*inj_switch(end) - inj_switch(end-1)];
%
%%
start_trig = TrigPos;
start_trig(StatusChn(:,4) == 0) = [];
start_trigT = start_trig./info.Fs;
start_trigT_int = start_trigT(2:end) - start_trigT(1:end-1);

inj_int = find(start_trigT_int > 100);

%% Stimulation Triggers
stim = TrigPos;
stim(StatusChn(:,2) == 0) = [];

%%
chns1 = [1,2,3,4,13,14,15,16,17,18,19,20,29,30,31,32];
chns2 = chns1 + 32;
 chns3 =[65:96];
% %chns3 = [];
  chns4 = [97:128];
 chns4 = [];
%chns = [chns1,chns2];%,chns3, chns4];
chns = [chns3,chns4];

Plot = 1; %Set to 0 if you don't want a figure
if Plot
    figure('units','normalized','outerposition',[0 0 1 1])
end

%%
for iPair =1:Prt_size
        load(['depth_stim_prt' num2str(iPair) '_log.mat']);
        info.Prt = ExpSetup.Protocol;
        EP_all = cell(1,96);
        BV_all = cell(1,96);
        dZ_all = cell(1,96);
    
        EP_temp = [];
        dZ_temp = [];
        BV_temp = [];
        
       switch_iPair = find(inj_switch > start_trig(inj_int(iPair)) & inj_switch < start_trig(inj_int(iPair)+1));
       % switch_iPair = find(inj_switch > start_trig(end));% & inj_switch < start_trig(inj_int(iPair))+210*HDR.SampleRate);
       switch_iPair = switch_iPair(2:end);
       inj_switch_iPair = inj_switch(switch_iPair);
       inj_switch_iPair = [inj_switch_iPair; 2*inj_switch_iPair(end) - inj_switch_iPair(end-1)];
        %inj_switch_int = (inj_switch(inj_switch_iPair(2:end)) - inj_switch(inj_switch_iPair(1:end-1)))./info.Fs;
         
    for iRpt = 1:info.Prt_rpt
    
    %Read in data between each injection pair
    [Data,HDR] = sread(HDR, round((inj_switch_iPair(iRpt+1) - inj_switch_iPair(iRpt))./HDR.SampleRate), inj_switch_iPair(iRpt)./HDR.SampleRate);
    Data = Data(:,chns);
    %Find the stim triggers that fall in the timepoint between the
    %injection
    T_trig = find(stim >inj_switch_iPair(iRpt) & stim < inj_switch_iPair(iRpt+1));
    T_trigt = stim(T_trig);
    T_trig_inj = T_trigt - inj_switch_iPair(iRpt); %shift down so they are right time within window
    T_trig_inj2 = T_trig_inj+round((0.5)*HDR.SampleRate);
    T_trig_inj([5,10,15,20,25]) = [];
    T_trig_inj2([4,9,14,19,24]) = [];
    T_trig_inj2 = T_trig_inj2(1:end-1);
    T_trig_inj = [T_trig_inj;T_trig_inj2];

    %Filter data
    [X_ep, A_dz, X_dz] = filter_data(Data, info);
 
    [EP, dZ, BV, T, N_bin, N_chan, Data_seg] = segment_data(X_ep, A_dz,  T_trig_inj, info, Data);
 
    [avg_EP, avg_dZ_abs, avg_dZ_rel, avg_dZ_std, BV0] = compute_averages(EP, dZ, BV, T, N_bin, N_chan);
    
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.Pair = info.Prt;%((iPair-1)*8+iRpt,:);
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.EP_avg = avg_EP;
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.dZ_avg = avg_dZ_abs;
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.dZ_per = avg_dZ_rel;
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.dZ_std = avg_dZ_std;
     EIT{(iPair-1)*info.Prt_rpt+iRpt}.BV0 = BV0;
     
     for iChn = 1:N_chan
            EP_temp = [EP_all{1,iChn},EP{1,iChn}];
            dZ_temp = [dZ_all{1,iChn},dZ{1,iChn}];
            BV_temp = [BV_all{1,iChn},BV{1,iChn}];
            EP_all{iChn} = EP_temp;
            dZ_all{iChn} = dZ_temp;
            BV_all{iChn} = BV_temp;
     end
 end
     
     [avg_EP, avg_dZ_abs, avg_dZ_rel, avg_dZ_std, BV0] = compute_averages(EP_all, dZ_all, BV_all, T, N_bin, N_chan);
        
      EIT_avg{iPair}.Pair = info.Prt;%(iPair,:);
      EIT_avg{iPair}.EP_avg = avg_EP;
      EIT_avg{iPair}.dZ_avg = avg_dZ_abs;
      EIT_avg{iPair}.dZ_per = avg_dZ_rel;
      EIT_avg{iPair}.dZ_std = avg_dZ_std;
      EIT_avg{iPair}.BV0 = BV0;
        
      plot(T,avg_dZ_abs(:,:));
      drawnow;
      
      display(['Finished Pair' num2str(iPair)]); 
    
end
 
%save('EIT_001_Both_part5', 'EIT', 'EIT_avg', '-v7.3');
 
 
        
 
 





