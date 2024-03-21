
%% EVE-Evaluator
%   Notice:
%   This Script can detect the non-stationary disturbances of the given
%   data, with a native design for a data with 1 voltage signal and 3
%   current signals, unless the signal number of new data is changed,
%   otherwise there is no need to change any code of this script.
%   Discription:
%   The discription of this script can be found at the README
%
%   Version: 4.2.4
%   2024.02.15

%% Preparation
clc
clear
close all
config = readlines("config.csv"); %The configure file name

DTPath = config(3);
U_nominal = double(config(4));
group_size = double(config(5));
sample_window_length = double(config(6));
Fs = double(config(7));
Threshold_Dip = double(config(8));
Threshold_Swell = double(config(9));
Threshold_Interruption = double(config(10));
Threshold_Hysteresis = double(config(11));
start_time = datetime(string(config(12)), 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');

Ts=1/Fs;    % Sampling period

cd(string(DTPath)) %Go to the Data folder to get the list of whole data
listing = dir('*.tdms');
len = length(listing);


%% GENRPT = 0; %For demo only
U_avg_500K = 0;
U_rms_500K = 0;
I_rms_L1_500K = 0;
I_rms_L2_500K = 0;
I_rms_L3_500K = 0;
I_avg_L1_500K = 0;
I_avg_L2_500K = 0;
I_avg_L3_500K = 0;

U_ripple_500K = 0;
RDF_Voltage_500K = 0;
RMS_Ripple_Factor_Voltage_500K = 0;
Peak_Ripple_Factor_Voltage_500K = 0;
I_ripple_L1_500K = 0;
RDF_L1_500K = 0;
RMS_Ripple_Factor_L1_500K = 0;
Peak_Ripple_Factor_L1_500K = 0;
I_ripple_L2_500K = 0;
RDF_L2_500K = 0;
RMS_Ripple_Factor_L2_500K = 0;
Peak_Ripple_Factor_L2_500K = 0;
I_ripple_L3_500K = 0;
RDF_L3_500K = 0;
RMS_Ripple_Factor_L3_500K = 0;
Peak_Ripple_Factor_L3_500K = 0;
U_rms_10ms_500K = 0;
U_avg_200K = 0;
U_rms_200K = 0;
I_rms_L1_200K = 0;
I_rms_L2_200K = 0;
I_rms_L3_200K = 0;
I_avg_L1_200K = 0;
I_avg_L2_200K = 0;
I_avg_L3_200K = 0;

U_ripple_200K = 0;
RDF_Voltage_200K = 0;
RMS_Ripple_Factor_Voltage_200K = 0;
Peak_Ripple_Factor_Voltage_200K = 0;
I_ripple_L1_200K = 0;
RDF_L1_200K = 0;
RMS_Ripple_Factor_L1_200K = 0;
Peak_Ripple_Factor_L1_200K = 0;
I_ripple_L2_200K = 0;
RDF_L2_200K = 0;
RMS_Ripple_Factor_L2_200K = 0;
Peak_Ripple_Factor_L2_200K = 0;
I_ripple_L3_200K = 0;
RDF_L3_200K = 0;
RMS_Ripple_Factor_L3_200K = 0;
Peak_Ripple_Factor_L3_200K = 0;
U_rms_10ms_200K = 0;
U_avg_100K = 0;
U_rms_100K = 0;
I_rms_L1_100K = 0;
I_rms_L2_100K = 0;
I_rms_L3_100K = 0;
I_avg_L1_100K = 0;
I_avg_L2_100K = 0;
I_avg_L3_100K = 0;

U_ripple_100K = 0;
RDF_Voltage_100K = 0;
RMS_Ripple_Factor_Voltage_100K = 0;
Peak_Ripple_Factor_Voltage_100K = 0;
I_ripple_L1_100K = 0;
RDF_L1_100K = 0;
RMS_Ripple_Factor_L1_100K = 0;
Peak_Ripple_Factor_L1_100K = 0;
I_ripple_L2_100K = 0;
RDF_L2_100K = 0;
RMS_Ripple_Factor_L2_100K = 0;
Peak_Ripple_Factor_L2_100K = 0;
I_ripple_L3_100K = 0;
RDF_L3_100K = 0;
RMS_Ripple_Factor_L3_100K = 0;
Peak_Ripple_Factor_L3_100K = 0;
U_rms_10ms_100K = 0;
U_avg_50K = 0;
U_rms_50K = 0;
I_rms_L1_50K = 0;
I_rms_L2_50K = 0;
I_rms_L3_50K = 0;
I_avg_L1_50K = 0;
I_avg_L2_50K = 0;
I_avg_L3_50K = 0;

U_ripple_50K = 0;
RDF_Voltage_50K = 0;
RMS_Ripple_Factor_Voltage_50K = 0;
Peak_Ripple_Factor_Voltage_50K = 0;
I_ripple_L1_50K = 0;
RDF_L1_50K = 0;
RMS_Ripple_Factor_L1_50K = 0;
Peak_Ripple_Factor_L1_50K = 0;
I_ripple_L2_50K = 0;
RDF_L2_50K = 0;
RMS_Ripple_Factor_L2_50K = 0;
Peak_Ripple_Factor_L2_50K = 0;
I_ripple_L3_50K = 0;
RDF_L3_50K = 0;
RMS_Ripple_Factor_L3_50K = 0;
Peak_Ripple_Factor_L3_50K = 0;
U_rms_10ms_50K = 0;
U_avg_20K = 0;
U_rms_20K = 0;
I_rms_L1_20K = 0;
I_rms_L2_20K = 0;
I_rms_L3_20K = 0;
I_avg_L1_20K = 0;
I_avg_L2_20K = 0;
I_avg_L3_20K = 0;

U_ripple_20K = 0;
RDF_Voltage_20K = 0;
RMS_Ripple_Factor_Voltage_20K = 0;
Peak_Ripple_Factor_Voltage_20K = 0;
I_ripple_L1_20K = 0;
RDF_L1_20K = 0;
RMS_Ripple_Factor_L1_20K = 0;
Peak_Ripple_Factor_L1_20K = 0;
I_ripple_L2_20K = 0;
RDF_L2_20K = 0;
RMS_Ripple_Factor_L2_20K = 0;
Peak_Ripple_Factor_L2_20K = 0;
I_ripple_L3_20K = 0;
RDF_L3_20K = 0;
RMS_Ripple_Factor_L3_20K = 0;
Peak_Ripple_Factor_L3_20K = 0;
U_rms_10ms_20K = 0;
U_avg_10K = 0;
U_rms_10K = 0;
I_rms_L1_10K = 0;
I_rms_L2_10K = 0;
I_rms_L3_10K = 0;
I_avg_L1_10K = 0;
I_avg_L2_10K = 0;
I_avg_L3_10K = 0;

U_ripple_10K = 0;
RDF_Voltage_10K = 0;
RMS_Ripple_Factor_Voltage_10K = 0;
Peak_Ripple_Factor_Voltage_10K = 0;
I_ripple_L1_10K = 0;
RDF_L1_10K = 0;
RMS_Ripple_Factor_L1_10K = 0;
Peak_Ripple_Factor_L1_10K = 0;
I_ripple_L2_10K = 0;
RDF_L2_10K = 0;
RMS_Ripple_Factor_L2_10K = 0;
Peak_Ripple_Factor_L2_10K = 0;
I_ripple_L3_10K = 0;
RDF_L3_10K = 0;
RMS_Ripple_Factor_L3_10K = 0;
Peak_Ripple_Factor_L3_10K = 0;
U_rms_10ms_10K = 0;
U_avg_5K = 0;
U_rms_5K = 0;
I_rms_L1_5K = 0;
I_rms_L2_5K = 0;
I_rms_L3_5K = 0;
I_avg_L1_5K = 0;
I_avg_L2_5K = 0;
I_avg_L3_5K = 0;

U_ripple_5K = 0;
RDF_Voltage_5K = 0;
RMS_Ripple_Factor_Voltage_5K = 0;
Peak_Ripple_Factor_Voltage_5K = 0;
I_ripple_L1_5K = 0;
RDF_L1_5K = 0;
RMS_Ripple_Factor_L1_5K = 0;
Peak_Ripple_Factor_L1_5K = 0;
I_ripple_L2_5K = 0;
RDF_L2_5K = 0;
RMS_Ripple_Factor_L2_5K = 0;
Peak_Ripple_Factor_L2_5K = 0;
I_ripple_L3_5K = 0;
RDF_L3_5K = 0;
RMS_Ripple_Factor_L3_5K = 0;
Peak_Ripple_Factor_L3_5K = 0;
U_rms_10ms_5K = 0;
leftover = 0;
fprintf('Starting...\n\n');

%% Data Analysis
for num = 1:len
    %% Data Loading


    Name = listing(num).name; % Name of the files
    data = tdmsread(Name);

    Recordings=data{1,1};
    Recordings=table2array(Recordings);
    % These file structure and gain are obtained from the data provider,
    % different data provider might have different design of data structure and
    % gain.
    L1_Voltage=Recordings(:,1);
    L1_Current=Recordings(:,2);
    L2_Current=Recordings(:,3);
    L3_Current=Recordings(:,4);

    L1_Voltage=L1_Voltage.*1000;
    L1_Current=L1_Current.*100;
    L2_Current=L2_Current.*100;
    L3_Current=L3_Current.*25;

    num_groups = floor(sample_window_length / group_size);


    % L1_Voltage_D=downsample(L1_Voltage,DS);
    % L1_Current_D=downsample(L1_Current,DS);
    % L2_Current_D=downsample(L2_Current,DS);
    % L3_Current_D=downsample(L3_Current,DS);

    %% Leftover
    if num == 1 % The starting file is special as it has no previous file
        Data_Voltage = L1_Voltage;
        Data_L1_Current = L1_Current;
        Data_L2_Current = L2_Current;
        Data_L3_Current = L3_Current;
    else
        Data_Voltage = cat(1,leftover(:,1),L1_Voltage);
        Data_L1_Current = cat(1,leftover(:,2),L1_Current);
        Data_L2_Current = cat(1,leftover(:,3),L2_Current);
        Data_L3_Current = cat(1,leftover(:,4),L3_Current);
    end
    num_Sample = floor(length(Data_Voltage)/200000); % Cut the data to 200ms window

    clear leftover;
    leftover = horzcat(Data_Voltage(200000*num_Sample + 1:end), Data_L1_Current(200000*num_Sample + 1:end),...
        Data_L2_Current(200000*num_Sample + 1:end),Data_L3_Current(200000*num_Sample + 1:end)); % Generate this files's leftover

    %% Calculation
    for docount = 1:num_Sample
        %500K
        voltage_500K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_500K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),2);
        current_L2_500K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),2);
        current_L3_500K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),2);
        %200K
        voltage_200K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_200K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),5);
        current_L2_200K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),5);
        current_L3_200K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),5);
        %100K
        voltage_100K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_100K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),10);
        current_L2_100K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),10);
        current_L3_100K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),10);
        %50K
        voltage_50K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_50K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),20);
        current_L2_50K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),20);
        current_L3_50K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),20);
        %20K
        voltage_20K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_20K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),50);
        current_L2_20K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),50);
        current_L3_20K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),50);
        %10K
        voltage_10K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_10K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),100);
        current_L2_10K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),100);
        current_L3_10K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),100);
        %5K
        voltage_5K = downsample(Data_Voltage(1+(docount-1)*200000:docount*200000),2);
        current_L1_5K = downsample(Data_L1_Current(1+(docount-1)*200000:docount*200000),200);
        current_L2_5K = downsample(Data_L2_Current(1+(docount-1)*200000:docount*200000),200);
        current_L3_5K = downsample(Data_L3_Current(1+(docount-1)*200000:docount*200000),200);
        %% Mean & RMS Calculation
        %500K
        Urms_sample_500K = rms(voltage_500K);
        Uavg_sample_500K = mean(voltage_500K);
        current_mean_sample_L1_500K = mean(current_L1_500K);
        current_rms_sample_L1_500K = rms(current_L1_500K);
        current_mean_sample_L2_500K = mean(current_L2_500K);
        current_rms_sample_L2_500K = rms(current_L2_500K);
        current_mean_sample_L3_500K = mean(current_L3_500K);
        current_rms_sample_L3_500K = rms(current_L3_500K);

        k = 1;
        j = 1;
        temp = zeros(5000,1);
        for i = 1:100000
            temp(k,1) = voltage_500K(i);
            temp(k,2) = current_L1_500K(i);
            temp(k,3) = current_L2_500K(i);
            temp(k,4) = current_L3_500K(i);
            k = k+1;
            if k == (5000 + 1)
                Urms_nonStat_sample_500K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_500K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_500K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_500K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end
        %% RDF & 2 Factors
        L = 100000;
        RDF_Voltage_sample_500K = 0;
        Peak_Ripple_Factor_Voltage_sample_500K = 0;
        RMS_Ripple_Factor_Voltage_sample_500K = 0;

        RDF_L1_sample_500K = 0;
        Peak_Ripple_Factor_L1_sample_500K = 0;
        RMS_Ripple_Factor_L1_sample_500K = 0;

        RDF_L2_sample_500K = 0;
        Peak_Ripple_Factor_L2_sample_500K = 0;
        RMS_Ripple_Factor_L2_sample_500K = 0;

        RDF_L3_sample_500K = 0;
        Peak_Ripple_Factor_L3_sample_500K = 0;
        RMS_Ripple_Factor_L3_sample_500K = 0;


        % if sum(isNonStatDistOccur_sample(:)) ~= 0
        %     RDF_Voltage_sample = NaN;
        %     Peak_Ripple_Factor_Voltage_sample = NaN;
        %     RMS_Ripple_Factor_Voltage_sample = NaN;
        %     RDF_L1_sample = NaN;
        %     Peak_Ripple_Factor_L1_sample = NaN;
        %     RMS_Ripple_Factor_L1_sample = NaN;
        %     RDF_L2_sample = NaN;
        %     Peak_Ripple_Factor_L2_sample = NaN;
        %     RMS_Ripple_Factor_L2_sample = NaN;
        %     RDF_L3_sample = NaN;
        %     Peak_Ripple_Factor_L3_sample = NaN;
        %     RMS_Ripple_Factor_L3_sample = NaN;
        %     Uripple = NaN;
        %     Iripple_L1 = NaN;
        %     Iripple_L2 = NaN;
        %     Iripple_L3 = NaN;
        % else
        % Voltage
        Y_500K = fft(voltage_500K);
        Fs_500K = 500000;
        P2_500K = abs(Y_500K/L);
        P1_500K = P2_500K(1:round(L/2));
        P1_500K(2:end) = (2*P1_500K(2:end))/sqrt(2);
        f_500K = Fs_500K*(0:(L/2)-1)/L;

        Temp_500K = sum(P1_500K(2:end).^2);
        Temp2_500K = sqrt(Temp_500K);
        RDF_Voltage_sample_500K = (Temp2_500K / P1_500K(1)) *100;

        Peak_500K = max(voltage_500K);
        Valley_500K = min(voltage_500K);
        Peak_Ripple_Factor_Voltage_sample_500K = (Peak_500K - Valley_500K)/Uavg_sample_500K * 100;

        Uripple_500K = sqrt((Urms_sample_500K ^2) - (Uavg_sample_500K ^2));
        RMS_Ripple_Factor_Voltage_sample_500K = Uripple_500K/Uavg_sample_500K * 100;
        % Line 1
        Y_L1_500K = fft(current_L1_500K);

        P2_L1_500K = abs(Y_L1_500K/L);
        P1_L1_500K = P2_L1_500K(1:round(L/2));
        P1_L1_500K(2:end) = (2*P1_L1_500K(2:end))/sqrt(2);

        Temp_L1_500K = sum(P1_L1_500K(2:end).^2);
        Temp2_L1_500K = sqrt(Temp_L1_500K);
        RDF_L1_sample_500K = (Temp2_L1_500K / P1_L1_500K(1)) *100;

        Peak_500K = max(current_L1_500K);
        Valley_500K = min(current_L1_500K);
        Peak_Ripple_Factor_L1_sample_500K = (Peak_500K - Valley_500K)/current_mean_sample_L1_500K * 100;

        Iripple_L1_500K = sqrt((current_rms_sample_L1_500K^2) - (current_mean_sample_L1_500K ^2));
        RMS_Ripple_Factor_L1_sample_500K = Iripple_L1_500K/current_mean_sample_L1_500K * 100;
        % Line 2
        Y_L2_500K = fft(current_L2_500K);

        P2_L2_500K = abs(Y_L2_500K/L);
        P1_L2_500K = P2_L2_500K(1:round(L/2));
        P1_L2_500K(2:end) = (2*P1_L2_500K(2:end))/sqrt(2);

        Temp_L2_500K = sum(P1_L2_500K(2:end).^2);
        Temp2_L2_500K = sqrt(Temp_L2_500K);
        RDF_L2_sample_500K = (Temp2_L2_500K / P1_L2_500K(1)) *100;

        Peak_500K = max(current_L2_500K);
        Valley_500K = min(current_L2_500K);
        Peak_Ripple_Factor_L2_sample_500K = (Peak_500K - Valley_500K)/current_mean_sample_L2_500K * 100;

        Iripple_L2_500K = sqrt((current_rms_sample_L2_500K^2) - (current_mean_sample_L2_500K ^2));
        RMS_Ripple_Factor_L2_sample_500K = Iripple_L2_500K/current_mean_sample_L2_500K * 100;
        % Line 3
        Y_L3_500K = fft(current_L3_500K);

        P2_L3_500K = abs(Y_L3_500K/L);
        P1_L3_500K = P2_L3_500K(1:round(L/2));
        P1_L3_500K(2:end) = (2*P1_L3_500K(2:end))/sqrt(2);

        Temp_L3_500K = sum(P1_L3_500K(2:end).^2);
        Temp2_L3_500K = sqrt(Temp_L3_500K);
        RDF_L3_sample_500K = (Temp2_L3_500K / P1_L3_500K(1)) *100;

        Peak_500K = max(current_L3_500K);
        Valley_500K = min(current_L3_500K);
        Peak_Ripple_Factor_L3_sample_500K = (Peak_500K - Valley_500K)/current_mean_sample_L3_500K * 100;

        Iripple_L3_500K = sqrt((current_rms_sample_L3_500K^2) - (current_mean_sample_L3_500K ^2));
        RMS_Ripple_Factor_L3_sample_500K = Iripple_L3_500K/current_mean_sample_L3_500K * 100;

        %% Storage
        if num == 1 && docount == 1
            U_avg_500K = cat(1,U_avg_500K,Uavg_sample_500K);
            U_rms_500K = cat(1,U_rms_500K,Urms_sample_500K);
            I_rms_L1_500K = cat(1,I_rms_L1_500K,current_rms_sample_L1_500K);
            I_rms_L2_500K = cat(1,I_rms_L2_500K,current_rms_sample_L2_500K);
            I_rms_L3_500K = cat(1,I_rms_L3_500K,current_rms_sample_L3_500K);
            I_avg_L1_500K = cat(1,I_avg_L1_500K,current_mean_sample_L1_500K);
            I_avg_L2_500K = cat(1,I_avg_L2_500K,current_mean_sample_L2_500K);
            I_avg_L3_500K = cat(1,I_avg_L3_500K,current_mean_sample_L3_500K);

            U_ripple_500K = cat(1,U_ripple_500K,Uripple_500K);
            RDF_Voltage_500K = cat(1,RDF_Voltage_500K,RDF_Voltage_sample_500K);
            RMS_Ripple_Factor_Voltage_500K = cat(1,RMS_Ripple_Factor_Voltage_500K,RMS_Ripple_Factor_Voltage_sample_500K);
            Peak_Ripple_Factor_Voltage_500K = cat(1,Peak_Ripple_Factor_Voltage_500K,Peak_Ripple_Factor_Voltage_sample_500K);
            I_ripple_L1_500K = cat(1,I_ripple_L1_500K,Iripple_L1_500K);
            RDF_L1_500K = cat(1,RDF_L1_500K,RDF_L1_sample_500K);
            RMS_Ripple_Factor_L1_500K = cat(1,RMS_Ripple_Factor_L1_500K,RMS_Ripple_Factor_L1_sample_500K);
            Peak_Ripple_Factor_L1_500K = cat(1,Peak_Ripple_Factor_L1_500K,Peak_Ripple_Factor_L1_sample_500K);
            I_ripple_L2_500K = cat(1,I_ripple_L2_500K,Iripple_L2_500K);
            RDF_L2_500K = cat(1,RDF_L2_500K,RDF_L2_sample_500K);
            RMS_Ripple_Factor_L2_500K = cat(1,RMS_Ripple_Factor_L2_500K,RMS_Ripple_Factor_L2_sample_500K);
            Peak_Ripple_Factor_L2_500K = cat(1,Peak_Ripple_Factor_L2_500K,Peak_Ripple_Factor_L2_sample_500K);
            I_ripple_L3_500K = cat(1,I_ripple_L3_500K,Iripple_L3_500K);
            RDF_L3_500K = cat(1,RDF_L3_500K,RDF_L3_sample_500K);
            RMS_Ripple_Factor_L3_500K = cat(1,RMS_Ripple_Factor_L3_500K,RMS_Ripple_Factor_L3_sample_500K);
            Peak_Ripple_Factor_L3_500K = cat(1,Peak_Ripple_Factor_L3_500K,Peak_Ripple_Factor_L3_sample_500K);
            U_rms_10ms_500K = cat(1,U_rms_10ms_500K,Urms_nonStat_sample_500K);

            U_avg_500K(1,:) = [];
            U_rms_500K(1,:) = [];
            I_rms_L1_500K(1,:) = [];
            I_rms_L2_500K(1,:) = [];
            I_rms_L3_500K(1,:) = [];
            I_avg_L1_500K(1,:) = [];
            I_avg_L2_500K(1,:) = [];
            I_avg_L3_500K(1,:) = [];

            U_ripple_500K(1,:) = [];
            RDF_Voltage_500K(1,:) = [];
            RMS_Ripple_Factor_Voltage_500K(1,:) = [];
            Peak_Ripple_Factor_Voltage_500K(1,:) = [];
            I_ripple_L1_500K(1,:) = [];
            RDF_L1_500K(1,:) = [];
            RMS_Ripple_Factor_L1_500K(1,:) = [];
            Peak_Ripple_Factor_L1_500K(1,:) = [];
            I_ripple_L2_500K(1,:) = [];
            RDF_L2_500K(1,:) = [];
            RMS_Ripple_Factor_L2_500K(1,:) = [];
            Peak_Ripple_Factor_L2_500K(1,:) = [];
            I_ripple_L3_500K(1,:) = [];
            RDF_L3_500K(1,:) = [];
            RMS_Ripple_Factor_L3_500K(1,:) = [];
            Peak_Ripple_Factor_L3_500K(1,:) = [];
            U_rms_10ms_500K(1,:) = [];

        else
            U_avg_500K = cat(1,U_avg_500K,Uavg_sample_500K);
            U_rms_500K = cat(1,U_rms_500K,Urms_sample_500K);
            I_rms_L1_500K = cat(1,I_rms_L1_500K,current_rms_sample_L1_500K);
            I_rms_L2_500K = cat(1,I_rms_L2_500K,current_rms_sample_L2_500K);
            I_rms_L3_500K = cat(1,I_rms_L3_500K,current_rms_sample_L3_500K);
            I_avg_L1_500K = cat(1,I_avg_L1_500K,current_mean_sample_L1_500K);
            I_avg_L2_500K = cat(1,I_avg_L2_500K,current_mean_sample_L2_500K);
            I_avg_L3_500K = cat(1,I_avg_L3_500K,current_mean_sample_L3_500K);

            U_ripple_500K = cat(1,U_ripple_500K,Uripple_500K);
            RDF_Voltage_500K = cat(1,RDF_Voltage_500K,RDF_Voltage_sample_500K);
            RMS_Ripple_Factor_Voltage_500K = cat(1,RMS_Ripple_Factor_Voltage_500K,RMS_Ripple_Factor_Voltage_sample_500K);
            Peak_Ripple_Factor_Voltage_500K = cat(1,Peak_Ripple_Factor_Voltage_500K,Peak_Ripple_Factor_Voltage_sample_500K);
            I_ripple_L1_500K = cat(1,I_ripple_L1_500K,Iripple_L1_500K);
            RDF_L1_500K = cat(1,RDF_L1_500K,RDF_L1_sample_500K);
            RMS_Ripple_Factor_L1_500K = cat(1,RMS_Ripple_Factor_L1_500K,RMS_Ripple_Factor_L1_sample_500K);
            Peak_Ripple_Factor_L1_500K = cat(1,Peak_Ripple_Factor_L1_500K,Peak_Ripple_Factor_L1_sample_500K);
            I_ripple_L2_500K = cat(1,I_ripple_L2_500K,Iripple_L2_500K);
            RDF_L2_500K = cat(1,RDF_L2_500K,RDF_L2_sample_500K);
            RMS_Ripple_Factor_L2_500K = cat(1,RMS_Ripple_Factor_L2_500K,RMS_Ripple_Factor_L2_sample_500K);
            Peak_Ripple_Factor_L2_500K = cat(1,Peak_Ripple_Factor_L2_500K,Peak_Ripple_Factor_L2_sample_500K);
            I_ripple_L3_500K = cat(1,I_ripple_L3_500K,Iripple_L3_500K);
            RDF_L3_500K = cat(1,RDF_L3_500K,RDF_L3_sample_500K);
            RMS_Ripple_Factor_L3_500K = cat(1,RMS_Ripple_Factor_L3_500K,RMS_Ripple_Factor_L3_sample_500K);
            Peak_Ripple_Factor_L3_500K = cat(1,Peak_Ripple_Factor_L3_500K,Peak_Ripple_Factor_L3_sample_500K);
            U_rms_10ms_500K = cat(1,U_rms_10ms_500K,Urms_nonStat_sample_500K);


        end
        %% Mean & RMS Calculation
        %200K
        Urms_sample_200K = rms(voltage_200K);
        Uavg_sample_200K = mean(voltage_200K);
        current_mean_sample_L1_200K = mean(current_L1_200K);
        current_rms_sample_L1_200K = rms(current_L1_200K);
        current_mean_sample_L2_200K = mean(current_L2_200K);
        current_rms_sample_L2_200K = rms(current_L2_200K);
        current_mean_sample_L3_200K = mean(current_L3_200K);
        current_rms_sample_L3_200K = rms(current_L3_200K);

        k = 1;
        j = 1;
        temp = zeros(2000,1);
        for i = 1:40000
            temp(k,1) = voltage_200K(i);
            temp(k,2) = current_L1_200K(i);
            temp(k,3) = current_L2_200K(i);
            temp(k,4) = current_L3_200K(i);
            k = k+1;
            if k == (2000 + 1)
                Urms_nonStat_sample_200K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_200K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_200K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_200K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 40000;
        RDF_Voltage_sample_200K = 0;
        Peak_Ripple_Factor_Voltage_sample_200K = 0;
        RMS_Ripple_Factor_Voltage_sample_200K = 0;

        RDF_L1_sample_200K = 0;
        Peak_Ripple_Factor_L1_sample_200K = 0;
        RMS_Ripple_Factor_L1_sample_200K = 0;

        RDF_L2_sample_200K = 0;
        Peak_Ripple_Factor_L2_sample_200K = 0;
        RMS_Ripple_Factor_L2_sample_200K = 0;

        RDF_L3_sample_200K = 0;
        Peak_Ripple_Factor_L3_sample_200K = 0;
        RMS_Ripple_Factor_L3_sample_200K = 0;



        % Voltage
        Y_200K = fft(voltage_200K);
        Fs_200K = 200000;
        P2_200K = abs(Y_200K/L);
        P1_200K = P2_200K(1:round(L/2));
        P1_200K(2:end) = (2*P1_200K(2:end))/sqrt(2);
        f_200K = Fs_200K*(0:(L/2)-1)/L;

        Temp_200K = sum(P1_200K(2:end).^2);
        Temp2_200K = sqrt(Temp_200K);
        RDF_Voltage_sample_200K = (Temp2_200K / P1_200K(1)) *100;

        Peak_200K = max(voltage_200K);
        Valley_200K = min(voltage_200K);
        Peak_Ripple_Factor_Voltage_sample_200K = (Peak_200K - Valley_200K)/Uavg_sample_200K * 100;

        Uripple_200K = sqrt((Urms_sample_200K ^2) - (Uavg_sample_200K ^2));
        RMS_Ripple_Factor_Voltage_sample_200K = Uripple_200K/Uavg_sample_200K * 100;
        % Line 1
        Y_L1_200K = fft(current_L1_200K);

        P2_L1_200K = abs(Y_L1_200K/L);
        P1_L1_200K = P2_L1_200K(1:round(L/2));
        P1_L1_200K(2:end) = (2*P1_L1_200K(2:end))/sqrt(2);

        Temp_L1_200K = sum(P1_L1_200K(2:end).^2);
        Temp2_L1_200K = sqrt(Temp_L1_200K);
        RDF_L1_sample_200K = (Temp2_L1_200K / P1_L1_200K(1)) *100;

        Peak_200K = max(current_L1_200K);
        Valley_200K = min(current_L1_200K);
        Peak_Ripple_Factor_L1_sample_200K = (Peak_200K - Valley_200K)/current_mean_sample_L1_200K * 100;

        Iripple_L1_200K = sqrt((current_rms_sample_L1_200K^2) - (current_mean_sample_L1_200K ^2));
        RMS_Ripple_Factor_L1_sample_200K = Iripple_L1_200K/current_mean_sample_L1_200K * 100;
        % Line 2
        Y_L2_200K = fft(current_L2_200K);

        P2_L2_200K = abs(Y_L2_200K/L);
        P1_L2_200K = P2_L2_200K(1:round(L/2));
        P1_L2_200K(2:end) = (2*P1_L2_200K(2:end))/sqrt(2);

        Temp_L2_200K = sum(P1_L2_200K(2:end).^2);
        Temp2_L2_200K = sqrt(Temp_L2_200K);
        RDF_L2_sample_200K = (Temp2_L2_200K / P1_L2_200K(1)) *100;

        Peak_200K = max(current_L2_200K);
        Valley_200K = min(current_L2_200K);
        Peak_Ripple_Factor_L2_sample_200K = (Peak_200K - Valley_200K)/current_mean_sample_L2_200K * 100;

        Iripple_L2_200K = sqrt((current_rms_sample_L2_200K^2) - (current_mean_sample_L2_200K ^2));
        RMS_Ripple_Factor_L2_sample_200K = Iripple_L2_200K/current_mean_sample_L2_200K * 100;
        % Line 3
        Y_L3_200K = fft(current_L3_200K);

        P2_L3_200K = abs(Y_L3_200K/L);
        P1_L3_200K = P2_L3_200K(1:round(L/2));
        P1_L3_200K(2:end) = (2*P1_L3_200K(2:end))/sqrt(2);

        Temp_L3_200K = sum(P1_L3_200K(2:end).^2);
        Temp2_L3_200K = sqrt(Temp_L3_200K);
        RDF_L3_sample_200K = (Temp2_L3_200K / P1_L3_200K(1)) *100;

        Peak_200K = max(current_L3_200K);
        Valley_200K = min(current_L3_200K);
        Peak_Ripple_Factor_L3_sample_200K = (Peak_200K - Valley_200K)/current_mean_sample_L3_200K * 100;

        Iripple_L3_200K = sqrt((current_rms_sample_L3_200K^2) - (current_mean_sample_L3_200K ^2));
        RMS_Ripple_Factor_L3_sample_200K = Iripple_L3_200K/current_mean_sample_L3_200K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_200K = cat(1,U_avg_200K,Uavg_sample_200K);
            U_rms_200K = cat(1,U_rms_200K,Urms_sample_200K);
            I_rms_L1_200K = cat(1,I_rms_L1_200K,current_rms_sample_L1_200K);
            I_rms_L2_200K = cat(1,I_rms_L2_200K,current_rms_sample_L2_200K);
            I_rms_L3_200K = cat(1,I_rms_L3_200K,current_rms_sample_L3_200K);
            I_avg_L1_200K = cat(1,I_avg_L1_200K,current_mean_sample_L1_200K);
            I_avg_L2_200K = cat(1,I_avg_L2_200K,current_mean_sample_L2_200K);
            I_avg_L3_200K = cat(1,I_avg_L3_200K,current_mean_sample_L3_200K);

            U_ripple_200K = cat(1,U_ripple_200K,Uripple_200K);
            RDF_Voltage_200K = cat(1,RDF_Voltage_200K,RDF_Voltage_sample_200K);
            RMS_Ripple_Factor_Voltage_200K = cat(1,RMS_Ripple_Factor_Voltage_200K,RMS_Ripple_Factor_Voltage_sample_200K);
            Peak_Ripple_Factor_Voltage_200K = cat(1,Peak_Ripple_Factor_Voltage_200K,Peak_Ripple_Factor_Voltage_sample_200K);
            I_ripple_L1_200K = cat(1,I_ripple_L1_200K,Iripple_L1_200K);
            RDF_L1_200K = cat(1,RDF_L1_200K,RDF_L1_sample_200K);
            RMS_Ripple_Factor_L1_200K = cat(1,RMS_Ripple_Factor_L1_200K,RMS_Ripple_Factor_L1_sample_200K);
            Peak_Ripple_Factor_L1_200K = cat(1,Peak_Ripple_Factor_L1_200K,Peak_Ripple_Factor_L1_sample_200K);
            I_ripple_L2_200K = cat(1,I_ripple_L2_200K,Iripple_L2_200K);
            RDF_L2_200K = cat(1,RDF_L2_200K,RDF_L2_sample_200K);
            RMS_Ripple_Factor_L2_200K = cat(1,RMS_Ripple_Factor_L2_200K,RMS_Ripple_Factor_L2_sample_200K);
            Peak_Ripple_Factor_L2_200K = cat(1,Peak_Ripple_Factor_L2_200K,Peak_Ripple_Factor_L2_sample_200K);
            I_ripple_L3_200K = cat(1,I_ripple_L3_200K,Iripple_L3_200K);
            RDF_L3_200K = cat(1,RDF_L3_200K,RDF_L3_sample_200K);
            RMS_Ripple_Factor_L3_200K = cat(1,RMS_Ripple_Factor_L3_200K,RMS_Ripple_Factor_L3_sample_200K);
            Peak_Ripple_Factor_L3_200K = cat(1,Peak_Ripple_Factor_L3_200K,Peak_Ripple_Factor_L3_sample_200K);
            U_rms_10ms_200K = cat(1,U_rms_10ms_200K,Urms_nonStat_sample_200K);

            U_avg_200K(1,:) = [];
            U_rms_200K(1,:) = [];
            I_rms_L1_200K(1,:) = [];
            I_rms_L2_200K(1,:) = [];
            I_rms_L3_200K(1,:) = [];
            I_avg_L1_200K(1,:) = [];
            I_avg_L2_200K(1,:) = [];
            I_avg_L3_200K(1,:) = [];

            U_ripple_200K(1,:) = [];
            RDF_Voltage_200K(1,:) = [];
            RMS_Ripple_Factor_Voltage_200K(1,:) = [];
            Peak_Ripple_Factor_Voltage_200K(1,:) = [];
            I_ripple_L1_200K(1,:) = [];
            RDF_L1_200K(1,:) = [];
            RMS_Ripple_Factor_L1_200K(1,:) = [];
            Peak_Ripple_Factor_L1_200K(1,:) = [];
            I_ripple_L2_200K(1,:) = [];
            RDF_L2_200K(1,:) = [];
            RMS_Ripple_Factor_L2_200K(1,:) = [];
            Peak_Ripple_Factor_L2_200K(1,:) = [];
            I_ripple_L3_200K(1,:) = [];
            RDF_L3_200K(1,:) = [];
            RMS_Ripple_Factor_L3_200K(1,:) = [];
            Peak_Ripple_Factor_L3_200K(1,:) = [];
            U_rms_10ms_200K(1,:) = [];

        else
            U_avg_200K = cat(1,U_avg_200K,Uavg_sample_200K);
            U_rms_200K = cat(1,U_rms_200K,Urms_sample_200K);
            I_rms_L1_200K = cat(1,I_rms_L1_200K,current_rms_sample_L1_200K);
            I_rms_L2_200K = cat(1,I_rms_L2_200K,current_rms_sample_L2_200K);
            I_rms_L3_200K = cat(1,I_rms_L3_200K,current_rms_sample_L3_200K);
            I_avg_L1_200K = cat(1,I_avg_L1_200K,current_mean_sample_L1_200K);
            I_avg_L2_200K = cat(1,I_avg_L2_200K,current_mean_sample_L2_200K);
            I_avg_L3_200K = cat(1,I_avg_L3_200K,current_mean_sample_L3_200K);

            U_ripple_200K = cat(1,U_ripple_200K,Uripple_200K);
            RDF_Voltage_200K = cat(1,RDF_Voltage_200K,RDF_Voltage_sample_200K);
            RMS_Ripple_Factor_Voltage_200K = cat(1,RMS_Ripple_Factor_Voltage_200K,RMS_Ripple_Factor_Voltage_sample_200K);
            Peak_Ripple_Factor_Voltage_200K = cat(1,Peak_Ripple_Factor_Voltage_200K,Peak_Ripple_Factor_Voltage_sample_200K);
            I_ripple_L1_200K = cat(1,I_ripple_L1_200K,Iripple_L1_200K);
            RDF_L1_200K = cat(1,RDF_L1_200K,RDF_L1_sample_200K);
            RMS_Ripple_Factor_L1_200K = cat(1,RMS_Ripple_Factor_L1_200K,RMS_Ripple_Factor_L1_sample_200K);
            Peak_Ripple_Factor_L1_200K = cat(1,Peak_Ripple_Factor_L1_200K,Peak_Ripple_Factor_L1_sample_200K);
            I_ripple_L2_200K = cat(1,I_ripple_L2_200K,Iripple_L2_200K);
            RDF_L2_200K = cat(1,RDF_L2_200K,RDF_L2_sample_200K);
            RMS_Ripple_Factor_L2_200K = cat(1,RMS_Ripple_Factor_L2_200K,RMS_Ripple_Factor_L2_sample_200K);
            Peak_Ripple_Factor_L2_200K = cat(1,Peak_Ripple_Factor_L2_200K,Peak_Ripple_Factor_L2_sample_200K);
            I_ripple_L3_200K = cat(1,I_ripple_L3_200K,Iripple_L3_200K);
            RDF_L3_200K = cat(1,RDF_L3_200K,RDF_L3_sample_200K);
            RMS_Ripple_Factor_L3_200K = cat(1,RMS_Ripple_Factor_L3_200K,RMS_Ripple_Factor_L3_sample_200K);
            Peak_Ripple_Factor_L3_200K = cat(1,Peak_Ripple_Factor_L3_200K,Peak_Ripple_Factor_L3_sample_200K);
            U_rms_10ms_200K = cat(1,U_rms_10ms_200K,Urms_nonStat_sample_200K);


        end
        %% Mean & RMS Calculation
        %100K
        Urms_sample_100K = rms(voltage_100K);
        Uavg_sample_100K = mean(voltage_100K);
        current_mean_sample_L1_100K = mean(current_L1_100K);
        current_rms_sample_L1_100K = rms(current_L1_100K);
        current_mean_sample_L2_100K = mean(current_L2_100K);
        current_rms_sample_L2_100K = rms(current_L2_100K);
        current_mean_sample_L3_100K = mean(current_L3_100K);
        current_rms_sample_L3_100K = rms(current_L3_100K);

        k = 1;
        j = 1;
        temp = zeros(1000,1);
        for i = 1:20000
            temp(k,1) = voltage_100K(i);
            temp(k,2) = current_L1_100K(i);
            temp(k,3) = current_L2_100K(i);
            temp(k,4) = current_L3_100K(i);
            k = k+1;
            if k == (1000 + 1)
                Urms_nonStat_sample_100K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_100K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_100K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_100K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 20000;
        RDF_Voltage_sample_100K = 0;
        Peak_Ripple_Factor_Voltage_sample_100K = 0;
        RMS_Ripple_Factor_Voltage_sample_100K = 0;

        RDF_L1_sample_100K = 0;
        Peak_Ripple_Factor_L1_sample_100K = 0;
        RMS_Ripple_Factor_L1_sample_100K = 0;

        RDF_L2_sample_100K = 0;
        Peak_Ripple_Factor_L2_sample_100K = 0;
        RMS_Ripple_Factor_L2_sample_100K = 0;

        RDF_L3_sample_100K = 0;
        Peak_Ripple_Factor_L3_sample_100K = 0;
        RMS_Ripple_Factor_L3_sample_100K = 0;



        % Voltage
        Y_100K = fft(voltage_100K);
        Fs_100K = 100000;
        P2_100K = abs(Y_100K/L);
        P1_100K = P2_100K(1:round(L/2));
        P1_100K(2:end) = (2*P1_100K(2:end))/sqrt(2);
        f_100K = Fs_100K*(0:(L/2)-1)/L;

        Temp_100K = sum(P1_100K(2:end).^2);
        Temp2_100K = sqrt(Temp_100K);
        RDF_Voltage_sample_100K = (Temp2_100K / P1_100K(1)) *100;

        Peak_100K = max(voltage_100K);
        Valley_100K = min(voltage_100K);
        Peak_Ripple_Factor_Voltage_sample_100K = (Peak_100K - Valley_100K)/Uavg_sample_100K * 100;

        Uripple_100K = sqrt((Urms_sample_100K ^2) - (Uavg_sample_100K ^2));
        RMS_Ripple_Factor_Voltage_sample_100K = Uripple_100K/Uavg_sample_100K * 100;
        % Line 1
        Y_L1_100K = fft(current_L1_100K);

        P2_L1_100K = abs(Y_L1_100K/L);
        P1_L1_100K = P2_L1_100K(1:round(L/2));
        P1_L1_100K(2:end) = (2*P1_L1_100K(2:end))/sqrt(2);

        Temp_L1_100K = sum(P1_L1_100K(2:end).^2);
        Temp2_L1_100K = sqrt(Temp_L1_100K);
        RDF_L1_sample_100K = (Temp2_L1_100K / P1_L1_100K(1)) *100;

        Peak_100K = max(current_L1_100K);
        Valley_100K = min(current_L1_100K);
        Peak_Ripple_Factor_L1_sample_100K = (Peak_100K - Valley_100K)/current_mean_sample_L1_100K * 100;

        Iripple_L1_100K = sqrt((current_rms_sample_L1_100K^2) - (current_mean_sample_L1_100K ^2));
        RMS_Ripple_Factor_L1_sample_100K = Iripple_L1_100K/current_mean_sample_L1_100K * 100;
        % Line 2
        Y_L2_100K = fft(current_L2_100K);

        P2_L2_100K = abs(Y_L2_100K/L);
        P1_L2_100K = P2_L2_100K(1:round(L/2));
        P1_L2_100K(2:end) = (2*P1_L2_100K(2:end))/sqrt(2);

        Temp_L2_100K = sum(P1_L2_100K(2:end).^2);
        Temp2_L2_100K = sqrt(Temp_L2_100K);
        RDF_L2_sample_100K = (Temp2_L2_100K / P1_L2_100K(1)) *100;

        Peak_100K = max(current_L2_100K);
        Valley_100K = min(current_L2_100K);
        Peak_Ripple_Factor_L2_sample_100K = (Peak_100K - Valley_100K)/current_mean_sample_L2_100K * 100;

        Iripple_L2_100K = sqrt((current_rms_sample_L2_100K^2) - (current_mean_sample_L2_100K ^2));
        RMS_Ripple_Factor_L2_sample_100K = Iripple_L2_100K/current_mean_sample_L2_100K * 100;
        % Line 3
        Y_L3_100K = fft(current_L3_100K);

        P2_L3_100K = abs(Y_L3_100K/L);
        P1_L3_100K = P2_L3_100K(1:round(L/2));
        P1_L3_100K(2:end) = (2*P1_L3_100K(2:end))/sqrt(2);

        Temp_L3_100K = sum(P1_L3_100K(2:end).^2);
        Temp2_L3_100K = sqrt(Temp_L3_100K);
        RDF_L3_sample_100K = (Temp2_L3_100K / P1_L3_100K(1)) *100;

        Peak_100K = max(current_L3_100K);
        Valley_100K = min(current_L3_100K);
        Peak_Ripple_Factor_L3_sample_100K = (Peak_100K - Valley_100K)/current_mean_sample_L3_100K * 100;

        Iripple_L3_100K = sqrt((current_rms_sample_L3_100K^2) - (current_mean_sample_L3_100K ^2));
        RMS_Ripple_Factor_L3_sample_100K = Iripple_L3_100K/current_mean_sample_L3_100K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_100K = cat(1,U_avg_100K,Uavg_sample_100K);
            U_rms_100K = cat(1,U_rms_100K,Urms_sample_100K);
            I_rms_L1_100K = cat(1,I_rms_L1_100K,current_rms_sample_L1_100K);
            I_rms_L2_100K = cat(1,I_rms_L2_100K,current_rms_sample_L2_100K);
            I_rms_L3_100K = cat(1,I_rms_L3_100K,current_rms_sample_L3_100K);
            I_avg_L1_100K = cat(1,I_avg_L1_100K,current_mean_sample_L1_100K);
            I_avg_L2_100K = cat(1,I_avg_L2_100K,current_mean_sample_L2_100K);
            I_avg_L3_100K = cat(1,I_avg_L3_100K,current_mean_sample_L3_100K);

            U_ripple_100K = cat(1,U_ripple_100K,Uripple_100K);
            RDF_Voltage_100K = cat(1,RDF_Voltage_100K,RDF_Voltage_sample_100K);
            RMS_Ripple_Factor_Voltage_100K = cat(1,RMS_Ripple_Factor_Voltage_100K,RMS_Ripple_Factor_Voltage_sample_100K);
            Peak_Ripple_Factor_Voltage_100K = cat(1,Peak_Ripple_Factor_Voltage_100K,Peak_Ripple_Factor_Voltage_sample_100K);
            I_ripple_L1_100K = cat(1,I_ripple_L1_100K,Iripple_L1_100K);
            RDF_L1_100K = cat(1,RDF_L1_100K,RDF_L1_sample_100K);
            RMS_Ripple_Factor_L1_100K = cat(1,RMS_Ripple_Factor_L1_100K,RMS_Ripple_Factor_L1_sample_100K);
            Peak_Ripple_Factor_L1_100K = cat(1,Peak_Ripple_Factor_L1_100K,Peak_Ripple_Factor_L1_sample_100K);
            I_ripple_L2_100K = cat(1,I_ripple_L2_100K,Iripple_L2_100K);
            RDF_L2_100K = cat(1,RDF_L2_100K,RDF_L2_sample_100K);
            RMS_Ripple_Factor_L2_100K = cat(1,RMS_Ripple_Factor_L2_100K,RMS_Ripple_Factor_L2_sample_100K);
            Peak_Ripple_Factor_L2_100K = cat(1,Peak_Ripple_Factor_L2_100K,Peak_Ripple_Factor_L2_sample_100K);
            I_ripple_L3_100K = cat(1,I_ripple_L3_100K,Iripple_L3_100K);
            RDF_L3_100K = cat(1,RDF_L3_100K,RDF_L3_sample_100K);
            RMS_Ripple_Factor_L3_100K = cat(1,RMS_Ripple_Factor_L3_100K,RMS_Ripple_Factor_L3_sample_100K);
            Peak_Ripple_Factor_L3_100K = cat(1,Peak_Ripple_Factor_L3_100K,Peak_Ripple_Factor_L3_sample_100K);
            U_rms_10ms_100K = cat(1,U_rms_10ms_100K,Urms_nonStat_sample_100K);

            U_avg_100K(1,:) = [];
            U_rms_100K(1,:) = [];
            I_rms_L1_100K(1,:) = [];
            I_rms_L2_100K(1,:) = [];
            I_rms_L3_100K(1,:) = [];
            I_avg_L1_100K(1,:) = [];
            I_avg_L2_100K(1,:) = [];
            I_avg_L3_100K(1,:) = [];

            U_ripple_100K(1,:) = [];
            RDF_Voltage_100K(1,:) = [];
            RMS_Ripple_Factor_Voltage_100K(1,:) = [];
            Peak_Ripple_Factor_Voltage_100K(1,:) = [];
            I_ripple_L1_100K(1,:) = [];
            RDF_L1_100K(1,:) = [];
            RMS_Ripple_Factor_L1_100K(1,:) = [];
            Peak_Ripple_Factor_L1_100K(1,:) = [];
            I_ripple_L2_100K(1,:) = [];
            RDF_L2_100K(1,:) = [];
            RMS_Ripple_Factor_L2_100K(1,:) = [];
            Peak_Ripple_Factor_L2_100K(1,:) = [];
            I_ripple_L3_100K(1,:) = [];
            RDF_L3_100K(1,:) = [];
            RMS_Ripple_Factor_L3_100K(1,:) = [];
            Peak_Ripple_Factor_L3_100K(1,:) = [];
            U_rms_10ms_100K(1,:) = [];

        else
            U_avg_100K = cat(1,U_avg_100K,Uavg_sample_100K);
            U_rms_100K = cat(1,U_rms_100K,Urms_sample_100K);
            I_rms_L1_100K = cat(1,I_rms_L1_100K,current_rms_sample_L1_100K);
            I_rms_L2_100K = cat(1,I_rms_L2_100K,current_rms_sample_L2_100K);
            I_rms_L3_100K = cat(1,I_rms_L3_100K,current_rms_sample_L3_100K);
            I_avg_L1_100K = cat(1,I_avg_L1_100K,current_mean_sample_L1_100K);
            I_avg_L2_100K = cat(1,I_avg_L2_100K,current_mean_sample_L2_100K);
            I_avg_L3_100K = cat(1,I_avg_L3_100K,current_mean_sample_L3_100K);

            U_ripple_100K = cat(1,U_ripple_100K,Uripple_100K);
            RDF_Voltage_100K = cat(1,RDF_Voltage_100K,RDF_Voltage_sample_100K);
            RMS_Ripple_Factor_Voltage_100K = cat(1,RMS_Ripple_Factor_Voltage_100K,RMS_Ripple_Factor_Voltage_sample_100K);
            Peak_Ripple_Factor_Voltage_100K = cat(1,Peak_Ripple_Factor_Voltage_100K,Peak_Ripple_Factor_Voltage_sample_100K);
            I_ripple_L1_100K = cat(1,I_ripple_L1_100K,Iripple_L1_100K);
            RDF_L1_100K = cat(1,RDF_L1_100K,RDF_L1_sample_100K);
            RMS_Ripple_Factor_L1_100K = cat(1,RMS_Ripple_Factor_L1_100K,RMS_Ripple_Factor_L1_sample_100K);
            Peak_Ripple_Factor_L1_100K = cat(1,Peak_Ripple_Factor_L1_100K,Peak_Ripple_Factor_L1_sample_100K);
            I_ripple_L2_100K = cat(1,I_ripple_L2_100K,Iripple_L2_100K);
            RDF_L2_100K = cat(1,RDF_L2_100K,RDF_L2_sample_100K);
            RMS_Ripple_Factor_L2_100K = cat(1,RMS_Ripple_Factor_L2_100K,RMS_Ripple_Factor_L2_sample_100K);
            Peak_Ripple_Factor_L2_100K = cat(1,Peak_Ripple_Factor_L2_100K,Peak_Ripple_Factor_L2_sample_100K);
            I_ripple_L3_100K = cat(1,I_ripple_L3_100K,Iripple_L3_100K);
            RDF_L3_100K = cat(1,RDF_L3_100K,RDF_L3_sample_100K);
            RMS_Ripple_Factor_L3_100K = cat(1,RMS_Ripple_Factor_L3_100K,RMS_Ripple_Factor_L3_sample_100K);
            Peak_Ripple_Factor_L3_100K = cat(1,Peak_Ripple_Factor_L3_100K,Peak_Ripple_Factor_L3_sample_100K);
            U_rms_10ms_100K = cat(1,U_rms_10ms_100K,Urms_nonStat_sample_100K);


        end
        %% Mean & RMS Calculation
        %50K
        Urms_sample_50K = rms(voltage_50K);
        Uavg_sample_50K = mean(voltage_50K);
        current_mean_sample_L1_50K = mean(current_L1_50K);
        current_rms_sample_L1_50K = rms(current_L1_50K);
        current_mean_sample_L2_50K = mean(current_L2_50K);
        current_rms_sample_L2_50K = rms(current_L2_50K);
        current_mean_sample_L3_50K = mean(current_L3_50K);
        current_rms_sample_L3_50K = rms(current_L3_50K);

        k = 1;
        j = 1;
        temp = zeros(500,1);
        for i = 1:10000
            temp(k,1) = voltage_50K(i);
            temp(k,2) = current_L1_50K(i);
            temp(k,3) = current_L2_50K(i);
            temp(k,4) = current_L3_50K(i);
            k = k+1;
            if k == (500 + 1)
                Urms_nonStat_sample_50K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_50K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_50K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_50K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 10000;
        RDF_Voltage_sample_50K = 0;
        Peak_Ripple_Factor_Voltage_sample_50K = 0;
        RMS_Ripple_Factor_Voltage_sample_50K = 0;

        RDF_L1_sample_50K = 0;
        Peak_Ripple_Factor_L1_sample_50K = 0;
        RMS_Ripple_Factor_L1_sample_50K = 0;

        RDF_L2_sample_50K = 0;
        Peak_Ripple_Factor_L2_sample_50K = 0;
        RMS_Ripple_Factor_L2_sample_50K = 0;

        RDF_L3_sample_50K = 0;
        Peak_Ripple_Factor_L3_sample_50K = 0;
        RMS_Ripple_Factor_L3_sample_50K = 0;

        % Voltage
        Y_50K = fft(voltage_50K);
        Fs_50K = 50000;
        P2_50K = abs(Y_50K/L);
        P1_50K = P2_50K(1:round(L/2));
        P1_50K(2:end) = (2*P1_50K(2:end))/sqrt(2);
        f_50K = Fs_50K*(0:(L/2)-1)/L;

        Temp_50K = sum(P1_50K(2:end).^2);
        Temp2_50K = sqrt(Temp_50K);
        RDF_Voltage_sample_50K = (Temp2_50K / P1_50K(1)) *100;

        Peak_50K = max(voltage_50K);
        Valley_50K = min(voltage_50K);
        Peak_Ripple_Factor_Voltage_sample_50K = (Peak_50K - Valley_50K)/Uavg_sample_50K * 100;

        Uripple_50K = sqrt((Urms_sample_50K ^2) - (Uavg_sample_50K ^2));
        RMS_Ripple_Factor_Voltage_sample_50K = Uripple_50K/Uavg_sample_50K * 100;
        % Line 1
        Y_L1_50K = fft(current_L1_50K);

        P2_L1_50K = abs(Y_L1_50K/L);
        P1_L1_50K = P2_L1_50K(1:round(L/2));
        P1_L1_50K(2:end) = (2*P1_L1_50K(2:end))/sqrt(2);

        Temp_L1_50K = sum(P1_L1_50K(2:end).^2);
        Temp2_L1_50K = sqrt(Temp_L1_50K);
        RDF_L1_sample_50K = (Temp2_L1_50K / P1_L1_50K(1)) *100;

        Peak_50K = max(current_L1_50K);
        Valley_50K = min(current_L1_50K);
        Peak_Ripple_Factor_L1_sample_50K = (Peak_50K - Valley_50K)/current_mean_sample_L1_50K * 100;

        Iripple_L1_50K = sqrt((current_rms_sample_L1_50K^2) - (current_mean_sample_L1_50K ^2));
        RMS_Ripple_Factor_L1_sample_50K = Iripple_L1_50K/current_mean_sample_L1_50K * 100;
        % Line 2
        Y_L2_50K = fft(current_L2_50K);

        P2_L2_50K = abs(Y_L2_50K/L);
        P1_L2_50K = P2_L2_50K(1:round(L/2));
        P1_L2_50K(2:end) = (2*P1_L2_50K(2:end))/sqrt(2);

        Temp_L2_50K = sum(P1_L2_50K(2:end).^2);
        Temp2_L2_50K = sqrt(Temp_L2_50K);
        RDF_L2_sample_50K = (Temp2_L2_50K / P1_L2_50K(1)) *100;

        Peak_50K = max(current_L2_50K);
        Valley_50K = min(current_L2_50K);
        Peak_Ripple_Factor_L2_sample_50K = (Peak_50K - Valley_50K)/current_mean_sample_L2_50K * 100;

        Iripple_L2_50K = sqrt((current_rms_sample_L2_50K^2) - (current_mean_sample_L2_50K ^2));
        RMS_Ripple_Factor_L2_sample_50K = Iripple_L2_50K/current_mean_sample_L2_50K * 100;
        % Line 3
        Y_L3_50K = fft(current_L3_50K);

        P2_L3_50K = abs(Y_L3_50K/L);
        P1_L3_50K = P2_L3_50K(1:round(L/2));
        P1_L3_50K(2:end) = (2*P1_L3_50K(2:end))/sqrt(2);

        Temp_L3_50K = sum(P1_L3_50K(2:end).^2);
        Temp2_L3_50K = sqrt(Temp_L3_50K);
        RDF_L3_sample_50K = (Temp2_L3_50K / P1_L3_50K(1)) *100;

        Peak_50K = max(current_L3_50K);
        Valley_50K = min(current_L3_50K);
        Peak_Ripple_Factor_L3_sample_50K = (Peak_50K - Valley_50K)/current_mean_sample_L3_50K * 100;

        Iripple_L3_50K = sqrt((current_rms_sample_L3_50K^2) - (current_mean_sample_L3_50K ^2));
        RMS_Ripple_Factor_L3_sample_50K = Iripple_L3_50K/current_mean_sample_L3_50K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_50K = cat(1,U_avg_50K,Uavg_sample_50K);
            U_rms_50K = cat(1,U_rms_50K,Urms_sample_50K);
            I_rms_L1_50K = cat(1,I_rms_L1_50K,current_rms_sample_L1_50K);
            I_rms_L2_50K = cat(1,I_rms_L2_50K,current_rms_sample_L2_50K);
            I_rms_L3_50K = cat(1,I_rms_L3_50K,current_rms_sample_L3_50K);
            I_avg_L1_50K = cat(1,I_avg_L1_50K,current_mean_sample_L1_50K);
            I_avg_L2_50K = cat(1,I_avg_L2_50K,current_mean_sample_L2_50K);
            I_avg_L3_50K = cat(1,I_avg_L3_50K,current_mean_sample_L3_50K);

            U_ripple_50K = cat(1,U_ripple_50K,Uripple_50K);
            RDF_Voltage_50K = cat(1,RDF_Voltage_50K,RDF_Voltage_sample_50K);
            RMS_Ripple_Factor_Voltage_50K = cat(1,RMS_Ripple_Factor_Voltage_50K,RMS_Ripple_Factor_Voltage_sample_50K);
            Peak_Ripple_Factor_Voltage_50K = cat(1,Peak_Ripple_Factor_Voltage_50K,Peak_Ripple_Factor_Voltage_sample_50K);
            I_ripple_L1_50K = cat(1,I_ripple_L1_50K,Iripple_L1_50K);
            RDF_L1_50K = cat(1,RDF_L1_50K,RDF_L1_sample_50K);
            RMS_Ripple_Factor_L1_50K = cat(1,RMS_Ripple_Factor_L1_50K,RMS_Ripple_Factor_L1_sample_50K);
            Peak_Ripple_Factor_L1_50K = cat(1,Peak_Ripple_Factor_L1_50K,Peak_Ripple_Factor_L1_sample_50K);
            I_ripple_L2_50K = cat(1,I_ripple_L2_50K,Iripple_L2_50K);
            RDF_L2_50K = cat(1,RDF_L2_50K,RDF_L2_sample_50K);
            RMS_Ripple_Factor_L2_50K = cat(1,RMS_Ripple_Factor_L2_50K,RMS_Ripple_Factor_L2_sample_50K);
            Peak_Ripple_Factor_L2_50K = cat(1,Peak_Ripple_Factor_L2_50K,Peak_Ripple_Factor_L2_sample_50K);
            I_ripple_L3_50K = cat(1,I_ripple_L3_50K,Iripple_L3_50K);
            RDF_L3_50K = cat(1,RDF_L3_50K,RDF_L3_sample_50K);
            RMS_Ripple_Factor_L3_50K = cat(1,RMS_Ripple_Factor_L3_50K,RMS_Ripple_Factor_L3_sample_50K);
            Peak_Ripple_Factor_L3_50K = cat(1,Peak_Ripple_Factor_L3_50K,Peak_Ripple_Factor_L3_sample_50K);
            U_rms_10ms_50K = cat(1,U_rms_10ms_50K,Urms_nonStat_sample_50K);

            U_avg_50K(1,:) = [];
            U_rms_50K(1,:) = [];
            I_rms_L1_50K(1,:) = [];
            I_rms_L2_50K(1,:) = [];
            I_rms_L3_50K(1,:) = [];
            I_avg_L1_50K(1,:) = [];
            I_avg_L2_50K(1,:) = [];
            I_avg_L3_50K(1,:) = [];

            U_ripple_50K(1,:) = [];
            RDF_Voltage_50K(1,:) = [];
            RMS_Ripple_Factor_Voltage_50K(1,:) = [];
            Peak_Ripple_Factor_Voltage_50K(1,:) = [];
            I_ripple_L1_50K(1,:) = [];
            RDF_L1_50K(1,:) = [];
            RMS_Ripple_Factor_L1_50K(1,:) = [];
            Peak_Ripple_Factor_L1_50K(1,:) = [];
            I_ripple_L2_50K(1,:) = [];
            RDF_L2_50K(1,:) = [];
            RMS_Ripple_Factor_L2_50K(1,:) = [];
            Peak_Ripple_Factor_L2_50K(1,:) = [];
            I_ripple_L3_50K(1,:) = [];
            RDF_L3_50K(1,:) = [];
            RMS_Ripple_Factor_L3_50K(1,:) = [];
            Peak_Ripple_Factor_L3_50K(1,:) = [];
            U_rms_10ms_50K(1,:) = [];

        else
            U_avg_50K = cat(1,U_avg_50K,Uavg_sample_50K);
            U_rms_50K = cat(1,U_rms_50K,Urms_sample_50K);
            I_rms_L1_50K = cat(1,I_rms_L1_50K,current_rms_sample_L1_50K);
            I_rms_L2_50K = cat(1,I_rms_L2_50K,current_rms_sample_L2_50K);
            I_rms_L3_50K = cat(1,I_rms_L3_50K,current_rms_sample_L3_50K);
            I_avg_L1_50K = cat(1,I_avg_L1_50K,current_mean_sample_L1_50K);
            I_avg_L2_50K = cat(1,I_avg_L2_50K,current_mean_sample_L2_50K);
            I_avg_L3_50K = cat(1,I_avg_L3_50K,current_mean_sample_L3_50K);

            U_ripple_50K = cat(1,U_ripple_50K,Uripple_50K);
            RDF_Voltage_50K = cat(1,RDF_Voltage_50K,RDF_Voltage_sample_50K);
            RMS_Ripple_Factor_Voltage_50K = cat(1,RMS_Ripple_Factor_Voltage_50K,RMS_Ripple_Factor_Voltage_sample_50K);
            Peak_Ripple_Factor_Voltage_50K = cat(1,Peak_Ripple_Factor_Voltage_50K,Peak_Ripple_Factor_Voltage_sample_50K);
            I_ripple_L1_50K = cat(1,I_ripple_L1_50K,Iripple_L1_50K);
            RDF_L1_50K = cat(1,RDF_L1_50K,RDF_L1_sample_50K);
            RMS_Ripple_Factor_L1_50K = cat(1,RMS_Ripple_Factor_L1_50K,RMS_Ripple_Factor_L1_sample_50K);
            Peak_Ripple_Factor_L1_50K = cat(1,Peak_Ripple_Factor_L1_50K,Peak_Ripple_Factor_L1_sample_50K);
            I_ripple_L2_50K = cat(1,I_ripple_L2_50K,Iripple_L2_50K);
            RDF_L2_50K = cat(1,RDF_L2_50K,RDF_L2_sample_50K);
            RMS_Ripple_Factor_L2_50K = cat(1,RMS_Ripple_Factor_L2_50K,RMS_Ripple_Factor_L2_sample_50K);
            Peak_Ripple_Factor_L2_50K = cat(1,Peak_Ripple_Factor_L2_50K,Peak_Ripple_Factor_L2_sample_50K);
            I_ripple_L3_50K = cat(1,I_ripple_L3_50K,Iripple_L3_50K);
            RDF_L3_50K = cat(1,RDF_L3_50K,RDF_L3_sample_50K);
            RMS_Ripple_Factor_L3_50K = cat(1,RMS_Ripple_Factor_L3_50K,RMS_Ripple_Factor_L3_sample_50K);
            Peak_Ripple_Factor_L3_50K = cat(1,Peak_Ripple_Factor_L3_50K,Peak_Ripple_Factor_L3_sample_50K);
            U_rms_10ms_50K = cat(1,U_rms_10ms_50K,Urms_nonStat_sample_50K);


        end
        %% Mean & RMS Calculation
        %20K
        Urms_sample_20K = rms(voltage_20K);
        Uavg_sample_20K = mean(voltage_20K);
        current_mean_sample_L1_20K = mean(current_L1_20K);
        current_rms_sample_L1_20K = rms(current_L1_20K);
        current_mean_sample_L2_20K = mean(current_L2_20K);
        current_rms_sample_L2_20K = rms(current_L2_20K);
        current_mean_sample_L3_20K = mean(current_L3_20K);
        current_rms_sample_L3_20K = rms(current_L3_20K);

        k = 1;
        j = 1;
        temp = zeros(200,1);
        for i = 1:4000
            temp(k,1) = voltage_20K(i);
            temp(k,2) = current_L1_20K(i);
            temp(k,3) = current_L2_20K(i);
            temp(k,4) = current_L3_20K(i);
            k = k+1;
            if k == (200 + 1)
                Urms_nonStat_sample_20K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_20K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_20K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_20K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 4000;
        RDF_Voltage_sample_20K = 0;
        Peak_Ripple_Factor_Voltage_sample_20K = 0;
        RMS_Ripple_Factor_Voltage_sample_20K = 0;

        RDF_L1_sample_20K = 0;
        Peak_Ripple_Factor_L1_sample_20K = 0;
        RMS_Ripple_Factor_L1_sample_20K = 0;

        RDF_L2_sample_20K = 0;
        Peak_Ripple_Factor_L2_sample_20K = 0;
        RMS_Ripple_Factor_L2_sample_20K = 0;

        RDF_L3_sample_20K = 0;
        Peak_Ripple_Factor_L3_sample_20K = 0;
        RMS_Ripple_Factor_L3_sample_20K = 0;



        % Voltage
        Y_20K = fft(voltage_20K);
        Fs_20K = 20000;
        P2_20K = abs(Y_20K/L);
        P1_20K = P2_20K(1:round(L/2));
        P1_20K(2:end) = (2*P1_20K(2:end))/sqrt(2);
        f_20K = Fs_20K*(0:(L/2)-1)/L;

        Temp_20K = sum(P1_20K(2:end).^2);
        Temp2_20K = sqrt(Temp_20K);
        RDF_Voltage_sample_20K = (Temp2_20K / P1_20K(1)) *100;

        Peak_20K = max(voltage_20K);
        Valley_20K = min(voltage_20K);
        Peak_Ripple_Factor_Voltage_sample_20K = (Peak_20K - Valley_20K)/Uavg_sample_20K * 100;

        Uripple_20K = sqrt((Urms_sample_20K ^2) - (Uavg_sample_20K ^2));
        RMS_Ripple_Factor_Voltage_sample_20K = Uripple_20K/Uavg_sample_20K * 100;
        % Line 1
        Y_L1_20K = fft(current_L1_20K);

        P2_L1_20K = abs(Y_L1_20K/L);
        P1_L1_20K = P2_L1_20K(1:round(L/2));
        P1_L1_20K(2:end) = (2*P1_L1_20K(2:end))/sqrt(2);

        Temp_L1_20K = sum(P1_L1_20K(2:end).^2);
        Temp2_L1_20K = sqrt(Temp_L1_20K);
        RDF_L1_sample_20K = (Temp2_L1_20K / P1_L1_20K(1)) *100;

        Peak_20K = max(current_L1_20K);
        Valley_20K = min(current_L1_20K);
        Peak_Ripple_Factor_L1_sample_20K = (Peak_20K - Valley_20K)/current_mean_sample_L1_20K * 100;

        Iripple_L1_20K = sqrt((current_rms_sample_L1_20K^2) - (current_mean_sample_L1_20K ^2));
        RMS_Ripple_Factor_L1_sample_20K = Iripple_L1_20K/current_mean_sample_L1_20K * 100;
        % Line 2
        Y_L2_20K = fft(current_L2_20K);

        P2_L2_20K = abs(Y_L2_20K/L);
        P1_L2_20K = P2_L2_20K(1:round(L/2));
        P1_L2_20K(2:end) = (2*P1_L2_20K(2:end))/sqrt(2);

        Temp_L2_20K = sum(P1_L2_20K(2:end).^2);
        Temp2_L2_20K = sqrt(Temp_L2_20K);
        RDF_L2_sample_20K = (Temp2_L2_20K / P1_L2_20K(1)) *100;

        Peak_20K = max(current_L2_20K);
        Valley_20K = min(current_L2_20K);
        Peak_Ripple_Factor_L2_sample_20K = (Peak_20K - Valley_20K)/current_mean_sample_L2_20K * 100;

        Iripple_L2_20K = sqrt((current_rms_sample_L2_20K^2) - (current_mean_sample_L2_20K ^2));
        RMS_Ripple_Factor_L2_sample_20K = Iripple_L2_20K/current_mean_sample_L2_20K * 100;
        % Line 3
        Y_L3_20K = fft(current_L3_20K);

        P2_L3_20K = abs(Y_L3_20K/L);
        P1_L3_20K = P2_L3_20K(1:round(L/2));
        P1_L3_20K(2:end) = (2*P1_L3_20K(2:end))/sqrt(2);

        Temp_L3_20K = sum(P1_L3_20K(2:end).^2);
        Temp2_L3_20K = sqrt(Temp_L3_20K);
        RDF_L3_sample_20K = (Temp2_L3_20K / P1_L3_20K(1)) *100;

        Peak_20K = max(current_L3_20K);
        Valley_20K = min(current_L3_20K);
        Peak_Ripple_Factor_L3_sample_20K = (Peak_20K - Valley_20K)/current_mean_sample_L3_20K * 100;

        Iripple_L3_20K = sqrt((current_rms_sample_L3_20K^2) - (current_mean_sample_L3_20K ^2));
        RMS_Ripple_Factor_L3_sample_20K = Iripple_L3_20K/current_mean_sample_L3_20K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_20K = cat(1,U_avg_20K,Uavg_sample_20K);
            U_rms_20K = cat(1,U_rms_20K,Urms_sample_20K);
            I_rms_L1_20K = cat(1,I_rms_L1_20K,current_rms_sample_L1_20K);
            I_rms_L2_20K = cat(1,I_rms_L2_20K,current_rms_sample_L2_20K);
            I_rms_L3_20K = cat(1,I_rms_L3_20K,current_rms_sample_L3_20K);
            I_avg_L1_20K = cat(1,I_avg_L1_20K,current_mean_sample_L1_20K);
            I_avg_L2_20K = cat(1,I_avg_L2_20K,current_mean_sample_L2_20K);
            I_avg_L3_20K = cat(1,I_avg_L3_20K,current_mean_sample_L3_20K);

            U_ripple_20K = cat(1,U_ripple_20K,Uripple_20K);
            RDF_Voltage_20K = cat(1,RDF_Voltage_20K,RDF_Voltage_sample_20K);
            RMS_Ripple_Factor_Voltage_20K = cat(1,RMS_Ripple_Factor_Voltage_20K,RMS_Ripple_Factor_Voltage_sample_20K);
            Peak_Ripple_Factor_Voltage_20K = cat(1,Peak_Ripple_Factor_Voltage_20K,Peak_Ripple_Factor_Voltage_sample_20K);
            I_ripple_L1_20K = cat(1,I_ripple_L1_20K,Iripple_L1_20K);
            RDF_L1_20K = cat(1,RDF_L1_20K,RDF_L1_sample_20K);
            RMS_Ripple_Factor_L1_20K = cat(1,RMS_Ripple_Factor_L1_20K,RMS_Ripple_Factor_L1_sample_20K);
            Peak_Ripple_Factor_L1_20K = cat(1,Peak_Ripple_Factor_L1_20K,Peak_Ripple_Factor_L1_sample_20K);
            I_ripple_L2_20K = cat(1,I_ripple_L2_20K,Iripple_L2_20K);
            RDF_L2_20K = cat(1,RDF_L2_20K,RDF_L2_sample_20K);
            RMS_Ripple_Factor_L2_20K = cat(1,RMS_Ripple_Factor_L2_20K,RMS_Ripple_Factor_L2_sample_20K);
            Peak_Ripple_Factor_L2_20K = cat(1,Peak_Ripple_Factor_L2_20K,Peak_Ripple_Factor_L2_sample_20K);
            I_ripple_L3_20K = cat(1,I_ripple_L3_20K,Iripple_L3_20K);
            RDF_L3_20K = cat(1,RDF_L3_20K,RDF_L3_sample_20K);
            RMS_Ripple_Factor_L3_20K = cat(1,RMS_Ripple_Factor_L3_20K,RMS_Ripple_Factor_L3_sample_20K);
            Peak_Ripple_Factor_L3_20K = cat(1,Peak_Ripple_Factor_L3_20K,Peak_Ripple_Factor_L3_sample_20K);
            U_rms_10ms_20K = cat(1,U_rms_10ms_20K,Urms_nonStat_sample_20K);

            U_avg_20K(1,:) = [];
            U_rms_20K(1,:) = [];
            I_rms_L1_20K(1,:) = [];
            I_rms_L2_20K(1,:) = [];
            I_rms_L3_20K(1,:) = [];
            I_avg_L1_20K(1,:) = [];
            I_avg_L2_20K(1,:) = [];
            I_avg_L3_20K(1,:) = [];

            U_ripple_20K(1,:) = [];
            RDF_Voltage_20K(1,:) = [];
            RMS_Ripple_Factor_Voltage_20K(1,:) = [];
            Peak_Ripple_Factor_Voltage_20K(1,:) = [];
            I_ripple_L1_20K(1,:) = [];
            RDF_L1_20K(1,:) = [];
            RMS_Ripple_Factor_L1_20K(1,:) = [];
            Peak_Ripple_Factor_L1_20K(1,:) = [];
            I_ripple_L2_20K(1,:) = [];
            RDF_L2_20K(1,:) = [];
            RMS_Ripple_Factor_L2_20K(1,:) = [];
            Peak_Ripple_Factor_L2_20K(1,:) = [];
            I_ripple_L3_20K(1,:) = [];
            RDF_L3_20K(1,:) = [];
            RMS_Ripple_Factor_L3_20K(1,:) = [];
            Peak_Ripple_Factor_L3_20K(1,:) = [];
            U_rms_10ms_20K(1,:) = [];

        else
            U_avg_20K = cat(1,U_avg_20K,Uavg_sample_20K);
            U_rms_20K = cat(1,U_rms_20K,Urms_sample_20K);
            I_rms_L1_20K = cat(1,I_rms_L1_20K,current_rms_sample_L1_20K);
            I_rms_L2_20K = cat(1,I_rms_L2_20K,current_rms_sample_L2_20K);
            I_rms_L3_20K = cat(1,I_rms_L3_20K,current_rms_sample_L3_20K);
            I_avg_L1_20K = cat(1,I_avg_L1_20K,current_mean_sample_L1_20K);
            I_avg_L2_20K = cat(1,I_avg_L2_20K,current_mean_sample_L2_20K);
            I_avg_L3_20K = cat(1,I_avg_L3_20K,current_mean_sample_L3_20K);

            U_ripple_20K = cat(1,U_ripple_20K,Uripple_20K);
            RDF_Voltage_20K = cat(1,RDF_Voltage_20K,RDF_Voltage_sample_20K);
            RMS_Ripple_Factor_Voltage_20K = cat(1,RMS_Ripple_Factor_Voltage_20K,RMS_Ripple_Factor_Voltage_sample_20K);
            Peak_Ripple_Factor_Voltage_20K = cat(1,Peak_Ripple_Factor_Voltage_20K,Peak_Ripple_Factor_Voltage_sample_20K);
            I_ripple_L1_20K = cat(1,I_ripple_L1_20K,Iripple_L1_20K);
            RDF_L1_20K = cat(1,RDF_L1_20K,RDF_L1_sample_20K);
            RMS_Ripple_Factor_L1_20K = cat(1,RMS_Ripple_Factor_L1_20K,RMS_Ripple_Factor_L1_sample_20K);
            Peak_Ripple_Factor_L1_20K = cat(1,Peak_Ripple_Factor_L1_20K,Peak_Ripple_Factor_L1_sample_20K);
            I_ripple_L2_20K = cat(1,I_ripple_L2_20K,Iripple_L2_20K);
            RDF_L2_20K = cat(1,RDF_L2_20K,RDF_L2_sample_20K);
            RMS_Ripple_Factor_L2_20K = cat(1,RMS_Ripple_Factor_L2_20K,RMS_Ripple_Factor_L2_sample_20K);
            Peak_Ripple_Factor_L2_20K = cat(1,Peak_Ripple_Factor_L2_20K,Peak_Ripple_Factor_L2_sample_20K);
            I_ripple_L3_20K = cat(1,I_ripple_L3_20K,Iripple_L3_20K);
            RDF_L3_20K = cat(1,RDF_L3_20K,RDF_L3_sample_20K);
            RMS_Ripple_Factor_L3_20K = cat(1,RMS_Ripple_Factor_L3_20K,RMS_Ripple_Factor_L3_sample_20K);
            Peak_Ripple_Factor_L3_20K = cat(1,Peak_Ripple_Factor_L3_20K,Peak_Ripple_Factor_L3_sample_20K);
            U_rms_10ms_20K = cat(1,U_rms_10ms_20K,Urms_nonStat_sample_20K);


        end
        %% Mean & RMS Calculation
        %10K
        Urms_sample_10K = rms(voltage_10K);
        Uavg_sample_10K = mean(voltage_10K);
        current_mean_sample_L1_10K = mean(current_L1_10K);
        current_rms_sample_L1_10K = rms(current_L1_10K);
        current_mean_sample_L2_10K = mean(current_L2_10K);
        current_rms_sample_L2_10K = rms(current_L2_10K);
        current_mean_sample_L3_10K = mean(current_L3_10K);
        current_rms_sample_L3_10K = rms(current_L3_10K);

        k = 1;
        j = 1;
        temp = zeros(100,1);
        for i = 1:2000
            temp(k,1) = voltage_10K(i);
            temp(k,2) = current_L1_10K(i);
            temp(k,3) = current_L2_10K(i);
            temp(k,4) = current_L3_10K(i);
            k = k+1;
            if k == (100 + 1)
                Urms_nonStat_sample_10K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_10K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_10K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_10K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 2000;
        RDF_Voltage_sample_10K = 0;
        Peak_Ripple_Factor_Voltage_sample_10K = 0;
        RMS_Ripple_Factor_Voltage_sample_10K = 0;

        RDF_L1_sample_10K = 0;
        Peak_Ripple_Factor_L1_sample_10K = 0;
        RMS_Ripple_Factor_L1_sample_10K = 0;

        RDF_L2_sample_10K = 0;
        Peak_Ripple_Factor_L2_sample_10K = 0;
        RMS_Ripple_Factor_L2_sample_10K = 0;

        RDF_L3_sample_10K = 0;
        Peak_Ripple_Factor_L3_sample_10K = 0;
        RMS_Ripple_Factor_L3_sample_10K = 0;



        % Voltage
        Y_10K = fft(voltage_10K);
        Fs_10K = 10000;
        P2_10K = abs(Y_10K/L);
        P1_10K = P2_10K(1:round(L/2));
        P1_10K(2:end) = (2*P1_10K(2:end))/sqrt(2);
        f_10K = Fs_10K*(0:(L/2)-1)/L;

        Temp_10K = sum(P1_10K(2:end).^2);
        Temp2_10K = sqrt(Temp_10K);
        RDF_Voltage_sample_10K = (Temp2_10K / P1_10K(1)) *100;

        Peak_10K = max(voltage_10K);
        Valley_10K = min(voltage_10K);
        Peak_Ripple_Factor_Voltage_sample_10K = (Peak_10K - Valley_10K)/Uavg_sample_10K * 100;

        Uripple_10K = sqrt((Urms_sample_10K ^2) - (Uavg_sample_10K ^2));
        RMS_Ripple_Factor_Voltage_sample_10K = Uripple_10K/Uavg_sample_10K * 100;
        % Line 1
        Y_L1_10K = fft(current_L1_10K);

        P2_L1_10K = abs(Y_L1_10K/L);
        P1_L1_10K = P2_L1_10K(1:round(L/2));
        P1_L1_10K(2:end) = (2*P1_L1_10K(2:end))/sqrt(2);

        Temp_L1_10K = sum(P1_L1_10K(2:end).^2);
        Temp2_L1_10K = sqrt(Temp_L1_10K);
        RDF_L1_sample_10K = (Temp2_L1_10K / P1_L1_10K(1)) *100;

        Peak_10K = max(current_L1_10K);
        Valley_10K = min(current_L1_10K);
        Peak_Ripple_Factor_L1_sample_10K = (Peak_10K - Valley_10K)/current_mean_sample_L1_10K * 100;

        Iripple_L1_10K = sqrt((current_rms_sample_L1_10K^2) - (current_mean_sample_L1_10K ^2));
        RMS_Ripple_Factor_L1_sample_10K = Iripple_L1_10K/current_mean_sample_L1_10K * 100;
        % Line 2
        Y_L2_10K = fft(current_L2_10K);

        P2_L2_10K = abs(Y_L2_10K/L);
        P1_L2_10K = P2_L2_10K(1:round(L/2));
        P1_L2_10K(2:end) = (2*P1_L2_10K(2:end))/sqrt(2);

        Temp_L2_10K = sum(P1_L2_10K(2:end).^2);
        Temp2_L2_10K = sqrt(Temp_L2_10K);
        RDF_L2_sample_10K = (Temp2_L2_10K / P1_L2_10K(1)) *100;

        Peak_10K = max(current_L2_10K);
        Valley_10K = min(current_L2_10K);
        Peak_Ripple_Factor_L2_sample_10K = (Peak_10K - Valley_10K)/current_mean_sample_L2_10K * 100;

        Iripple_L2_10K = sqrt((current_rms_sample_L2_10K^2) - (current_mean_sample_L2_10K ^2));
        RMS_Ripple_Factor_L2_sample_10K = Iripple_L2_10K/current_mean_sample_L2_10K * 100;
        % Line 3
        Y_L3_10K = fft(current_L3_10K);

        P2_L3_10K = abs(Y_L3_10K/L);
        P1_L3_10K = P2_L3_10K(1:round(L/2));
        P1_L3_10K(2:end) = (2*P1_L3_10K(2:end))/sqrt(2);

        Temp_L3_10K = sum(P1_L3_10K(2:end).^2);
        Temp2_L3_10K = sqrt(Temp_L3_10K);
        RDF_L3_sample_10K = (Temp2_L3_10K / P1_L3_10K(1)) *100;

        Peak_10K = max(current_L3_10K);
        Valley_10K = min(current_L3_10K);
        Peak_Ripple_Factor_L3_sample_10K = (Peak_10K - Valley_10K)/current_mean_sample_L3_10K * 100;

        Iripple_L3_10K = sqrt((current_rms_sample_L3_10K^2) - (current_mean_sample_L3_10K ^2));
        RMS_Ripple_Factor_L3_sample_10K = Iripple_L3_10K/current_mean_sample_L3_10K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_10K = cat(1,U_avg_10K,Uavg_sample_10K);
            U_rms_10K = cat(1,U_rms_10K,Urms_sample_10K);
            I_rms_L1_10K = cat(1,I_rms_L1_10K,current_rms_sample_L1_10K);
            I_rms_L2_10K = cat(1,I_rms_L2_10K,current_rms_sample_L2_10K);
            I_rms_L3_10K = cat(1,I_rms_L3_10K,current_rms_sample_L3_10K);
            I_avg_L1_10K = cat(1,I_avg_L1_10K,current_mean_sample_L1_10K);
            I_avg_L2_10K = cat(1,I_avg_L2_10K,current_mean_sample_L2_10K);
            I_avg_L3_10K = cat(1,I_avg_L3_10K,current_mean_sample_L3_10K);

            U_ripple_10K = cat(1,U_ripple_10K,Uripple_10K);
            RDF_Voltage_10K = cat(1,RDF_Voltage_10K,RDF_Voltage_sample_10K);
            RMS_Ripple_Factor_Voltage_10K = cat(1,RMS_Ripple_Factor_Voltage_10K,RMS_Ripple_Factor_Voltage_sample_10K);
            Peak_Ripple_Factor_Voltage_10K = cat(1,Peak_Ripple_Factor_Voltage_10K,Peak_Ripple_Factor_Voltage_sample_10K);
            I_ripple_L1_10K = cat(1,I_ripple_L1_10K,Iripple_L1_10K);
            RDF_L1_10K = cat(1,RDF_L1_10K,RDF_L1_sample_10K);
            RMS_Ripple_Factor_L1_10K = cat(1,RMS_Ripple_Factor_L1_10K,RMS_Ripple_Factor_L1_sample_10K);
            Peak_Ripple_Factor_L1_10K = cat(1,Peak_Ripple_Factor_L1_10K,Peak_Ripple_Factor_L1_sample_10K);
            I_ripple_L2_10K = cat(1,I_ripple_L2_10K,Iripple_L2_10K);
            RDF_L2_10K = cat(1,RDF_L2_10K,RDF_L2_sample_10K);
            RMS_Ripple_Factor_L2_10K = cat(1,RMS_Ripple_Factor_L2_10K,RMS_Ripple_Factor_L2_sample_10K);
            Peak_Ripple_Factor_L2_10K = cat(1,Peak_Ripple_Factor_L2_10K,Peak_Ripple_Factor_L2_sample_10K);
            I_ripple_L3_10K = cat(1,I_ripple_L3_10K,Iripple_L3_10K);
            RDF_L3_10K = cat(1,RDF_L3_10K,RDF_L3_sample_10K);
            RMS_Ripple_Factor_L3_10K = cat(1,RMS_Ripple_Factor_L3_10K,RMS_Ripple_Factor_L3_sample_10K);
            Peak_Ripple_Factor_L3_10K = cat(1,Peak_Ripple_Factor_L3_10K,Peak_Ripple_Factor_L3_sample_10K);
            U_rms_10ms_10K = cat(1,U_rms_10ms_10K,Urms_nonStat_sample_10K);

            U_avg_10K(1,:) = [];
            U_rms_10K(1,:) = [];
            I_rms_L1_10K(1,:) = [];
            I_rms_L2_10K(1,:) = [];
            I_rms_L3_10K(1,:) = [];
            I_avg_L1_10K(1,:) = [];
            I_avg_L2_10K(1,:) = [];
            I_avg_L3_10K(1,:) = [];

            U_ripple_10K(1,:) = [];
            RDF_Voltage_10K(1,:) = [];
            RMS_Ripple_Factor_Voltage_10K(1,:) = [];
            Peak_Ripple_Factor_Voltage_10K(1,:) = [];
            I_ripple_L1_10K(1,:) = [];
            RDF_L1_10K(1,:) = [];
            RMS_Ripple_Factor_L1_10K(1,:) = [];
            Peak_Ripple_Factor_L1_10K(1,:) = [];
            I_ripple_L2_10K(1,:) = [];
            RDF_L2_10K(1,:) = [];
            RMS_Ripple_Factor_L2_10K(1,:) = [];
            Peak_Ripple_Factor_L2_10K(1,:) = [];
            I_ripple_L3_10K(1,:) = [];
            RDF_L3_10K(1,:) = [];
            RMS_Ripple_Factor_L3_10K(1,:) = [];
            Peak_Ripple_Factor_L3_10K(1,:) = [];
            U_rms_10ms_10K(1,:) = [];

        else
            U_avg_10K = cat(1,U_avg_10K,Uavg_sample_10K);
            U_rms_10K = cat(1,U_rms_10K,Urms_sample_10K);
            I_rms_L1_10K = cat(1,I_rms_L1_10K,current_rms_sample_L1_10K);
            I_rms_L2_10K = cat(1,I_rms_L2_10K,current_rms_sample_L2_10K);
            I_rms_L3_10K = cat(1,I_rms_L3_10K,current_rms_sample_L3_10K);
            I_avg_L1_10K = cat(1,I_avg_L1_10K,current_mean_sample_L1_10K);
            I_avg_L2_10K = cat(1,I_avg_L2_10K,current_mean_sample_L2_10K);
            I_avg_L3_10K = cat(1,I_avg_L3_10K,current_mean_sample_L3_10K);

            U_ripple_10K = cat(1,U_ripple_10K,Uripple_10K);
            RDF_Voltage_10K = cat(1,RDF_Voltage_10K,RDF_Voltage_sample_10K);
            RMS_Ripple_Factor_Voltage_10K = cat(1,RMS_Ripple_Factor_Voltage_10K,RMS_Ripple_Factor_Voltage_sample_10K);
            Peak_Ripple_Factor_Voltage_10K = cat(1,Peak_Ripple_Factor_Voltage_10K,Peak_Ripple_Factor_Voltage_sample_10K);
            I_ripple_L1_10K = cat(1,I_ripple_L1_10K,Iripple_L1_10K);
            RDF_L1_10K = cat(1,RDF_L1_10K,RDF_L1_sample_10K);
            RMS_Ripple_Factor_L1_10K = cat(1,RMS_Ripple_Factor_L1_10K,RMS_Ripple_Factor_L1_sample_10K);
            Peak_Ripple_Factor_L1_10K = cat(1,Peak_Ripple_Factor_L1_10K,Peak_Ripple_Factor_L1_sample_10K);
            I_ripple_L2_10K = cat(1,I_ripple_L2_10K,Iripple_L2_10K);
            RDF_L2_10K = cat(1,RDF_L2_10K,RDF_L2_sample_10K);
            RMS_Ripple_Factor_L2_10K = cat(1,RMS_Ripple_Factor_L2_10K,RMS_Ripple_Factor_L2_sample_10K);
            Peak_Ripple_Factor_L2_10K = cat(1,Peak_Ripple_Factor_L2_10K,Peak_Ripple_Factor_L2_sample_10K);
            I_ripple_L3_10K = cat(1,I_ripple_L3_10K,Iripple_L3_10K);
            RDF_L3_10K = cat(1,RDF_L3_10K,RDF_L3_sample_10K);
            RMS_Ripple_Factor_L3_10K = cat(1,RMS_Ripple_Factor_L3_10K,RMS_Ripple_Factor_L3_sample_10K);
            Peak_Ripple_Factor_L3_10K = cat(1,Peak_Ripple_Factor_L3_10K,Peak_Ripple_Factor_L3_sample_10K);
            U_rms_10ms_10K = cat(1,U_rms_10ms_10K,Urms_nonStat_sample_10K);


        end
        %% Mean & RMS Calculation
        %5K
        Urms_sample_5K = rms(voltage_5K);
        Uavg_sample_5K = mean(voltage_5K);
        current_mean_sample_L1_5K = mean(current_L1_5K);
        current_rms_sample_L1_5K = rms(current_L1_5K);
        current_mean_sample_L2_5K = mean(current_L2_5K);
        current_rms_sample_L2_5K = rms(current_L2_5K);
        current_mean_sample_L3_5K = mean(current_L3_5K);
        current_rms_sample_L3_5K = rms(current_L3_5K);

        k = 1;
        j = 1;
        temp = zeros(50,1);
        for i = 1:1000
            temp(k,1) = voltage_5K(i);
            temp(k,2) = current_L1_5K(i);
            temp(k,3) = current_L2_5K(i);
            temp(k,4) = current_L3_5K(i);
            k = k+1;
            if k == (50 + 1)
                Urms_nonStat_sample_5K(j,1) = rms(temp(:,1));
                current_rms_nonStat_sample_L1_5K(j,1) = rms(temp(:,2));
                current_rms_nonStat_sample_L2_5K(j,1) = rms(temp(:,3));
                current_rms_nonStat_sample_L3_5K(j,1) = rms(temp(:,4));
                k = 1;
                j = j + 1;
            end
        end

        %% RDF & 2 Factors
        L = 1000;
        RDF_Voltage_sample_5K = 0;
        Peak_Ripple_Factor_Voltage_sample_5K = 0;
        RMS_Ripple_Factor_Voltage_sample_5K = 0;

        RDF_L1_sample_5K = 0;
        Peak_Ripple_Factor_L1_sample_5K = 0;
        RMS_Ripple_Factor_L1_sample_5K = 0;

        RDF_L2_sample_5K = 0;
        Peak_Ripple_Factor_L2_sample_5K = 0;
        RMS_Ripple_Factor_L2_sample_5K = 0;

        RDF_L3_sample_5K = 0;
        Peak_Ripple_Factor_L3_sample_5K = 0;
        RMS_Ripple_Factor_L3_sample_5K = 0;



        % Voltage
        Y_5K = fft(voltage_5K);
        Fs_5K = 5000;
        P2_5K = abs(Y_5K/L);
        P1_5K = P2_5K(1:round(L/2));
        P1_5K(2:end) = (2*P1_5K(2:end))/sqrt(2);
        f_5K = Fs_5K*(0:(L/2)-1)/L;

        Temp_5K = sum(P1_5K(2:end).^2);
        Temp2_5K = sqrt(Temp_5K);
        RDF_Voltage_sample_5K = (Temp2_5K / P1_5K(1)) *100;

        Peak_5K = max(voltage_5K);
        Valley_5K = min(voltage_5K);
        Peak_Ripple_Factor_Voltage_sample_5K = (Peak_5K - Valley_5K)/Uavg_sample_5K * 100;

        Uripple_5K = sqrt((Urms_sample_5K ^2) - (Uavg_sample_5K ^2));
        RMS_Ripple_Factor_Voltage_sample_5K = Uripple_5K/Uavg_sample_5K * 100;
        % Line 1
        Y_L1_5K = fft(current_L1_5K);

        P2_L1_5K = abs(Y_L1_5K/L);
        P1_L1_5K = P2_L1_5K(1:round(L/2));
        P1_L1_5K(2:end) = (2*P1_L1_5K(2:end))/sqrt(2);

        Temp_L1_5K = sum(P1_L1_5K(2:end).^2);
        Temp2_L1_5K = sqrt(Temp_L1_5K);
        RDF_L1_sample_5K = (Temp2_L1_5K / P1_L1_5K(1)) *100;

        Peak_5K = max(current_L1_5K);
        Valley_5K = min(current_L1_5K);
        Peak_Ripple_Factor_L1_sample_5K = (Peak_5K - Valley_5K)/current_mean_sample_L1_5K * 100;

        Iripple_L1_5K = sqrt((current_rms_sample_L1_5K^2) - (current_mean_sample_L1_5K ^2));
        RMS_Ripple_Factor_L1_sample_5K = Iripple_L1_5K/current_mean_sample_L1_5K * 100;
        % Line 2
        Y_L2_5K = fft(current_L2_5K);

        P2_L2_5K = abs(Y_L2_5K/L);
        P1_L2_5K = P2_L2_5K(1:round(L/2));
        P1_L2_5K(2:end) = (2*P1_L2_5K(2:end))/sqrt(2);

        Temp_L2_5K = sum(P1_L2_5K(2:end).^2);
        Temp2_L2_5K = sqrt(Temp_L2_5K);
        RDF_L2_sample_5K = (Temp2_L2_5K / P1_L2_5K(1)) *100;

        Peak_5K = max(current_L2_5K);
        Valley_5K = min(current_L2_5K);
        Peak_Ripple_Factor_L2_sample_5K = (Peak_5K - Valley_5K)/current_mean_sample_L2_5K * 100;

        Iripple_L2_5K = sqrt((current_rms_sample_L2_5K^2) - (current_mean_sample_L2_5K ^2));
        RMS_Ripple_Factor_L2_sample_5K = Iripple_L2_5K/current_mean_sample_L2_5K * 100;
        % Line 3
        Y_L3_5K = fft(current_L3_5K);

        P2_L3_5K = abs(Y_L3_5K/L);
        P1_L3_5K = P2_L3_5K(1:round(L/2));
        P1_L3_5K(2:end) = (2*P1_L3_5K(2:end))/sqrt(2);

        Temp_L3_5K = sum(P1_L3_5K(2:end).^2);
        Temp2_L3_5K = sqrt(Temp_L3_5K);
        RDF_L3_sample_5K = (Temp2_L3_5K / P1_L3_5K(1)) *100;

        Peak_5K = max(current_L3_5K);
        Valley_5K = min(current_L3_5K);
        Peak_Ripple_Factor_L3_sample_5K = (Peak_5K - Valley_5K)/current_mean_sample_L3_5K * 100;

        Iripple_L3_5K = sqrt((current_rms_sample_L3_5K^2) - (current_mean_sample_L3_5K ^2));
        RMS_Ripple_Factor_L3_sample_5K = Iripple_L3_5K/current_mean_sample_L3_5K * 100;


        %% Storage
        if num == 1 && docount == 1
            U_avg_5K = cat(1,U_avg_5K,Uavg_sample_5K);
            U_rms_5K = cat(1,U_rms_5K,Urms_sample_5K);
            I_rms_L1_5K = cat(1,I_rms_L1_5K,current_rms_sample_L1_5K);
            I_rms_L2_5K = cat(1,I_rms_L2_5K,current_rms_sample_L2_5K);
            I_rms_L3_5K = cat(1,I_rms_L3_5K,current_rms_sample_L3_5K);
            I_avg_L1_5K = cat(1,I_avg_L1_5K,current_mean_sample_L1_5K);
            I_avg_L2_5K = cat(1,I_avg_L2_5K,current_mean_sample_L2_5K);
            I_avg_L3_5K = cat(1,I_avg_L3_5K,current_mean_sample_L3_5K);

            U_ripple_5K = cat(1,U_ripple_5K,Uripple_5K);
            RDF_Voltage_5K = cat(1,RDF_Voltage_5K,RDF_Voltage_sample_5K);
            RMS_Ripple_Factor_Voltage_5K = cat(1,RMS_Ripple_Factor_Voltage_5K,RMS_Ripple_Factor_Voltage_sample_5K);
            Peak_Ripple_Factor_Voltage_5K = cat(1,Peak_Ripple_Factor_Voltage_5K,Peak_Ripple_Factor_Voltage_sample_5K);
            I_ripple_L1_5K = cat(1,I_ripple_L1_5K,Iripple_L1_5K);
            RDF_L1_5K = cat(1,RDF_L1_5K,RDF_L1_sample_5K);
            RMS_Ripple_Factor_L1_5K = cat(1,RMS_Ripple_Factor_L1_5K,RMS_Ripple_Factor_L1_sample_5K);
            Peak_Ripple_Factor_L1_5K = cat(1,Peak_Ripple_Factor_L1_5K,Peak_Ripple_Factor_L1_sample_5K);
            I_ripple_L2_5K = cat(1,I_ripple_L2_5K,Iripple_L2_5K);
            RDF_L2_5K = cat(1,RDF_L2_5K,RDF_L2_sample_5K);
            RMS_Ripple_Factor_L2_5K = cat(1,RMS_Ripple_Factor_L2_5K,RMS_Ripple_Factor_L2_sample_5K);
            Peak_Ripple_Factor_L2_5K = cat(1,Peak_Ripple_Factor_L2_5K,Peak_Ripple_Factor_L2_sample_5K);
            I_ripple_L3_5K = cat(1,I_ripple_L3_5K,Iripple_L3_5K);
            RDF_L3_5K = cat(1,RDF_L3_5K,RDF_L3_sample_5K);
            RMS_Ripple_Factor_L3_5K = cat(1,RMS_Ripple_Factor_L3_5K,RMS_Ripple_Factor_L3_sample_5K);
            Peak_Ripple_Factor_L3_5K = cat(1,Peak_Ripple_Factor_L3_5K,Peak_Ripple_Factor_L3_sample_5K);
            U_rms_10ms_5K = cat(1,U_rms_10ms_5K,Urms_nonStat_sample_5K);

            U_avg_5K(1,:) = [];
            U_rms_5K(1,:) = [];
            I_rms_L1_5K(1,:) = [];
            I_rms_L2_5K(1,:) = [];
            I_rms_L3_5K(1,:) = [];
            I_avg_L1_5K(1,:) = [];
            I_avg_L2_5K(1,:) = [];
            I_avg_L3_5K(1,:) = [];

            U_ripple_5K(1,:) = [];
            RDF_Voltage_5K(1,:) = [];
            RMS_Ripple_Factor_Voltage_5K(1,:) = [];
            Peak_Ripple_Factor_Voltage_5K(1,:) = [];
            I_ripple_L1_5K(1,:) = [];
            RDF_L1_5K(1,:) = [];
            RMS_Ripple_Factor_L1_5K(1,:) = [];
            Peak_Ripple_Factor_L1_5K(1,:) = [];
            I_ripple_L2_5K(1,:) = [];
            RDF_L2_5K(1,:) = [];
            RMS_Ripple_Factor_L2_5K(1,:) = [];
            Peak_Ripple_Factor_L2_5K(1,:) = [];
            I_ripple_L3_5K(1,:) = [];
            RDF_L3_5K(1,:) = [];
            RMS_Ripple_Factor_L3_5K(1,:) = [];
            Peak_Ripple_Factor_L3_5K(1,:) = [];
            U_rms_10ms_5K(1,:) = [];

        else
            U_avg_5K = cat(1,U_avg_5K,Uavg_sample_5K);
            U_rms_5K = cat(1,U_rms_5K,Urms_sample_5K);
            I_rms_L1_5K = cat(1,I_rms_L1_5K,current_rms_sample_L1_5K);
            I_rms_L2_5K = cat(1,I_rms_L2_5K,current_rms_sample_L2_5K);
            I_rms_L3_5K = cat(1,I_rms_L3_5K,current_rms_sample_L3_5K);
            I_avg_L1_5K = cat(1,I_avg_L1_5K,current_mean_sample_L1_5K);
            I_avg_L2_5K = cat(1,I_avg_L2_5K,current_mean_sample_L2_5K);
            I_avg_L3_5K = cat(1,I_avg_L3_5K,current_mean_sample_L3_5K);

            U_ripple_5K = cat(1,U_ripple_5K,Uripple_5K);
            RDF_Voltage_5K = cat(1,RDF_Voltage_5K,RDF_Voltage_sample_5K);
            RMS_Ripple_Factor_Voltage_5K = cat(1,RMS_Ripple_Factor_Voltage_5K,RMS_Ripple_Factor_Voltage_sample_5K);
            Peak_Ripple_Factor_Voltage_5K = cat(1,Peak_Ripple_Factor_Voltage_5K,Peak_Ripple_Factor_Voltage_sample_5K);
            I_ripple_L1_5K = cat(1,I_ripple_L1_5K,Iripple_L1_5K);
            RDF_L1_5K = cat(1,RDF_L1_5K,RDF_L1_sample_5K);
            RMS_Ripple_Factor_L1_5K = cat(1,RMS_Ripple_Factor_L1_5K,RMS_Ripple_Factor_L1_sample_5K);
            Peak_Ripple_Factor_L1_5K = cat(1,Peak_Ripple_Factor_L1_5K,Peak_Ripple_Factor_L1_sample_5K);
            I_ripple_L2_5K = cat(1,I_ripple_L2_5K,Iripple_L2_5K);
            RDF_L2_5K = cat(1,RDF_L2_5K,RDF_L2_sample_5K);
            RMS_Ripple_Factor_L2_5K = cat(1,RMS_Ripple_Factor_L2_5K,RMS_Ripple_Factor_L2_sample_5K);
            Peak_Ripple_Factor_L2_5K = cat(1,Peak_Ripple_Factor_L2_5K,Peak_Ripple_Factor_L2_sample_5K);
            I_ripple_L3_5K = cat(1,I_ripple_L3_5K,Iripple_L3_5K);
            RDF_L3_5K = cat(1,RDF_L3_5K,RDF_L3_sample_5K);
            RMS_Ripple_Factor_L3_5K = cat(1,RMS_Ripple_Factor_L3_5K,RMS_Ripple_Factor_L3_sample_5K);
            Peak_Ripple_Factor_L3_5K = cat(1,Peak_Ripple_Factor_L3_5K,Peak_Ripple_Factor_L3_sample_5K);
            U_rms_10ms_5K = cat(1,U_rms_10ms_5K,Urms_nonStat_sample_5K);


        end
    end
    fprintf('Finished No.%d.\n',num);
end
fprintf('Finished!\n');