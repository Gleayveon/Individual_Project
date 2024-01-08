% Version: 2.0.5β
clc
clear
close all
cd 'A:\Lin project'\Data\
listing = dir('*.tdms');
len = length(listing);
start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
leftover = 0;
for num = 1:len
    [Udc_out,Urms_out,I_mean_L1_out,I_rms_L1_out,I_mean_L2_out,...
    I_rms_L2_out,I_mean_L3_out,I_rms_L3_out,leftover] = ...
    evaluate(num,listing,group_size,leftover);
    Urms = cat(1,Urms,Urms_out(2:end));
    Udc = cat(1,Udc, Udc_out(2:end));
    I_rms_Line1 = cat(1,I_rms_Line1,I_rms_L1_out(2:end));
    I_rms_Line2 = cat(1,I_rms_Line2,I_rms_L2_out(2:end));
    I_rms_Line3 = cat(1,I_rms_Line3,I_rms_L3_out(2:end));
    I_mean_Line1 = cat(1,I_mean_Line1,I_mean_L1_out(2:end));
    I_mean_Line2 = cat(1,I_mean_Line2,I_mean_L2_out(2:end));
    I_mean_Line3 = cat(1,I_mean_Line3,I_mean_L2_out(2:end));
end
