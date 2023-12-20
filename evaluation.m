function [Udc_out,Urms_out,I_mean_L1,I_rms_L1,I_mean_L2,I_rms_L2,I_mean_L3,I_rms_L3,...
    RDF_V_eachwindow,RDF_L1_eachwindow,RDF_L2_eachwindow,RDF_L3_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,num_Sample,...
    Factor_peak_valley_sample_V,Factor_rms_sample_V,Factor_peak_valley_sample_L1,Factor_rms_sample_L1,...
    Factor_peak_valley_sample_L2,Factor_rms_sample_L2,Factor_peak_valley_sample_L3,Factor_rms_sample_L3,...
    Ripple_V,Ripple_L1,Ripple_L2,Ripple_L3,isSwell_legacy,isDip_legacy,isInterruption_legacy,leftover] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy,Fs,Ts,U_nominal,...
    timescale,group_size,hysteresis,Dip_tr,Swell_tr,Interruption_tr,leftover)
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
%   I_mean_L1                   = Mean Current of Line 1
%   I_rms_L1                    = RMS Current of Line 1
%   I_mean_L2                   = Mean Current of Line 2
%   I_rms_L2                    = RMS Current of Line 2
%   I_mean_L3                   = Mean Current of Line 3
%   I_rms_L3                    = RMS Current of Line 3
%   RDF_V_eachwindow            = RDF of voltage of each sample window (i.e.200ms)
%   RDF_L1_eachwindow           = RDF of voltage of each sample window (i.e.200ms)
%   RDF_L2_eachwindow           = RDF of voltage of each sample window (i.e.200ms)
%   RDF_L3_eachwindow           = RDF of voltage of each sample window (i.e.200ms)
%   Swell_timesum               = The total time length of Swell in this sample
%   Dip_timesum                 = The total time length of Dip in this sample
%   Interruption_timesum        = The total time length of Interruption in this sample
%   SampleDipCount              = The total number of new Dip detected in this sample
%   SampleSwellCount            = The total number of new Swell detected in this sample
%   SampleInterruptionCount     = The total number of new Interruption detected in this sample
%   Factor_peak_valley_sample_V = The Peak to Valley Factor of Voltage of this sample
%   Factor_rms_sample_V         = The mean RMS Factor of Voltage of this sample
%   Factor_peak_valley_sample_L1= The Peak to Valley Factor of Curent of Line 1 of this sample
%   Factor_rms_sample_L1        = The mean RMS Factor of Curent of Line 1 of this sample
%   Factor_peak_valley_sample_L2= The Peak to Valley Factor of Curent of Line 2 of this sample
%   Factor_rms_sample_L2        = The mean RMS Factor of Curent of Line 2 of this sample
%   Factor_peak_valley_sample_L3= The Peak to Valley Factor of Curent of Line 3 of this sample
%   Factor_rms_sample_L3        = The mean RMS Factor of Curent of Line 3 of this sample
%   isSwell                     = Is Swell occuring last sample window?
%   isDip                       = Is Dip occuring last sample window?
%   isInterruption              = Is Interruption occuring last sample window?
% Version: 1.3.5β

%% Data Loading
cd 'A:\Lin project'\Data_Check\  % Here is the path of where Data file locate

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


%%

if num == 1;
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
num_Sample = floor(length(Data_Voltage)/200000);

    clear leftover;
    leftover = horzcat(Data_Voltage(200000*num_Sample + 1:end), Data_L1_Current(200000*num_Sample + 1:end),...
        Data_L2_Current(200000*num_Sample + 1:end),Data_L3_Current(200000*num_Sample + 1:end));

%% Evaluation Start

RDF_V_eachwindow = zeros(num_Sample,1);
RDF_L1_eachwindow = zeros(num_Sample,1);
RDF_L2_eachwindow = zeros(num_Sample,1);
RDF_L3_eachwindow = zeros(num_Sample,1);
num_groups = floor(200000 / group_size);
Swell_timesum = 0;
Dip_timesum = 0;
Interruption_timesum = 0;
SampleDipCount = 0;
SampleSwellCount = 0;
SampleInterruptionCount = 0;
PeaktoValley = zeros(5,1);
Factor_peak_valley_sample_V = zeros(num_Sample,1);
Factor_rms_sample_V = zeros(num_Sample,1);
Uripple_mean = zeros(num_Sample,1);
Uripple_variance = zeros(num_Sample,1);

