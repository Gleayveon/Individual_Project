%% Version: 2.0.6β
% clc
% clear
% close all

% cd 'A:\Lin project\Data\'
% listing = dir('*.tdms');
% len = length(listing);
start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
Fs=1000000; % Sampling frequency
Ts=1/Fs;    % Sampling period
group_size = 5000;
U_nominal = 700;
hysteresis = 0.02*U_nominal;
Dip_tr = 0.9*U_nominal; %Threashold_Dip
Swell_tr = 1.1*U_nominal;
Interruption_tr = 0.1*U_nominal;

leftover = 0;
% for num = 1:len
%     [Udc_out,Urms_out,I_mean_L1_out,I_rms_L1_out,I_mean_L2_out,...
%     I_rms_L2_out,I_mean_L3_out,I_rms_L3_out,leftover] = ...
%     evaluate(num,listing,group_size,leftover);
%     Urms = cat(1,Urms,Urms_out(2:end));
%     Udc = cat(1,Udc, Udc_out(2:end));
%     I_rms_Line1 = cat(1,I_rms_Line1,I_rms_L1_out(2:end));
%     I_rms_Line2 = cat(1,I_rms_Line2,I_rms_L2_out(2:end));
%     I_rms_Line3 = cat(1,I_rms_Line3,I_rms_L3_out(2:end));
%     I_mean_Line1 = cat(1,I_mean_Line1,I_mean_L1_out(2:end));
%     I_mean_Line2 = cat(1,I_mean_Line2,I_mean_L2_out(2:end));
%     I_mean_Line3 = cat(1,I_mean_Line3,I_mean_L2_out(2:end));
% end

% Urms(1,:) = [];
% Udc(1,:) = [];
% I_rms_Line1(1,:) = [];
% I_rms_Line2(1,:) = [];
% I_rms_Line3(1,:) = [];
% I_mean_Line1(1,:) = [];
% I_mean_Line2(1,:) = [];
% I_mean_Line3(1,:) = [];

%% Detection
timecount = 0;
isSwell = 0; %To flag status of the sample
isDip = 0;
isInterruption = 0;
DipCount = 0; 
SwellCount = 0;
InterruptionCount = 0;
Swell_time = 0;
Swell_spec = U_nominal;
Dip_time = 0;
Dip_spec = U_nominal;
Interruption_time = 0;
Interruption_spec = U_nominal;
Swell_timesum = 0;
Dip_timesum = 0;
Interruption_timesum = 0;

isNonStatDistOccur = zeros(length(Urms),1);
% Swell
for i = 1:length(Urms)
    if Urms(i) > Swell_tr && isSwell == 0
        isSwell = 1;
        timecount = 1;
        SwellCount = SwellCount + 1;
        SwellTime(timecount,SwellCount) = 1;
        SwellSpec(timecount,SwellCount) = Urms(i);
        isNonStatDistOccur(i) = 1;

    elseif Urms(i) > (Swell_tr - hysteresis) && isSwell == 1
        timecount = timecount + 1;
        SwellTime(timecount,SwellCount) = 1;
        SwellSpec(timecount,SwellCount) = Urms(i);
        isNonStatDistOccur(i) = 1;
    elseif Urms(i) < (Swell_tr - hysteresis) && isSwell == 1
        isSwell = 0;
    elseif Urms(i) < Dip_tr && isDip == 0 && Urms(i) > Interruption_tr
        isDip = 1;
        timecount = 1;
        DipCount = DipCount + 1;
        DipTime(timecount,DipCount) = 1;
        DipSpec(timecount,DipCount) = Urms(i);
        isNonStatDistOccur(i) = 2;
    elseif Urms(i) < (Dip_tr + hysteresis) && isDip == 1 && Urms(i) > Interruption_tr
        timecount = timecount + 1;
        DipTime(timecount,DipCount) = 1;
        DipSpec(timecount,DipCount) = Urms(i);
        isNonStatDistOccur(i) = 2;
    elseif Urms(i) > (Dip_tr + hysteresis) && isDip == 1
        isDip = 0;
    elseif Urms(i) < Interruption_tr && isInterruption == 0
        isInterruption = 1;
        timecount = 1;
        InterruptionCount = InterruptionCount + 1;
        InterruptionTime(timecount,InterruptionCount) = 1;
        InterruptionSpec(timecount,InterruptionCount) = Urms(i);
        isNonStatDistOccur(i) = 3;
        isDip = 0;
    elseif Urms(i) < Interruption_tr && isInterruption == 1
        timecount = timecount + 1;
        InterruptionTime(timecount,InterruptionCount) = 1;
        InterruptionSpec(timecount,InterruptionCount) = Urms(i);
        isNonStatDistOccur(i) = 3;
    elseif Urms(i) > Interruption_tr && isInterruption == 1
        isInterruption = 0;
    end
