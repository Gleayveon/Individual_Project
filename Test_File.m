%% Test File

config = readlines("config.csv");
MLPath = config(2);
DTPath = config(3);
U_nominal = double(config(4));
group_size = double(config(5));
sample_window_length = double(config(6));
Fs = double(config(7));
start_time = datetime(string(config(8)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Ts=1/Fs;    % Sampling period

if exist("setting_time.csv", 'file') == 2 && exist("setting.csv",'file') == 2
    Setting_Times = readlines("setting_time.csv");
    for i = 1:length(Setting_Times)
        Setting_Time(i) = datetime(string(Setting_Times(i)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
    end
    Setting = readtable("setting.csv",'ReadVariableNames', false);
else
end
fprintf('System Settings Loaded.\n\n');
Setting = table2array(Setting);

import mlreportgen.dom.*
rptname = 'AutoReportTest'
rpt = Document(rptname,'docx','Evaluation Report');

% PubDate = date();

% OA_1 = sprintf('The analysis data are recorded during %s to %s.\n', start_time, time_5MS(end));
% OA_2 = 'During these period, ';
% if SwellCount == 0
%     OA_3 = 'There is no swell in these sample.';
% elseif SwellCount == 1
%     OA_3 = sprintf('%d swell has been identified.', SwellCount);
% else
%     OA_3 = sprintf('%d swells have been identified.', SwellCount);
% end
% if DipCount == 0
%     OA_4 = ' And there is no dip in these sample.';
% elseif DipCount == 1
%     OA_4 = ' And identified one dip in these sample.';
% else
%     OA_4 = sprintf(' And identified %d dips in these sample.', DipCount);
% end
% if InterruptionCount == 0
%     OA_5 = ' Besides, there is no interruption in these sample.';
% elseif InterruptionCount == 1
%     OA_5 = ' Besides, there is one interruption in these sample.';
% else
%     OA_5 = sprintf(' Besides, there are %d interruptions in these sample.', InterruptionCount);
% end
% 
% OA = [OA_1, OA_2, OA_3, OA_4, OA_5];
% 
% fig = figure;
% Pie_Data(1) = group_size * length(U_avg) - Dip_timesum - Swell_timesum - Interruption_timesum;
% Pie_Data(2) = Swell_timesum;
% Pie_Data(3) = Dip_timesum;
% Pie_Data(4) = Interruption_timesum;
% pie(Pie_Data,'%.3f%%');
% legend('Normal','Swell','Dip','Interruption');
% title('Chart of the data''s voltage status');
% exportgraphics(fig,'piechart.jpg');
% PieChart = Image('piechart.jpg');
% PieChart.Height = "2.6in";
% PieChart.Width = "2.5in";
% 
% fig = figure;
% % subplot(2,1,1)
% yyaxis left
% plot(time_5MS,U_rms,'Color','#633736',LineStyle='-');
% if exist("Setting_Time") == 1
%     for i = 1:length(Setting_Time)
%         label(i) = {sprintf('Setting %d',i)};
%     end
%     xline(Setting_Time,'-',label)
% else
% end
% ylabel('V')
% yyaxis right
% plot(time_5MS,I_rms_L1,'Color','#C31E2D',LineStyle='-');
% hold on
% plot(time_5MS,I_rms_L2,'Color','#2773C8',LineStyle='-');
% hold on
% plot(time_5MS,I_rms_L3,'Color','#9CC38A',LineStyle='-');
% ylabel('A')
% xlabel('time')
% legend('Voltage','Line 1','Line 2','Line 3');
% hold off
% for i = 1:length(isNonStatDistOccur)
%     if isNonStatDistOccur(i) == 0
%         Status(i) = NaN;
%     elseif isNonStatDistOccur(i) == 1
%         Status(i) = 2; %swell
%     elseif isNonStatDistOccur(i) == 2
%         Status(i) = 3; %dip
%     else
%         Status(i) = 1; %inpt
%     end
% end
% subplot(2,1,2)
% plot(time_5MS,Status,'o','Color','#C31E2D');
% yline(1,'Label','Interruption');
% yline(2,'Label','Swell');
% yline(3,'Label','Dip');
% if exist("Setting_Time") == 1
%     xline(Setting_Time,'-',label)
% else
% end
% ylim([1 3.5]);
% Setting = table2array(Setting);
% exportgraphics(fig,'RMS_AVG_Plot.jpg');
% RMS_AVG_Plot = Image('RMS_AVG_Plot.jpg');
% RMS_AVG_Plot.Height = "3in";
% RMS_AVG_Plot.Width = "5.2in";

while ~strcmp(rpt.CurrentHoleId,'#end#')
        switch rpt.CurrentHoleId
            % case 'PubDate'
            %     % append(rpt,PubDate);
            % case 'OA_Cmt'
            %     % append(rpt,OA);
            % case 'PieChart'
            %     % append(rpt,PieChart);
            % case 'RMS_AVG_Plot'
            %     % append(rpt,RMS_AVG_Plot);
            % case 'DipSec'
            %     % for Usr_input_3 = 1:DipCount
            %     %     CH_1 = sprintf('Dip No.%d \n',Usr_input_3);
            %     %     append(rpt,CH_1);
            %     %     if Dip(Usr_input_3,1) == 0 ...
            %     %             disp_starttime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,3)+Dip(Usr_input_3,2)); % 40 here as 5ms is used
            %     %         disp_endtime = time_5MS((sample_window_length/group_size)*Dip(Usr_input_3,6)+Dip(Usr_input_3,5));
            %     %     else
            %     %         disp_starttime = time_5MS(Dip(Usr_input_3,1)+Dip(Usr_input_3,2));
            %     %         disp_endtime = time_5MS(Dip(Usr_input_3,4)+Dip(Usr_input_3,5));
            %     %     end
            %     %     CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
            %     %     append(rpt,CH_2);
            %     %     for i = 1:length(Setting)
            %     %         if Setting_Time(i) < disp_starttime
            %     %             continue
            %     %         else
            %     %             break
            %     %         end
            %     %     end
            %     %     for j = 1:length(Setting)
            %     %         if Setting_Time(j) < disp_endtime
            %     %             continue
            %     %         else
            %     %             break
            %     %         end
            %     %     end
            %     %     Tolerance_Within1 = 0;
            %     %     Tolerance_Within2 = 0;
            %     %     Tolerance_Without = 0;
            %     %     Tolerance_Spec = DipSpec(:,Usr_input_3);
            %     %     temp2 = 1;
            %     %     temp3 = 1;
            %     %     temp4 = 1;
            %     %     for temp = 1:(Dip_time(Usr_input_3)/group_size)
            %     %         if Tolerance_Spec(temp) > 0.7*U_nominal
            %     %             Tolerance_Within1(temp2) = group_size;
            %     %             temp2 = temp2 + 1;
            %     %         elseif Tolerance_Spec(temp) > 0.6*U_nominal && Tolerance_Spec(temp) <= 0.7*U_nominal
            %     %             Tolerance_Within2(temp3) = group_size;
            %     %             temp3 = temp3 + 1;
            %     %         else
            %     %             Tolerance_Without(temp4) = group_size;
            %     %             temp4 = temp4 + 1;
            %     %         end
            %     %     end
            %     %     if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
            %     %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
            %     %         append(rpt,CH_3);
            %     %         Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
            %     %         append(rpt,Ch_3);
            %     %     else
            %     %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
            %     %         append(rpt,CH_3);
            %     %         Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
            %     %         append(rpt,Ch_3);
            %     %     end
            %     % 
            %     %     CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
            %     %     append(rpt,CH_4);
            %     %     CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
            %     %     append(rpt,CH_4);
            %     %     for k = 1:(j-i+1)
            %     %         CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
            %     %             ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
            %     %         append(rpt,CH_5);
            %     %     end
            %     %     dist_len = Dip_time(Usr_input_3)/group_size;
            %     %     if dist_len == 1
            %     %         CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
            %     %         append(rpt,CH_6);
            %     %     else
            %     %         x_data=DipSpec(1:dist_len,Usr_input_3);
            %     %         pd = fitdist(x_data,'Normal');
            %     %         pd_avg = mean(pd);
            %     %         x_pdf = [1:0.1:100];
            %     %         y_data = pdf(pd,x_pdf);
            %     % 
            %     %         fig = figure
            %     %         histogram(x_data,'Normalization','pdf')
            %     %         line(x_pdf,y_data)
            %     %         title('Distribution of this disturbance')
            %     %         filename = sprintf('Dip_%03d.png', Usr_input_3);
            %     %         exportgraphics(fig,filename);
            %     %         DipChart = Image(filename);
            %     %         DipChart.Height = "2.6in";
            %     %         DipChart.Width = "2.5in";
            %     %         append(rpt,DipChart);
            %     %     end
            %     % end
            % case 'SwellSec'
            %     % for Usr_input_3 = 1:SwellCount
            %     %     CH_1 = sprintf('Swell No.%d \n',Usr_input_3);
            %     %     append(rpt,CH_1);
            %     % 
            %     %     if Swell(Usr_input_3,1) == 0 ...
            %     %             disp_starttime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,3)+Swell(Usr_input_3,2)); % 40 here as 5ms is used
            %     %         disp_endtime = time_5MS((sample_window_length/group_size)*Swell(Usr_input_3,6)+Swell(Usr_input_3,5));
            %     %     else
            %     %         disp_starttime = time_5MS(Swell(Usr_input_3,1)+Swell(Usr_input_3,2));
            %     %         disp_endtime = time_5MS(Swell(Usr_input_3,4)+Swell(Usr_input_3,5));
            %     %     end
            %     %     CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
            %     %     append(rpt,CH_2);
            %     %     for i = 1:length(Setting)
            %     %         if Setting_Time(i) < disp_starttime
            %     %             continue
            %     %         else
            %     %             break
            %     %         end
            %     %     end
            %     %     for j = 1:length(Setting)
            %     %         if Setting_Time(j) < disp_endtime
            %     %             continue
            %     %         else
            %     %             break
            %     %         end
            %     %     end
            %     %     Tolerance_Within1 = 0;
            %     %     Tolerance_Within2 = 0;
            %     %     Tolerance_Without = 0;
            %     %     Tolerance_Spec = SwellSpec(:,Usr_input_3);
            %     %     temp2 = 1;
            %     %     temp3 = 1;
            %     %     temp4 = 1;
            %     %     for temp = 1:(Swell_time(Usr_input_3)/group_size)
            %     %         if Tolerance_Spec(temp) < 1.25*U_nominal
            %     %             Tolerance_Within1(temp2) = group_size;
            %     %             temp2 = temp2 + 1;
            %     %         elseif Tolerance_Spec(temp) < 1.4*U_nominal && Tolerance_Spec(temp) >= 1.25*U_nominal
            %     %             Tolerance_Within2(temp3) = group_size;
            %     %             temp3 = temp3 + 1;
            %     %         else
            %     %             Tolerance_Without(temp4) = group_size;
            %     %             temp4 = temp4 + 1;
            %     %         end
            %     %     end
            %     %     if sum(Tolerance_Within1) < 1000000 && sum(Tolerance_Within2) < 100000 && sum(Tolerance_Without) == 0
            %     %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
            %     %         append(rpt,CH_3);
            %     %         Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
            %     %         append(rpt,Ch_3);
            %     %     else
            %     %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
            %     %         append(rpt,CH_3);
            %     %         Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
            %     %         append(rpt,Ch_3);
            %     %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
            %     %         append(rpt,Ch_3);
            %     %     end
            %     % 
            %     %     CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
            %     %     append(rpt,CH_4);
            %     %     CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
            %     %     append(rpt,CH_4);
            %     %     for k = 1:(j-i+1)
            %     %         CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
            %     %             ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
            %     %         append(rpt,CH_5);
            %     %     end
            %     %     dist_len = Swell_time(Usr_input_3)/group_size;
            %     %     if dist_len == 1
            %     %         CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
            %     %         append(rpt,CH_6);
            %     %     else
            %     %         x_data=SwellSpec(1:dist_len,Usr_input_3);
            %     %         pd = fitdist(x_data,'Normal');
            %     %         pd_avg = mean(pd);
            %     %         x_pdf = [1:0.1:100];
            %     %         y_data = pdf(pd,x_pdf);
            %     % 
            %     %         fig = figure
            %     %         histogram(x_data,'Normalization','pdf');
            %     %         line(x_pdf,y_data)
            %     %         title('Distribution of the selected disturbance');
            %     %         filename = sprintf('Swell_%03d.png', Usr_input_3);
            %     %         exportgraphics(fig,filename);
            %     %         SwellChart = Image(filename);
            %     %         SwellChart.Height = "2.6in";
            %     %         SwellChart.Width = "2.5in";
            %     %         append(rpt,SwellChart);
            %     %     end
            %     % end
            % case 'InterruptionSec'
            %     % for Usr_input_3 = 1:InterruptionCount
                %     CH_1 = sprintf('Interruption No.%d \n',Usr_input_3);
                %     append(rpt,CH_1);
                %     if Interruption(Usr_input_3,1) == 0 ...
                %             disp_starttime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,3)+Interruption(Usr_input_3,2)); % 40 here as 5ms is used
                %         disp_endtime = time_5MS((sample_window_length/group_size)*Interruption(Usr_input_3,6)+Interruption(Usr_input_3,5));
                %     else
                %         disp_starttime = time_5MS(Interruption(Usr_input_3,1)+Interruption(Usr_input_3,2));
                %         disp_endtime = time_5MS(Interruption(Usr_input_3,4)+Interruption(Usr_input_3,5));
                %     end
                %     CH_2 = sprintf('   Start time: %s\n    End time: %s\n',disp_starttime, disp_endtime);
                %     append(rpt,CH_2);
                %     for i = 1:length(Setting)
                %         if Setting_Time(i) < disp_starttime
                %             continue
                %         else
                %             break
                %         end
                %     end
                %     for j = 1:length(Setting)
                %         if Setting_Time(j) < disp_endtime
                %             continue
                %         else
                %             break
                %         end
                %     end
                %     if Interruption_time(Usr_input_3) < 10000
                %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-']);
                %         append(rpt,CH_3);
                %         Ch_3 = sprintf(['\nAll samples during this distortion are within the tolerance of Voltage Dip\nTherefore, this distortion can be tolerate.\n\n']);
                %         append(rpt,Ch_3);
                %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                %         append(rpt,Ch_3);
                %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                %         append(rpt,Ch_3);
                %     else
                %         CH_3 = sprintf(['\n·-·-·-·-·-·-·-·-·-·-\n']);
                %         append(rpt,CH_3);
                %         Ch_3 = sprintf(['\nThis distortion is severe and can not be tolerate.\n\n']);
                %         append(rpt,Ch_3);
                %         Ch_3 = sprintf(['(0.7~1.25 of nominal voltage for duration < 1s, 0.6~1.4 of nominal voltage for duration < 0.1s, interruption duration < 10ms)\n']);
                %         append(rpt,Ch_3);
                %         Ch_3 = sprintf(['(NB No standard defined for tolerance of equipment to voltage dips,\nshort interruptions and voltage Dips in LVDC networks, this tool used the standrad used in railway applications.)\n']);
                %         append(rpt,Ch_3);
                %     end
                % 
                %     CH_4 = sprintf('·-·-·-·-·-·-·-·-·-·-\n');
                %     append(rpt,CH_4);
                %     CH_4 = sprintf('During this disturbance, the network is under the following setting(s)\n');
                %     append(rpt,CH_4);
                %     for k = 1:(j-i+1)
                %         CH_5 = sprintf('Network Setting %d,\n      AFE is %s.\n      4000uF Capacitor is %s.\n      PV is %s.\n      EVC is %s.\n'...
                %             ,k,string(Setting(i+k-1,1)),string(Setting(i+k-1,2)),string(Setting(i+k-1,3)),string(Setting(i+k-1,4)));
                %         append(rpt,CH_5);
                %     end
                %     dist_len = Interruption_time(Usr_input_3)/group_size;
                %     if dist_len == 1
                %         CH_6 = sprintf('·-·-·-·-·-·-·-·-·-·-\nThis distortion duration is too short (only last for one sample window, %d ms), no distribution can be defined\n',group_size);
                %         append(rpt,CH_6);
                %     else
                %         x_data=InterruptionSpec(1:dist_len,Usr_input_3);
                %         pd = fitdist(x_data,'Normal');
                %         pd_avg = mean(pd);
                %         x_pdf = [1:0.1:100];
                %         y_data = pdf(pd,x_pdf);
                % 
                %         fig = figure
                %         histogram(x_data,'Normalization','pdf')
                %         line(x_pdf,y_data)
                %         title('Distribution of this disturbance')
                %         filename = sprintf('Interruption_%03d.png', Usr_input_3);
                %         exportgraphics(fig,filename);
                %         InterruptionChart = Image(filename);
                %         InterruptionChart.Height = "2.6in";
                %         InterruptionChart.Width = "2.5in";
                %         append(rpt,InterruptionChart);
                %     end
                % end
            case 'SystemSettings_OA'
                        CH_7 = sprintf('The system seeting during the analysis peroiod are shown in the following table:');
                        append(rpt,CH_7);
                        Table2Disp = horzcat(Setting_Times,Setting(2:end,:));
                        TableTitle = ['Time'];
                        TableTitle = horzcat(TableTitle,Setting(1,:));
                        Table2Disp = cat(1,TableTitle,Table2Disp);
                        table1 =  FormalTable(Table2Disp);
                        table1.StyleName = 'myTableStyle';
                        table1.Style = [table1.Style,{ResizeToFitContents(true),Width('6in')}, ...
                            {HAlign('center')}];
                        append(rpt,table1);
            case 'SystemSetting_Sec'
                % Small_interval = zeros(length(U_rms),1);
                % Large_interval = zeros(length(RMS_Ripple_Factor_Voltage),1);
                % for Usr_input_3  = 1:length(Setting_Times)
                % 
                %     if Usr_input_3 == 1
                %         start_5MS = 1;
                %         start_200MS = 1;
                %     else
                %         temp = 0;
                %         for j = 1:length(time_5MS)
                %             if time_5MS(j) <= Setting_Time(Usr_input_3)
                %                 temp = temp + 1;
                %             else
                %                 start_5MS = temp;
                %                 start_200MS = floor(start_5MS/(sample_window_length/group_size));
                %                 if floor(start_5MS/(sample_window_length/group_size)) == 0
                %                     start_200MS = 1;
                %                 end
                %                 break
                %             end
                %         end
                %     end
                %     if Usr_input_3 == length(Setting_Time)
                %         termin_5MS = length(time_5MS);
                %         termin_200MS = floor(length(time_5MS)/(sample_window_length/group_size));
                %     else
                %         temp = 0;
                %         for j = 1:length(time_5MS)
                %             if time_5MS(j) <= Setting_Time(Usr_input_3 + 1)
                %                 temp = temp + 1;
                %             else
                %                 termin_5MS = temp;
                %                 termin_200MS = floor(termin_5MS/(sample_window_length/group_size));
                %                 break
                %             end
                %         end
                %     end
                %     Small_interval(start_5MS:termin_5MS) = Usr_input_3;
                %     Large_interval(start_200MS:termin_200MS) = Usr_input_3;
                % end

                CH_8 = sprintf('The following figures are the boxplot of RMS Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_rms,Small_interval);
                title('RMS Voltage');
                filename = sprintf('boxplot_RMS.png');
                exportgraphics(fig,filename);
                boxplot_RMSChart = Image(filename);
                boxplot_RMSChart.Height = "2.6in";
                boxplot_RMSChart.Width = "2.5in";
                append(rpt,boxplot_RMSChart);

                CH_8 = sprintf('The following figures are the boxplot of average Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_avg,Small_interval);
                title('Average Voltage');
                filename = sprintf('boxplot_avg.png');
                exportgraphics(fig,filename);
                boxplot_avgChart = Image(filename);
                boxplot_avgChart.Height = "2.6in";
                boxplot_avgChart.Width = "2.5in";
                append(rpt,boxplot_avgChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple Voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(U_ripple,Small_interval);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple.png');
                exportgraphics(fig,filename);
                boxplot_rippleChart = Image(filename);
                boxplot_rippleChart.Height = "2.6in";
                boxplot_rippleChart.Width = "2.5in";
                append(rpt,boxplot_rippleChart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 1 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L1,Small_interval);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple_L1.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L1Chart = Image(filename);
                boxplot_ripple_L1Chart.Height = "2.6in";
                boxplot_ripple_L1Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L1Chart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 2 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L2,Small_interval);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple_L2.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L2Chart = Image(filename);
                boxplot_ripple_L2Chart.Height = "2.6in";
                boxplot_ripple_L2Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L2Chart);

                CH_8 = sprintf('The following figures are the boxplot of ripple current of line 3 different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(I_ripple_L3,Small_interval);
                title('Ripple Voltage');
                filename = sprintf('boxplot_ripple_L3.png');
                exportgraphics(fig,filename);
                boxplot_ripple_L3Chart = Image(filename);
                boxplot_ripple_L3Chart.Height = "2.6in";
                boxplot_ripple_L3Chart.Width = "2.5in";
                append(rpt,boxplot_ripple_L3Chart);

                

                for 1 = 1:length(RDF_Voltage)
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

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_Voltage,Large_interval);
                title('RMS Factor Voltage');
                filename = sprintf('boxplot_RRF_V.png');
                exportgraphics(fig,filename);
                boxplot_RRF_VChart = Image(filename);
                boxplot_RRF_VChart.Height = "2.6in";
                boxplot_RRF_VChart.Width = "2.5in";
                append(rpt,boxplot_RRF_VChart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 1 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_L1,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L1.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L1Chart = Image(filename);
                boxplot_RRF_L1Chart.Height = "2.6in";
                boxplot_RRF_L1Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L1Chart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 2 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_L2,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L2.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L2Chart = Image(filename);
                boxplot_RRF_L2Chart.Height = "2.6in";
                boxplot_RRF_L2Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L2Chart);

                CH_8 = sprintf('The following figures are the boxplot of RMS ripple factor of current of line 3 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(RMS_Ripple_L3,Large_interval);
                title('RMS Factor Current');
                filename = sprintf('boxplot_RRF_L3.png');
                exportgraphics(fig,filename);
                boxplot_RRF_L3Chart = Image(filename);
                boxplot_RRF_L3Chart.Height = "2.6in";
                boxplot_RRF_L3Chart.Width = "2.5in";
                append(rpt,boxplot_RRF_L3Chart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of voltage of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_Voltage,Large_interval);
                title('Peak Valley Factor Voltage');
                filename = sprintf('boxplot_PVF_V.png');
                exportgraphics(fig,filename);
                boxplot_PVF_VChart = Image(filename);
                boxplot_PVF_VChart.Height = "2.6in";
                boxplot_PVF_VChart.Width = "2.5in";
                append(rpt,boxplot_PVF_VChart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 1 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_L1,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L1.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L1Chart = Image(filename);
                boxplot_PVF_L1Chart.Height = "2.6in";
                boxplot_PVF_L1Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L1Chart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 2 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_L2,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L2.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L2Chart = Image(filename);
                boxplot_PVF_L2Chart.Height = "2.6in";
                boxplot_PVF_L2Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L2Chart);

                CH_8 = sprintf('The following figures are the boxplot of peak valley factor of current of line 3 of different system settings.');
                append(rpt,CH_8);
                fig = figure
                boxplot(Peak_Ripple_L3,Large_interval);
                title('Peak Valley Factor Current');
                filename = sprintf('boxplot_PVF_L3.png');
                exportgraphics(fig,filename);
                boxplot_PVF_L3Chart = Image(filename);
                boxplot_PVF_L3Chart.Height = "2.6in";
                boxplot_PVF_L3Chart.Width = "2.5in";
                append(rpt,boxplot_PVF_L3Chart);
        end
        moveToNextHole(rpt);
end
close(rpt);
    rptview(rpt)