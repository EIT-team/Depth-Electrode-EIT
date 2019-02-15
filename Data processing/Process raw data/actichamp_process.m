path_n = 'D:\Rat_052\EIT_whisker_all';
EIT_n = 'EIT_001.vhdr';
EIT_fname = fullfile(path_n, EIT_n);
EEG_fname = sopen([EIT_fname(1:end-5) '.eeg']);
log_fname = ([EIT_fname(1:end-5) '_log.mat']);

load(log_fname);

load('chns_actichamp.mat');

info.Prt = ExpSetup.Protocol;
info.Prt_size = size(unique(ExpSetup.Protocol, 'rows'),1)/2;
info.Prt_rpt = size(info.Prt,1)/info.Prt_size;

info.T_window = (ExpSetup.StimulatorTriggerTime/1000);
info.Meas_time = ExpSetup.MeasurementTime/1000;
info.Fc = ExpSetup.Freq;
info.Fs = EEG_fname.SampleRate;

info.EP_low = 500;
info.EP_high = 5;
info.N_butter_EP_low = 5;
info.N_butter_EP_high = 3;
info.dZ_BW = 1000;
info.N_butter_dZ = 5;


%Create figure
Plot = 1; %Set to 0 if you don't want a figure
if Plot
    figure('units','normalized','outerposition',[0 0 1 1])
end

[inj_switch] = get_switching_time(EEG_fname, info);

get_carrier_freq(inj_switch, info, EIT_fname);
EP_all = cell(1,63);
BV_all = cell(1,63);
dZ_all = cell(1,63);
for iPair =1:info.Prt_size
    
    clear EP_all BV_all dZ_all T_trig
    EP_all = cell(1,63);
    BV_all = cell(1,63);
    dZ_all = cell(1,63);
    
    EP_temp = [];
    dZ_temp = [];
    BV_temp = [];
    for iRpt = 1:info.Prt_rpt
        
        EEG = pop_loadbv('', EIT_fname, [inj_switch((iPair-1)*info.Prt_rpt+iRpt) round(inj_switch((iPair-1)*info.Prt_rpt+iRpt+1))]);
        Data = double(EEG.data(chns,:)');
        
        [T_trig] = get_stim_time(EEG, info);
        T_trig2 = T_trig + 500/1000*info.Fs;
        T_trig = [T_trig; T_trig2];
        
        [X_ep, A_dz, X_dz] = filter_data(Data, info);
        
        [EP, dZ, BV, T, N_bin, N_chan, Data_seg] = segment_data(X_ep, A_dz,  T_trig, info, Data);
        
        [avg_EP, avg_dZ_abs, avg_dZ_rel, avg_dZ_std, BV0] = compute_averages(EP, dZ, BV, T, N_bin, N_chan);
        
        EIT{(iPair-1)*info.Prt_rpt+iRpt}.Pair = info.Prt((iPair-1)*info.Prt_rpt+iRpt,:);
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
        
        EIT_avg{iPair}.Pair = info.Prt(iPair,:);
        EIT_avg{iPair}.EP_avg = avg_EP;
        EIT_avg{iPair}.dZ_avg = avg_dZ_abs;
        EIT_avg{iPair}.dZ_per = avg_dZ_rel;
        EIT_avg{iPair}.dZ_std = avg_dZ_std;
        EIT_avg{iPair}.BV0 = BV0;
        
        plot(T,avg_dZ_abs(:,:));
        drawnow;
end


        

