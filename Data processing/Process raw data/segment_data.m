function [EP, dZ, BV, T, N_bin, N_chan, Data_seg] = segment_data(X_ep, A_dz, T_trig, info, Data)
%Segments data into epochs around stimulation points
%Input - X_ep - data with EPs
%        A_dz - data with dZs
%        T_trig - data points of stimulation triggers
%        info - information
%Output - EP - cell array with segmented EP data 
%         dZ - cell array with segmented dZ data
%         BV - cell array with segmented boundary voltage
%         T - array with time point -250ms to 250ms, stimulation at T = 0s
%         N_bin - number of data points in each segment
%         N_chan - number of channels

%Number of channels
N_chan = size(A_dz, 2);
%Number of triggers (simulations)
N_trig = length(T_trig);
%Number of data points around each 
N_bin = round(info.T_window*info.Fs);

%Window around trigger from -250ms to +250ms
w = (1:N_bin) - round(N_bin*0.5);
%Converts sample points to time points in ms
T = 1e3*w/info.Fs;

% t = find(T>=-10 & T<40);
% %t(1250) = t(1249)+1;
% w = w(t);
% N_bin = length(t);
% T = T(t);

EP = cell(1,N_chan);
dZ = cell(1,N_chan);
BV = cell(1,N_chan);
Data_seg = cell(1,N_chan);
%P = cell(1,N_chan);

%Loop over each channel
for iChan = 1:N_chan
    EP{iChan} = zeros(N_bin,N_trig);
    dZ{iChan} = zeros(N_bin,N_trig);
    %P{iChan} = zeros(N_bin,N_trig);
    BV{iChan} = zeros(1,N_trig);
    Data_seg{iChan} = zeros(N_bin, N_trig);
    
    %Segment data into trials
    for iTrig = 1:N_trig
        %Data points that are within -250ms and +250ms of the stimulation
        ival = T_trig(iTrig) + w;
        EP{iChan}(:,iTrig) = detrend(X_ep(ival,iChan),'constant');
        dZ{iChan}(:,iTrig) = detrend(A_dz(ival,iChan),'constant');
        %P{iChan}(:,iTrig) = detrend(P_dz(ival,iChan),'constant');
        %Mean potential on channel 
        BV{iChan}(iTrig) = mean(A_dz(ival,iChan));
        Data_seg{iChan}(:,iTrig) = Data(ival,iChan);
    end
    
end