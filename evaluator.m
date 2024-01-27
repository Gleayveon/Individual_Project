function [U_avg,U_rms,I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,...
    isNonStatDistOccur,timecount,isSwell,isDip,...
    isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
    InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
    RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
    RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
    RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
    RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,leftover]...
    = evaluator(num,listing,sample_window_length,group_size,Fs,Ts,U_avg,U_rms,...
    I_avg_L1,I_avg_L2,I_avg_L3,I_rms_L1,I_rms_L2,I_rms_L3,isNonStatDistOccur,...
    hysteresis,Swell_tr,Dip_tr,Interruption_tr,timecount,isSwell,isDip,...
    isInterruption,DipCount,SwellCount,InterruptionCount,DipTime,SwellTime,...
    InterruptionTime,DipSpec,SwellSpec,InterruptionSpec,U_ripple,RDF_Voltage,...
    RMS_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage,I_ripple_L1,RDF_L1,...
    RMS_Ripple_Factor_L1,Peak_Ripple_Factor_L1,I_ripple_L2,RDF_L2,...
    RMS_Ripple_Factor_L2,Peak_Ripple_Factor_L2,I_ripple_L3,RDF_L3,...
    RMS_Ripple_Factor_L3,Peak_Ripple_Factor_L3,Dip,Swell,Interruption,leftover)

%% Data Loading
% Version: 3.0.4
cd 'A:\Lin project'\Data\  % Here is the path of where Data file locate

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

