clc
clear
close all

%% loading EMG data
[file,path]=uigetfile('*.xlsx');
data_txt=importdata([path,file]);
t=data_txt(:,1);
raw_data=data_txt(:,2);
t=t(1:length(raw_data)); N=length(t);
%figure; plot(t,raw_data); title('raw EMG signal')

%% removing zero drift of EMG signal
data=detrend(raw_data);
figure; plot(t,data); title('EMG signal')

%% butter worth filter of EMG signal
order=4;
cutoff_low= 10;
cutoff_high= 500;

fs=1200; %sampling frequency, Hz
[b,a]=butter(order,[cutoff_low/(fs/2) cutoff_high/(fs/2)],'bandpass'); 
data_butter=filtfilt(b,a,data); %low-pass butter worth filter
%figure; plot(t,data_butter); title('low pass filter of EMG signal')

%% rectifing EMG signal
data_abs=abs(data_butter);
%figure; plot(t,data_abs); title('rectified EMG signal')

%% root mean square of EMG signal
w=round((50/1000)*fs); %window length
for i=1:N-w
    data_rms(i)=rms(data_abs(i:i+w));
%     data_rms(i)=data_rms(i)./max(data_rms);
end
figure; plot(t(1:N-w),data_rms); title('root mean square of EMG signal')
data_rms=data_rms';
mvic=max(data_rms)
