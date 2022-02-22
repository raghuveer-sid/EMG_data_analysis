%% loading (Question 1)
EMG=load('EMG_data_ANNA.mat');
emg=cell2mat(struct2cell(EMG));
KINEM=load('kinem_ANNA.mat');
kinem=cell2mat(struct2cell(KINEM));

%DATA
Fs=1000; %Hz

%% Question 2
%Filter design
NUM=load('Num.mat');%Num.mat is the design of bandpass filter
Num=cell2mat(struct2cell(NUM));
%a.Filtering
%Biceps
emg_filt2=filter(Num,1,emg(2,:));
y2 = filtfilt(Num,1,double(emg_filt2));
%Triceps
emg_filt3=filter(Num,1,emg(3,:));
y3 = filtfilt(Num,1,double(emg_filt3));

%b.Rectify
%Take the abs of y2
%plot(abs(y2));
%plot(abs(y3));

%c.Low pass
LOP=load('Lop.mat'); %LoP.mat is the design of Low pass filter
Lop=cell2mat(struct2cell(LOP));
%Biceps
Yout2=filter(LoP,1,abs(y2));%filtering of the rectify signal
%Triceps
Yout3=filter(LoP,1,abs(y3));

%d.Downsample
y2_ds=downsample(Yout2,100);
%plot(y2_ds);
y3_ds=downsample(Yout3,100);
%plot(y3_ds);

%% Question 3
t=kinem(1,:);
s=kinem(2,:);
x=kinem(3,:);
y=kinem(4,:);
x_target=kinem(5,:);
y_target=kinem(6,:);

%% Question 4
%Extraction of EMG set
   %The matrix "set" returns each index with each line corresponding 
   %to the set number and containing the start and the end index of the set.  
nb_mov=0; 
count=0;
add=0;
set=[];
set(1,1)=1; %To have the step 1 starting at index 1
for i=1:length(emg(2,:))-1
    %We add 1 at nb_mov when we finish a movement
    if (emg(1,i)==2 && emg(1,i+1)==0) 
        nb_mov=nb_mov+1;
        %We check the index and add it the "set" every 96 movements
        if (nb_mov==(97+add)) 
        set(1+count,2)=i-1;%end index of a step
        set(2+count,1)=i;%start index of the following step
        add=add+96;
        count=count+1;
        
        end
    end 
end
set(12,2)=length(emg(2,:));

% Extract motion
nb_set_motion=1;
%index is a vector for which each ième element correspond to the index of
%time where we have to start (or stop for i+1) the step i
index=[]; 
index(1)=1;
%Check if the index i correspond to a transition between 2 step
for i=1:length(t)-1
    %To have a transition we need to be at the end of a movement (8->1)
    %and we need to have a long elapsed time period between 8 and 1   
    if (kinem(2,i)==8 && kinem(2,i+1)==1 && (t(i+1)-t(i))>= 0.1)
        nb_set_motion=nb_set_motion+1;
        index(nb_set_motion)=i;
    end 
end


%% Final subplot
%%%%%%%%%%%%Biceps all%%%%%%%%%%%
figure(1)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(2,:));
hold on 
plot(y2);
subplot(2,2,2)
%EMG rectified with on top the Envelope plotted
plot(abs(y2));
hold on
plot(abs(Yout2));
subplot(2,2,3)
%The movement signal X and Y in time
plot(t,x);
hold on
plot(t,y);
subplot(2,2,4)
%The xy movements signal together with the targets
plot(x,y)
hold on 
plot(x_target,y_target)

%%%%%%%%%%%%%%%%Triceps all%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(3,:));
hold on 
plot(y3);
subplot(2,2,2)
plot(abs(y3));
hold on
plot(abs(Yout3));
subplot(2,2,3)
plot(t,x);
hold on
plot(t,y);
subplot(2,2,4)
plot(x,y)
hold on 
plot(x_target,y_target)

%%%%%%%%%%%%%%%Biceps step 1%%%%%%%%%%%%%%%%%%%%%%
%Step 1 = the first set of movements
figure(3)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(2,1:set(1,2)))
axis([0 set(1,2) -2500 1000])
hold on
plot(y12)

subplot(2,2,2)
plot(abs(y12));
hold on
plot(abs(Yout12));
subplot(2,2,3)
plot(index(1):index(2),x(index(1):index(2)))
hold on
plot(index(1):index(2),y(index(1):index(2)))
subplot(2,2,4)
plot(x(index(1):index(2)),y(index(1):index(2)))
hold on 
plot(x_target(index(1):index(2)),y_target(index(1):index(2)))

