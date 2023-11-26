clc
clear
close all
cd 'A:\Lin project\Data_Check'
% listing = dir('*.csv')
listing = dir('*.tdms')
len = length(listing)
Pie_Data = [0 0 0 0]; %[ Nomal Swell Dip Interruption ]
fs=1000000; % Sampling frequency
Ts=1/fs;    % Sampling period

for num = 1:len
    cd 'A:\Lin project\Individual_Project'
    [Udc_mean_sample, Urms_mean_sample, RDF_eachwindow, Swell_timesum, Dip_timesum,...
    Interruption_timesum, SampleDipCount, SampleSwellCount, SampleInterruptionCount,...
    Factor_peak_valley_sample, Factor_rms_sample] = evaluation(num,listing);
    num
    Pie_Data(1) = Pie_Data(1) + 1000000 - Dip_timesum - Swell_timesum - Interruption_timesum;
    Pie_Data(2) = Pie_Data(2) + Swell_timesum;
    Pie_Data(3) = Pie_Data(3) + Dip_timesum;
    Pie_Data(4) = Pie_Data(4) + Interruption_timesum;
    figure(1)
    pie(Pie_Data);
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
    cd 'A:\Lin project\Data_Check'
end
