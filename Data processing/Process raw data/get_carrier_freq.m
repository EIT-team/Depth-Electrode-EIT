function [] = get_carrier_freq(inj_switch, info, EIT_fname)
%Detects the carrier frequency from the first injection pair in the
%Protocol
%Input - inj_switch - switching times
%        info - information
%        EIT_fname - file containing data

%Load in 10s of data from first injection pair
EEG = pop_loadbv('', EIT_fname,[inj_switch(1)+info.Fs inj_switch(1)+10*info.Fs]);

%Looks at data from injecting channel
Inj_chan = double(EEG.data(info.Prt(1,2),:)');

%Removes any linear trend
V_inj = detrend(Inj_chan, 'constant');

%Does FFT and detects frequency with largest power spectrum
NFFT = 2^nextpow2(length(V_inj));
Y = fft(V_inj,NFFT)/length(V_inj);
f = info.Fs/2*linspace(0,1,NFFT/2+1);
w_ind=2*abs(Y(1:NFFT/2+1));
[~,maxw] = max((w_ind));
Fc = f(maxw);

disp(sprintf('****** Detected carrier frequency: Fc = %i Hz ******', round(Fc)));