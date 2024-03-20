%%   EVE-Main Script
%       Including:
%       Define Global Variables, Time Stamp Mapping, Report generator, Interactive Tool
%       Version: 4.2.7
%       2024.02.25
% %% Preparation
% clc
% clear
% close all
% config = readlines("config.csv"); %The configure file name
% MLPath = config(2);
% DTPath = config(3);
% U_nominal = double(config(4));
% group_size = double(config(5));
% sample_window_length = double(config(6));
% Fs = double(config(7));
% Threshold_Dip = double(config(8));
% Threshold_Swell = double(config(9));
% Threshold_Interruption = double(config(10));
% Threshold_Hysteresis = double(config(11));
% start_time = datetime(string(config(12)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% GENRPT = str2num(config(13));
% Ts=1/Fs;    % Sampling period
% 
% cd(string(DTPath)) %Go to the Data folder to get the list of whole data
% listing = dir('*.tdms');
% len = length(listing);
% 
% 
% % GENRPT = 0; %For demo only
% U_avg =  0; %Create variable's heading, which will be deleted after the first sample is analysised
% U_rms = 0;
% I_avg_L1 = 0;
% I_rms_L1 = 0;
% I_avg_L2 = 0;
% I_rms_L2 = 0;
% I_avg_L3 = 0;
% I_rms_L3 = 0;
% U_rms_10ms = 0;
% I_rms_L1_10ms = 0;
% I_rms_L2_10ms = 0;
% I_rms_L3_10ms = 0;
% 
% U_rms_20ms = 0;
% I_rms_L1_20ms = 0;
% I_rms_L2_20ms = 0;
% I_rms_L3_20ms = 0;
% 
% leftover = 0;
% fprintf('Starting...\n\n');
% % Network Settings
% cd(string(MLPath))
% if exist("setting_time.csv", 'file') == 2 && exist("setting.csv",'file') == 2
%     Setting_Times = readlines("setting_time.csv");
%     for i = 1:length(Setting_Times)
%         Setting_Time(i) = datetime(string(Setting_Times(i)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
%     end
%     Setting = readtable("setting.csv",'ReadVariableNames', false);
% else
% end
% fprintf('System Settings Loaded.\n\n');
% % NonStationary
% isNonStatDistOccur = 0; %Heading of Non-stationary disturbance Occur
% hysteresis = Threshold_Hysteresis*U_nominal;
% Swell_tr = Threshold_Swell*U_nominal;
% Dip_tr = Threshold_Dip*U_nominal;
% Interruption_tr = Threshold_Interruption*U_nominal;
% timecount = 0;
% isSwell = 0; %To flag status of the sample
% isDip = 0;
% isInterruption = 0;
% DipCount = 0;
% SwellCount = 0;
% InterruptionCount = 0;
% DipTime = 0;
% SwellTime = 0;
% InterruptionTime = 0;
% DipSpec = 0;
% SwellSpec = 0;
% InterruptionSpec = 0;
% Dip = 0;
% Swell = 0;
% Interruption = 0;
% %Stationaty
% U_ripple = 0;
% RDF_Voltage = 0;
% RMS_Ripple_Factor_Voltage = 0;
% Peak_Ripple_Factor_Voltage = 0;
% I_ripple_L1 = 0;
% RDF_L1 = 0;
% RMS_Ripple_Factor_L1 = 0;
% Peak_Ripple_Factor_L1 = 0;
% I_ripple_L2 = 0;
% RDF_L2 = 0;
% RMS_Ripple_Factor_L2 = 0;
% Peak_Ripple_Factor_L2 = 0;
% I_ripple_L3 = 0;
% RDF_L3 = 0;
% RMS_Ripple_Factor_L3 = 0;
% Peak_Ripple_Factor_L3 = 0;
% %% Data Analysis
% for num = 1:len
%     [U_avg,U_rms,I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,...
%         isNonStatDistOccur,timecount,isSwell,isDip,...
%         isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
%         InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
%         RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
%         RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
%         RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
%         RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,...
%         U_rms_10ms,I_rms_L1_10ms,I_rms_L2_10ms,I_rms_L3_10ms,...
%         U_rms_20ms,I_rms_L1_20ms,I_rms_L2_20ms,I_rms_L3_20ms,MLPath,DTPath,leftover]...
%         = evaluator(num,listing,sample_window_length,group_size,Fs,Ts,U_avg,U_rms,...
%         I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,isNonStatDistOccur,...
%         hysteresis,Swell_tr,Dip_tr,Interruption_tr,timecount,isSwell,isDip,...
%         isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
%         InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
%         RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
%         RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
%         RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
%         RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,...
%         U_rms_10ms,I_rms_L1_10ms,I_rms_L2_10ms,I_rms_L3_10ms,...
%         U_rms_20ms,I_rms_L1_20ms,I_rms_L2_20ms,I_rms_L3_20ms,MLPath,DTPath,leftover);
% end
% fprintf('Data Analysis Finished.\n\n');
% % Preparation for Getting the Each Disturbance Detail
% Swell_time = 0;
% Swell_spec = U_nominal;
% Dip_time = 0;
% Dip_spec = U_nominal;
% Interruption_time = 0;
% Interruption_spec = U_nominal;
% Swell_timesum = 0;
% Dip_timesum = 0;
% Interruption_timesum = 0;
% 
% % Time Stamp
% time_Short_SS = (group_size/1000):(group_size/1000):(group_size/1000)*length(U_rms_10ms);
% time_Short_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_Short_SS, 'UniformOutput', false);
% time_Short = cat(1, time_Short_Cell{:});
% time_Long_SS = (sample_window_length/1000):(sample_window_length/1000):(sample_window_length/1000)*length(U_rms);
% time_Long_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_Long_SS, 'UniformOutput', false);
% time_Long = cat(1, time_Long_Cell{:});
% fprintf('Time Stemps Allocated.\n\n');
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
% %% Overall Display
% disp('=========Detection_Report=========');
% fprintf(['In these signals sampled,\n']);
% if SwellCount == 0
%     fprintf(['There is no Swell in these sample.\n'])
% else
%     fprintf(['%d Swell(s) have been identified.\n'],SwellCount);
% end
% if DipCount == 0
%     fprintf(['There is no Dip in these sample.\n'])
% else
%     fprintf(['%d Dip(s) have been identified.\n'],DipCount);
% end
% if InterruptionCount == 0
%     fprintf(['There is no Interruption in these sample.\n'])
% else
%     fprintf(['%d Interruption(s) have been identified.\n'],InterruptionCount);
% end
% fprintf('-------------------------------------\n');
% if SwellCount == 0
%     fprintf(['There is no Swell in these sample.\n'])
% else
%     for i = 1:SwellCount
%         fprintf('Swell No.%d: Maximum Urms is %.4f V. Duration is %d ms.\n', i, Swell_spec(i), Swell_time(i)/1000);
%     end
% end
% fprintf('----------------------------------\n\n');
% 
% if DipCount == 0
%     fprintf(['There is no Dip in these sample.\n'])
% else
%     for i = 1:DipCount
%         fprintf('Dip No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Dip_spec(i), Dip_time(i)/1000);
%     end
% end
% fprintf('----------------------------------\n\n');
% 
% if InterruptionCount == 0
%     fprintf(['There is no Interruption in these sample.\n'])
% else
%     for i = 1:InterruptionCount
%         fprintf('Interruption No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Interruption_spec(i), Interruption_time(i)/1000);
%     end
% end
% fprintf('----------------------------------\n\n');
figure
subplot(2,1,1)
yyaxis left
plot(time_Short,U_rms_10ms,'Color','#633736',LineStyle='-');
for i = 1:length(Setting_Time)
    label(i) = {sprintf('Setting %d',i)};
end
xline(Setting_Time,'-',label)
ylabel('V')
yyaxis right
plot(time_Short,I_rms_L1_10ms,'Color','#C31E2D',LineStyle='-');
hold on
plot(time_Short,I_rms_L2_10ms,'Color','#2773C8',LineStyle='-');
hold on
plot(time_Short,I_rms_L3_10ms,'Color','#9CC38A',LineStyle='-');
ylabel('A')
xlabel('time')
legend('Voltage','Line 1','Line 2','Line 3');
hold off
for i = 1:length(isNonStatDistOccur)
    if isNonStatDistOccur(i) == 0
        Status(i) = NaN;
    elseif isNonStatDistOccur(i) == 1
        Status(i) = 2; %swell
    elseif isNonStatDistOccur(i) == 2
        Status(i) = 3; %dip
    else
        Status(i) = 1; %inpt
    end
end
subplot(2,1,2)
plot(time_Short,Status,'o','Color','#C31E2D');
yline(1,'Label','Interruption');
yline(2,'Label','Swell');
yline(3,'Label','Dip');
xline(Setting_Time,'-',label)
ylim([1 3.5]);
% Setting = table2array(Setting);
% 
% U_ripple = double(abs(U_ripple));
% I_ripple_L1 = double(abs(I_ripple_L1));
% I_ripple_L2 = double(abs(I_ripple_L2));
% I_ripple_L3 = double(abs(I_ripple_L3));
% RDF_Voltage = double(abs(RDF_Voltage));
% RDF_L1 = double(abs(RDF_L1));
% RDF_L2 = double(abs(RDF_L2));
% RDF_L3 = double(abs(RDF_L3));
% RMS_Ripple_Factor_Voltage = double(abs(RMS_Ripple_Factor_Voltage));
% RMS_Ripple_Factor_L1 = double(abs(RMS_Ripple_Factor_L1));
% RMS_Ripple_Factor_L2 = double(abs(RMS_Ripple_Factor_L2));
% RMS_Ripple_Factor_L3 = double(abs(RMS_Ripple_Factor_L3));
% Peak_Ripple_Factor_Voltage = double(abs(Peak_Ripple_Factor_Voltage));
% Peak_Ripple_Factor_L1 = double(abs(Peak_Ripple_Factor_L1));
% Peak_Ripple_Factor_L2 = double(abs(Peak_Ripple_Factor_L2));
% Peak_Ripple_Factor_L3 = double(abs(Peak_Ripple_Factor_L3));
%% Peport Generator & Interactive Tool
if GENRPT == 1
    
    % Report Generator
    import mlreportgen.dom.*
    rptname = 'AutoReport'
    rpt = Document(rptname,'docx','Evaluation Report');
    
    PubDate = date();

    OA_1 = sprintf('The analysis data are recorded during %s to %s.\n', start_time, time_Short(end));
    OA_2 = 'During these period, ';
    if SwellCount == 0
        OA_3 = 'There is no swell in these sample.';
    elseif SwellCount == 1
        OA_3 = sprintf('%d swell has been identified.', SwellCount);
    else
        OA_3 = sprintf('%d swells have been identified.', SwellCount);
    end
    if DipCount == 0
        OA_4 = ' And there is no dip in these sample.';
    elseif DipCount == 1
        OA_4 = ' And identified one dip in these sample.';
    else
        OA_4 = sprintf(' And identified %d dips in these sample.', DipCount);
    end
    if InterruptionCount == 0
        OA_5 = ' Besides, there is no interruption in these sample.';
    elseif InterruptionCount == 1
        OA_5 = ' Besides, there is one interruption in these sample.';
    else
        OA_5 = sprintf(' Besides, there are %d interruptions in these sample.', InterruptionCount);
    end

    OA = [OA_1, OA_2, OA_3, OA_4, OA_5];

    fig = figure;
    Pie_Data(1) = group_size * length(U_rms_10ms) - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Swell_timesum;
    Pie_Data(3) = Dip_timesum;
    Pie_Data(4) = Interruption_timesum;
    pie(Pie_Data,'%.3f%%');
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
    exportgraphics(fig,'piechart.jpg');
    PieChart = Image('piechart.jpg');
    PieChart.Height = "2.6in";
    PieChart.Width = "2.5in";

    fig = figure;
    subplot(2,1,1)
    yyaxis left
    plot(time_Short,U_rms_10ms,'Color','#633736',LineStyle='-');
    if exist("Setting_Time") == 1
        for i = 1:length(Setting_Time)
            label(i) = {sprintf('Setting %d',i)};
        end
        xline(Setting_Time,'-',label)
    else
    end
    ylabel('V')
    yyaxis right
    plot(time_Short,I_rms_L1_10ms,'Color','#C31E2D',LineStyle='-');
    hold on
    plot(time_Short,I_rms_L2_10ms,'Color','#2773C8',LineStyle='-');
    hold on
    plot(time_Short,I_rms_L3_10ms,'Color','#9CC38A',LineStyle='-');
    ylabel('A')
    xlabel('time')
    legend('Voltage','Line 1','Line 2','Line 3');
    hold off
    subplot(2,1,2)
    plot(time_Short,Status,'o','Color','#C31E2D');
    yline(1,'Label','Interruption');
    yline(2,'Label','Swell');
    yline(3,'Label','Dip');
    if exist("Setting_Time") == 1
        xline(Setting_Time,'-',label)
    else
    end
    ylim([1 3.5]);
    exportgraphics(fig,'RMS_AVG_Plot.jpg');
    RMS_AVG_Plot = Image('RMS_AVG_Plot.jpg');
    RMS_AVG_Plot.Height = "3in";
    RMS_AVG_Plot.Width = "5.2in";

    while ~strcmp(rpt.CurrentHoleId,'#end#')
        switch rpt.CurrentHoleId
            case 'PubDate'
                append(rpt,PubDate);
            case 'OA_Cmt'
                append(rpt,OA);
            case 'PieChart'
                append(rpt,PieChart);
            case 'RMS_AVG_Plot'
                append(rpt,RMS_AVG_Plot);
            case 'DipSec'
                for Usr_input_3 = 1:DipCount
                    CH_1 = sprintf('Dip No.%d \n',Usr_input_3);
                    append(rpt,CH_1);
                    if Dip(Usr_input_3,1) == 0 ...
                            disp_starttime = time_Short((sample_window_length/group_size)*Dip(Usr_input_3,3)+Dip(Usr_input_3,2));
                        disp_endtime = time_Short((sample_window_length/group_size)*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
                        disp_endtime = time_Short(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
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
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    end

                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
                    append(rpt,CH_4);
                    CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4);
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
                        append(rpt,CH_5);
                    end
                    dist_len = Dip_time(Usr_input_3)/group_size;
                    if dist_len == 1
                        CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                        append(rpt,CH_6);
                    else
                        x_data=DipSpec(1:dist_len,Usr_input_3);
                        pd = fitdist(x_data,'Normal');
                        pd_avg = mean(pd);
                        x_pdf = [1:0.1:100];
                        y_data = pdf(pd,x_pdf);

                        fig = figure
                        histogram(x_data,'Normalization','pdf')
                        line(x_pdf,y_data)
                        title('Distribution of this disturbance')
                        filename = sprintf('Dip_%03d.png', Usr_input_3);
                        exportgraphics(fig,filename);
                        DipChart = Image(filename);
                        DipChart.Height = "2.6in";
                        DipChart.Width = "2.5in";
                        append(rpt,DipChart);
                    end
                end
            case 'SwellSec'
                for Usr_input_3 = 1:SwellCount
                    CH_1 = sprintf('Swell No.%d \n',Usr_input_3);
                    append(rpt,CH_1);

                    if Swell(Usr_input_3,1) == 0 ...
                            disp_starttime = time_Short((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_Short((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
                        disp_endtime = time_Short(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
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
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    end

                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
                    append(rpt,CH_4);
                    CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4);
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
                        append(rpt,CH_5);
                    end
                    dist_len = Swell_time(Usr_input_3)/group_size;
                    if dist_len == 1
                        CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                        append(rpt,CH_6);
                    else
                        x_data=SwellSpec(1:dist_len,Usr_input_3);
                        pd = fitdist(x_data,'Normal');
                        pd_avg = mean(pd);
                        x_pdf = [1:0.1:100];
                        y_data = pdf(pd,x_pdf);

                        fig = figure
                        histogram(x_data,'Normalization','pdf');
                        line(x_pdf,y_data)
                        title('Distribution of the selected disturbance');
                        filename = sprintf('Swell_%03d.png', Usr_input_3);
                        exportgraphics(fig,filename);
                        SwellChart = Image(filename);
                        SwellChart.Height = "2.6in";
                        SwellChart.Width = "2.5in";
                        append(rpt,SwellChart);
                    end
                end
            case 'InterruptionSec'
                for Usr_input_3 = 1:InterruptionCount
                    CH_1 = sprintf('Interruption No.%d \n',Usr_input_3);
                    append(rpt,CH_1);
                    if Interruption(Usr_input_3,1) == 0 ...
                            disp_starttime = time_Short((sample_window_length/group_size)*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2));
                        disp_endtime = time_Short((sample_window_length/group_size)*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                        disp_endtime = time_Short(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
                        if Setting_Time(j) < disp_endtime
                            continue
                        else
                            break
                        end
                    end
                    if Interruption_time(Usr_input_3) < 10000
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
                        append(rpt,CH_3);
                        Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                        append(rpt,Ch_3);
                        Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                        append(rpt,Ch_3);
                    end

                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
                    append(rpt,CH_4);
                    CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4);
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
                        append(rpt,CH_5);
                    end
                    dist_len = Interruption_time(Usr_input_3)/group_size;
                    if dist_len == 1
                        CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                        append(rpt,CH_6);
                    else
                        x_data=InterruptionSpec(1:dist_len,Usr_input_3);
                        pd = fitdist(x_data,'Normal');
                        pd_avg = mean(pd);
                        x_pdf = [1:0.1:100];
                        y_data = pdf(pd,x_pdf);

                        fig = figure
                        histogram(x_data,'Normalization','pdf')
                        line(x_pdf,y_data)
                        title('Distribution of this disturbance')
                        filename = sprintf('Interruption_%03d.png', Usr_input_3);
                        exportgraphics(fig,filename);
                        InterruptionChart = Image(filename);
                        InterruptionChart.Height = "2.6in";
                        InterruptionChart.Width = "2.5in";
                        append(rpt,InterruptionChart);
                    end
                end
            case 'SystemSettings_OA'
                CH_7 = sprintf('The system seeting during the analysis peroiod are shown in the following table:');
                append(rpt,CH_7);
                Table2Disp = horzcat(Setting_Times,Setting(2:end,:));
                TableTitle = ['Time'];
                TableTitle = horzcat(TableTitle,Setting(1,:));
                TableNum = zeros(length(Setting)-1,1);

                for i = 1:length(Setting)-1
                    TableNum(i,1) = i;
                end
                NumTitle = ['No.'];
                TableNum = num2cell(TableNum);
                TableNum = cat(1,NumTitle,TableNum);
                Table2Disp = cat(1,TableTitle,Table2Disp);
                Table2Disp = horzcat(TableNum,Table2Disp);
                table1 =  FormalTable(Table2Disp);
                table1.StyleName = 'myTableStyle';
                table1.Style = [table1.Style,{ResizeToFitContents(true),Width('6in')}, ...
                    {HAlign('center')}];
                append(rpt,table1);
            case 'SystemSetting_Sec'
                Small_interval = zeros(length(U_rms_10ms),1);
                Large_interval = zeros(length(RMS_Ripple_Factor_Voltage),1);
                for Usr_input_3  = 1:length(Setting_Time)

                    if Usr_input_3 == 1
                        start_5MS = 1;
                        start_200MS = 1;
                    else
                        temp = 0;
                        for j = 1:length(time_Short)
                            if time_Short(j) <= Setting_Time(Usr_input_3)
                                temp = temp + 1;
                            else
                                start_5MS = temp;
                                start_200MS = floor(start_5MS/(sample_window_length/group_size));
                                if floor(start_5MS/(sample_window_length/group_size)) == 0
                                    start_200MS = 1;
                                end
                                break
                            end
                        end
                    end
                    if Usr_input_3 == length(Setting_Time)
                        termin_5MS = length(time_Short);
                        termin_200MS = floor(length(time_Short)/(sample_window_length/group_size));
                    else
                        temp = 0;
                        for j = 1:length(time_Short)
                            if time_Short(j) <= Setting_Time(Usr_input_3 + 1)
                                temp = temp + 1;
                            else
                                termin_5MS = temp;
                                termin_200MS = floor(termin_5MS/(sample_window_length/group_size));
                                break
                            end
                        end
                    end
                    Small_interval(start_5MS:termin_5MS) = Usr_input_3;
                    Large_interval(start_200MS:termin_200MS) = Usr_input_3;
                end

                CH_8 = sprintf('The following figures are the boxplot of RMS Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_rms,Large_interval);
                title('RMS Voltage');
                filename = sprintf('boxplot_RMS.png');
                exportgraphics(fig,filename);
                boxplot_RMSChart = Image(filename);
                boxplot_RMSChart.Height = "2.6in";
                boxplot_RMSChart.Width = "2.5in";
                append(rpt,boxplot_RMSChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(U_rms,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(U_rms(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RMS Voltage');
                filename = sprintf('boxplot_RMS_AT.png');
                exportgraphics(fig,filename);
                boxplot_RMS_ATChart = Image(filename);
                boxplot_RMS_ATChart.Height = "2.6in";
                boxplot_RMS_ATChart.Width = "2.5in";
                append(rpt,boxplot_RMS_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of average Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_avg,Large_interval);
                title('Average Voltage');
                filename = sprintf('boxplot_avg.png');
                exportgraphics(fig,filename);
                boxplot_avgChart = Image(filename);
                boxplot_avgChart.Height = "2.6in";
                boxplot_avgChart.Width = "2.5in";
                append(rpt,boxplot_avgChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(U_avg,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(U_avg(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Average Voltage');
                filename = sprintf('boxplot_avg_AT.png');
                exportgraphics(fig,filename);
                boxplot_avg_ATChart = Image(filename);
                boxplot_avg_ATChart.Height = "2.6in";
                boxplot_avg_ATChart.Width = "2.5in";
                append(rpt,boxplot_avg_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_ripple,Large_interval);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple.png');
                exportgraphics(fig,filename);
                boxplot_rippleChart = Image(filename);
                boxplot_rippleChart.Height = "2.6in";
                boxplot_rippleChart.Width = "2.5in";
                append(rpt,boxplot_rippleChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(U_ripple,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(U_ripple(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple_AT.png');
                exportgraphics(fig,filename);
                boxplot_ripple_ATChart = Image(filename);
                boxplot_ripple_ATChart.Height = "2.6in";
                boxplot_ripple_ATChart.Width = "2.5in";
                append(rpt,boxplot_ripple_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 1 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L1,Large_interval);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L1.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L1Chart = Image(filename);
                boxplot_ripple_L1Chart.Height = "2.6in";
                boxplot_ripple_L1Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L1Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(I_ripple_L1,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(I_ripple_L1(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L1_AT.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L1_ATChart = Image(filename);
                boxplot_ripple_L1_ATChart.Height = "2.6in";
                boxplot_ripple_L1_ATChart.Width = "2.5in";
                append(rpt,boxplot_ripple_L1_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 2 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L2,Large_interval);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L2.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L2Chart = Image(filename);
                boxplot_ripple_L2Chart.Height = "2.6in";
                boxplot_ripple_L2Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L2Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(I_ripple_L2,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(I_ripple_L2(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L2_AT.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L2_ATChart = Image(filename);
                boxplot_ripple_L2_ATChart.Height = "2.6in";
                boxplot_ripple_L2_ATChart.Width = "2.5in";
                append(rpt,boxplot_ripple_L2_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 3 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L3,Large_interval);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L3.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L3Chart = Image(filename);
                boxplot_ripple_L3Chart.Height = "2.6in";
                boxplot_ripple_L3Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L3Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(I_ripple_L3,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(I_ripple_L3(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Ripple Current');
                filename = sprintf('boxplot_ripple_L3_AT.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L3_ATChart = Image(filename);
                boxplot_ripple_L3_ATChart.Height = "2.6in";
                boxplot_ripple_L3_ATChart.Width = "2.5in";
                append(rpt,boxplot_ripple_L3_ATChart);

                for i = 1:length(RDF_Voltage)
                    if RDF_Voltage(i) > 100
                        RDF_Voltage(i) = 100;
                    end
                    if RDF_L1(i) > 100
                        RDF_L1(i) = 100;
                    end
                    if RDF_L2(i) > 100
                        RDF_L2(i) = 100;
                    end
                    if RDF_L3(i) > 100
                        RDF_L3(i) = 100;
                    end
                    if RMS_Ripple_Factor_Voltage(i) > 100
                        RMS_Ripple_Factor_Voltage(i) = 100;
                    end
                    if RMS_Ripple_Factor_L1(i) > 100
                        RMS_Ripple_Factor_L1(i) = 100;
                    end
                    if RMS_Ripple_Factor_L2(i) > 100
                        RMS_Ripple_Factor_L2(i) = 100;
                    end
                    if RMS_Ripple_Factor_L3(i) > 100
                        RMS_Ripple_Factor_L3(i) = 100;
                    end
                    if Peak_Ripple_Factor_Voltage(i) > 100
                        Peak_Ripple_Factor_Voltage(i) = 100;
                    end
                    if Peak_Ripple_Factor_L1(i) > 100
                        Peak_Ripple_Factor_L1(i) = 100;
                    end
                    if Peak_Ripple_Factor_L2(i) > 100
                        Peak_Ripple_Factor_L2(i) = 100;
                    end
                    if Peak_Ripple_Factor_L3(i) > 100
                        Peak_Ripple_Factor_L3(i) = 100;
                    end
                end
                CH_8 = sprintf('The following figures are the boxplot of RDF of voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RDF_Voltage,Large_interval);
                title('RDF Voltage');
                filename = sprintf('boxplot_RDF_V.png');
                exportgraphics(fig,filename);
                boxplot_RDF_VChart = Image(filename);
                boxplot_RDF_VChart.Height = "2.6in";
                boxplot_RDF_VChart.Width = "2.5in";
                append(rpt,boxplot_RDF_VChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RDF_Voltage,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RDF_Voltage(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RDF Voltage');
                filename = sprintf('boxplot_RDF_V_AT.png');
                exportgraphics(fig,filename);
                boxplot_RDF_V_ATChart = Image(filename);
                boxplot_RDF_V_ATChart.Height = "2.6in";
                boxplot_RDF_V_ATChart.Width = "2.5in";
                append(rpt,boxplot_RDF_V_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RDF of current of line 1 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RDF_L1,Large_interval);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L1.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L1Chart = Image(filename);
                boxplot_RDF_L1Chart.Height = "2.6in";
                boxplot_RDF_L1Chart.Width = "2.5in";
                append(rpt,boxplot_RDF_L1Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RDF_L1,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RDF_L1(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L1_AT.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L1_ATChart = Image(filename);
                boxplot_RDF_L1_ATChart.Height = "2.6in";
                boxplot_RDF_L1_ATChart.Width = "2.5in";
                append(rpt,boxplot_RDF_L1_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RDF of current of line 2 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RDF_L2,Large_interval);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L2.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L2Chart = Image(filename);
                boxplot_RDF_L2Chart.Height = "2.6in";
                boxplot_RDF_L2Chart.Width = "2.5in";
                append(rpt,boxplot_RDF_L2Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RDF_L2,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RDF_L2(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L2_AT.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L2_ATChart = Image(filename);
                boxplot_RDF_L2_ATChart.Height = "2.6in";
                boxplot_RDF_L2_ATChart.Width = "2.5in";
                append(rpt,boxplot_RDF_L2_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RDF of current of line 3 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RDF_L3,Large_interval);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L3.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L3Chart = Image(filename);
                boxplot_RDF_L3Chart.Height = "2.6in";
                boxplot_RDF_L3Chart.Width = "2.5in";
                append(rpt,boxplot_RDF_L3Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RDF_L3,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RDF_L3(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RDF Current');
                filename = sprintf('boxplot_RDF_L3_AT.png');
                exportgraphics(fig,filename);
                boxplot_RDF_L3_ATChart = Image(filename);
                boxplot_RDF_L3_ATChart.Height = "2.6in";
                boxplot_RDF_L3_ATChart.Width = "2.5in";
                append(rpt,boxplot_RDF_L3_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_Factor_Voltage,Large_interval);
                title('RMS Factor Voltage');
                filename = sprintf('boxplot_RRF_V.png');
                exportgraphics(fig,filename);
                boxplot_RRF_VChart = Image(filename);
                boxplot_RRF_VChart.Height = "2.6in";
                boxplot_RRF_VChart.Width = "2.5in";
                append(rpt,boxplot_RRF_VChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RMS_Ripple_Factor_Voltage,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RMS_Ripple_Factor_Voltage(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RMS Factor Voltage');
                filename = sprintf('boxplot_RRF_V_AT.png');
                exportgraphics(fig,filename);
                boxplot_RRF_V_ATChart = Image(filename);
                boxplot_RRF_V_ATChart.Height = "2.6in";
                boxplot_RRF_V_ATChart.Width = "2.5in";
                append(rpt,boxplot_RRF_V_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 1 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_Factor_L1,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L1.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L1Chart = Image(filename);
                boxplot_RRF_L1Chart.Height = "2.6in";
                boxplot_RRF_L1Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L1Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RMS_Ripple_Factor_L1,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RMS_Ripple_Factor_L1(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L1_AT.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L1_ATChart = Image(filename);
                boxplot_RRF_L1_ATChart.Height = "2.6in";
                boxplot_RRF_L1_ATChart.Width = "2.5in";
                append(rpt,boxplot_RRF_L1_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 2 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_Factor_L2,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L2.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L2Chart = Image(filename);
                boxplot_RRF_L2Chart.Height = "2.6in";
                boxplot_RRF_L2Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L2Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RMS_Ripple_Factor_L2,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RMS_Ripple_Factor_L2(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L2_AT.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L2_ATChart = Image(filename);
                boxplot_RRF_L2_ATChart.Height = "2.6in";
                boxplot_RRF_L2_ATChart.Width = "2.5in";
                append(rpt,boxplot_RRF_L2_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 3 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_Factor_L3,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L3.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L3Chart = Image(filename);
                boxplot_RRF_L3Chart.Height = "2.6in";
                boxplot_RRF_L3Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L3Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(RMS_Ripple_Factor_L3,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(RMS_Ripple_Factor_L3(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L3_AT.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L3_ATChart = Image(filename);
                boxplot_RRF_L3_ATChart.Height = "2.6in";
                boxplot_RRF_L3_ATChart.Width = "2.5in";
                append(rpt,boxplot_RRF_L3_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_Factor_Voltage,Large_interval);
                title('Peak Valley Factor Voltage');
                filename = sprintf('boxplot_PVF_V.png');
                exportgraphics(fig,filename);
                boxplot_PVF_VChart = Image(filename);
                boxplot_PVF_VChart.Height = "2.6in";
                boxplot_PVF_VChart.Width = "2.5in";
                append(rpt,boxplot_PVF_VChart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(Peak_Ripple_Factor_Voltage,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(Peak_Ripple_Factor_Voltage(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Peak Valley Factor Voltage');
                filename = sprintf('boxplot_PVF_V_AT.png');
                exportgraphics(fig,filename);
                boxplot_PVF_V_ATChart = Image(filename);
                boxplot_PVF_V_ATChart.Height = "2.6in";
                boxplot_PVF_V_ATChart.Width = "2.5in";
                append(rpt,boxplot_PVF_V_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 1 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_Factor_L1,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L1.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L1Chart = Image(filename);
                boxplot_PVF_L1Chart.Height = "2.6in";
                boxplot_PVF_L1Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L1Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(Peak_Ripple_Factor_L1,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(Peak_Ripple_Factor_L1(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L1_AT.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L1_ATChart = Image(filename);
                boxplot_PVF_L1_ATChart.Height = "2.6in";
                boxplot_PVF_L1_ATChart.Width = "2.5in";
                append(rpt,boxplot_PVF_L1_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 2 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_Factor_L2,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L2.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L2Chart = Image(filename);
                boxplot_PVF_L2Chart.Height = "2.6in";
                boxplot_PVF_L2Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L2Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(Peak_Ripple_Factor_L2,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(Peak_Ripple_Factor_L2(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L2_AT.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L2_ATChart = Image(filename);
                boxplot_PVF_L2_ATChart.Height = "2.6in";
                boxplot_PVF_L2_ATChart.Width = "2.5in";
                append(rpt,boxplot_PVF_L2_ATChart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 3 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_Factor_L3,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L3.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L3Chart = Image(filename);
                boxplot_PVF_L3Chart.Height = "2.6in";
                boxplot_PVF_L3Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L3Chart);
                CH_9 = sprintf('The following figures are the auto scaled boxplot.');
                append(rpt,CH_9);
                fig = figure
                boxplot(Peak_Ripple_Factor_L3,Large_interval);
                h = findobj(gca, 'tag', 'Box');

                q1_all = zeros(1, numel(h));
                q3_all = zeros(1, numel(h));

                for i = 1:numel(h)
                    q1_all(i) = h(i).YData(1);
                    q3_all(i) = h(i).YData(3);
                end

                IQR_all = q3_all - q1_all;

                min_q1 = min(q1_all);
                max_q3 = max(q3_all);

                ylimits = [max(0, min_q1 - 1.5 * max(IQR_all)), max_q3 + 1.5 * max(IQR_all)];

                percentile90 = prctile(Peak_Ripple_Factor_L3(:), 90);
                ylimits(1) = min(ylimits(1), percentile90);
                ylimits(2) = max(ylimits(2), percentile90);

                ylim(ylimits);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L3_AT.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L3_ATChart = Image(filename);
                boxplot_PVF_L3_ATChart.Height = "2.6in";
                boxplot_PVF_L3_ATChart.Width = "2.5in";
                append(rpt,boxplot_PVF_L3_ATChart);

        end
        moveToNextHole(rpt);
    end
    close(rpt);
    rptview(rpt)
    close all
else
    % Interactive Tool
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
                            disp_starttime = time_Short((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_Short((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
                        disp_endtime = time_Short(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
                    end
                    fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
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
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
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
                            disp_starttime = time_Short((sample_window_length/group_size)*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_Short((sample_window_length/group_size)*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                        disp_endtime = time_Short(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
                    end
                    fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
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
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
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
                            disp_starttime = time_Short((sample_window_length/group_size)*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_Short((sample_window_length/group_size)*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
                    else
                        disp_starttime = time_Short(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
                        disp_endtime = time_Short(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
                    end
                    fprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    for i = 1:length(Setting)-1
                        if Setting_Time(i) < disp_starttime
                            continue
                        else
                            break
                        end
                    end
                    for j = 1:length(Setting)-1
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
                            ,k,string(Setting(i+k,1)),string(Setting(i+k,2)),string(Setting(i+k,3)),string(Setting(i+k,4)));
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
                        % fprintf("%3d:    Before %s\n",i,Setting_Time(i));
                        fprintf("%3d:    %s to %s\n",i,Setting_Time(i),Setting_Time(i+1));
                    elseif i == length(Setting_Time)
                        fprintf("%3d:    %s to End\n",i,Setting_Time(i));
                    else
                        fprintf("%3d:    %s to %s\n",i,Setting_Time(i),Setting_Time(i+1));
                    end
                end
                I_Atool = ("Enter the number shown above of the period you would like to analysis.\n (e.g. For No.1, type 1)\n ");
                Usr_input_3 = input(I_Atool);
                if Usr_input_3 == 1
                    start_5MS = 1;
                    start_200MS = 1;
                else
                    temp = 0;
                    for j = 1:length(time_Short)
                        if time_Short(j) <= Setting_Time(Usr_input_3)
                            temp = temp + 1;
                        else
                            start_5MS = temp;
                            start_200MS = floor(start_5MS/(sample_window_length/group_size));
                            if floor(start_5MS/(sample_window_length/group_size)) == 0
                                start_200MS = 1;
                            end
                            break
                        end
                    end
                end
                if Usr_input_3 == length(Setting_Time)
                    termin_5MS = length(time_Short);
                    termin_200MS = floor(length(time_Short)/(sample_window_length/group_size));
                else
                    temp = 0;
                    for j = 1:length(time_Short)
                        if time_Short(j) <= Setting_Time(Usr_input_3 + 1)
                            temp = temp + 1;
                        else
                            termin_5MS = temp;
                            termin_200MS = floor(termin_5MS/(sample_window_length/group_size));
                            break
                        end
                    end
                end
                figure
                subplot(2,3,1)
                time = time_Long(start_200MS:termin_200MS);
                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),U_rms(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('V')
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),I_rms_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_rms_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_rms_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('A')
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title("RMS value of voltage and current during this period")
                subplot(2,3,2)
                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),U_ripple(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('V')
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),I_ripple_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_ripple_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_ripple_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('A')
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title('Ripple value of voltage and current during this period')
                subplot(2,3,3)
                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),U_avg(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('V')
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),I_avg_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_avg_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),I_avg_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('A')
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title("Average value of voltage and current during this period");
                subplot(2,3,4)

                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),RDF_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),RDF_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),RDF_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),RDF_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title('RDF value of voltage and current during this period');
                subplot(2,3,5)
                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),Peak_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),Peak_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),Peak_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),Peak_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title('Peak Ripple Factor value of voltage and current during this period');
                subplot(2,3,6)
                yyaxis left
                plot(time_Long(start_200MS:termin_200MS),RMS_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                yyaxis right
                plot(time_Long(start_200MS:termin_200MS),RMS_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),RMS_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_Long(start_200MS:termin_200MS),RMS_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
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
    else
        fprintf('==========================\n\n       Tool Terminated       \n\n==========================\n');
    end
end