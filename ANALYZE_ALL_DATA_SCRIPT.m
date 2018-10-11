%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyze Runner Data
% CREATED: 1/25/18
% MODIFIED: 3/29/18
%
% PURPOSE: 
%   Analyze input forces from treadmill
% INPUTS:
%   Data
% OUTPUTS:
%   Plots
% HOUSEKEEPING: 
clear all; close all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% NOTES
% Data files must be in '.xlsx' format
% When prompted click on approximately zero of the graphs you see
% Data is saved to an excel file of your naming
% Excel File with results will be saved to your current directory

%% PLEASE ENTER DIRECTORY OF EXCEL DATA FILES ON YOUR COMPUTER HERE
source_dir = 'C:\Users\chris\Google Drive\Documents\Research\Biomechanics\Experimental Trials Analysis and Data\BiomechData\S1\12';

%% PLEASE ENTER THE NAME OF THE RESULTS EXCEL FILE TO BE WRITTEN HERE
ExcelFileName = 'Results_S1_12.xlsx';







%% BEGIN CODE

global offsetX offsetY
offsetX =0;
offsetY =0;

% Call Main Analysis Function
source_files = dir(fullfile(source_dir, '*.xlsx'));

for i = 1:length(source_files)
    filename = fullfile(source_dir,source_files(i).name);
    data = xlsread(filename);
    close all;
    output(:,i) = analysis_Function(data);
end

% Parse Data
peak = output(1,:);    % Braking Force [N]
valley = output(2,:);  % Thrust Force [N]
propImp = output(3,:); % Propulsive Impulse [N-s]
brakeImp = output(4,:);% Braking Impulse [N-s]
impDiff = output(5,:); % Impulse Difference [N-s]
expDiff = output(6,:); % Expected Difference [N-s]
pullF = output(7,:);   % Pulling Force[N]
stdDev = output(8,:);  % Standard Deviation[N]
stepFreq = output(9,:);% Step Frequency [Hz]
contTime =output(10,:);% Contact Time [s]
duty = output(11,:);   % Duty Factor[%]


% Write to Excel File Titled "Results"
nameMat = {'Braking Force [N]','Thrust Force [N]','Propulsive Impulse [N-s]',....
    'Braking Impulse [N-s]','Impulse Difference [N-s]','Expected Difference [N-s]','Pulling Force [N]',....
    'Std Dev Pulling Force','Step Frequency [Hz]','Contact Time [s]', 'Duty Factor [%]'};
dataMat = [peak; valley; propImp; brakeImp; impDiff; expDiff; pullF;....
    stdDev; stepFreq; contTime; duty]'; 
dataMat = num2cell(dataMat);
dataS = [nameMat;dataMat];
xlswrite(ExcelFileName,dataS);