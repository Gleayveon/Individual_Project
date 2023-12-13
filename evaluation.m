function [Udc_out,Urms_out,RDF_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,...
    Factor_peak_valley_sample,Factor_rms_sample,isSwell_legacy,isDip_legacy,isInterruption_legacy,...
    RDF_eachwindow_i1,Factor_peak_valley_sample_i1,Factor_rms_sample_i1] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy,Fs,Ts,U_nominal,...
    timescale,group_size,hysteresis,Dip_tr,Swell_tr,Interruption_tr)
% evaluation(A)
% Inputs:
%   num                         = Number of the data
%   listing                     = Sample's name list
%   isSwell_legacy              = Is Swell occuring last sample window?
%   isDip_legacy                = Is Dip occuring last sample window?
%   isInterruption_legacy       = Is Interruption occuring last sample window?
%   Fs                          = Sampling frequency
%   Ts                          = Sampling period
%   U_nominal                   = Nominal Voltage
%   timescale                   = Time duration of one sample file
%   group_size                  = Evaluation resolution
%   hysteresis                  = Hysteresis
%   Dip_tr                      = Threshold of Dip
%   Swell_tr                    = Threshold of Swell
%   Interruption_tr             = Threshold of Interruption
% Outputs:
%   Udc_out                     = Udc of this sample
%   Urms_out                    = Urms of this sample
%   RDF_eachwindow              = RDF of each sample window (i.e.200ms) 
%   Swell_timesum               = The total time length of Swell in this sample
%   Dip_timesum                 = The total time length of Dip in this sample
%   Interruption_timesum        = The total time length of Interruption in this sample
%   SampleDipCount              = The total number of new Dip detected in this sample
%   SampleSwellCount            = The total number of new Swell detected in this sample
%   SampleInterruptionCount     = The total number of new Interruption detected in this sample
%   Factor_peak_valley_sample   = The Peak to Valley Factor of this sample
%   Factor_rms_sample           = The mean RMS Factor of this sample
%   isSwell                     = Is Swell occuring last sample window?
%   isDip                       = Is Dip occuring last sample window?
%   isInterruption              = Is Interruption occuring last sample window?
%   RDF_eachwindow_i1           = RDF of Line 1 Current of each sample window (i.e.200ms) 
%   Factor_peak_valley_sample_i1= The Line 1 Current Peak to Valley Factor of this sample
%   Factor_rms_sample_i1        = The Line 1 Current mean RMS Factor of this sample
% Version: 2.0.0α

%% Data Loading
cd 'A:\Lin project\Data_Check'  % Here is the path of where Data file locate
% cd 'A:\Lin project\ss'
Name = listing(num).name; % Name of the files
data = tdmsread(Name); 

Recordings=data{1,1};
Recordings=table2array(Recordings);

L1_Voltage=Recordings(:,1);
L1_Current=Recordings(:,2);
L2_Current=Recordings(:,3);
L3_Current=Recordings(:,4);

L1_Voltage=L1_Voltage.*1000;
L1_Current=L1_Current.*100;
L2_Current=L2_Current.*100;
L3_Current=L3_Current.*25;
% %% For debug
% data = readtable(Name);
% voltage = data.voltage1;
% figure(1)
% Time=(Ts:Ts:length(L1_Voltage)*Ts)'; % Time vector 
% 
% plot(Time,L1_Voltage)
% hold on
% plot(Time,L1_Current)
% hold on
% plot(Time,L2_Current)
% hold on
% plot(Time,L3_Current)


%% Evaluation Start

Udc_mean_sample = zeros(5,1);
Urms_mean_sample = zeros(5,1);
RDF_eachwindow = zeros(5,1);
num_groups = floor(200000 / group_size);
Swell_timesum = 0;
Dip_timesum = 0;
Interruption_timesum = 0;
SampleDipCount = 0;
SampleSwellCount = 0;
SampleInterruptionCount = 0;
PeaktoValley = zeros(5,1);
Factor_peak_valley_sample = zeros(5,1);
Factor_rms_sample = zeros(5,1);
Uripple_mean = zeros(5,1);
Uripple_variance = zeros(5,1);
Udc_out = zeros(200,1);
%Split one file to 5 samples (200ms each)
voltage1 = L1_Voltage(1:200000);
L1_Current_1 = L1_Current(1:200000);
voltage2 = L1_Voltage(200001:400000);
L1_Current_2 = L1_Current(200001:400000);
voltage3 = L1_Voltage(400001:600000);
L1_Current_3 = L1_Current(400001:600000);
voltage4 = L1_Voltage(600001:800000);
L1_Current_4 = L1_Current(600001:800000);
voltage5 = L1_Voltage(800001:1000000);
L1_Current_5 = L1_Current(800001:1000000);

