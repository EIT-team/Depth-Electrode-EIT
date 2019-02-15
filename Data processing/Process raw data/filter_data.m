function [X_ep, A_dz, X_dz] = filter_data(Data, info)
%Applies filters to raw data to extract EPs and dZs 
%Input - Data - raw data for current injection pair
%        info
%Output - X_ep - data with EPs
%         A_dz - data with dZ
%         X_sin - data before demodulation to check for saturation
%         artefacts

%%EPS%%
%Low pass filter to retrieve EP's
[b,a] = butter(info.N_butter_EP_low, info.EP_low/(info.Fs/2), 'low');
X_ep = filtfilt(b,a,Data);

% [b,a] = butter(info.N_butter_EP_high, info.EP_high/(info.Fs/2), 'high');
% X_ep = filtfilt(b,a,X_ep);

%Notch filter to remove 50Hz
[b,a] = iirnotch(50/(info.Fs/2),(50/(info.Fs/2))/35);
X_ep = filtfilt(b,a,X_ep);

%Notch filter to remove carrier frequency
[b,a] = iirnotch(info.Fc/(info.Fs/2),(info.Fc/(info.Fs/2))/35);
X_ep = filtfilt(b,a,X_ep);

%%MUAe%%
% [b,a] = iirnotch(info.Fc/(info.Fs/2),(info.Fc/(info.Fs/2))/35);
% X_ep = filtfilt(b,a,Data);
% 
% 
% [b,a] = butter(8, 400/(info.Fs/2), 'high');
% X_ep = filtfilt(b,a,X_ep);
% 
% X_ep = abs(X_ep);
% 
% [b,a] = butter(5, 150/(info.Fs/2), 'low');
% X_ep = filtfilt(b,a,X_ep);
% 
% 
% %Notch filter to remove 50Hz
% [b,a] = iirnotch(50/(info.Fs/2),(50/(info.Fs/2))/35);
% X_ep = filtfilt(b,a,X_ep);
% % 
% %Notch filter to remove carrier frequency
% [b,a] = iirnotch(info.Fc/(info.Fs/2),(info.Fc/(info.Fs/2))/35);
% X_ep = filtfilt(b,a,X_ep);





%%dZ%%
%Band-pass filter
[b,a] = butter(info.N_butter_dZ,(info.Fc+info.dZ_BW*[-1,1])/(info.Fs/2), 'bandpass');
X_dz = filtfilt(b,a,Data);
%X_sin = X_dz;

clear Data
%Use Hilbert transform to demodulate
for i = 1:size(X_dz,2)
A_dz(:,i) = abs(hilbert(X_dz(:,i)));
%P_dZ(:,i) = unwrap(angle(hilbert(X_dz(:,i))));
%A_dz(:,i) = abs(X_dz(:,i));
end
% 
%  [b,a] = butter(info.N_butter_dZ_high, info.dZ_high/(info.Fs/2), 'high');
% % % A_dz(:,33:end) = filtfilt(b,a,A_dz(:,33:end));
%  A_dz = filtfilt(b,a,A_dz);

%clear X_dz

%Notch filter to remove 50Hz
% [b,a] = iirnotch(50/(info.Fs/2),(50/(info.Fs/2))/10);
% A_dz = filtfilt(b,a,A_dz);

