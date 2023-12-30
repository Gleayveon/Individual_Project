% Version: 2.0.2β
clc
clear
close all
cd 'A:\Lin project'\Data
listing = dir('*.tdms');
len = length(listing);
start_time = datetime('2023-09-26 13:48:00', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
leftover = 0;
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
RDF_total_L1 = 0;
RDF_total_L2 = 0;
RDF_total_L3 = 0;
Ripple_Voltage = 0;
Ripple_Line1 = 0;
Ripple_Line2 = 0;
Ripple_Line3 = 0;

for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [Udc_out,Urms_out,I_mean_L1,I_rms_L1,I_mean_L2,I_rms_L2,I_mean_L3,I_rms_L3,...
    RDF_V_eachwindow,RDF_L1_eachwindow,RDF_L2_eachwindow,RDF_L3_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,num_Sample,...
    Factor_peak_valley_sample_V,Factor_rms_sample_V,Factor_peak_valley_sample_L1,Factor_rms_sample_L1,...
    Factor_peak_valley_sample_L2,Factor_rms_sample_L2,Factor_peak_valley_sample_L3,Factor_rms_sample_L3,...
    Ripple_V,Ripple_L1,Ripple_L2,Ripple_L3,isSwell_legacy,isDip_legacy,isInterruption_legacy,leftover] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy,Fs,Ts,U_nominal,...
    timescale,group_size,hysteresis,Dip_tr,Swell_tr,Interruption_tr,leftover);
    
    Pie_Data(1) = Pie_Data(1) + 200000*num_Sample - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Pie_Data(2) + Swell_timesum;
    Pie_Data(3) = Pie_Data(3) + Dip_timesum;
    Pie_Data(4) = Pie_Data(4) + Interruption_timesum;
    SwellCount = SwellCount + SampleSwellCount;
    DipCount = DipCount + SampleDipCount;
    InterruptionCount = InterruptionCount + SampleInterruptionCount;
    Urms_main = cat(1,Urms_main,Urms_out(2:end));
    Udc_main = cat(1,Udc_main, Udc_out(2:end));
    I_rms_Line1 = cat(1,I_rms_Line1,I_rms_L1(2:end));
    I_rms_Line2 = cat(1,I_rms_Line2,I_rms_L2(2:end));
    I_rms_Line3 = cat(1,I_rms_Line3,I_rms_L3(2:end));
    I_mean_Line1 = cat(1,I_mean_Line1,I_mean_L1(2:end));
    I_mean_Line2 = cat(1,I_mean_Line2,I_mean_L2(2:end));
    I_mean_Line3 = cat(1,I_mean_Line3,I_mean_L3(2:end));
    Ripple_Voltage = cat(1,Ripple_Voltage,Ripple_V(2:end));
    Ripple_Line1 = cat(1,Ripple_Line1,Ripple_L1(2:end));
    Ripple_Line2 = cat(1,Ripple_Line2,Ripple_L2(2:end));
    Ripple_Line3 = cat(1,Ripple_Line3,Ripple_L3(2:end));
    Factor_rms_V = cat(1,Factor_rms_V, Factor_rms_sample_V);
    Factor_peak_valley_V = cat(1,Factor_peak_valley_V,Factor_peak_valley_sample_V);
    RDF_total_V = cat(1,RDF_total_V,RDF_V_eachwindow);
    RDF_total_L1 = cat(1,RDF_total_L1,RDF_L1_eachwindow);
    RDF_total_L2 = cat(1,RDF_total_L2,RDF_L2_eachwindow);
    RDF_total_L3 = cat(1,RDF_total_L3,RDF_L3_eachwindow);
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

