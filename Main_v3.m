%% Version: 3.0.2
% clc
% clear
% close all
% 
% cd 'A:\Lin project\Data\'
% listing = dir('*.tdms');
% len = length(listing);
% start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% sample_window_length = 200000;  %unit is us
% Fs=1000000; % Sampling frequency
% Ts=1/Fs;    % Sampling period
% group_size = 5000;  %unit is us
% U_nominal = 700;
% 
% U_avg =  0;
% U_rms = 0;
% I_avg_L1 = 0;
% I_rms_L1 = 0;
% I_avg_L2 = 0;
% I_rms_L2 = 0;
% I_avg_L3 = 0;
% I_rms_L3 = 0;
% 
% leftover = 0;
% 
% % NonStationary
%     isNonStatDistOccur = 0;
%     hysteresis = 0.02*U_nominal;
%     Swell_tr = 1.1*U_nominal;
%     Dip_tr = 0.9*U_nominal; %Threashold_Dip
%     Interruption_tr = 0.1*U_nominal;
%     timecount = 0;
%     isSwell = 0; %To flag status of the sample
%     isDip = 0;
%     isInterruption = 0;
%     DipCount = 0;
%     SwellCount = 0;
%     InterruptionCount = 0;
%     DipTime = 0;
%     SwellTime = 0;
%     InterruptionTime = 0;
%     DipSpec = 0;
%     SwellSpec = 0;
%     InterruptionSpec = 0;
% %Stationaty
%     U_ripple = 0;
%     RDF_Voltage = 0;
%     RMS_Ripple_Factor_Voltage = 0;
%     Peak_Ripple_Factor_Voltage = 0;
%     I_ripple_L1 = 0;
%     RDF_L1 = 0;
%     RMS_Ripple_Factor_L1 = 0;
%     Peak_Ripple_Factor_L1 = 0;
%     I_ripple_L2 = 0;
%     RDF_L2 = 0;
%     RMS_Ripple_Factor_L2 = 0;
%     Peak_Ripple_Factor_L2 = 0;
%     I_ripple_L3 = 0;
%     RDF_L3 = 0;
%     RMS_Ripple_Factor_L3 = 0;
%     Peak_Ripple_Factor_L3 = 0;
% 
% for num = 1:len
%     cd 'A:\Lin project\Individual_Project'
%     [U_avg,U_rms,I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,...
%     isNonStatDistOccur,timecount,isSwell,isDip,...
%     isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
%     InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
%     RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
%     RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
%     RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
%     RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,leftover]...
%     = evaluator(num,listing,sample_window_length,group_size,Fs,Ts,U_avg,U_rms,...
%     I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,isNonStatDistOccur,...
%     hysteresis,Swell_tr,Dip_tr,Interruption_tr,timecount,isSwell,isDip,...
%     isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
%     InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
%     RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
%     RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
%     RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
%     RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,leftover);
% end

    Swell_time = 0;
    Swell_spec = U_nominal;
    Dip_time = 0;
    Dip_spec = U_nominal;
    Interruption_time = 0;
    Interruption_spec = U_nominal;
    Swell_timesum = 0;
    Dip_timesum = 0;
    Interruption_timesum = 0;

for i = 1:SwellCount
    Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
    Swell_time(i) = group_size * sum(SwellTime(:,i));
    Swell_spec(i) = max(SwellSpec(1:sum(SwellTime(:,i)),i));
end
for i = 1:DipCount
    Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i));
    Dip_time(i) = group_size * sum(DipTime(:,i));
    Dip_spec(i) = min(DipSpec(1:sum(DipTime(:,i)),i));
end
for i = 1:InterruptionCount
    Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i));
    Interruption_time(i) = group_size * sum(InterruptionTime(:,i));
    Interruption_spec(i) = min(InterruptionSpec(1:sum(InterruptionTime(:,i)),i));
end

disp('=========Detection_Report=========');
fprintf(['In these signals sampled,\n']);
if SwellCount == 0;
    fprintf(['There is no Swell in these sample.\n'])
else
    fprintf(['%d Swell(s) have been identified.\n'],SwellCount);
end
if DipCount == 0
    fprintf(['There is no Dip in these sample.\n'])
else
    fprintf(['%d Dip(s) have been identified.\n'],DipCount);
end
if InterruptionCount == 0
    fprintf(['There is no Interruption in these sample.\n'])
else
    fprintf(['%d Interruption(s) have been identified.\n'],InterruptionCount);
end
fprintf('-------------------------------------\n');
if SwellCount == 0;
    fprintf(['There is no Swell in these sample.\n'])
else
    for i = 1:SwellCount
        fprintf('Swell No.%d: Maximum Urms is %.4f V. Duration is %d ms.\n', i, Swell_spec(i), Swell_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if DipCount == 0;
    fprintf(['There is no Dip in these sample.\n'])
else
    for i = 1:DipCount
        fprintf('Dip No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Dip_spec(i), Dip_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if InterruptionCount == 0;
    fprintf(['There is no Interruption in these sample.\n'])
else
    for i = 1:InterruptionCount
        fprintf('Interruption No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Interruption_spec(i), Interruption_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');
