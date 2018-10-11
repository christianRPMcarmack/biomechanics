function output = analysis_Function(trial2);
% AUTHOR: Christian R Carmack
% CREATED: 1/25/18
% MODIFIED: 1/25/18
% PURPOSE: 
%   Analyze input forces from treadmill
% INPUTS:
%   Data
% OUTPUTS:
%   Plots
%% NOTES:
%   To run this program input the filenames of the trial data and zero
%   trial data. For example: 
%          analysis_Function('trial2_pilot1.xlsx')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global offsetX offsetY
%% IMPORT DATA
%trial2 = xlsread(file);
%trial2_0 = xlsread(zerofile);

%% PARSE DATA
% Trial 2
Fp2 = trial2(:,1);
Fy2= trial2(:,2);
Fx2 = trial2(:,3);
t2 = 0:0.001:(length(Fy2)/1000)-0.001;

% % ZERO TRIALS
% % Trial 2
% Fp2_0 = trial2_0(:,1);
% Fy2_0 = trial2_0(:,2);
% Fx2_0 = trial2_0(:,3);
% t2_0 = 0:0.001:(length(Fy2_0)/1000)-0.001;
 
% BUTTERWORTH FILTER
[b,a] = butter(10,20/500);
Fy2 = filtfilt(b,a,Fy2);
Fx2 = filtfilt(b,a,Fx2);
Fp2 = filtfilt(b,a,Fp2);

%% MANUALLY INPUT OFFSETS
figure
plot(t2,Fy2)
title('Zero Fy Force')
legend('Fy')
xlim([10 11])
ylim([-60 60])
[h offsetY] = ginput(1);

figure
plot(t2,Fx2)
title('Zero Fx Force')
legend('Fx')
xlim([10 11])
ylim([-60 60])
[h offsetX] = ginput(1);

% Fix Zeroing on Fx Fy Fp
Fx2 = Fx2-offsetX;%-mean(Fx2_0);

i3 = find(Fx2<25);
Fy2 = Fy2-offsetY;%-mean(Fy2(i3));
%Fy2 = Fy2--mean(Fy2_0);

% Recut Data to correct impulse calculations
i2 = find(Fy2>0);
j2 = find(Fy2<0);
Fy2 = Fy2(i2(1):j2(end));
Fx2 = Fx2(i2(1):j2(end));
Fp2 = Fp2(i2(1):j2(end));
t2 = 0:0.001:(length(Fy2)/1000)-0.001;


%% PULLING FORCE
if mean(Fp2)<0
    Fp2 = 0;
end
Fp2 = 9.81.*Fp2./1000;

avgPullForce = mean(Fp2);
maxPullForce = max(Fp2);
minPullForce = min(Fp2);
stdDev = std(Fp2);

disp(['Pulling Force:      ',num2str([avgPullForce]), ' g'])
disp(['Max Pull Force:     ',num2str([maxPullForce]), ' g'])
disp(['Min Pull Force:     ',num2str([minPullForce]), ' g'])
disp(['Std Dev Force:      ',num2str([stdDev]), ' g'])

%% PEAKS AND VALLEYS
% Average Peak Height
[pks,locs2] = findpeaks(Fy2,'MinPeakDistance',250);
avgpeak2 = linspace(mean(pks),mean(pks),length(locs2));
disp(['Peak Propelling:    ',num2str(avgpeak2(1)), ' N'])
pks2 = pks;


% Average Peak Depth
[pks,loc2] = findpeaks(-Fy2,'MinPeakDistance',250);
avgv2 = linspace(mean(pks),mean(pks),length(loc2));
disp(['Peak Braking:       ',num2str(avgv2(1)), ' N'])

%% ZERO FY BASED ON FX

for i = 1:length(Fy2)
    if Fx2(i)<25
        Fyy2(i) = 0;
    else
        Fyy2(i) = Fy2(i);
    end
end

% Show Effects of Zeroing Fy
figure
plot(t2,Fy2,t2,Fyy2)
title('Original vs Zeroed Fy')
legend('1','2')
xlim([28 30])


% Assign Zeros
Fy2 = Fyy2;
%% PLOT INITIAL DATA
figure
plot(t2,Fy2,t2,Fx2)
xlabel('Time [s]')
ylabel('Force [N]')
legend('Horizontal Force','Vertical Force')
xlim([0 2])

figure
plot(t2,Fp2)
xlabel('Time [s]')
ylabel('Force [N]')
legend('Pulling Force')
xlim([0 3])

if avgPullForce>7
    avgPullForce=8;
elseif avgPullForce>3&&avgPullForce<7
    avgPullForce=4;
else
    avgPullForce=0;
end
%% IMPULSE

% Find Indices of Peaks
i2 = find(Fy2<0);

% Inegrate to get Impulse
Imp2 = abs(trapz(Fy2(i2))/length(pks2))/1000;
disp(['Propelling Impulse: ',num2str(Imp2), ' Ns'])

% Inegrate to get Impulse
i2 = find(Fy2>0);
ImpB2 = abs(trapz(Fy2(i2))/length(pks2))/1000;
disp(['Braking Impulse:    ',num2str(ImpB2), ' Ns'])

% Difference in Braking and Propulsion
ImpDiff = Imp2-ImpB2;
disp(['Impulse Difference: ',num2str(ImpDiff(1)), ' Ns'])

%% STEP FREQUENCY 
for i = 1:length(locs2)-1
% Find Step Frequency
numPks2 = 1/(t2(locs2(i+1))-t2(locs2(i)));


% Find Contact Time per Step
i2 = find(Fy2(locs2(i):locs2(i+1))==0);
timeCont2 = (t2(locs2(i+1))-t2(locs2(i)))-length(i2)*0.001;

% Duty Factor
i2 = find(Fy2<0);
dutyF2 = 100*(length(t2)-length(i2))/length(t2);
end

disp(['Expected Difference:',num2str(avgPullForce/numPks2), ' Ns'])
disp(['Step Frequency:     ',num2str(numPks2), ' Hz'])
disp(['Contact Time:       ',num2str(timeCont2), ' s'])
disp(['Duty Factor:        ',num2str(dutyF2), ' %'])


disp(' ')
output = [avgpeak2(1) avgv2(1) Imp2 ImpB2 ImpDiff avgPullForce/numPks2  avgPullForce stdDev numPks2 timeCont2 dutyF2];
end
