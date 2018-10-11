%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RunAnalysis_Script.m
% CREATED: 1/25/18
% MODIFIED: 1/25/18
%
% PURPOSE: 
%   Analyze input forces from treadmill
% INPUTS:
%   Data
% OUTPUTS:
%   Plots
% NOTES:
    % Columns
    % C1 = Mx 
    % C2 = Fy: - means braking and + means pushing
    % C3 = Fx: vertical force
    % C4 = distance from Cp to treadmill center
    
    % Trials: 
    % 1 = 0%
    % 2 = 1%
    % 3 = 3%
    % 4 = 1%
    % 5 = 0%
% HOUSEKEEPING:
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMPORT DATA
% trial2 = xlsread('trial2_pilot1.xlsx');
% trial3 = xlsread('trial3_pilot1.xlsx');
% trial4 = xlsread('trial4_pilot1.xlsx');
% trial5 = xlsread('trial5_pilot1.xlsx');
% 
% trial2_0 = xlsread('zero_trial2_pilot1.xlsx');
% trial3_0 = xlsread('zero_trial3_pilot1.xlsx');
% trial4_0 = xlsread('zero_trial4_pilot1.xlsx');
% trial5_0 = xlsread('zero_trial5_pilot1.xlsx');
load('expData.mat')

%% PARSE DATA
% Trial 2
Mx2 = trial2(:,1);
Fy2= trial2(:,2);
Fx2 = trial2(:,3);
Ds2 = trial2(:,4);
t2 = 0:0.001:(length(Fy2)/1000)-0.001;
% Trial 3
Mx3 = trial3(:,1);
Fy3= trial3(:,2);
Fx3 = trial3(:,3);
Ds3 = trial3(:,4);
t3 = 0:0.001:(length(Fy3)/1000)-0.001;
% Trial 4
Mx4 = trial4(:,1);
Fy4= trial4(:,2);
Fx4 = trial4(:,3);
Ds4 = trial4(:,4);
t4 = 0:0.001:(length(Fy4)/1000)-0.001;
% Trial 5
Mx5 = trial5(:,1);
Fy5= trial5(:,2);
Fx5 = trial5(:,3);
Ds5 = trial5(:,4);
t5 = 0:0.001:(length(Fy5)/1000)-0.001;

% ZERO TRIALS
% Trial 2
Mx2_0 = trial2_0(:,1);
Fy2_0 = trial2_0(:,2);
Fx2_0 = trial2_0(:,3);
Ds2_0 = trial2_0(:,4);
t2_0 = 0:0.001:(length(Fy2_0)/1000)-0.001;
% Trial 3
Mx3_0 = trial3_0(:,1);
Fy3_0 = trial3_0(:,2);
Fx3_0 = trial3_0(:,3);
Ds3_0 = trial3_0(:,4);
t3_0 = 0:0.001:(length(Fy3_0)/1000)-0.001;
% Trial 4
Mx4_0 = trial4_0(:,1);
Fy4_0 = trial4_0(:,2);
Fx4_0 = trial4_0(:,3);
Ds4_0 = trial4_0(:,4);
t4_0 = 0:0.001:(length(Fy4_0)/1000)-0.001;
% Trial 5
Mx5_0 = trial5_0(:,1);
Fy5_0 = trial5_0(:,2);
Fx5_0 = trial5_0(:,3);
Ds5_0 = trial5_0(:,4);
t5_0 = 0:0.001:(length(Fy5_0)/1000)-0.001;

% Fix Zeroing on Fx and Fy
Fy2 = Fy2-mean(Fy2_0);
Fy3 = Fy3-mean(Fy3_0);
Fy4 = Fy4-mean(Fy4_0);
Fy5 = Fy5-mean(Fy5_0);

Fx2 = Fx2-mean(Fx2_0);
Fx3 = Fx3-mean(Fx3_0);
Fx4 = Fx4-mean(Fx4_0);
Fx5 = Fx5-mean(Fx5_0);

%j2 = find(Fx2<0);
%Fx2 = Fx2+mean(Fx2(j2));
%j3 = find(Fx3<0);
%Fx3 = Fx3+mean(Fx3(j3));
%j4 = find(Fx4<0);
%Fx4 = Fx4+mean(Fx4(j4));
%j5 = find(Fx5<0);
%Fx5 = Fx5+mean(Fx5(j5));


% BUTTERWORTH FILTER
[b,a] = butter(10,20/500);
Fy2 = filtfilt(b,a,Fy2);
Fy3 = filtfilt(b,a,Fy3);
Fy4 = filtfilt(b,a,Fy4);
Fy5 = filtfilt(b,a,Fy5);
Fx2 = filtfilt(b,a,Fx2);
Fx3 = filtfilt(b,a,Fx3);
Fx4 = filtfilt(b,a,Fx4);
Fx5 = filtfilt(b,a,Fx5);