num_groups = floor(sample_window_length / group_size);


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
    
    voltage = Data_Voltage(1+(docount-1)*200000:docount*200000);
    current_L1 = Data_L1_Current(1+(docount-1)*200000:docount*200000);
    current_L2 = Data_L2_Current(1+(docount-1)*200000:docount*200000);
    current_L3 = Data_L3_Current(1+(docount-1)*200000:docount*200000);

    %% Mean & RMS Calculation
    
    Urms_sample = zeros(num_groups, 1);
    Uavg_sample = zeros(num_groups, 1);
    current_mean_sample_L1 = zeros(num_groups, 1);
    current_rms_sample_L1 = zeros(num_groups, 1);
    current_mean_sample_L2 = zeros(num_groups, 1);
    current_rms_sample_L2 = zeros(num_groups, 1);
    current_mean_sample_L3 = zeros(num_groups, 1);
    current_rms_sample_L3 = zeros(num_groups, 1);
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
            Uavg_sample(j) = mean(temp(:,1));
            Urms_sample(j) = rms(temp(:,1));
            current_mean_sample_L1(j) = mean(temp(:,2));
            current_rms_sample_L1(j) = rms(temp(:,2));
            current_mean_sample_L2(j) = mean(temp(:,3));
            current_rms_sample_L2(j) = rms(temp(:,3));
            current_mean_sample_L3(j) = mean(temp(:,4));
            current_rms_sample_L3(j) = rms(temp(:,4));
            k = 1;
            j = j + 1;
        end
    end

    %% Detection


    isNonStatDistOccur_sample = zeros(length(Urms_sample),1);
    % Swell
    for i = 1:length(Urms_sample)
        if Urms_sample(i) > Swell_tr && isSwell == 0
            isSwell = 1;
            timecount = 1;
            SwellCount = SwellCount + 1;
            SwellTime(timecount,SwellCount) = 1;
            SwellSpec(timecount,SwellCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 1;
            if num == 1
                Swell(SwellCount,1) = 0;
                Swell(SwellCount,2) = i;
                Swell(SwellCount,3) = ducount;
            else
                Swell(SwellCount,1) = length(U_rms);
                Swell(SwellCount,2) = i;
                Swell(SwellCount,3) = docount;
            end

        elseif Urms_sample(i) > (Swell_tr - hysteresis) && isSwell == 1
            timecount = timecount + 1;
            SwellTime(timecount,SwellCount) = 1;
            SwellSpec(timecount,SwellCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 1;
        elseif Urms_sample(i) < (Swell_tr - hysteresis) && isSwell == 1
            isSwell = 0;
            if num == 1
                Swell(SwellCount,4) = 0;
                Swell(SwellCount,5) = i;
                Swell(SwellCount,6) = docount;
            else
                Swell(SwellCount,4) = length(U_rms);
                Swell(SwellCount,5) = i;
                Swell(SwellCount,6) = docount;
            end
        end

        if Urms_sample(i) < Dip_tr && isDip == 0 && Urms_sample(i) > Interruption_tr
            isDip = 1;
            timecount = 1;
            DipCount = DipCount + 1;
            DipTime(timecount,DipCount) = 1;
            DipSpec(timecount,DipCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 2;
            if num == 1
                Dip(DipCount,1) = 0;
                Dip(DipCount,2) = i;
                Dip(DipCount,3) = ducount;
            else
                Dip(DipCount,1) = length(U_rms);
                Dip(DipCount,2) = i;
                Dip(DipCount,3) = docount;
            end
        elseif Urms_sample(i) < (Dip_tr + hysteresis) && isDip == 1 && Urms_sample(i) > Interruption_tr
            timecount = timecount + 1;
            DipTime(timecount,DipCount) = 1;
            DipSpec(timecount,DipCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 2;
        elseif Urms_sample(i) > (Dip_tr + hysteresis) && isDip == 1
            isDip = 0;
            if num == 1
                Dip(DipCount,4) = 0;
                Dip(DipCount,5) = i;
                Dip(DipCount,6) = docount;
            else
                Dip(DipCount,4) = length(U_rms);
                Dip(DipCount,5) = i;
                Dip(DipCount,6) = docount;
            end
        elseif Urms_sample(1) < Interruption_tr && isDip == 1
            isDip = 0;
            if num == 1
                Dip(DipCount,4) = 0;
                Dip(DipCount,5) = i;
                Dip(DipCount,6) = docount;
            else
                Dip(DipCount,4) = length(U_rms);
                Dip(DipCount,5) = i;
                Dip(DipCount,6) = docount;
            end
        end

        if Urms_sample(i) < Interruption_tr && isInterruption == 0
            isInterruption = 1;
            timecount = 1;
            InterruptionCount = InterruptionCount + 1;
            InterruptionTime(timecount,InterruptionCount) = 1;
            InterruptionSpec(timecount,InterruptionCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 3;
            if num == 1
                Interruption(InterruptionCount,1) = 0;
                Interruption(InterruptionCount,2) = i;
                Interruption(InterruptionCount,3) = ducount;
            else
                Interruption(InterruptionCount,1) = length(U_rms);
                Interruption(InterruptionCount,2) = i;
                Interruption(InterruptionCount,3) = docount;
            end
        elseif Urms_sample(i) < Interruption_tr && isInterruption == 1
            timecount = timecount + 1;
            InterruptionTime(timecount,InterruptionCount) = 1;
            InterruptionSpec(timecount,InterruptionCount) = Urms_sample(i);
            isNonStatDistOccur_sample(i) = 3;
        elseif Urms_sample(i) > Interruption_tr && isInterruption == 1
            isInterruption = 0;
            if num == 1
                Interruption(InterruptionCount,4) = 0;
                Interruption(InterruptionCount,5) = i;
                Interruption(InterruptionCount,6) = docount;
            else
                Interruption(InterruptionCount,4) = length(U_rms);
                Interruption(InterruptionCount,5) = i;
                Interruption(InterruptionCount,6) = docount;
            end
        end
    end

    %% RDF & 2 Factors
    L = sample_window_length / group_size;
    t = (0:L-1)*Ts;

    RDF_Voltage_sample = 0;
    Peak_Ripple_Factor_Voltage_sample = 0;
    RMS_Ripple_Factor_Voltage_sample = 0;

    RDF_L1_sample = 0;
    Peak_Ripple_Factor_L1_sample = 0;
    RMS_Ripple_Factor_L1_sample = 0;

    RDF_L2_sample = 0;
    Peak_Ripple_Factor_L2_sample = 0;
    RMS_Ripple_Factor_L2_sample = 0;

    RDF_L3_sample = 0;
    Peak_Ripple_Factor_L3_sample = 0;
    RMS_Ripple_Factor_L3_sample = 0;

    
    if sum(isNonStatDistOccur_sample(:)) ~= 0
        RDF_Voltage_sample = NaN;
        Peak_Ripple_Factor_Voltage_sample = NaN;
        RMS_Ripple_Factor_Voltage_sample = NaN;
        RDF_L1_sample = NaN;
        Peak_Ripple_Factor_L1_sample = NaN;
        RMS_Ripple_Factor_L1_sample = NaN;
        RDF_L2_sample = NaN;
        Peak_Ripple_Factor_L2_sample = NaN;
        RMS_Ripple_Factor_L2_sample = NaN;
        RDF_L3_sample = NaN;
        Peak_Ripple_Factor_L3_sample = NaN;
        RMS_Ripple_Factor_L3_sample = NaN;
        Uripple = NaN(length(Urms_sample),1);
        Iripple_L1 = NaN(length(current_rms_sample_L1),1);
        Iripple_L2 = NaN(length(current_rms_sample_L2),1);
        Iripple_L3 = NaN(length(current_rms_sample_L3),1);
    else
        % Voltage
        Y = fft(Urms_sample);

        P2 = abs(Y/L);
        P1 = P2(1:round(L/2));
        P1(2:end) = (2*P1(2:end))/sqrt(2);
        f = Fs*(0:(L/2)-1)/L;

        Temp = sum(P1(2:end).^2);
        Temp2 = sqrt(Temp);
        RDF_Voltage_sample = (Temp2 / P1(1)) *100;

        Peak = max(Urms_sample);
        Valley = min(Urms_sample);
        Peak_Ripple_Factor_Voltage_sample = (Peak - Valley)/mean(Uavg_sample);

        Uripple = sqrt((Urms_sample.^2) - (Uavg_sample .^2));
        RMS_Ripple_Factor_Voltage_sample = mean(Uripple./Uavg_sample) * 100;
        % Line 1
        Y_L1 = fft(current_rms_sample_L1);

        P2_L1 = abs(Y_L1/L);
        P1_L1 = P2_L1(1:round(L/2));
        P1_L1(2:end) = (2*P1_L1(2:end))/sqrt(2);

        Temp_L1 = sum(P1_L1(2:end).^2);
        Temp2_L1 = sqrt(Temp_L1);
        RDF_L1_sample = (Temp2_L1 / P1_L1(1)) *100;

        Peak = max(current_rms_sample_L1);
        Valley = min(current_rms_sample_L1);
        Peak_Ripple_Factor_L1_sample = abs(Peak - Valley)/mean(current_mean_sample_L1);

        Iripple_L1 = sqrt((current_rms_sample_L1.^2) - (current_mean_sample_L1 .^2));
        RMS_Ripple_Factor_L1_sample = mean(Iripple_L1./abs(current_mean_sample_L1)) * 100;
        % Line 2
        Y_L2 = fft(current_rms_sample_L2);

        P2_L2 = abs(Y_L2/L);
        P1_L2 = P2_L2(1:round(L/2));
        P1_L2(2:end) = (2*P1_L2(2:end))/sqrt(2);

        Temp_L2 = sum(P1_L2(2:end).^2);
        Temp2_L2 = sqrt(Temp_L2);
        RDF_L2_sample = (Temp2_L2 / P1_L2(1)) *100;

        Peak = max(current_rms_sample_L2);
        Valley = min(current_rms_sample_L2);
        Peak_Ripple_Factor_L2_sample = abs(Peak - Valley)/mean(current_mean_sample_L2);

        Iripple_L2 = sqrt((current_rms_sample_L2.^2) - (current_mean_sample_L2 .^2));
        RMS_Ripple_Factor_L2_sample = mean(Iripple_L2./abs(current_mean_sample_L2)) * 100;
        % Line 3
        Y_L3 = fft(current_rms_sample_L3);

        P2_L3 = abs(Y_L3/L);
        P1_L3 = P2_L3(1:round(L/2));
        P1_L3(2:end) = (2*P1_L3(2:end))/sqrt(2);

        Temp_L3 = sum(P1_L3(2:end).^2);
        Temp2_L3 = sqrt(Temp_L3);
        RDF_L3_sample = (Temp2_L3 / P1_L3(1)) *100;

        Peak = max(current_rms_sample_L3);
        Valley = min(current_rms_sample_L3);
        Peak_Ripple_Factor_L3_sample = abs(Peak - Valley)/mean(current_mean_sample_L3);

        Iripple_L3 = sqrt((current_rms_sample_L3.^2) - (current_mean_sample_L3 .^2));
        RMS_Ripple_Factor_L3_sample = mean(Iripple_L3./abs(current_mean_sample_L3)) * 100;
    end
    if num == length(listing) && docount == num_Sample
        if isDip == 1
            Dip(DipCount,4) = length(U_rms);
            Dip(DipCount,5) = i;
            Dip(DipCount,6) = docount;
        elseif isInterruption == 1
            Interruption(InterruptionCount,4) = length(U_rms);
            Interruption(InterruptionCount,5) = i;
            Interruption(InterruptionCount,6) = docount;
        elseif isSwell == 1
            Swell(SwellCount,4) = length(U_rms);
            Swell(SwellCount,5) = i;
            Swell(SwellCount,6) = docount;
        else
            break
        end
    end
        
    %% Storage
if num == 1 && docount == 1
    U_avg = cat(1,U_avg,Uavg_sample);
    U_rms = cat(1,U_rms,Urms_sample);
    I_rms_L1 = cat(1,I_rms_L1,current_rms_sample_L1);
    I_rms_L2 = cat(1,I_rms_L2,current_rms_sample_L2);
    I_rms_L3 = cat(1,I_rms_L3,current_rms_sample_L3);
    I_avg_L1 = cat(1,I_avg_L1,current_mean_sample_L1);
    I_avg_L2 = cat(1,I_avg_L2,current_mean_sample_L2);
    I_avg_L3 = cat(1,I_avg_L3,current_mean_sample_L3);
    isNonStatDistOccur = cat(1,isNonStatDistOccur,isNonStatDistOccur_sample);
    U_ripple = cat(1,U_ripple,Uripple);
    RDF_Voltage = cat(1,RDF_Voltage,RDF_Voltage_sample);
    RMS_Ripple_Factor_Voltage = cat(1,RMS_Ripple_Factor_Voltage,RMS_Ripple_Factor_Voltage_sample);
    Peak_Ripple_Factor_Voltage = cat(1,Peak_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage_sample);
    I_ripple_L1 = cat(1,I_ripple_L1,Iripple_L1);
    RDF_L1 = cat(1,RDF_L1,RDF_L1_sample);
    RMS_Ripple_Factor_L1 = cat(1,RMS_Ripple_Factor_L1,RMS_Ripple_Factor_L1_sample);
    Peak_Ripple_Factor_L1 = cat(1,Peak_Ripple_Factor_L1,Peak_Ripple_Factor_L1_sample);
    I_ripple_L2 = cat(1,I_ripple_L2,Iripple_L2);
    RDF_L2 = cat(1,RDF_L2,RDF_L2_sample);
    RMS_Ripple_Factor_L2 = cat(1,RMS_Ripple_Factor_L2,RMS_Ripple_Factor_L2_sample);
    Peak_Ripple_Factor_L2 = cat(1,Peak_Ripple_Factor_L2,Peak_Ripple_Factor_L2_sample);
    I_ripple_L3 = cat(1,I_ripple_L3,Iripple_L3);
    RDF_L3 = cat(1,RDF_L3,RDF_L3_sample);
    RMS_Ripple_Factor_L3 = cat(1,RMS_Ripple_Factor_L3,RMS_Ripple_Factor_L3_sample);
    Peak_Ripple_Factor_L3 = cat(1,Peak_Ripple_Factor_L3,Peak_Ripple_Factor_L3_sample);

    U_avg(1,:) = [];
    U_rms(1,:) = [];
    I_rms_L1(1,:) = [];
    I_rms_L2(1,:) = [];
    I_rms_L3(1,:) = [];
    I_avg_L1(1,:) = [];
    I_avg_L2(1,:) = [];
    I_avg_L3(1,:) = [];
    isNonStatDistOccur(1,:) = [];
    U_ripple(1,:) = [];
    RDF_Voltage(1,:) = [];
    RMS_Ripple_Factor_Voltage(1,:) = [];
    Peak_Ripple_Factor_Voltage(1,:) = [];
    I_ripple_L1(1,:) = [];
    RDF_L1(1,:) = [];
    RMS_Ripple_Factor_L1(1,:) = [];
    Peak_Ripple_Factor_L1(1,:) = [];
    I_ripple_L2(1,:) = [];
    RDF_L2(1,:) = [];
    RMS_Ripple_Factor_L2(1,:) = [];
    Peak_Ripple_Factor_L2(1,:) = [];
    I_ripple_L3(1,:) = [];
    RDF_L3(1,:) = [];
    RMS_Ripple_Factor_L3(1,:) = [];
    Peak_Ripple_Factor_L3(1,:) = [];
else
    U_avg = cat(1,U_avg,Uavg_sample);
    U_rms = cat(1,U_rms,Urms_sample);
    I_rms_L1 = cat(1,I_rms_L1,current_rms_sample_L1);
    I_rms_L2 = cat(1,I_rms_L2,current_rms_sample_L2);
    I_rms_L3 = cat(1,I_rms_L3,current_rms_sample_L3);
    I_avg_L1 = cat(1,I_avg_L1,current_mean_sample_L1);
    I_avg_L2 = cat(1,I_avg_L2,current_mean_sample_L2);
    I_avg_L3 = cat(1,I_avg_L3,current_mean_sample_L3);
    isNonStatDistOccur = cat(1,isNonStatDistOccur,isNonStatDistOccur_sample);
    U_ripple = cat(1,U_ripple,Uripple);
    RDF_Voltage = cat(1,RDF_Voltage,RDF_Voltage_sample);
    RMS_Ripple_Factor_Voltage = cat(1,RMS_Ripple_Factor_Voltage,RMS_Ripple_Factor_Voltage_sample);
    Peak_Ripple_Factor_Voltage = cat(1,Peak_Ripple_Factor_Voltage,Peak_Ripple_Factor_Voltage_sample);
    I_ripple_L1 = cat(1,I_ripple_L1,Iripple_L1);
    RDF_L1 = cat(1,RDF_L1,RDF_L1_sample);
    RMS_Ripple_Factor_L1 = cat(1,RMS_Ripple_Factor_L1,RMS_Ripple_Factor_L1_sample);
    Peak_Ripple_Factor_L1 = cat(1,Peak_Ripple_Factor_L1,Peak_Ripple_Factor_L1_sample);
    I_ripple_L2 = cat(1,I_ripple_L2,Iripple_L2);
    RDF_L2 = cat(1,RDF_L2,RDF_L2_sample);
    RMS_Ripple_Factor_L2 = cat(1,RMS_Ripple_Factor_L2,RMS_Ripple_Factor_L2_sample);
    Peak_Ripple_Factor_L2 = cat(1,Peak_Ripple_Factor_L2,Peak_Ripple_Factor_L2_sample);
    I_ripple_L3 = cat(1,I_ripple_L3,Iripple_L3);
    RDF_L3 = cat(1,RDF_L3,RDF_L3_sample);
    RMS_Ripple_Factor_L3 = cat(1,RMS_Ripple_Factor_L3,RMS_Ripple_Factor_L3_sample);
    Peak_Ripple_Factor_L3 = cat(1,Peak_Ripple_Factor_L3,Peak_Ripple_Factor_L3_sample);
end
end
fprintf(['Finished No.%d. So far, %d Swell(s), %d Dip(s), %d Interruption(s)\n'],num,SwellCount,DipCount,InterruptionCount);
cd 'A:\Lin project\Individual_Project\' %This is the path of THIS file locate
end
