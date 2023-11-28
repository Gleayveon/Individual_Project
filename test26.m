clc
clear
close all
cd 'A:\Lin project\Data_Check'
% listing = dir('*.csv')
listing = dir('*.tdms');
len = length(listing);
Pie_Data = [0 0 0 0]; %[ Nomal Swell Dip Interruption ]
fs=1000000; % Sampling frequency
Ts=1/fs;    % Sampling period
isSwell_legacy = 0;
isDip_legacy = 0;
isInterruption_legacy = 0;
SwellCount = 0;
DipCount = 0;
InterruptionCount = 0;
Udc_mean = 0;
Urms_mean = 0;
Factor_rms = 0;
Factor_peak_valley = 0;
RDF_total = 0;
for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [Udc_mean_sample,Urms_mean_sample,RDF_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,...
    Factor_peak_valley_sample,Factor_rms_sample,isSwell_legacy,isDip_legacy,isInterruption_legacy] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy);
    
    Pie_Data(1) = Pie_Data(1) + 1000000 - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Pie_Data(2) + Swell_timesum;
    Pie_Data(3) = Pie_Data(3) + Dip_timesum;
    Pie_Data(4) = Pie_Data(4) + Interruption_timesum;
    SwellCount = SwellCount + SampleSwellCount;
    DipCount = DipCount + SampleDipCount;
    InterruptionCount = InterruptionCount + SampleInterruptionCount;
    Urms_mean = cat(1,Urms_mean,Urms_mean_sample);
    Udc_mean = cat(1,Udc_mean, Udc_mean_sample);
    figure(1)
    pie(Pie_Data);
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
    cd 'A:\Lin project\Data_Check'
    
    figure(2)
    subplot(2,1,1)
    time = 0:5:(length(Udc_mean)-2);
    plot(time,Udc_mean(2:end));
    title('U_D_C mean');
    ylabel('U_D_C Magnitude');
    xlabel('Time (ms)')
    hold on
    subplot(2,1,2)
    plot(time,Urms_mean(2:end));
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    Factor_rms = cat(1,Factor_rms, Factor_rms_sample);
    figure(3)
    time = 0:5:(length(Factor_rms)-2);
    plot(time,Factor_rms(2:end));
    title('Factor_r_m)s');
    xlabel('Time (ms)');
    ylabel('Factor_r_m_s Magnitude');
    Factor_peak_valley = cat(1,Factor_peak_valley,Factor_peak_valley_sample);
    figure(4)
    plot(time,Factor_peak_valley(2:end));
    title('Factor_p_e_a_k_-_v_a_l_l_e_y');
    xlabel('Time (ms)');
    ylabel('Factor_p_e_a_k_-_v_a_l_l_e_y Magnitude');
    RDF_total = cat(1,RDF_total,RDF_eachwindow);
    figure(5)
    time = 0:5:(length(RDF_total)-2);
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
