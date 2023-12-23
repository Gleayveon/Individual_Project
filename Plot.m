% Version: 1.4.1β
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
start_time = datetime('13:47:47', 'Format', 'HH:mm:ss.SSS');
time_5MS_SS = 5:5:5*(length(Udc_main)-1);
time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
time_5MS = cat(1, time_5MS_Cell{:});
time_200MS_SS = 200:200:200*(length(Factor_rms_V)-1);
time_200MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS, 'UniformOutput', false);
time_200MS = cat(1, time_200MS_Cell{:});

figure(1)
    pie(Pie_Data,'%.3f%%');
    legend('Normal','Swell','Dip','Interruption');
    title('Chart of the data''s voltage status');
figure(2)
    subplot(2,1,1)
    plot(time_5MS,Udc_main(2:end));
    title('U_D_C mean');
    ylabel('U_D_C Magnitude');
    xlabel('Time (ms)')
    hold on
    subplot(2,1,2)
    plot(time_5MS,Urms_main(2:end));
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    yline(Dip_tr,'--','Color','#C31E2D','Label','Dip threshold');
    yline(Swell_tr,'--','Color','#2773C8','Label','Swell threshold');
    yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption threshold');
    xline(datetime('13:49:00','Format', 'HH:mm:ss.SSS'),'Label','13:49');
    xline(datetime('14:05:00','Format', 'HH:mm:ss.SSS'),'Label','14:05');
    xline(datetime('14:18:00','Format', 'HH:mm:ss.SSS'),'Label','14:18');
    xline(datetime('14:25:00','Format', 'HH:mm:ss.SSS'),'Label','14:25');
    xline(datetime('14:30:00','Format', 'HH:mm:ss.SSS'),'Label','14:30');
    xline(datetime('14:47:00','Format', 'HH:mm:ss.SSS'),'Label','14:47');
    xline(datetime('14:53:00','Format', 'HH:mm:ss.SSS'),'Label','14:53');
    xline(datetime('14:55:00','Format', 'HH:mm:ss.SSS'),'Label','14:55');
    xline(datetime('14:57:00','Format', 'HH:mm:ss.SSS'),'Label','14:57');
    xline(datetime('14:58:00','Format', 'HH:mm:ss.SSS'),'Label','14:58');
    xline(datetime('14:59:00','Format', 'HH:mm:ss.SSS'),'Label','14:59');
    xline(datetime('15:00:00','Format', 'HH:mm:ss.SSS'),'Label','15:00');
    xline(datetime('15:05:00','Format', 'HH:mm:ss.SSS'),'Label','15:05');
    xline(datetime('15:09:00','Format', 'HH:mm:ss.SSS'),'Label','15:09');
    xline(datetime('15:10:00','Format', 'HH:mm:ss.SSS'),'Label','15:10');
    xline(datetime('15:11:00','Format', 'HH:mm:ss.SSS'),'Label','15:11');
    xline(datetime('15:16:00','Format', 'HH:mm:ss.SSS'),'Label','15:16');
    xline(datetime('15:18:00','Format', 'HH:mm:ss.SSS'),'Label','15:18');
    xline(datetime('15:32:00','Format', 'HH:mm:ss.SSS'),'Label','15:32');
    xline(datetime('15:33:00','Format', 'HH:mm:ss.SSS'),'Label','15:33');
figure(3)
    plot(time_200MS,Factor_rms_V(2:end));
    title('Factor_r_m_s Voltage');
    xlabel('Time (ms)');
    ylabel('Factor_r_m_s Magnitude (%)');
    
figure(4)
    plot(time_200MS,Factor_peak_valley_V(2:end));
    title('Factor_p_e_a_k_-_v_a_l_l_e_y Voltage');
    xlabel('Time (ms)');
    ylabel('Factor_p_e_a_k_-_v_a_l_l_e_y Magnitude (%)');
    
figure(5)
    plot(time_200MS,RDF_total_V(2:end));
    title('RDF_V_o_l_t_a_g_e_1');
    xlabel('Time (ms)');
    ylabel('RDF_V_o_l_t_a_g_e_1 Magnitude');
figure(6)
    plot(time_5MS,Ripple_Voltage(2:end),'Color','#633736');
    hold on
    plot(time_5MS,Ripple_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,Ripple_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,Ripple_Line3(2:end),'Color','#9CC38A');
    legend('Voltage','Line 1','Line 2','Line 3');
    hold off
figure(7)
    subplot(2,1,1)
    plot(time_5MS,I_mean_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,I_mean_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,I_mean_Line3(2:end),'Color','#9CC38A');
    hold off
    title('Current_m_e_a_m _o_f _e_v_e_r_y _5_m_s of all lines');
    ylabel('Magnitude');
    xlabel('Time (ms)');
    legend('Line 1','Line 2','Line 3');
    subplot(2,1,2)
    plot(time_5MS,I_rms_Line1(2:end),'Color','#C31E2D');
    hold on
    plot(time_5MS,I_rms_Line2(2:end),'Color','#2773C8');
    hold on
    plot(time_5MS,I_rms_Line3(2:end),'Color','#9CC38A');
    hold off
    title('Current_r_m_s _o_f _e_v_e_r_y _5_m_s of all lines');
    ylabel('Magnitude');
    xlabel('Time (ms)');
    legend('Line 1','Line 2','Line 3');