%% PLOT INITIAL DATA
figure
plot(t2,Fy2,t2,Fx2)
xlabel('Time [s]')
ylabel('Force [N]')
legend('Horizontal Force','Vertical Force')
xlim([2 3])

%% PEAKS AND VALLEYS
% Average Peak Height
[pks,locs2] = findpeaks(Fy2,'MinPeakDistance',250);
avgpeak2 = linspace(mean(pks),mean(pks),length(locs2));
disp(['Peak Propelling 1%: ',num2str(avgpeak2(1)), ' N'])
pks2 = pks;

[pks,locs3] = findpeaks(Fy3,'MinPeakDistance',250);
avgpeak3 = linspace(mean(pks),mean(pks),length(locs3));
disp(['Peak Propelling 3%: ',num2str(avgpeak3(1)), ' N'])
pks3 = pks;

[pks,locs4] = findpeaks(Fy4,'MinPeakDistance',250);
avgpeak4 = linspace(mean(pks),mean(pks),length(locs4));
disp(['Peak Propelling 1%: ',num2str(avgpeak4(1)), ' N'])
pks4 = pks;

[pks,locs5] = findpeaks(Fy5,'MinPeakDistance',250);
avgpeak5 = linspace(mean(pks),mean(pks),length(locs5));
disp(['Peak Propelling 0%: ',num2str(avgpeak5(1)), ' N'])
pks5 = pks;

% Average Peak Depth
[pks,loc2] = findpeaks(-Fy2,'MinPeakDistance',250);
avgv2 = linspace(mean(pks),mean(pks),length(loc2));
disp(['Peak Braking 1%: ',num2str(avgv2(1)), ' N'])

[pks,loc3] = findpeaks(-Fy3,'MinPeakDistance',250);
avgv3 = linspace(mean(pks),mean(pks),length(loc3));
disp(['Peak Braking 3%: ',num2str(avgv3(1)), ' N'])

[pks,loc4] = findpeaks(-Fy4,'MinPeakDistance',250);
avgv4 = linspace(mean(pks),mean(pks),length(loc4));
disp(['Peak Braking 1%: ',num2str(avgv4(1)), ' N', ' N'])

[pks,loc5] = findpeaks(-Fy5,'MinPeakDistance',250);
avgv5 = linspace(mean(pks),mean(pks),length(loc5));
disp(['Peak Braking 0%: ',num2str(avgv5(1)), ' N'])

% Align Peaks
%t2 = t2-t2(loc2(1));
%t3 = t3-t3(loc3(1));
%t4 = t4-t4(loc4(1));
%t5 = t5-t5(loc5(1));


%% ZERO FY 
for i = 1:length(Fy2)
    if Fx2(i)<mean(Fx2_0)  
        Fyy2(i) = 0;
    else
        Fyy2(i) = Fy2(i);
    end
end
for i = 1:length(Fy3)
    if Fx3(i)<mean(Fx3_0)  
        Fyy3(i) = 0;
    else
        Fyy3(i) = Fy3(i);
    end
end
for i = 1:length(Fy4)
    if Fx4(i)<mean(Fx4_0)  
        Fyy4(i) = 0;
    else
        Fyy4(i) = Fy4(i);
    end
end
for i = 1:length(Fy5)
    if Fx5(i)<mean(Fx5_0) 
        Fyy5(i) = 0;
    else
        Fyy5(i) = Fy5(i);
    end
end

figure
plot(t2,Fy2,t2,Fyy2)
title('Original vs Zeroed Fy2')
legend('1','2')
xlim([6 10])
% Assign Zeros
Fy2 = Fyy2;
Fy3 = Fyy3;
Fy4 = Fyy4;
Fy5 = Fyy5;

%% IMPULSE

% Find Indices of Peaks
i2 = find(Fy2<0);
i3 = find(Fy3<0);
i4 = find(Fy4<0);
i5 = find(Fy5<0);

% Inegrate to get Impulse
Imp2 = abs(trapz(Fy2(i2))/length(pks2))/1000;
disp(['Propelling Impulse 1%: ',num2str(Imp2), ' N-s'])

Imp3 = abs(trapz(Fy3(i3))/length(pks3))/1000;
disp(['Propelling Impulse 3%: ',num2str(Imp3), ' N-s'])

Imp4 = abs(trapz(Fy4(i4))/length(pks4))/1000;
disp(['Propelling Impulse 1%: ',num2str(Imp4), ' N-s'])

Imp5 = abs(trapz(Fy5(i5))/length(pks5))/1000;
disp(['Propelling Impulse 0%: ',num2str(Imp5), ' N-s'])

