%% Version: 3.0.5b
clc
clear
close all

cd 'A:\Lin project\Data\'
listing = dir('*.tdms');
len = length(listing);
start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
sample_window_length = 200000;  %unit is us
Fs=1000000; % Sampling frequency
Ts=1/Fs;    % Sampling period
group_size = 5000;  %unit is us
U_nominal = 700;

U_avg =  0;
U_rms = 0;
I_avg_L1 = 0;
I_rms_L1 = 0;
I_avg_L2 = 0;
I_rms_L2 = 0;
I_avg_L3 = 0;
I_rms_L3 = 0;

leftover = 0;
% Network Settings
Setting_Time(1)=datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
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

Setting(1,:)=["on" "on" "on" "off"];
Setting(2,:)=["off" "off" "on" "off"];
Setting(3,:)=["off" "off" "on" "Hyundai Ioniq at EVCS3 (Charging did not work)"];
Setting(4,:)=["Reset system" "Reset system" "Reset system" "Reset system"];
Setting(5,:)=["on" "on" "on" "Charging Ioniq at EVCS3"];
Setting(6,:)=["on" "on" "on" "Discharging Nissan Leaf at EVCS 3"];
Setting(7,:)=["on" "on" "off" "Discharging Nissan Leaf at EVCS 3"];
Setting(8,:)=["on" "on" "off" "Charging Nissan at EVCS3"];
Setting(9,:)=["on" "on" "on" "Charging Nissan at EVCS3"];
Setting(10,:)=["on" "on" "on" "off"];
Setting(11,:)=["off" "on" "off" "off"];
Setting(12,:)=["off" "off" "off" "off"];
Setting(13,:)=["off" "off" "on" "off"];
Setting(14,:)=["off" "off" "on" "Charging Nissan at EVCS3"];
Setting(15,:)=["on" "on" "on" "Charging Nissan at EVCS3"];
Setting(16,:)=["on" "on" "on" "off"];
Setting(17,:)=["off" "off?" "on" "Charging Ioniq at EVCS3"];
Setting(18,:)=["off" "off" "on" "off"];
Setting(19,:)=["off" "off" "on" "Charging Nissan at EVCS3"];
Setting(20,:)=["Reset system" "Reset system" "Reset system" "Reset system"];
Setting(21,:)=["on" "on" "on" "off"];
% NonStationary
    isNonStatDistOccur = 0;
    hysteresis = 0.02*U_nominal;
    Swell_tr = 1.1*U_nominal;
    Dip_tr = 0.9*U_nominal; %Threashold_Dip
    Interruption_tr = 0.1*U_nominal;
    timecount = 0;
    isSwell = 0; %To flag status of the sample
    isDip = 0;
    isInterruption = 0;
    DipCount = 0;
    SwellCount = 0;
    InterruptionCount = 0;
    DipTime = 0;
    SwellTime = 0;
    InterruptionTime = 0;
    DipSpec = 0;
    SwellSpec = 0;
    InterruptionSpec = 0;
%Stationaty
    U_ripple = 0;
    RDF_Voltage = 0;
    RMS_Ripple_Factor_Voltage = 0;
    Peak_Ripple_Factor_Voltage = 0;
    I_ripple_L1 = 0;
    RDF_L1 = 0;
    RMS_Ripple_Factor_L1 = 0;
    Peak_Ripple_Factor_L1 = 0;
    I_ripple_L2 = 0;
    RDF_L2 = 0;
    RMS_Ripple_Factor_L2 = 0;
    Peak_Ripple_Factor_L2 = 0;
    I_ripple_L3 = 0;
    RDF_L3 = 0;
    RMS_Ripple_Factor_L3 = 0;
    Peak_Ripple_Factor_L3 = 0;

for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [U_avg,U_rms,I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,...
    isNonStatDistOccur,timecount,isSwell,isDip,...
    isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
    InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
    RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
    RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
    RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
    RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,leftover]...
    = evaluator(num,listing,sample_window_length,group_size,Fs,Ts,U_avg,U_rms,...
    I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,isNonStatDistOccur,...
    hysteresis,Swell_tr,Dip_tr,Interruption_tr,timecount,isSwell,isDip,...
    isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
    InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
    RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
    RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
    RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
    RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,leftover);
end

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