end

for i = 1:SwellCount
    Swell_timesum = Swell_timesum + group_size * sum(SwellTime(:,i));
    Swell_time(i) = group_size * sum(SwellTime(:,i));
    Swell_spec(i) = max(SwellSpec(1:sum(SwellTime(:,i)),i));
end
for i = 1:DipCount
    Dip_timesum = Dip_timesum + group_size * sum(DipTime(:,i));
    Dip_time(i) = group_size * sum(DipTime(:,i));
    Dip_spec(i) = min(DipSpec(1:sum(DipTime(:,i)),i));
end
for i = 1:InterruptionCount
    Interruption_timesum = Interruption_timesum + group_size * sum(InterruptionTime(:,i));
    Interruption_time(i) = group_size * sum(InterruptionTime(:,i));
    Interruption_spec(i) = min(InterruptionSpec(1:sum(InterruptionTime(:,i)),i));
end
%% RDF & 2 Factors
j = 1;
k = 1;
L = 200;
t = (0:L-1)*Ts;
U_calc = zeros(200,1);
Flags = zeros(200,1);
RDF = zeros(floor(length(Urms)/200),1);
Peak_Ripple_Factor = zeros(floor(length(Urms)/200),1);
RMS_Ripple_Factor = zeros(floor(length(Urms)/200),1);
for i = 1:length(Urms)
    U_calc(j) = Urms(i);
    Flags(j) = isNonStatDistOccur(i);
    j = j + 1;
    if j == 201
        if sum(Flags(:,1)) ~= 0
            RDF(k) = NaN;
            Peak_Ripple_Factor(k) = NaN;
            RMS_Ripple_Factor(k) = NaN;
            k = k + 1;
        else
            Y = fft(U_calc);
            P2 = abs(Y/L);
            P1 = P2(1:round(L/2));
            P1(2:end) = (2*P1(2:end))/sqrt(2);
            f = Fs*(0:(L/2)-1)/L;
            Temp = sum(P1(2:end).^2);
            Temp2 = sqrt(Temp);
            RDF(k) = (Temp2 / P1(1)) *100;

            Peak = max(U_calc);
            Valley = min(U_calc);
            Peak_Ripple_Factor(k) = abs(Peak - Valley)/U_nominal;

            Uripple = sqrt((Urms.^2) - (Udc .^2));
            RMS_Ripple_Factor(k) = mean(Uripple./U_nominal) * 100;

            k = k + 1;
        end
    end
end

%% Display
Pie_Data(1) = 5000*length(Urms) - sum(Swell_time) - sum(Dip_time) - sum(Interruption_time);
Pie_Data(2) = sum(Swell_time);
Pie_Data(3) = sum(Dip_time);
Pie_Data(4) = sum(Interruption_time);
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
if SwellCount == 0;
    fprintf(['There is no Swell in these sample.\n'])
else
    for i = 1:SwellCount
        fprintf('Swell No.%d: Maximum Urms is %.4f V. Duration is %d ms.\n', i, Swell_spec(i), Swell_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if DipCount == 0;
    fprintf(['There is no Dip in these sample.\n'])
else
    for i = 1:DipCount
        fprintf('Dip No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Dip_spec(i), Dip_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

if InterruptionCount == 0;
    fprintf(['There is no Interruption in these sample.\n'])
else
    for i = 1:InterruptionCount
        fprintf('Interruption No.%d: Minimum Urms is %.4f V. Duration is %d ms.\n', i, Interruption_spec(i), Interruption_time(i)/1000);
    end
end
fprintf('----------------------------------\n\n');

time_5MS_SS = 5:5:5*(length(Udc));
time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
time_5MS = cat(1, time_5MS_Cell{:});
% time_200MS_SS = 200:200:200*(length(Factor_rms_V)-1);
% time_200MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS, 'UniformOutput', false);
% time_200MS = cat(1, time_200MS_Cell{:});

figure(1)
    pie(Pie_Data,'%.3f%%');
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
figure(2)
    subplot(2,1,1)
    plot(time_5MS,Udc(1:end));
    title('U_D_C mean');
    ylabel('U_D_C Magnitude');
    xlabel('Time (ms)')
    hold on
    subplot(2,1,2)
    plot(time_5MS,Urms(1:end));
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    yline(Dip_tr,'--','Color','#C31E2D','Label','Dip threshold');
    yline(Swell_tr,'--','Color','#2773C8','Label','Swell threshold');
    yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption threshold');
