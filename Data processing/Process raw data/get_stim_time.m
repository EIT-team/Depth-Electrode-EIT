function [T_trig] = get_stim_time(EEG, info)
%Finds the time points where stimulation occurs 
%Needed for averaging EPs and dZs around these points
%Input - EEG - output from sopen
%        info - information
%Output - T_trig - data points where stimulation occurs

%Get time points of all triggers
T_trig = cell2mat({EEG.event.latency})';

%Find triggers that correspond to stimulation ('S2')
for i=1:length(T_trig)
    if ~strcmp([EEG.event(1,i).type], ['S  2']);
    %if ~strcmp([EEG.event(1,i).type], ['R 12']);
        T_trig(i) = 0;
    end
end

T_trig(T_trig==0) = [];
%Remove first and last 4 stimulations as the data contains switching
%artefact
% T_trig=T_trig(4:end-3);

%Remove first and last 4 stimulations as the data contains switching
%artefact
%T_trig=T_trig(10:end-10);
T_trig=T_trig(3:end-3);

%Calculate the time between stimulations and make sure it is the same as
%info.T_window
T_stim = mean(T_trig(2:end) - T_trig(1:end-1))/info.Fs;
disp(['Stimulation every ' num2str(round(T_stim*1000)) ' ms']);
