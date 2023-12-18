% Version: 1.3.1β
clc
clear
close all
cd 'A:\Lin project'\Data_Check\
listing = dir('*.tdms');
len = length(listing);
start_time = datetime('13:48:00', 'Format', 'HH:mm:ss.SSS');
Pie_Data = [0 0 0 0]; %[ Nomal Swell Dip Interruption ]
Fs=1000000; % Sampling frequency
Ts=1/Fs;    % Sampling period
U_nominal = 700; %The nominal voltage of the network
timescale = 1000000; %The time length of this sample
group_size = 5000; %resolution 5ms(5000us)
hysteresis = 0.02*U_nominal;
Dip_tr = 0.9*U_nominal; %Threashold_Dip
Swell_tr = 1.1*U_nominal;
Interruption_tr = 0.1*U_nominal;
isSwell_legacy = 0;
isDip_legacy = 0;
isInterruption_legacy = 0;
SwellCount = 0;
DipCount = 0;
InterruptionCount = 0;
Udc_main = 0;
Urms_main = 0;
Factor_rms_V = 0;
Factor_peak_valley_V = 0;
I_rms_Line1 = 0;
I_rms_Line2 = 0;
I_rms_Line3 = 0;
I_mean_Line1 = 0;
I_mean_Line2 = 0;
I_mean_Line3 = 0;
RDF_total_V = 0;
Ripple_Voltage = 0;
Ripple_Line1 = 0;
Ripple_Line2 = 0;
Ripple_Line3 = 0;

for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [Udc_out,Urms_out,I_mean_L1,I_rms_L1,I_mean_L2,I_rms_L2,I_mean_L3,I_rms_L3,...
    RDF_V_eachwindow,RDF_L1_eachwindow,RDF_L2_eachwindow,RDF_L3_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,...
    Factor_peak_valley_sample_V,Factor_rms_sample_V,Factor_peak_valley_sample_L1,Factor_rms_sample_L1,...
    Factor_peak_valley_sample_L2,Factor_rms_sample_L2,Factor_peak_valley_sample_L3,Factor_rms_sample_L3,...
    Ripple_V,Ripple_L1,Ripple_L2,Ripple_L3,isSwell_legacy,isDip_legacy,isInterruption_legacy] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy,Fs,Ts,U_nominal,...
    timescale,group_size,hysteresis,Dip_tr,Swell_tr,Interruption_tr);
    
    Pie_Data(1) = Pie_Data(1) + 1000000 - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Pie_Data(2) + Swell_timesum;
    Pie_Data(3) = Pie_Data(3) + Dip_timesum;
    Pie_Data(4) = Pie_Data(4) + Interruption_timesum;
    SwellCount = SwellCount + SampleSwellCount;
    DipCount = DipCount + SampleDipCount;
    InterruptionCount = InterruptionCount + SampleInterruptionCount;
    Urms_main = cat(1,Urms_main,Urms_out);
    Udc_main = cat(1,Udc_main, Udc_out);
    I_rms_Line1 = cat(1,I_rms_Line1,I_rms_L1);
    I_rms_Line2 = cat(1,I_rms_Line2,I_rms_L2);
    I_rms_Line3 = cat(1,I_rms_Line3,I_rms_L3);
    I_mean_Line1 = cat(1,I_mean_Line1,I_mean_L1);
    I_mean_Line2 = cat(1,I_mean_Line2,I_mean_L2);
    I_mean_Line3 = cat(1,I_mean_Line3,I_mean_L3);
    Ripple_Voltage = cat(1,Ripple_Voltage,Ripple_V);
    Ripple_Line1 = cat(1,Ripple_Line1,Ripple_L1);
    Ripple_Line2 = cat(1,Ripple_Line2,Ripple_L2);
    Ripple_Line3 = cat(1,Ripple_Line3,Ripple_L3);
    Factor_rms_V = cat(1,Factor_rms_V, Factor_rms_sample_V);
    Factor_peak_valley_V = cat(1,Factor_peak_valley_V,Factor_peak_valley_sample_V);
    RDF_total_V = cat(1,RDF_total_V,RDF_V_eachwindow);
end
    % if rem(num,5) == 0
    figure(1)
    pie(Pie_Data,'%.3f%%');
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
    cd 'A:\Lin project\Data_Check'
    
    figure(2)
    subplot(2,1,1)
    time_5MS_SS = 5:5:5*(length(Udc_main)-1);
    time_5MS = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS);
    plot(time_5MS,Udc_main(2:end));
    title('U_D_C mean');
    ylabel('U_D_C Magnitude');
    xlabel('Time (ms)')
    hold on
    subplot(2,1,2)
    plot(time_5MS,Urms_main(2:end));
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    yline(Dip_tr,'--','Color','#C31E2D','Label','Dip threshold');
    yline(Swell_tr,'--','Color','#2773C8','Label','Swell threshold');
    yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption threshold');
    
    figure(3)
    time_200MS_SS = 200:200:200*(length(Factor_rms_V)-1);
    time_200MS = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS);
    plot(time_200MS,Factor_rms_V(2:end));
    title('Factor_r_m_s Voltage');
    xlabel('Time (ms)');
    ylabel('Factor_r_m_s Magnitude (%)');
    
    figure(4)
    plot(time_200MS,Factor_peak_valley_V(2:end));
    title('Factor_p_e_a_k_-_v_a_l_l_e_y Voltage');
    xlabel('Time (ms)');
    ylabel('Factor_p_e_a_k_-_v_a_l_l_e_y Magnitude (%)');
    
    figure(5)
    plot(time_200MS,RDF_total_V(2:end));
    title('RDF_V_o_l_t_a_g_e_1');
    xlabel('Time (ms)');
    ylabel('RDF_V_o_l_t_a_g_e_1 Magnitude');
    figure(6)
    plot(time_5MS,Ripple_Voltage(2:end),'Color','#633736');
    hold on
    plot(time_5MS,Ripple_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,Ripple_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,Ripple_Line3(2:end),'Color','#9CC38A');
    legend('Voltage','Line 1','Line 2','Line 3');
    hold off
    figure(7)
    subplot(2,1,1)
    plot(time_5MS,I_mean_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,I_mean_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,I_mean_Line3(2:end),'Color','#9CC38A');
    hold off
    title('Current_m_e_a_m _o_f _e_v_e_r_y _5_m_s of all lines');
    ylabel('Magnitude');
    xlabel('Time (ms)');
    legend('Line 1','Line 2','Line 3');
    subplot(2,1,2)
    plot(time_5MS,I_rms_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,I_rms_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,I_rms_Line3(2:end),'Color','#9CC38A');
    hold off
    title('Current_r_m_s _o_f _e_v_e_r_y _5_m_s of all lines');
    ylabel('Magnitude');
    xlabel('Time (ms)');
    legend('Line 1','Line 2','Line 3');
    % else
    % end

% end
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
