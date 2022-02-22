%loading
EMG=load('EMG_data_ANNA.mat');
emg=cell2mat(struct2cell(EMG));
KINEM=load('kinem_ANNA.mat');
kinem=cell2mat(struct2cell(KINEM));

%DATA
Fs=1000; %Hz
Nyquist_freq=Fs/2;

%Filter design
%Do it using >>fdatool (bandpass 20/30/450/460 Hz) and export it in the workspace (in this case it is
%called Num


%Filtering
emg_filt2=filter(Num,1,emg(2,:));
y2 = filtfilt(Num,1,double(emg_filt2));
emg_filt3=filter(Num,1,emg(3,:));
y3 = filtfilt(Num,1,double(emg_filt3));

%FIGURE
%figure(1)
%plot(emg(1,:));
figure(2)
plot(emg(2,:));
%hold on
%plot(emg_filt2);
hold on 
plot(y2);
figure(3)
plot(emg(3,:));
%hold on 
%plot(emg_filt3);
hold on 
plot(y3)

%Rectify
%figure(4)
%plot(abs(y2));
%figure(5)
%plot(abs(y3));

%Low pass
Yout2=filter(LoP,1,abs(y2));
Yout3=filter(LoP,1,abs(y3));

figure(6)
plot(abs(y2));
hold on
plot(abs(Yout2));
%axis([0 10 -2000 3000])
figure(7)
plot(abs(y3));
hold on
plot(abs(Yout3));

%Downsample
figure(8)
y2_ds=downsample(Yout2,100);
plot(y2_ds);
figure(9)
y3_ds=downsample(Yout3,100);
plot(y3_ds);



