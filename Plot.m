% Version: 4.0.0

% start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% time_5MS_SS = 5:5:5*length(U_avg);
% time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
% time_5MS = cat(1, time_5MS_Cell{:});
% time_200MS_SS = 200:200:200*length(RDF_L1);
% time_200MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS, 'UniformOutput', false);
% time_200MS = cat(1, time_200MS_Cell{:});
% 
% Pie_Data(1) = group_size * length(U_avg) - Dip_timesum - Swell_timesum - Interruption_timesum;
% Pie_Data(2) = Swell_timesum;
% Pie_Data(3) = Dip_timesum;
% Pie_Data(4) = Interruption_timesum;

% figure(1)
%     pie(Pie_Data,'%.3f%%');
%     legend('Normal','Swell','Dip','Interruption');
%     title('Chart of the data''s voltage status');
% figure(2)
%     plot(time_5MS,U_avg);
%     title('Voltage');
%     ylabel('Magnitude');
%     xlabel('Time (ms)')
%     hold on
%     plot(time_5MS,U_rms);
%     xlabel('Time (ms)')
%     legend('U_a_v_e_r_a_g_e','U_r_m_s')
%     yline(Dip_tr,'--','Color','#C31E2D','Label','Dip threshold');
%     yline(Swell_tr,'--','Color','#2773C8','Label','Swell threshold');
%     yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption threshold');
% figure(3)
%     plot(time_200MS,RMS_Ripple_Factor_Voltage);
%     title('Factor_r_m_s Voltage');
%     xlabel('Time (ms)');
%     ylabel('Factor_r_m_s Magnitude (%)');
% 
% figure(4)
%     plot(time_200MS,Peak_Ripple_Factor_Voltage);
%     title('Factor_p_e_a_k_-_v_a_l_l_e_y Voltage');
%     xlabel('Time (ms)');
%     ylabel('Factor_p_e_a_k_-_v_a_l_l_e_y Magnitude (%)');
% 
% figure(5)
%     plot(time_200MS,RDF_Voltage);
%     title('RDF_V_o_l_t_a_g_e_1');
%     xlabel('Time (ms)');
%     ylabel('RDF_V_o_l_t_a_g_e_1 Magnitude');
% figure(6)
%     plot(time_5MS,U_ripple,'Color','#633736');
%     hold on
%     plot(time_5MS,I_ripple_L1,'Color','#C31E2D');
%     hold on
%     plot(time_5MS,I_ripple_L2,'Color','#2773C8');
%     hold on
%     plot(time_5MS,I_ripple_L3,'Color','#9CC38A');
%     legend('Voltage','Line 1','Line 2','Line 3');
%     title('Ripple');
%     hold off
% figure(7)
%     subplot(2,1,1)
%     plot(time_5MS,I_avg_L1,'Color','#C31E2D');
%     hold on
%     plot(time_5MS,I_avg_L2,'Color','#2773C8');
%     hold on
%     plot(time_5MS,I_avg_L3,'Color','#9CC38A');
%     hold off
%     title('Current_m_e_a_m _o_f _e_v_e_r_y _5_m_s of all lines');
%     ylabel('Magnitude');
%     xlabel('Time (ms)');
%     legend('Line 1','Line 2','Line 3');
%     subplot(2,1,2)
%     plot(time_5MS,I_rms_L1,'Color','#C31E2D');
%     hold on
%     plot(time_5MS,I_rms_L2,'Color','#2773C8');
%     hold on
%     plot(time_5MS,I_rms_L3,'Color','#9CC38A');
%     hold off
%     title('Current_r_m_s _o_f _e_v_e_r_y _5_m_s of all lines');
%     ylabel('Magnitude');
%     xlabel('Time (ms)');
%     legend('Line 1','Line 2','Line 3');
figure(8)
 plot(time_5MS,U_rms);
    title('U_r_m_s mean');
    ylabel('U_r_m_s Magnitude');
    xlabel('Time (ms)')
    yline(Dip_tr,'--','Color','#C31E2D','Label','Dip tr Start');
    yline((Dip_tr+hysteresis),'--','Color','#C31E2D','Label','Dip tr End');
    yline(Swell_tr,'--','Color','#2773C8','Label','Swell tr Start');
    yline((Swell_tr-hysteresis),'--','Color','#2773C8','Label','Swell tr End');
    yline(Interruption_tr,'--','Color','#9CC38A','Label','Interruption tr ');
    xline(datetime('2023-09-26 13:49:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','13:49');
    xline(datetime('2023-09-26 14:05:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:05');
    xline(datetime('2023-09-26 14:18:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:18');
    xline(datetime('2023-09-26 14:25:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:25');
    xline(datetime('2023-09-26 14:30:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:30');
    xline(datetime('2023-09-26 14:47:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:47');
    xline(datetime('2023-09-26 14:53:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:53');
    xline(datetime('2023-09-26 14:55:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:55');
    xline(datetime('2023-09-26 14:57:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:57');
    xline(datetime('2023-09-26 14:58:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:58');
    xline(datetime('2023-09-26 14:59:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','14:59');
    xline(datetime('2023-09-26 15:00:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:00');
    xline(datetime('2023-09-26 15:05:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:05');
    xline(datetime('2023-09-26 15:09:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:09');
    xline(datetime('2023-09-26 15:10:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:10');
    xline(datetime('2023-09-26 15:11:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:11');
    xline(datetime('2023-09-26 15:16:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:16');
    xline(datetime('2023-09-26 15:18:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:18');
    xline(datetime('2023-09-26 15:32:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:32');
    xline(datetime('2023-09-26 15:33:00','Format', 'yyyy-MMM-d HH:mm:ss.SSS'),'Label','15:33');
    hold on
    plot(time_5MS,I_rms_L1)
    hold on
    plot(time_5MS,I_rms_L2)
    hold on
    plot(time_5MS,I_rms_L3)
    hold off
% figure(9)
%     plot(time_200MS,RMS_Ripple_Factor_L1);
%     hold on
%     plot(time_200MS,RMS_Ripple_Factor_L2);
%     hold on
%     plot(time_200MS,RMS_Ripple_Factor_L3);
%     hold on
%     title('Factor_r_m_s Current');
%     xlabel('Time (ms)');
%     ylabel('Factor_r_m_s Magnitude (%)');
%     legend('Line 1','Line 2','Line 3')
% 
% figure(10)
%     plot(time_200MS,Peak_Ripple_Factor_L1);
%     hold on
%     plot(time_200MS,Peak_Ripple_Factor_L2);
%     hold on
%     plot(time_200MS,Peak_Ripple_Factor_L3);
%     hold on
%     title('Factor_p_e_a_k_-_v_a_l_l_e_y Current');
%     xlabel('Time (ms)');
%     ylabel('Magnitude (%)');
%     legend('Line 1','Line 2','Line 3')
% 
% figure(11)
%     plot(time_200MS,RDF_L1);
%     hold on
%     plot(time_200MS,RDF_L2);
%     hold on
%     plot(time_200MS,RDF_L3);
%     hold on
%     title('RDF_C_u_r_r_e_n_t');
%     xlabel('Time (ms)');
%     ylabel('Magnitude');
%     legend('Line 1','Line 2','Line 3')