for docount = 1:5 
    if docount == 1
        voltage = voltage1;
        Current_L1 = L1_Current_1;
    elseif docount == 2
        voltage = voltage2;
        Current_L1 = L1_Current_2;
    elseif docount == 3
        voltage = voltage3;
        Current_L1 = L1_Current_3;
    elseif docount == 4
        voltage = voltage4;
        Current_L1 = L1_Current_4;
    else
        voltage = voltage5;
        Current_L1 = L1_Current_5;
    end

    %% Mean and RMS Calculate

    Udc = zeros(num_groups, 1);    
    Urms = zeros(num_groups, 1);
    I_L1rms = zeros(num_groups, 1);
    I_L1 = zeros(num_groups,1);
    k = 1;
    j = 1;
    temp = zeros(group_size,2);
    for i = 1:timescale/5
        temp(k,1) = voltage(i);
        temp(k,2) = Current_L1(i);
        k = k+1;
        if k == (group_size + 1)
            Udc(j) = mean(temp(:,1));
            Urms(j) = rms(temp(:,1));
            I_L1(j) = mean(temp(:,2));
            I_L1rms = rms(temp(:,2));
            k = 1;
            j = j + 1;
        end
    end

    %% U_rms & U_DC storage

    if docount == 1
        Urms_1 = Urms;
        Udc_1 = Udc;
    elseif docount == 2
        Urms_2 = Urms;
        Udc_2 = Udc;
    elseif docount == 3
        Urms_3 = Urms;
        Udc_3 = Udc;
    elseif docount == 4
        Urms_4 = Urms;
        Udc_4 = Udc;
    else
        Urms_5 = Urms;
        Udc_5 = Udc;
        Udc_out = cat(1,Udc_1,Udc_2,Udc_3,Udc_4,Udc_5);
        Urms_out = cat(1,Urms_1,Urms_2,Urms_3,Urms_4,Urms_5);
    end

    %% Detection

    timecount = 0;
    isSwell = 0; %To flag status of the sample
    isDip = 0;
    isInterruption = 0;
    DipCount = 1; %Not starts at 0 as previous sample may leave a flag of disturance and start from 0 will result a bug.
    SwellCount = 1;
    InterruptionCount = 1;

    isNonStatDistOccur = zeros(num_groups,1);
    % Swell
    for i = 1:num_groups
        if Urms(i) > Swell_tr && isSwell == 0
            if isSwell_legacy == 1 %Previous one's status
                isSwell = 1;
                timecount = 1;
                SwellCount = SwellCount;
                SwellTime(timecount,SwellCount) = 1;
                SwellSpec(timecount,SwellCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
                isSwell_legacy = 2; %Change to 2 here to help further counting
            else
                isSwell = 1;
                timecount = 1;
                SwellCount = SwellCount + 1;
                SwellTime(timecount,SwellCount) = 1;
                SwellSpec(timecount,SwellCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
            end
        elseif Urms(i) > (Swell_tr - hysteresis) && isSwell == 1
            timecount = timecount + 1;
            SwellTime(timecount,SwellCount) = 1;
            SwellSpec(timecount,SwellCount) = Urms(i);
            isNonStatDistOccur(i) = 1;
        elseif Urms(i) < (Swell_tr - hysteresis) && isSwell == 1
            isSwell = 0;
        else
        end
    end
    if isSwell_legacy == 2
        SampleSwellCount = SampleSwellCount + (SwellCount - 1);
        isSwell_legacy = isSwell; %To pass this sample's status to next one
        for i = 1:SwellCount
            Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
        end        
    else
        SampleSwellCount = SampleSwellCount + (SwellCount - 1);
        isSwell_legacy = isSwell;
        for i = 1:(SwellCount -1)
            Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i+1));
        end
    end

    for i = 1:num_groups %Same design as Swell
        if Urms(i) < Dip_tr && isDip == 0 && Urms(i) > Interruption_tr
            if isDip_legacy == 1
                isDip = 1;
                timecount = 1;
                DipCount = DipCount;
                DipTime(timecount,DipCount) = 1;
                DipSpec(timecount,DipCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
                isDip_legacy = 2;
            else
                isDip = 1;
                timecount = 1; 
                DipCount = DipCount + 1;
                DipTime(timecount,DipCount) = 1;
                DipSpec(timecount,DipCount) = Urms(i);
                isNonStatDistOccur(i) = 1;    
            end
        elseif Urms(i) < (Dip_tr + hysteresis) && isDip == 1 && Urms(i) > Interruption_tr
            timecount = timecount + 1;
            DipTime(timecount,DipCount) = 1;
            DipSpec(timecount,DipCount) = Urms(i);
            isNonStatDistOccur(i) = 1;
        elseif Urms(i) > (Dip_tr + hysteresis) && isDip == 1 && Urms(i) > Interruption_tr
            isDip = 0;
        else
        end
    end
    if isDip_legacy == 2
        SampleDipCount = SampleDipCount + (DipCount - 1);
        isDip_legacy = isDip;
        for i = 1:DipCount
            Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i));
        end
    else
        SampleDipCount = SampleDipCount + (DipCount - 1);
        isDip_legacy = isDip;
        for i = 1:(DipCount-1)
            Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i+1));
        end
    end
    %Interruption
    for i = 1:num_groups %Ditto
        if Urms(i) < Interruption_tr && isInterruption == 0
            if isInterruption_legacy == 1
                isInterruption = 1;
                timecount = 1;
                InterruptionCount = InterruptionCount;
                InterruptionTime(timecount,InterruptionCount) = 1;
                InterruptionSpec(timecount,InterruptionCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
                isInterruption_legacy = 2;
            else
                isInterruption = 1;
                timecount = 1;
                InterruptionCount = InterruptionCount + 1;
                InterruptionTime(timecount,InterruptionCount) = 1;
                InterruptionSpec(timecount,InterruptionCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
                isInterruption_legacy = 0;
            end
        elseif Urms(i) < Interruption_tr && isInterruption == 1
            timecount = timecount + 1;
            InterruptionTime(timecount,InterruptionCount) = 1;
            InterruptionSpec(timecount,InterruptionCount) = Urms(i);
            isNonStatDistOccur(i) = 1;
        elseif Urms(i) > Interruption_tr && isInterruption == 1
            isInterruption = 0;
        else
        end
    end
    if isInterruption_legacy == 2
        SampleInterruptionCount = SampleInterruptionCount + (InterruptionCount - 1);
        isInterruption_legacy = isInterruption;
        for i = 1:InterruptionCount
            Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i));
        end
    else
        SampleInterruptionCount = SampleInterruptionCount + (InterruptionCount - 1 );
        isInterruption_legacy = isInterruption;
        for i = 1:(InterruptionCount-1)
            Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i+1));
        end
    end

    %% U_ripple
    % RDF
    L = length(voltage);
    t = (0:L-1)*Ts;    
    Y = fft(voltage);
    
    P2 = abs(Y/L);
    P1 = P2(1:round(L/2));
    P1(2:end) = (2*P1(2:end))/sqrt(2);
    f = Fs*(0:(L/2)-1)/L;
    
    Temp = sum(P1(2:end).^2);
    Temp2 = sqrt(Temp);
    RDF = (Temp2 / P1(1)) *100;
    RDF_eachwindow(docount) = RDF; %I spilt the RDF calculation into steps to help debug
    

    Uripple = sqrt(Urms.^2./Udc .^2);
    Peak = max(voltage);
    Valley = min(voltage);
    PeaktoValley(docount) = abs(Peak - Valley);
    Factor_peak_valley_sample(docount) = PeaktoValley(docount)/mean(Udc) * 100;
    Factor_rms_sample(docount) = mean(Uripple./Udc) * 100;
    Uripple_mean(docount) = mean(Uripple);
    Uripple_variance(docount) = var(Uripple);

    %% I_ripple
    % RDF
    L_i1 = length(Current_L1);
    t_i1 = (0:L_i1-1)*Ts;    
    Y_i1 = fft(Current_L1);
    
    P2_i1 = abs(Y_i1/L_i1);
    P1_i1 = P2_i1(1:round(L_i1/2));
    P1_i1(2:end) = (2*P1_i1(2:end))/sqrt(2);
    f_i1 = Fs*(0:(L_i1/2)-1)/L_i1;
    
    Temp = sum(P1_i1(2:end).^2);
    Temp2 = sqrt(Temp);
    RDF_i1 = (Temp2 / P1_i1(1)) *100;
    RDF_eachwindow_i1(docount) = RDF_i1; %I spilt the RDF calculation into steps to help debug
    
    I_1_ripple = sqrt(I_L1rms.^2./I_L1 .^2);
    Peak_i1 = max(Current_L1);
    Valley_i1 = min(Current_L1);
    PeaktoValley_i1(docount) = abs(Peak_i1 - Valley_i1);
    Factor_peak_valley_sample_i1(docount) = PeaktoValley_i1(docount)/mean(I_L1) * 100;
    Factor_rms_sample_i1(docount) = mean(I_1_ripple./I_L1) * 100;
    Uripple_mean_i1(docount) = mean(I_1_ripple);
    Uripple_variance_i1(docount) = var(I_1_ripple);
    

end

cd 'A:\Lin project\Individual_Project\' %This is the path of THIS file locate
end