%%%%%%%%%%%%%%%Biceps step 6%%%%%%%%%%%%%%%
%Step 6 = the first set of force field
figure(4)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(2,set(6,1):set(6,2)))
axis([0 length(emg(2,set(6,1):set(6,2))) -2000 1000])
hold on
plot(y62)
subplot(2,2,2)
plot(abs(y62));
hold on
plot(abs(Yout62));
subplot(2,2,3)
plot(index(6):index(7),x(index(6):index(7)))
hold on
plot(index(6):index(7),y(index(6):index(7)))
subplot(2,2,4)
plot(x(index(6):index(7)),y(index(6):index(7)))
hold on 
plot(x_target(index(6):index(7)),y_target(index(6):index(7)))

%%%%%%%%%%%%%%%Biceps step 10%%%%%%%%%%%%%%%
%Step 10 = the last set of force field
figure(5)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(2,set(10,1):set(10,2)))
axis([0 length(emg(2,set(10,1):set(10,2))) -2000 4000])
hold on
plot(y102)

subplot(2,2,2)
plot(abs(y102));
hold on
plot(abs(Yout102));
subplot(2,2,3)
plot(index(10):index(11),x(index(10):index(11)))
hold on
plot(index(10):index(11),y(index(10):index(11)))
subplot(2,2,4)
plot(x(index(10):index(11)),y(index(10):index(11)))
hold on 
plot(x_target(index(10):index(11)),y_target(index(10):index(11)))

%%%%%%%%%%%%%%%Biceps step 11%%%%%%%%%%%%%%%
%Step 11 =  the first set of washout
figure(6)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(2,set(11,1):set(11,2)))
axis([0 length(emg(2,set(11,1):set(11,2))) -2000 4000])
hold on
plot(y112)

subplot(2,2,2)
plot(abs(y112));
hold on
plot(abs(Yout112));
subplot(2,2,3)
plot(index(11):index(12),x(index(11):index(12)))
hold on
plot(index(11):index(12),y(index(11):index(12)))
subplot(2,2,4)
plot(x(index(11):index(12)),y(index(11):index(12)))
hold on 
plot(x_target(index(11):index(12)),y_target(index(11):index(12)))

%%%%%%%%%%%%%%%Triceps step 1%%%%%%%%%%%%%%%
figure(7)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(3,1:set(1,2)))
axis([0 set(1,2) -2500 1000])
hold on
plot(y13)

subplot(2,2,2)
plot(abs(y13));
hold on
plot(abs(Yout13));
subplot(2,2,3)
plot(index(1):index(2),x(index(1):index(2)))
hold on
plot(index(1):index(2),y(index(1):index(2)))
subplot(2,2,4)
plot(x(index(1):index(2)),y(index(1):index(2)))
hold on 
plot(x_target(index(1):index(2)),y_target(index(1):index(2)))

%%%%%%%%%%%%%%Triceps step 6%%%%%%%%%%%%%%
figure(8)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(3,set(6,1):set(6,2)))
axis([0 length(emg(2,set(6,1):set(6,2))) -2000 1000])
hold on
plot(y63)

subplot(2,2,2)
plot(abs(y63));
hold on
plot(abs(Yout63));
subplot(2,2,3)
plot(index(6):index(7),x(index(6):index(7)))
hold on
plot(index(6):index(7),y(index(6):index(7)))
subplot(2,2,4)
plot(x(index(6):index(7)),y(index(6):index(7)))
hold on 
plot(x_target(index(6):index(7)),y_target(index(6):index(7)))

%%%%%%%%%%%%%Triceps step 10%%%%%%%%%%%%
figure(9)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(3,set(10,1):set(10,2)))
axis([0 length(emg(3,set(10,1):set(10,2))) -2000 4000])
hold on
plot(y103)
subplot(2,2,2)
plot(abs(y103));
hold on
plot(abs(Yout103));
subplot(2,2,3)
plot(index(10):index(11),x(index(10):index(11)))
hold on
plot(index(10):index(11),y(index(10):index(11)))
subplot(2,2,4)
plot(x(index(10):index(11)),y(index(10):index(11)))
hold on 
plot(x_target(index(10):index(11)),y_target(index(10):index(11)))

%%%%%%%%%%%%%Triceps step 11%%%%%%%%%%%%%%%
figure(10)
subplot(2,2,1)
%EMG row signal with on top the filtered signal plotted 
plot(emg(3,set(11,1):set(11,2)))
axis([0 length(emg(3,set(11,1):set(11,2))) -2000 4000])
hold on
plot(y113)

subplot(2,2,2)
plot(abs(y113));
hold on
plot(abs(Yout113));
subplot(2,2,3)
plot(index(11):index(12),x(index(11):index(12)))
hold on
plot(index(11):index(12),y(index(11):index(12)))
subplot(2,2,4)
plot(x(index(11):index(12)),y(index(11):index(12)))
hold on 
plot(x_target(index(11):index(12)),y_target(index(11):index(12)))