I_Atool_start =("Do you want to start the interactive tool? (Y/N)\n");
Usr_input = input(I_Atool_start,"s");
if Usr_input == "Y" || Usr_input == "Yes" || Usr_input == "yes" || Usr_input == "是" ...
        || Usr_input == "Oui" || Usr_input == "oui" || Usr_input == "Sí" || Usr_input == "sí" ||...
        Usr_input == "Да" || Usr_input == "да" || Usr_input == "da" || Usr_input == "y" || Usr_input == "نعم" 
    I_Atool_end =("Which kinds of distortion do you want to analysis? (Dip/Interruption/Swell)\nEnter any other thing to exit\n");
    Usr_input_2 = input(I_Atool_end,"s");
    while Usr_input_2 == "Dip" || Usr_input_2 == "Interruption" || Usr_input_2 == "Swell"...
            || Usr_input_2 == "dip" || Usr_input_2 == "interruption" || Usr_input_2 == "swell"
        if Usr_input_2 == "dip"
            Usr_input_2 = "Dip";
        elseif Usr_input_2 == "interruption"
            Usr_input_2 = "Interruption";
        elseif Usr_input_2 == "swell"
            Usr_input_2 = "Swell";
        else
        end
        fprintf('You have chosen %s.\n',Usr_input_2);
        I_Atool("Which number of this kind disturbance do you want to have a look?\n (e.g. For No.1, type 1)\n ");
        Usr_input_3 = input(I_Atool,"s");
        if Usr_input_2 == "Swell"
            fprintf('----------------------------------\n\n');
            fprintf('Swell No.%d \n',Usr_input_3);
            if Setting_Time(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(40*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                disp_endtime = time_5MS(40*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
            else 
                disp_starttime = time_5MS(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
                disp_endtime = time_5MS(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
            end
            fprintf('Start time: %s\n End time: %s\n',disp_starttime, disp_endtime);
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
            fprintf('During thie disturbance, the network is under the following setting(s)\n');
            for k = 1:(j-i+1)
                fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s,      EVC is %s.\n'...
                    ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
            end
            dist_len = Swell_time(Usr_input_3);
            x_data=SwellSpec(1:dist_len,Usr_input_3);
            pd = fitdist(x_data,'Normal');
            pd_avg = mean(pd);
            x_pdf = [1:0.1:100];
            y_data = pdf(pd,x_pdf);

            figure
            histogram(x_data,'Normalization','pdf')
            line(x_pdf,y_data)
            title('Distribution of this disturbance')
        elseif Usr_input_2 == "Interruption"
            fprintf('----------------------------------\n\n');
            fprintf('Interruption No.%d \n',Usr_input_3);
            if Setting_Time(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(40*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                disp_endtime = time_5MS(40*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
            else 
                disp_starttime = time_5MS(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                disp_endtime = time_5MS(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
            end
            fprintf('Start time: %s\n End time: %s\n',disp_starttime, disp_endtime);
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
            fprintf('During thie disturbance, the network is under the following setting(s)\n');
            for k = 1:(j-i+1)
                fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s,      EVC is %s.\n'...
                    ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
            end
            dist_len = Interruption_time(Usr_input_3);
            x_data=InterruptionSpec(1:dist_len,Usr_input_3);
            pd = fitdist(x_data,'Normal');
            pd_avg = mean(pd);
            x_pdf = [1:0.1:100];
            y_data = pdf(pd,x_pdf);

            figure
            histogram(x_data,'Normalization','pdf')
            line(x_pdf,y_data)
            title('Distribution of this disturbance')
        else
            fprintf('----------------------------------\n\n');
            fprintf('Dip No.%d \n',Usr_input_3);
            if Setting_Time(Usr_input_3,1) == 0 ...
                disp_starttime = time_5MS(40*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
                disp_endtime = time_5MS(40*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
            else 
                disp_starttime = time_5MS(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
                disp_endtime = time_5MS(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
            end
            fprintf('Start time: %s\n End time: %s\n',disp_starttime, disp_endtime);
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
            fprintf('During thie disturbance, the network is under the following setting(s)\n');
            for k = 1:(j-i+1)
                fprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s,      EVC is %s.\n'...
                    ,k,Setting(i+k-1,1),Setting(i+k-1,2),Setting(i+k-1,3),Setting(i+k-1,4));
            end
            dist_len = Dip_time(Usr_input_3);
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
        fprintf('----------------------------------\n\n');
        I_Atool_end =("Which kinds of distortion do you want to analysis? (Dip/Interruption/Swell)\nEnter any other thing to exit\n");
        Usr_input_2 = input(I_Atool_end,"s");
    end
else
end