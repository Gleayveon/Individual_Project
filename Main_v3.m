%% Version: 4.0.1
% clc
% clear
% close all
% 
% cd 'A:\Lin project'\Data\
% listing = dir('*.tdms');
% len = length(listing);
% start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% sample_window_length = 200000;  %unit is microsecond
% Fs=1000000; % Sampling frequency
% Ts=1/Fs;    % Sampling period
% group_size = 10000;  %unit is microsecond
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
% fprintf('Starting...\n\n');
% Network Settings
Setting_Time(1)=datetime('2023-09-26 13:47:47.010', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(2)=datetime('2023-09-26 13:48:37', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(3)=datetime('2023-09-26 14:05:00', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(4)=datetime('2023-09-26 14:18:20', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(5)=datetime('2023-09-26 14:25:00', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(6)=datetime('2023-09-26 14:29:58', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(7)=datetime('2023-09-26 14:47:07', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(8)=datetime('2023-09-26 14:52:18', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(9)=datetime('2023-09-26 14:54:41', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(10)=datetime('2023-09-26 14:57:10', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(11)=datetime('2023-09-26 14:58:11', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(12)=datetime('2023-09-26 14:59:00', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(13)=datetime('2023-09-26 15:00:18', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(14)=datetime('2023-09-26 15:04:36', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(15)=datetime('2023-09-26 15:08:59', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(16)=datetime('2023-09-26 15:10:43', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(17)=datetime('2023-09-26 15:11:38', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(18)=datetime('2023-09-26 15:16:17', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(19)=datetime('2023-09-26 15:18:54', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(20)=datetime('2023-09-26 15:32:31', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Setting_Time(21)=datetime('2023-09-26 15:33:23', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% 
% Setting(1,:)=["on" "on" "on" "off"];
% Setting(2,:)=["off" "off" "on" "off"];
% Setting(3,:)=["off" "off" "on" "Hyundai Ioniq at EVCS3 (Charging did not work)"];
% Setting(4,:)=["Reset system" "Reset system" "Reset system" "Reset system"];
% Setting(5,:)=["on" "on" "on" "Charging Ioniq at EVCS3"];
% Setting(6,:)=["on" "on" "on" "Discharging Nissan Leaf at EVCS 3"];
% Setting(7,:)=["on" "on" "off" "Discharging Nissan Leaf at EVCS 3"];
% Setting(8,:)=["on" "on" "off" "Charging Nissan at EVCS3"];
% Setting(9,:)=["on" "on" "on" "Charging Nissan at EVCS3"];
% Setting(10,:)=["on" "on" "on" "off"];
% Setting(11,:)=["off" "on" "off" "off"];
% Setting(12,:)=["off" "off" "off" "off"];
% Setting(13,:)=["off" "off" "on" "off"];
% Setting(14,:)=["off" "off" "on" "Charging Nissan at EVCS3"];
% Setting(15,:)=["on" "on" "on" "Charging Nissan at EVCS3"];
% Setting(16,:)=["on" "on" "on" "off"];
% Setting(17,:)=["off" "off?" "on" "Charging Ioniq at EVCS3"];
% Setting(18,:)=["off" "off" "on" "off"];
% Setting(19,:)=["off" "off" "on" "Charging Nissan at EVCS3"];
% Setting(20,:)=["Reset system" "Reset system" "Reset system" "Reset system"];
% Setting(21,:)=["on" "on" "on" "off"];
% fprintf('System Settings Loaded.\n\n');
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
%     Dip = 0;
%     Swell = 0;
%     Interruption = 0;
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
%     RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,leftover]...
%     = evaluator(num,listing,sample_window_length,group_size,Fs,Ts,U_avg,U_rms,...
%     I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,isNonStatDistOccur,...
%     hysteresis,Swell_tr,Dip_tr,Interruption_tr,timecount,isSwell,isDip,...
%     isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
%     InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
%     RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
%     RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
%     RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
%     RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,leftover);
% end
%     fprintf('Data Analysis Finished.\n\n');
% 
%     Swell_time = 0;
%     Swell_spec = U_nominal;
%     Dip_time = 0;
%     Dip_spec = U_nominal;
%     Interruption_time = 0;
%     Interruption_spec = U_nominal;
%     Swell_timesum = 0;
%     Dip_timesum = 0;
%     Interruption_timesum = 0;
% 
% % Time Stamp
%     time_5MS_SS = 10:10:10*length(U_avg);
%     time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
%     time_5MS = cat(1, time_5MS_Cell{:});
%     time_200MS_SS = 200:200:200*length(RDF_L1);
%     time_200MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS, 'UniformOutput', false);
%     time_200MS = cat(1, time_200MS_Cell{:});
%     fprintf('Time Stemps Allocated.\n\n');
% 
% for i = 1:SwellCount
%     Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
%     Swell_time(i) = group_size * sum(SwellTime(:,i));
%     Swell_spec(i) = max(SwellSpec(1:sum(SwellTime(:,i)),i));
% end
% for i = 1:DipCount
%     Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i));
%     Dip_time(i) = group_size * sum(DipTime(:,i));
%     Dip_spec(i) = min(DipSpec(1:sum(DipTime(:,i)),i));
% end
% for i = 1:InterruptionCount
%     Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i));
%     Interruption_time(i) = group_size * sum(InterruptionTime(:,i));
%     Interruption_spec(i) = min(InterruptionSpec(1:sum(InterruptionTime(:,i)),i));
% end

disp('=========Detection_Report=========');
fprintf(['In these signals sampled,\n']);
if SwellCount == 0
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
if SwellCount == 0
    fprintf(['There is no Swell in these sample.\n'])
else
    for i = 1:SwellCount
        fprintf('Swell No.%d: Maximum Urms is %.4f V. Duration is %d ms.\n', i, Swell_spec(i), Swell_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if DipCount == 0
    fprintf(['There is no Dip in these sample.\n'])
else
    for i = 1:DipCount
        fprintf('Dip No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Dip_spec(i), Dip_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if InterruptionCount == 0
    fprintf(['There is no Interruption in these sample.\n'])
else
    for i = 1:InterruptionCount
        fprintf('Interruption No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Interruption_spec(i), Interruption_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');
%%

I_Atool_start =("\nDo you want to start the interactive tool? (Y/N)\n");
Usr_input = input(I_Atool_start,"s");
if Usr_input == "Y" || Usr_input == "Yes" || Usr_input == "yes" || Usr_input == "是" ...
        || Usr_input == "Oui" || Usr_input == "oui" || Usr_input == "Sí" || Usr_input == "sí" ||...
        Usr_input == "Да" || Usr_input == "да" || Usr_input == "da" || Usr_input == "y" || Usr_input == "نعم"
    I_Atool_end =("\nWhich kinds of distortion do you want to analysis? (Dip/Interruption/Swell/System Setting)\nEnter any other thing to exit\n");
    Usr_input_2 = input(I_Atool_end,"s");
    while Usr_input_2 == "Dip" || Usr_input_2 == "Interruption" || Usr_input_2 == "Swell"...
            || Usr_input_2 == "dip" || Usr_input_2 == "interruption" || Usr_input_2 == "swell"...
            || Usr_input_2 == "SystemSetting" || Usr_input_2 == "Systemsetting" || Usr_input_2 == "systemSetting"...
            || Usr_input_2 == "systemsetting" || Usr_input_2 == "system setting"
        if Usr_input_2 == "dip"
            Usr_input_2 = "Dip";
        elseif Usr_input_2 == "interruption"
            Usr_input_2 = "Interruption";
        elseif Usr_input_2 == "swell"
            Usr_input_2 = "Swell";
        else
        end
        if Usr_input_2 == "SystemSetting"
            Usr_input_2 = "System Setting";
        elseif Usr_input_2 == "Systemsetting"
            Usr_input_2 = "System Setting";
        elseif Usr_input_2 == "systemSetting"
            Usr_input_2 = "System Setting";
        elseif Usr_input_2 == "systemsetting"
            Usr_input_2 = "System Setting";
        elseif Usr_input_2 == "system setting"
            Usr_input_2 = "System Setting";
        else
        end
        if Usr_input_2 == "Dip" || Usr_input_2 == "Interruption" || Usr_input_2 == "Swell"
            fprintf('\nYou have chosen %s.\n',Usr_input_2);
            I_Atool = ("Which number of this kind disturbance do you want to have a look?\n (e.g. For No.1, type 1)\n ");
            Usr_input_3 = input(I_Atool);
            if Usr_input_2 == "Swell"
                fprintf('----------------------------------\n\n');
                fprintf('Swell No.%d \n',Usr_input_3);
                if Swell(Usr_input_3,1) == 0 ...
                        disp_starttime = time_5MS(20*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                    disp_endtime = time_5MS(20*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
                else
                    disp_starttime = time_5MS(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
                    disp_endtime = time_5MS(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
                end
                fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                for i = 1:length(Setting)
                    if Setting_Time(i) < disp_starttime
                        continue
                    else
                        break
                    end
                end
                for j = 1:length(Setting)
                    if Setting_Time(j) < disp_endtime
                        continue
                    else
                        break
                    end
                end
                Tolerance_Within1 = 0;
                Tolerance_Within2 = 0;
                Tolerance_Without = 0;
                Tolerance_Spec = SwellSpec(:,Usr_input_3);
                temp2 = 1;
                temp3 = 1;
                temp4 = 1;
                for temp = 1:(Swell_time(Usr_input_3)/group_size)
                    if Tolerance_Spec(temp) < 1.25*U_nominal
                        Tolerance_Within1(temp2) = group_size;
                        temp2 = temp2 + 1;
                    elseif Tolerance_Spec(temp) < 1.4*U_nominal && Tolerance_Spec(temp) >= 1.25*U_nominal
                        Tolerance_Within2(temp3) = group_size;
                        temp3 = temp3 + 1;
                    else
                        Tolerance_Without(temp4) = group_size;
                        temp4 = temp4 + 1;
                    end
                end
                if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                else
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                end
                fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                for k = 1:(j-i+1)
                    fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                        ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
                end
                dist_len = Swell_time(Usr_input_3)/group_size;
                if dist_len == 1
                    fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                else
                    x_data=SwellSpec(1:dist_len,Usr_input_3);
                    pd = fitdist(x_data,'Normal');
                    pd_avg = mean(pd);
                    x_pdf = [1:0.1:100];
                    y_data = pdf(pd,x_pdf);

                    figure
                    histogram(x_data,'Normalization','pdf');
                    line(x_pdf,y_data)
                    title('Distribution of the selected disturbance');
                end
            elseif Usr_input_2 == "Interruption"
                fprintf('----------------------------------\n\n');
                fprintf('Interruption No.%d \n',Usr_input_3);
                if Interruption(Usr_input_3,1) == 0 ...
                        disp_starttime = time_5MS(20*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                    disp_endtime = time_5MS(20*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
                else
                    disp_starttime = time_5MS(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                    disp_endtime = time_5MS(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
                end
                fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                for i = 1:length(Setting)
                    if Setting_Time(i) < disp_starttime
                        continue
                    else
                        break
                    end
                end
                for j = 1:length(Setting)
                    if Setting_Time(j) < disp_endtime
                        continue
                    else
                        break
                    end
                end
                if Interruption_time(Usr_input_3) < 10000
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                else
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                end
                fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                for k = 1:(j-i+1)
                    fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                        ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
                end
                dist_len = Interruption_time(Usr_input_3)/group_size;
                if dist_len == 1
                    fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                else
                    x_data=InterruptionSpec(1:dist_len,Usr_input_3);
                    pd = fitdist(x_data,'Normal');
                    pd_avg = mean(pd);
                    x_pdf = [1:0.1:100];
                    y_data = pdf(pd,x_pdf);

                    figure
                    histogram(x_data,'Normalization','pdf')
                    line(x_pdf,y_data)
                    title('Distribution of this disturbance')
                end
            else
                fprintf('----------------------------------\n\n');
                fprintf('Dip No.%d \n',Usr_input_3);
                if Dip(Usr_input_3,1) == 0 ...
                        disp_starttime = time_5MS(20*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
                    disp_endtime = time_5MS(20*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
                else
                    disp_starttime = time_5MS(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
                    disp_endtime = time_5MS(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
                end
                fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                for i = 1:length(Setting)
                    if Setting_Time(i) < disp_starttime
                        continue
                    else
                        break
                    end
                end
                for j = 1:length(Setting)
                    if Setting_Time(j) < disp_endtime
                        continue
                    else
                        break
                    end
                end
                Tolerance_Within1 = 0;
                Tolerance_Within2 = 0;
                Tolerance_Without = 0;
                Tolerance_Spec = DipSpec(:,Usr_input_3);
                temp2 = 1;
                temp3 = 1;
                temp4 = 1;
                for temp = 1:(Dip_time(Usr_input_3)/group_size)
                    if Tolerance_Spec(temp) > 0.7*U_nominal
                        Tolerance_Within1(temp2) = group_size;
                        temp2 = temp2 + 1;
                    elseif Tolerance_Spec(temp) > 0.6*U_nominal && Tolerance_Spec(temp) <= 0.7*U_nominal
                        Tolerance_Within2(temp3) = group_size;
                        temp3 = temp3 + 1;
                    else
                        Tolerance_Without(temp4) = group_size;
                        temp4 = temp4 + 1;
                    end
                end
                if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                else
                    fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                        '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                        '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                end
                fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                for k = 1:(j-i+1)
                    fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                        ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
                end
                dist_len = Dip_time(Usr_input_3)/group_size;
                if dist_len == 1
                    fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                else
                    x_data=DipSpec(1:dist_len,Usr_input_3);
                    pd = fitdist(x_data,'Normal');
                    pd_avg = mean(pd);
                    x_pdf = [1:0.1:100];
                    y_data = pdf(pd,x_pdf);

                    figure
                    histogram(x_data,'Normalization','pdf')
                    line(x_pdf,y_data)
                    title('Distribution of this disturbance')
                end
            end
            fprintf('----------------------------------\n\n');
            I_Atool_end =("Which kinds of distortion do you want to analysis? (Dip/Interruption/Swell)\nEnter any other thing to exit\n");
            Usr_input_2 = input(I_Atool_end,"s");
        elseif Usr_input_2 == "System Setting"
            fprintf('\nYou have chosen %s.\n',Usr_input_2);
            for i = 1:length(Setting_Time)
                if i == 1
                    fprintf("No.:    Description\n");
                    fprintf("%3d:    Before %s\n",i,Setting_Time(i));
                    fprintf("%3d:    %s to %s\n",i+1,Setting_Time(i),Setting_Time(i+1));
                elseif i == length(Setting_Time)
                    fprintf("%3d:    %s to End\n",i+1,Setting_Time(i));
                else
                    fprintf("%3d:    %s to %s\n",i+1,Setting_Time(i),Setting_Time(i+1));
                end
            end
            I_Atool = ("Enter the number shown above of the period you would like to analysis.\n (e.g. For No.1, type 1)\n ");
            Usr_input_3 = input(I_Atool);
            if Usr_input_3 == 1
                start_5MS = 1;
                start_200MS = 1;
            else
                Usr_input_3_1 = Usr_input_3 - 1;
                temp = 0;
                for j = 1:length(time_5MS)
                    if time_5MS(j) <= Setting_Time(Usr_input_3_1)
                        temp = temp + 1;
                    else
                        start_5MS = temp;
                        start_200MS = floor(start_5MS/20);
                        if floor(start_5MS/20) == 0
                            start_200MS = 1;
                        end
                        break
                    end
                end
            end
            if Usr_input_3 == length(Setting_Time) + 1
                termin_5MS = length(time_5MS);
                termin_200MS = floor(length(time_5MS)/20);
            else
                temp = 0;
                for j = 1:length(time_5MS)
                    if time_5MS(j) <= Setting_Time(Usr_input_3_1 + 1)
                        temp = temp + 1;
                    else
                        termin_5MS = temp;
                        termin_200MS = floor(termin_5MS/20);
                        break
                    end
                end
            end
            figure
            subplot(2,3,1)
            time = time_5MS(start_5MS:termin_5MS);
            yyaxis left
            plot(time_5MS(start_5MS:termin_5MS),U_rms(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
            ylabel('V')
            yyaxis right
            plot(time_5MS(start_5MS:termin_5MS),I_rms_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_rms_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_rms_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
            ylabel('A')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title("RMS value of voltage and current during this period")
            subplot(2,3,2)
            yyaxis left
            plot(time_5MS(start_5MS:termin_5MS),U_ripple(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
            ylabel('V')
            yyaxis right
            plot(time_5MS(start_5MS:termin_5MS),I_ripple_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_ripple_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_ripple_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
            ylabel('A')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('Ripple value of voltage and current during this period')
            subplot(2,3,3)
            yyaxis left
            plot(time_5MS(start_5MS:termin_5MS),U_avg(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
            ylabel('V')
            yyaxis right
            plot(time_5MS(start_5MS:termin_5MS),I_avg_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_avg_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_5MS(start_5MS:termin_5MS),I_avg_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
            ylabel('A')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title("Average value of voltage and current during this period");
            subplot(2,3,4)
            time = time_200MS(start_200MS:termin_200MS);
            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),RDF_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),RDF_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RDF_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RDF_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('RDF value of voltage and current during this period');
            subplot(2,3,5)
            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('Peak Ripple Factor value of voltage and current during this period');
            subplot(2,3,6)
            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('RMS Ripple Factor value of voltage and current during this period');
            fprintf('----------------------------------\n\n');
            I_Atool_end =("Which kinds of distortion do you want to analysis? (Dip/Interruption/Swell)\nEnter any other thing to exit\n");
            Usr_input_2 = input(I_Atool_end,"s");
        end
        fprintf('==========================\n\n       Tool Terminated       \n\n==========================\n');
    end
elseif Usr_input == "uuddlrlrab" || Usr_input == "UUDDLRLRAB"
    Yuki = 1;
    fprintf('=======================\n\n       Debug Mode       \n\n=======================\n');
    for Usr_input_3 = 1:SwellCount
        fprintf('----------------------------------\n\n');
        fprintf('Swell No.%d \n',Usr_input_3);
        if Swell(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(20*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
            disp_endtime = time_5MS(20*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
        else
            disp_starttime = time_5MS(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
            disp_endtime = time_5MS(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
        end
        fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
        for i = 1:length(Setting)
            if Setting_Time(i) < disp_starttime
                continue
            else
                break
            end
        end
        for j = 1:length(Setting)
            if Setting_Time(j) < disp_endtime
                continue
            else
                break
            end
        end
        Tolerance_Within1 = 0;
        Tolerance_Within2 = 0;
        Tolerance_Without = 0;
        Tolerance_Spec = SwellSpec(:,Usr_input_3);
        temp2 = 1;
        temp3 = 1;
        temp4 = 1;
        for temp = 1:(Swell_time(Usr_input_3)/group_size)
            if Tolerance_Spec(temp) < 1.25*U_nominal
                Tolerance_Within1(temp2) = group_size;
                temp2 = temp2 + 1;
            elseif Tolerance_Spec(temp) < 1.4*U_nominal && Tolerance_Spec(temp) >= 1.25*U_nominal
                Tolerance_Within2(temp3) = group_size;
                temp3 = temp3 + 1;
            else
                Tolerance_Without(temp4) = group_size;
                temp4 = temp4 + 1;
            end
        end
        if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n..' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        else
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        end
        fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
        for k = 1:(j-i+1)
            fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
        end
        dist_len = Swell_time(Usr_input_3)/group_size;
        if dist_len == 1
            fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
        else
            x_data=SwellSpec(1:dist_len,Usr_input_3);
            pd = fitdist(x_data,'Normal');
            pd_avg = mean(pd);
            x_pdf = [1:0.1:100];
            y_data = pdf(pd,x_pdf);

            figure(Yuki)
            histogram(x_data,'Normalization','pdf');
            line(x_pdf,y_data)
            title('Distribution of the selected disturbance');
            Yuki = Yuki + 1;
        end
    end
    for Usr_input_3 = 1:InterruptionCount
        fprintf('----------------------------------\n\n');
        fprintf('Interruption No.%d \n',Usr_input_3);
        if Interruption(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(20*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
            disp_endtime = time_5MS(20*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
        else
            disp_starttime = time_5MS(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
            disp_endtime = time_5MS(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
        end
        fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
        for i = 1:length(Setting)
            if Setting_Time(i) < disp_starttime
                continue
            else
                break
            end
        end
        for j = 1:length(Setting)
            if Setting_Time(j) < disp_endtime
                continue
            else
                break
            end
        end
        if Interruption_time(Usr_input_3) < 10000
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n..' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        else
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        end
        fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
        for k = 1:(j-i+1)
            fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
        end
        dist_len = Interruption_time(Usr_input_3)/group_size;
        if dist_len == 1
            fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
        else
            x_data=InterruptionSpec(1:dist_len,Usr_input_3);
            pd = fitdist(x_data,'Normal');
            pd_avg = mean(pd);
            x_pdf = [1:0.1:100];
            y_data = pdf(pd,x_pdf);

            figure(Yuki)
            histogram(x_data,'Normalization','pdf')
            line(x_pdf,y_data)
            title('Distribution of this disturbance')
            Yuki = Yuki + 1;
        end
    end
    for Usr_input_3 = 1:DipCount
        fprintf('----------------------------------\n\n');
        fprintf('Dip No.%d \n',Usr_input_3);
        if Dip(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(20*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
            disp_endtime = time_5MS(20*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
        else
            disp_starttime = time_5MS(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
            disp_endtime = time_5MS(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
        end
        fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
        for i = 1:length(Setting)
            if Setting_Time(i) < disp_starttime
                continue
            else
                break
            end
        end
        for j = 1:length(Setting)
            if Setting_Time(j) < disp_endtime
                continue
            else
                break
            end
        end
        Tolerance_Within1 = 0;
        Tolerance_Within2 = 0;
        Tolerance_Without = 0;
        Tolerance_Spec = DipSpec(:,Usr_input_3);
        temp2 = 1;
        temp3 = 1;
        temp4 = 1;
        for temp = 1:(Dip_time(Usr_input_3)/group_size)
            if Tolerance_Spec(temp) > 0.7*U_nominal
                Tolerance_Within1(temp2) = group_size;
                temp2 = temp2 + 1;
            elseif Tolerance_Spec(temp) > 0.6*U_nominal && Tolerance_Spec(temp) <= 0.7*U_nominal
                Tolerance_Within2(temp3) = group_size;
                temp3 = temp3 + 1;
            else
                Tolerance_Without(temp4) = group_size;
                temp4 = temp4 + 1;
            end
        end
        if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        else
            fprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
        end
        fprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
        for k = 1:(j-i+1)
            fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
        end
        dist_len = Dip_time(Usr_input_3)/group_size;
        if dist_len == 1
            fprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
        else
            x_data=DipSpec(1:dist_len,Usr_input_3);
            pd = fitdist(x_data,'Normal');
            pd_avg = mean(pd);
            x_pdf = [1:0.1:100];
            y_data = pdf(pd,x_pdf);

            figure(Yuki)
            histogram(x_data,'Normalization','pdf')
            line(x_pdf,y_data)
            title('Distribution of this disturbance')
            Yuki = Yuki + 1;
        end
    end
    for Usr_input_3 = 1:(length(Setting_Time) + 1)
        if Usr_input_3 == 1
            start_5MS = 1;
            start_200MS = 1;
        else
            Usr_input_3_1 = Usr_input_3 - 1;
            temp = 0;
            for j = 1:length(time_5MS)
                if time_5MS(j) <= Setting_Time(Usr_input_3_1)
                    temp = temp + 1;
                else
                    start_5MS = temp;
                    start_200MS = floor(start_5MS/20);
                    if floor(start_5MS/20) == 0
                        start_200MS = 1;
                    end
                    break
                end
            end
        end
        if Usr_input_3 == length(Setting_Time) + 1
            termin_5MS = length(time_5MS);
            termin_200MS = floor(length(time_5MS)/20);
        else
            temp = 0;
            for j = 1:length(time_5MS)
                if time_5MS(j) <= Setting_Time(Usr_input_3_1 + 1)
                    temp = temp + 1;
                else
                    termin_5MS = temp;
                    termin_200MS = floor(termin_5MS/20);
                    break
                end
            end
        end
        figure(Yuki)
        subplot(2,3,1)
        time = time_5MS(start_5MS:termin_5MS);
        yyaxis left
        plot(time_5MS(start_5MS:termin_5MS),U_rms(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
        ylabel('V')
        yyaxis right
        plot(time_5MS(start_5MS:termin_5MS),I_rms_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_rms_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_rms_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
        ylabel('A')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title("RMS value of voltage and current during this period")
        subplot(2,3,2)
        yyaxis left
        plot(time_5MS(start_5MS:termin_5MS),U_ripple(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
        ylabel('V')
        yyaxis right
        plot(time_5MS(start_5MS:termin_5MS),I_ripple_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_ripple_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_ripple_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
        ylabel('A')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title('Ripple value of voltage and current during this period')
        subplot(2,3,3)
        yyaxis left
        plot(time_5MS(start_5MS:termin_5MS),U_avg(start_5MS:termin_5MS),'Color','#633736',LineStyle='-');
        ylabel('V')
        yyaxis right
        plot(time_5MS(start_5MS:termin_5MS),I_avg_L1(start_5MS:termin_5MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_avg_L2(start_5MS:termin_5MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_5MS(start_5MS:termin_5MS),I_avg_L3(start_5MS:termin_5MS),'Color','#9CC38A',LineStyle='-');
        ylabel('A')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title("Average value of voltage and current during this period");
        subplot(2,3,4)
        time = time_200MS(start_200MS:termin_200MS);
        yyaxis left
        plot(time_200MS(start_200MS:termin_200MS),RDF_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
        ylabel('Percent (%)')
        yyaxis right
        plot(time_200MS(start_200MS:termin_200MS),RDF_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),RDF_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),RDF_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
        ylabel('Percent (%)')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title('RDF value of voltage and current during this period');
        subplot(2,3,5)
        yyaxis left
        plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
        ylabel('Percent (%)')
        yyaxis right
        plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
        ylabel('Percent (%)')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title('Peak Ripple Factor value of voltage and current during this period');
        subplot(2,3,6)
        yyaxis left
        plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
        ylabel('Percent (%)')
        yyaxis right
        plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
        hold on
        plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
        ylabel('Percent (%)')
        xlabel('time')
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title('RMS Ripple Factor value of voltage and current during this period');
        Yuki = Yuki + 1;
    end
    fprintf('==========================\n\n       Tool Terminated       \n\n==========================\n');
else
    fprintf('==========================\n\n       Tool Terminated       \n\n==========================\n');
end