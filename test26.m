clc
clear
close all
cd 'A:\Lin project'\Data_Check\
listing = dir('*.tdms');
len = length(listing);
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
Factor_rms = 0;
Factor_peak_valley = 0;
RDF_total = 0;
for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [Udc_out,Urms_out,RDF_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,...
    Factor_peak_valley_sample,Factor_rms_sample,isSwell_legacy,isDip_legacy,isInterruption_legacy,...
    RDF_eachwindow_i1,Factor_peak_valley_sample_i1,Factor_rms_sample_i1] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy,Fs,Ts,U_nominal,...
    timescale,group_size,hysteresis,Dip_tr,Swell_tr,Interruption_tr);
    
    Pie_Data(1) = Pie_Data(1) + 1000000 - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Pie_Data(2) + Swell_timesum;
    Pie_Data(3) = Pie_Data(3) + Dip_timesum;
    Pie_Data(4) = Pie_Data(4) + Interruption_timesum;
    SwellCount = SwellCount + SampleSwellCount;
    DipCount = DipCount + SampleDipCount;
    InterruptionCount = InterruptionCount + SampleInterruptionCount;
    Urms_main = cat(1,Urms_main,Urms);
    Udc_main = cat(1,Udc_main, Udc);
    figure(1)
    pie(Pie_Data,'%.3f%%');
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
    cd 'A:\Lin project\Data_Check'
    
    figure(2)
    subplot(2,1,1)
    time = 5:5:5*(length(Udc_main)-1);
    plot(time,Udc_main(2:end));
    title('U_D_C mean');
    ylabel('U_D_C Magnitude');
    xlabel('Time (ms)')
    hold on
    subplot(2,1,2)
    plot(time,Urms_main(2:end));
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    yline(Dip_tr,'--','Color','#C31E2D','Label','Dip threshold');
    yline(Swell_tr,'--','Color','#2773C8','Label','Swell threshold');
    yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption threshold');
    Factor_rms = cat(1,Factor_rms, Factor_rms_sample);
    figure(3)
    time = 0:200:200*(length(Factor_rms)-2);
    plot(time,Factor_rms(2:end));
    title('Factor_r_m_s');
    xlabel('Time (ms)');
    ylabel('Factor_r_m_s Magnitude (%)');
    Factor_peak_valley = cat(1,Factor_peak_valley,Factor_peak_valley_sample);
    figure(4)
    plot(time,Factor_peak_valley(2:end));
    title('Factor_p_e_a_k_-_v_a_l_l_e_y');
    xlabel('Time (ms)');
    ylabel('Factor_p_e_a_k_-_v_a_l_l_e_y Magnitude (%)');
    RDF_total = cat(1,RDF_total,RDF_eachwindow);
    figure(5)
    time = 0:200:200*(length(RDF_total)-2);
    plot(time,RDF_total(2:end));
    title('RDF_V_o_l_t_a_g_e_1');
    xlabel('Time (ms)');
    ylabel('RDF_V_o_l_t_a_g_e_1 Magnitude');


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
