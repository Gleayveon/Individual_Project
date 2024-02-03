%% Version: 4.1.1
% clc
% clear
% close all
% config = readlines("config.csv");
% MLPath = config(2);
% DTPath = config(3);
% U_nominal = double(config(4));
% group_size = double(config(5));
% sample_window_length = double(config(6));
% Fs = double(config(7));
% GENRPT = double(config(8));
% start_time = datetime(string(config(8)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% cd(string(DTPath))
% listing = dir('*.tdms');
% len = length(listing);
% Ts=1/Fs;    % Sampling period
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
%     time_5MS_SS = (group_size/1000):(group_size/1000):(group_size/1000)*length(U_avg);
%     time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
%     time_5MS = cat(1, time_5MS_Cell{:});
%     time_200MS_SS = (sample_window_length/1000):(sample_window_length/1000):(sample_window_length/1000)*length(RDF_L1);
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
figure
subplot(2,1,1)
            yyaxis left
            plot(time_5MS,U_rms,'Color','#633736',LineStyle='-');
            for i = 1:length(Setting_Time)
                label(i) = {sprintf('Setting %d',i)};
            end
                xline(Setting_Time,'-',label)
            ylabel('V')
            yyaxis right
            plot(time_5MS,I_rms_L1,'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_5MS,I_rms_L2,'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_5MS,I_rms_L3,'Color','#9CC38A',LineStyle='-');
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
plot(time_5MS,Status,'o','Color','#C31E2D');
yline(1,'Label','Interruption');
yline(2,'Label','Swell');
yline(3,'Label','Dip');
xline(Setting_Time,'-',label)
ylim([1 3.5]);
Setting = table2array(Setting);

if GENRPT == 1

    import mlreportgen.dom.*
    rptname = 'AutoReport'
    rpt = Document(rptname,'docx','Evaluation Report');

    PubDate = date();

    OA_1 = sprintf('The analysis data are recorded during %s to %s.\n', start_time, time_5MS(end));
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
    Pie_Data(1) = group_size * length(U_avg) - Dip_timesum - Swell_timesum - Interruption_timesum;
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
    plot(time_5MS,U_rms,'Color','#633736',LineStyle='-');
    if exist("Setting_Time") == 1
        for i = 1:length(Setting_Time)
            label(i) = {sprintf('Setting %d',i)};
        end
        xline(Setting_Time,'-',label)
    else
    end
    ylabel('V')
    yyaxis right
    plot(time_5MS,I_rms_L1,'Color','#C31E2D',LineStyle='-');
    hold on
    plot(time_5MS,I_rms_L2,'Color','#2773C8',LineStyle='-');
    hold on
    plot(time_5MS,I_rms_L3,'Color','#9CC38A',LineStyle='-');
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
    plot(time_5MS,Status,'o','Color','#C31E2D');
    yline(1,'Label','Interruption');
    yline(2,'Label','Swell');
    yline(3,'Label','Dip');
    if exist("Setting_Time") == 1
        xline(Setting_Time,'-',label)
    else
    end
    ylim([1 3.5]);
    Setting = table2array(Setting);
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
                    else
                        disp_starttime = time_5MS(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
                        disp_endtime = time_5MS(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
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
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    end
                    append(rpt,CH_3);
                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4);
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
                    else
                        disp_starttime = time_5MS(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
                        disp_endtime = time_5MS(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
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
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    end
                    append(rpt,CH_3);
                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4)
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
                    else
                        disp_starttime = time_5MS(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                        disp_endtime = time_5MS(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
                    end
                    CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                    append(rpt,CH_2);
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
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nAll samples during this distortion are within the tolerance of Voltage Swell\nTherefore, this distortion can be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    else
                        CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\nThis distortion is severe and can not be tolerate.\n\n' ...
                            '(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n' ...
                            '(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage swells in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                    end
                    append(rpt,CH_3);
                    CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\nDuring this disturbance, the network is under the following setting(s)\n');
                    append(rpt,CH_4);
                    for k = 1:(j-i+1)
                        CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
            case 'SystemSetting_OA'

            case 'SystemSetting_Sec'

        end
        moveToNextHole(rpt);
    end
    close(rpt);
    rptview(rpt)
else
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
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
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
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
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                            disp_starttime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
                        disp_endtime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
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
                            ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                    for j = 1:length(time_5MS)
                        if time_5MS(j) <= Setting_Time(Usr_input_3)
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
                    termin_5MS = length(time_5MS);
                    termin_200MS = floor(length(time_5MS)/(sample_window_length/group_size));
                else
                    temp = 0;
                    for j = 1:length(time_5MS)
                        if time_5MS(j) <= Setting_Time(Usr_input_3 + 1)
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
                ylim([0 100]);
                yyaxis right
                plot(time_200MS(start_200MS:termin_200MS),RDF_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),RDF_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),RDF_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title('RDF value of voltage and current during this period');
                subplot(2,3,5)
                yyaxis left
                plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                yyaxis right
                plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                xlabel('time')
                legend('Voltage','Line 1','Line 2','Line 3');
                hold off
                title('Peak Ripple Factor value of voltage and current during this period');
                subplot(2,3,6)
                yyaxis left
                plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
                ylabel('Percent (%)')
                ylim([0 100]);
                yyaxis right
                plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
                hold on
                plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
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
    elseif Usr_input == "uuddlrlrab" || Usr_input == "UUDDLRLRAB"
        Yuki = 1;
        fprintf('=======================\n\n       Debug Mode       \n\n=======================\n');
        for Usr_input_3 = 1:SwellCount
            fprintf('----------------------------------\n\n');
            fprintf('Swell No.%d \n',Usr_input_3);
            if Swell(Usr_input_3,1) == 0 ...
                    disp_starttime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
                disp_endtime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
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
                    ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                    ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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
                    ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
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

            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),RDF_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),RDF_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RDF_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RDF_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('RDF value of voltage and current during this period');
            subplot(2,3,5)
            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),Peak_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
            xlabel('time')
            legend('Voltage','Line 1','Line 2','Line 3');
            hold off
            title('Peak Ripple Factor value of voltage and current during this period');
            subplot(2,3,6)
            yyaxis left
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_Voltage(start_200MS:termin_200MS),'Color','#633736',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
            yyaxis right
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L1(start_200MS:termin_200MS),'Color','#C31E2D',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L2(start_200MS:termin_200MS),'Color','#2773C8',LineStyle='-');
            hold on
            plot(time_200MS(start_200MS:termin_200MS),RMS_Ripple_Factor_L3(start_200MS:termin_200MS),'Color','#9CC38A',LineStyle='-');
            ylabel('Percent (%)')
            ylim([0 100]);
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
end