% Find Indices of Peaks
i2 = find(Fy2>0);
i3 = find(Fy3>0);
i4 = find(Fy4>0);
i5 = find(Fy5>0);

% Inegrate to get Impulse
ImpB2 = abs(trapz(Fy2(i2))/length(pks2))/1000;
disp(['Braking Impulse 1%: ',num2str(ImpB2), ' N-s'])

ImpB3 = abs(trapz(Fy3(i3))/length(pks3))/1000;
disp(['Braking Impulse 3%: ',num2str(ImpB3), ' N-s'])

ImpB4 = abs(trapz(Fy4(i4))/length(pks4))/1000;
disp(['Braking Impulse 1%: ',num2str(ImpB4), ' N-s'])

ImpB5 = abs(trapz(Fy5(i5))/length(pks5))/1000;
disp(['Braking Impulse 0%: ',num2str(ImpB5), ' N-s'])

% Difference in Braking and Propulsion
ImpDiff = [Imp5 Imp4 Imp3]-[ImpB5 ImpB4 ImpB3];
disp(['Impulse Difference 0%: ',num2str(ImpDiff(1)), ' N-s'])
disp(['Impulse Difference 1%: ',num2str(ImpDiff(2)), ' N-s'])
disp(['Impulse Difference 3%: ',num2str(ImpDiff(3)), ' N-s'])

% Find Step Frequency
numPks2 = (length(pks2)/(length(t2)*0.001));
numPks3 = (length(pks3)/(length(t2)*0.001));
numPks4 = (length(pks4)/(length(t2)*0.001));
numPks5 = (length(pks5)/(length(t2)*0.001));
disp(['Stride Frequency 0%: ',num2str(numPks5), ' Hz'])
disp(['Stride Frequency 1%: ',num2str(numPks4), ' Hz'])
disp(['Stride Frequency 3%: ',num2str(numPks3), ' Hz'])

% Find Contact Time per Step
i2 = find(Fy2==0);
i3 = find(Fy3==0);
i4 = find(Fy4==0);
i5 = find(Fy5==0);
timeCont2 = (length(t2) - length(i2))*0.001/length(pks2);
timeCont3 = (length(t3) - length(i3))*0.001/length(pks3);
timeCont4 = (length(t4) - length(i4))*0.001/length(pks4);
timeCont5 = (length(t5) - length(i5))*0.001/length(pks5);
disp(['Contact Time 0%: ',num2str(timeCont5), ' s'])
disp(['Contact Time 1%: ',num2str(timeCont4), ' s'])
disp(['Contact Time 3%: ',num2str(timeCont3), ' s'])

% Duty Factor
dutyF2 = (length(t2)-length(i2))/length(i2);
dutyF3 = (length(t3)-length(i3))/length(i3);
dutyF4 = (length(t4)-length(i4))/length(i4);
dutyF5 = (length(t5)-length(i5))/length(i5);
disp(['Duty Factor 0%: ',num2str(timeCont5), '%'])
disp(['Duty Factor 1%: ',num2str(timeCont4), '%'])
disp(['Duty Factor 3%: ',num2str(timeCont3), '%'])
%% PLOT RESULTS




figure
hold on
plot(t2,Fy2,t3,Fy3,t4,Fy4,t5,Fy5)
plot(t2(locs2),avgpeak2,t3(locs3),avgpeak3,t4(locs4),avgpeak4,t5(locs5),avgpeak5)
plot(t2(loc2),-avgv2,t3(loc3),-avgv3,t4(loc4),-avgv4,t5(loc5),-avgv5)
xlim([2 5])
xlabel('Time [s]')
ylabel('Force [N-s]')
legend('Trial 2 1%','Trial 3 3%','Trial 4 1%','Trial 5 0%')
hold off

figure
plot([0 1 3],[avgpeak5(1) avgpeak4(1) avgpeak3(1)],0,avgpeak5(1),'o',1, avgpeak4(1),'o',3, avgpeak3(1),'o')
title('Peaks vs BWP')
xlabel('Body Weight Percentage')
ylabel('Force Peak')
legend('Average','0%','1%','3%')


figure
hold on
plot([0 1 3],[Imp5 Imp4 Imp3],0,Imp5,'o',1,Imp4,'o',3,Imp3,'o')
plot([0 1 3],[ImpB5 ImpB4 ImpB3],0,ImpB5,'o',1,ImpB4,'o',3,ImpB3,'o')
plot([0 1 3],ImpDiff,'o',[0 1 3],ImpDiff)
title('Impulse vs BWP')
xlabel('Body Weight Percentage')
ylabel('Impulse [N-s]')
legend('Propulsion','0%','1%','3%','Braking','0%','1%','3%','Difference')

