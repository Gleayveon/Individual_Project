function [Udc_out,Urms_out,I_mean_L1_out,I_rms_L1_out,I_mean_L2_out,...
    I_rms_L2_out,I_mean_L3_out,I_rms_L3_out,leftover] = ...
    evaluate(num,listing,group_size,leftover)
%% Data Loading
% Version: 3.0.1
cd 'A:\Lin project\Data\'  % Here is the path of where Data file locate

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

num_groups = floor(200000 / group_size);
Udc_out = 0;
Urms_out = 0;
I_rms_L1_out = 0;
I_rms_L2_out = 0;
I_rms_L3_out = 0;
I_mean_L1_out = 0;
I_mean_L2_out = 0;
I_mean_L3_out = 0;


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
    Udc_sample = zeros(num_groups, 1);
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
            Udc_sample(j) = mean(temp(:,1));
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

    %% Storage

    Udc_out = cat(1,Udc_out,Udc_sample);
    Urms_out = cat(1,Urms_out,Urms_sample);
    I_rms_L1_out = cat(1,I_rms_L1_out,current_rms_sample_L1);
    I_rms_L2_out = cat(1,I_rms_L2_out,current_rms_sample_L2);
    I_rms_L3_out = cat(1,I_rms_L3_out,current_rms_sample_L3);
    I_mean_L1_out = cat(1,I_mean_L1_out,current_mean_sample_L1);
    I_mean_L2_out = cat(1,I_mean_L2_out,current_mean_sample_L2);
    I_mean_L3_out = cat(1,I_mean_L3_out,current_mean_sample_L3);
end
fprintf(['Finished No.%d.\n'],num);
cd 'A:\Lin project\Individual_Project\' %This is the path of THIS file locate
end