Udc_out = 0;
Urms_out = 0;
Ripple_V = 0;
Ripple_L1 = 0;
Ripple_L2 = 0;
Ripple_L3 = 0;
I_rms_L1 = 0;
I_rms_L2 = 0;
I_rms_L3 = 0;
I_mean_L1 = 0;
I_mean_L2 = 0;
I_mean_L3 = 0;

% Evaluate is carried out in each 200ms period
for docount = 1:num_Sample

    
    voltage = Data_Voltage(1+(docount-1)*200000:docount*200000);
    current_L1 = Data_L1_Current(1+(docount-1)*200000:docount*200000);
    current_L2 = Data_L2_Current(1+(docount-1)*200000:docount*200000);
    current_L3 = Data_L3_Current(1+(docount-1)*200000:docount*200000);

    %% Mean & RMS Calculation
    
    Urms = zeros(num_groups, 1);
    Udc = zeros(num_groups, 1);
    current_mean_L1 = zeros(num_groups, 1);
    current_rms_L1 = zeros(num_groups, 1);
    current_mean_L2 = zeros(num_groups, 1);
    current_rms_L2 = zeros(num_groups, 1);
    current_mean_L3 = zeros(num_groups, 1);
    current_rms_L3 = zeros(num_groups, 1);
    k = 1;
    j = 1;
    temp = zeros(group_size,1);
    for i = 1:200000
        temp(k,1) = voltage(i);
        temp(k,2) = current_L1(i);
        temp(k,3) = current_L2(i);
        temp(k,4) = current_L3(i);
        k = k+1;
        if k == (group_size + 1)
            Udc(j) = mean(temp(:,1));
            Urms(j) = rms(temp(:,1));
            current_mean_L1(j) = mean(temp(:,2));
            current_rms_L1(j) = rms(temp(:,2));
            current_mean_L2(j) = mean(temp(:,3));
            current_rms_L2(j) = rms(temp(:,3));
            current_mean_L3(j) = mean(temp(:,4));
            current_rms_L3(j) = rms(temp(:,4));
            k = 1;
            j = j + 1;
        end
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

    %% Ripple
    % RDF
    L = length(voltage);
    t = (0:L-1)*Ts;  
    % Voltage
    Y = fft(voltage);
    
    P2 = abs(Y/L);
    P1 = P2(1:round(L/2));
    P1(2:end) = (2*P1(2:end))/sqrt(2);
    f = Fs*(0:(L/2)-1)/L;
    
    Temp = sum(P1(2:end).^2);
    Temp2 = sqrt(Temp);
    RDF = (Temp2 / P1(1)) *100;
    RDF_V_eachwindow(docount) = RDF; %I spilt the RDF calculation into steps to help debug
    % Line 1
    Y_L1 = fft(current_L1);
    
    P2_L1 = abs(Y_L1/L);
    P1_L1 = P2_L1(1:round(L/2));
    P1_L1(2:end) = (2*P1_L1(2:end))/sqrt(2);
    
    Temp_L1 = sum(P1_L1(2:end).^2);
    Temp2_L1 = sqrt(Temp_L1);
    RDF_L1 = (Temp2_L1 / P1_L1(1)) *100;
    RDF_L1_eachwindow(docount) = RDF_L1; %I spilt the RDF calculation into steps to help debug
    % Line 2
    Y_L2 = fft(current_L2);
    
    P2_L2 = abs(Y_L2/L);
    P1_L2 = P2_L2(1:round(L/2));
    P1_L2(2:end) = (2*P1_L2(2:end))/sqrt(2);
    
    Temp_L2 = sum(P1_L2(2:end).^2);
    Temp2_L2 = sqrt(Temp_L2);
    RDF_L2 = (Temp2_L2 / P1_L2(1)) *100;
    RDF_L2_eachwindow(docount) = RDF_L2; %I spilt the RDF calculation into steps to help debug
    % Line 3
    Y_L3 = fft(current_L3);
    
    P2_L3 = abs(Y_L3/L);
    P1_L3 = P2_L3(1:round(L/2));
    P1_L3(2:end) = (2*P1_L3(2:end))/sqrt(2);
    
    Temp_L3 = sum(P1_L3(2:end).^2);
    Temp2_L3 = sqrt(Temp_L3);
    RDF_L3 = (Temp2_L3 / P1_L3(1)) *100;
    RDF_L3_eachwindow(docount) = RDF_L3; %I spilt the RDF calculation into steps to help debug
    %  Factors
    % Uripple = sqrt(Urms^2 / Udc^2);
    % mean and var. of ripple can extract, but didn't, if required, add it
    % to the func. 
    Uripple = sqrt(Urms.^2./Udc .^2);
    Peak = max(voltage);
    Valley = min(voltage);
    PeaktoValley(docount) = abs(Peak - Valley);
    Factor_peak_valley_sample_V(docount) = PeaktoValley(docount)/mean(Udc) * 100;
    Factor_rms_sample_V(docount) = mean(Uripple./Udc) * 100;
    Uripple_mean(docount) = mean(Uripple);
    Uripple_variance(docount) = var(Uripple);
    
    Iripple_L1 = sqrt(current_rms_L1.^2./current_mean_L1 .^2);
    Peak_L1 = max(current_L1);
    Valley_L1 = min(current_L1);
    PeaktoValley_L1(docount) = abs(Peak_L1 - Valley_L1);
    Factor_peak_valley_sample_L1(docount) = PeaktoValley_L1(docount)/abs(mean(current_mean_L1)) * 100;
    Factor_rms_sample_L1(docount) = mean(abs(Iripple_L1)./abs(current_mean_L1)) * 100;
    Iripple_L1_mean(docount) = mean(Iripple_L1);
    Iripple_L1_variance(docount) = var(Iripple_L1);
    
    Iripple_L2 = sqrt(current_rms_L2.^2./current_mean_L2 .^2);
    Peak_L2 = max(current_L2);
    Valley_L2 = min(current_L2);
    PeaktoValley_L2(docount) = abs(Peak_L2 - Valley_L2);
    Factor_peak_valley_sample_L2(docount) = PeaktoValley_L2(docount)/abs(mean(current_mean_L2)) * 100;
    Factor_rms_sample_L2(docount) = mean(abs(Iripple_L2)./abs(current_mean_L2)) * 100;
    Iripple_L2_mean(docount) = mean(Iripple_L2);
    Iripple_L2_variance(docount) = var(Iripple_L2);

    Iripple_L3 = sqrt(current_rms_L3.^2./current_mean_L3 .^2);
    Peak_L3 = max(current_L3);
    Valley_L3 = min(current_L3);
    PeaktoValley_L3(docount) = abs(Peak_L3 - Valley_L3);
    Factor_peak_valley_sample_L3(docount) = PeaktoValley_L3(docount)/abs(mean(current_mean_L3)) * 100;
    Factor_rms_sample_L3(docount) = mean(abs(Iripple_L3)./abs(current_mean_L3)) * 100;
    Iripple_L3_mean(docount) = mean(Iripple_L3);
    Iripple_L3_variance(docount) = var(Iripple_L3);

    %% Storage
   
    Udc_out = cat(1,Udc_out,Udc);
    Urms_out = cat(1,Urms_out,Urms);
    Ripple_V = cat(1,Ripple_V,Uripple);
    Ripple_L1 = cat(1,Ripple_L1,Iripple_L1);
    Ripple_L2 = cat(1,Ripple_L2,Iripple_L2);
    Ripple_L3 = cat(1,Ripple_L3,Iripple_L3);
    I_rms_L1 = cat(1,I_rms_L1,current_rms_L1);
    I_rms_L2 = cat(1,I_rms_L2,current_rms_L2);
    I_rms_L3 = cat(1,I_rms_L3,current_rms_L3);
    I_mean_L1 = cat(1,I_mean_L1,current_mean_L1);
    I_mean_L2 = cat(1,I_mean_L2,current_mean_L2);
    I_mean_L3 = cat(1,I_mean_L3,current_mean_L3);


end
fprintf(['Finished No.%d.\n'],num);
cd 'A:\Lin project\Individual_Project\' %This is the path of THIS file locate
end
