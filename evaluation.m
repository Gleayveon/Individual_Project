function [Udc_mean_sample,Urms_mean_sample,RDF_eachwindow,Swell_timesum,Dip_timesum,...
    Interruption_timesum,SampleDipCount,SampleSwellCount,SampleInterruptionCount,...
    Factor_peak_valley_sample,Factor_rms_sample,isSwell_legacy,isDip_legacy,isInterruption_legacy] = ...
    evaluation(num,listing,isSwell_legacy,isDip_legacy,isInterruption_legacy)
% evaluation(A)
% Inputs:
%   num                         = Number of the data
%   listing                     = Sample's name list
%   isSwell                     = Is Swell occuring last sample window?
%   isDip                       = Is Dip occuring last sample window?
%   isInterruption              = Is Interruption occuring last sample window?
% Outputs:
%   Udc_mean_sample             = Mean Udc of this sample
%   Urms_mean_sample            = Mean Urms of this sample
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

cd 'A:\Lin project\Data_Check'
Name = listing(num).name;
data = tdmsread(Name); % signal contains both ripple and non-stationary disturbances

fs=1000000; % Sampling frequency
Ts=1/fs;    % Sampling period
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
figure(1)
Time=(Ts:Ts:length(L1_Voltage)*Ts)'; % Time vector 

plot(Time,L1_Voltage)
hold on
plot(Time,L1_Current)
hold on
plot(Time,L2_Current)
hold on
plot(Time,L3_Current)


%%

U_nominal = 700;
timescale = 1000000;
Fs = 1000000;
group_size = 5;
hysteresis = 0.02*U_nominal;
Dip_tr = 0.9*U_nominal;
Swell_tr = 1.1*U_nominal;
Interruption_tr = 0.1*U_nominal;
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

voltage1 = L1_Voltage(1:200000);
voltage2 = L1_Voltage(200001:400000);
voltage3 = L1_Voltage(400001:600000);
voltage4 = L1_Voltage(600001:800000);
voltage5 = L1_Voltage(800001:1000000);

for docount = 1:5
    if docount == 1
        voltage = voltage1;
    elseif docount == 2
        voltage = voltage2;
    elseif docount == 3
        voltage = voltage3;
    elseif docount == 4
        voltage = voltage4;
    else
        voltage = voltage5;
    end

    %% U_DC

    Udc = zeros(num_groups, 1);
    k = 1;
    j = 1;
    temp = zeros(5,1);
    for i = 1:timescale/5
        temp(k) = voltage(i);
        k = k+1;
        if k == 6
            Udc(j) = mean(temp);
            k = 1;
            j = j + 1;
        end
    end
    Udc_mean_sample(docount) = mean(Udc);

    %% U_rms
    Urms = zeros(num_groups, 1);
    k = 1;
    j = 1;
    for i = 1:timescale/5
        temp(k) = voltage(i)^2;
        k = k+1;
        if k == group_size+1
            Urms(j) = sqrt(1/group_size * sum(temp));
            k = 1;
            j = j + 1;
        end
    end
    Urms_mean_sample(docount) = mean(Urms);

    %% Detection

    timecount = 0;
    isSwell = 0;
    isDip = 0;
    isInterruption = 0;
    DipCount = 1;
    SwellCount = 1;
    InterruptionCount = 1;

    isNonStatDistOccur = zeros(num_groups,1);
    % Swell
    for i = 1:num_groups
        if Urms(i) > Swell_tr && isSwell == 0
            if isSwell_legacy == 1
                isSwell = 1;
                timecount = 1;
                SwellCount = SwellCount;
                SwellTime(timecount,SwellCount) = 1;
                SwellSpec(timecount,SwellCount) = Urms(i);
                isNonStatDistOccur(i) = 1;
                isSwell_legacy = 2;
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
        isSwell_legacy = isSwell;
        for i = 1:SwellCount
            Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
        end        
    else
        SampleSwellCount = SampleSwellCount + (SwellCount - 1);
        isSwell_legacy = isSwell;
        for i = 1:(SwellCount -1)
            Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
        end
    end

    for i = 1:num_groups
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
        elseif Urms(i) < (Dip_tr - hysteresis) && isDip == 1 && Urms(i) > Interruption_tr
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
            Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i));
        end
    end
    %Interruption
    for i = 1:num_groups
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
            InterruptionSpec(timecount,InterruptionCount) = Urms(i);
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
            Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i));
        end
    end

    %% U_ripple
    % RDF
    T = 1/Fs;
    L = length(voltage);
    t = (0:L-1)*T;    
    Y = fft(voltage);
    
    P2 = abs(Y/L);
    P1 = P2(1:round(L/2));
    P1(2:end) = (2*P1(2:end))/sqrt(2);
    f = Fs*(0:(L/2)-1)/L;
    
    Temp = sum(P1(2:end).^2);
    Temp2 = sqrt(Temp);
    RDF = (Temp2 / P1(1)) *100;
    RDF_eachwindow(docount) = RDF;
    
    %  Factors
    % Uripple = sqrt(Urms^2 / Udc^2);
    Uripple = sqrt(Urms.^2./Udc .^2);
    Peak = max(voltage);
    Valley = min(voltage);
    PeaktoValley(docount) = abs(Peak - Valley);
    Factor_peak_valley_sample(docount) = PeaktoValley(docount)/mean(Udc) * 100;
    Factor_rms_sample(docount) = mean(Uripple./Udc) * 100;
    Uripple_mean(docount) = mean(Uripple);
    Uripple_variance(docount) = var(Uripple);
    

end

cd 'A:\Lin project\Individual_Project\'
end
