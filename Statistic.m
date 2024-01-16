%% Statistical analysis
% Version: 3.0.1

% start_time = datetime('2023-09-26 13:47:47', 'Format', 'yyyy-MMM-d HH:mm:ss.SSS');
% time_5MS_SS = 5:5:5*(length(Urms_main)-1);
% time_5MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_5MS_SS, 'UniformOutput', false);
% time_5MS = cat(1, time_5MS_Cell{:});
% time_200MS_SS = 200:200:200*(length(Factor_rms_V)-1);
% time_200MS_Cell = arrayfun(@(ms) start_time + milliseconds(ms), time_200MS_SS, 'UniformOutput', false);
% time_200MS = cat(1, time_200MS_Cell{:});
close all
figure(1)
    subplot(2,2,1)
        time = time_5MS(1:10000);
        yyaxis left
        plot(time_5MS(1:10000),Urms_main(2:10001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1:10000),I_mean_Line1(2:10001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1:10000),I_mean_Line2(2:10001),'Color','#2773C8');
        hold on
        plot(time_5MS(1:10000),I_mean_Line3(2:10001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(1:10000),Urms_main(2:10001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1:10000),I_rms_Line1(2:10001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1:10000),I_rms_Line2(2:10001),'Color','#2773C8');
        hold on
        plot(time_5MS(1:10000),I_rms_Line3(2:10001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(1:10000),Ripple_Voltage(2:10001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1:10000),Ripple_Line1(2:10001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1:10000),Ripple_Line2(2:10001),'Color','#2773C8');
        hold on
        plot(time_5MS(1:10000),Ripple_Line3(2:10001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(1:250);
        yyaxis left
        plot(time_200MS(1:250),RDF_total_V(2:251),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(1:250),RDF_total_L1(2:251),'Color','#C31E2D');
        hold on
        plot(time_200MS(1:250),RDF_total_L2(2:251),'Color','#2773C8');
        hold on
        plot(time_200MS(1:250),RDF_total_L3(2:251),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple') 
figure(2)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(49600:169600),Urms_main(49601:169601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(49600:169600),I_mean_Line1(49601:169601),'Color','#C31E2D');
        hold on
        plot(time_5MS(49600:169600),I_mean_Line2(49601:169601),'Color','#2773C8');
        hold on
        plot(time_5MS(49600:169600),I_mean_Line3(49601:169601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(49600:169600),Urms_main(49601:169601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(49600:169600),I_rms_Line1(49601:169601),'Color','#C31E2D');
        hold on
        plot(time_5MS(49600:169600),I_rms_Line2(49601:169601),'Color','#2773C8');
        hold on
        plot(time_5MS(49600:169600),I_rms_Line3(49601:169601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(49600:169600),Ripple_Voltage(49601:169601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(49600:169600),Ripple_Line1(49601:169601),'Color','#C31E2D');
        hold on
        plot(time_5MS(49600:169600),Ripple_Line2(49601:169601),'Color','#2773C8');
        hold on
        plot(time_5MS(49600:169600),Ripple_Line3(49601:169601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(1240:4240);
        yyaxis left
        plot(time_200MS(1240:4240),RDF_total_V(1241:4241),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(1240:4240),RDF_total_L1(1241:4241),'Color','#C31E2D');
        hold on
        plot(time_200MS(1240:4240),RDF_total_L2(1241:4241),'Color','#2773C8');
        hold on
        plot(time_200MS(1240:4240),RDF_total_L3(1241:4241),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')     
figure(3)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(446600:506600),Urms_main(446601:506601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(446600:506600),I_mean_Line1(446601:506601),'Color','#C31E2D');
        hold on
        plot(time_5MS(446600:506600),I_mean_Line2(446601:506601),'Color','#2773C8');
        hold on
        plot(time_5MS(446600:506600),I_mean_Line3(446601:506601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(446600:506600),Urms_main(446601:506601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(446600:506600),I_rms_Line1(446601:506601),'Color','#C31E2D');
        hold on
        plot(time_5MS(446600:506600),I_rms_Line2(446601:506601),'Color','#2773C8');
        hold on
        plot(time_5MS(446600:506600),I_rms_Line3(446601:506601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(446600:506600),Ripple_Voltage(446601:506601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(446600:506600),Ripple_Line1(446601:506601),'Color','#C31E2D');
        hold on
        plot(time_5MS(446600:506600),Ripple_Line2(446601:506601),'Color','#2773C8');
        hold on
        plot(time_5MS(446600:506600),Ripple_Line3(446601:506601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(11165:12665);
        yyaxis left
        plot(time_200MS(11165:12665),RDF_total_V(11166:12666),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(11165:12665),RDF_total_L1(11166:12666),'Color','#C31E2D');
        hold on
        plot(time_200MS(11165:12665),RDF_total_L2(11166:12666),'Color','#2773C8');
        hold on
        plot(time_200MS(11165:12665),RDF_total_L3(11166:12666),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')    
figure(4)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(507600:710600),Urms_main(507601:710601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(507600:710600),I_mean_Line1(507601:710601),'Color','#C31E2D');
        hold on
        plot(time_5MS(507600:710600),I_mean_Line2(507601:710601),'Color','#2773C8');
        hold on
        plot(time_5MS(507600:710600),I_mean_Line3(507601:710601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(507600:710600),Urms_main(507601:710601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(507600:710600),I_rms_Line1(507601:710601),'Color','#C31E2D');
        hold on
        plot(time_5MS(507600:710600),I_rms_Line2(507601:710601),'Color','#2773C8');
        hold on
        plot(time_5MS(507600:710600),I_rms_Line3(507601:710601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(507600:710600),Ripple_Voltage(507601:710601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(507600:710600),Ripple_Line1(507601:710601),'Color','#C31E2D');
        hold on
        plot(time_5MS(507600:710600),Ripple_Line2(507601:710601),'Color','#2773C8');
        hold on
        plot(time_5MS(507600:710600),Ripple_Line3(507601:710601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(12690:17765);
        yyaxis left
        plot(time_200MS(12690:17765),RDF_total_V(12691:17766),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(12690:17765),RDF_total_L1(12691:17766),'Color','#C31E2D');
        hold on
        plot(time_200MS(12690:17765),RDF_total_L2(12691:17766),'Color','#2773C8');
        hold on
        plot(time_200MS(12690:17765),RDF_total_L3(12691:17766),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')      
figure(5)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(713600:770600),Urms_main(713601:770601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(713600:770600),I_mean_Line1(713601:770601),'Color','#C31E2D');
        hold on
        plot(time_5MS(713600:770600),I_mean_Line2(713601:770601),'Color','#2773C8');
        hold on
        plot(time_5MS(713600:770600),I_mean_Line3(713601:770601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(713600:770600),Urms_main(713601:770601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(713600:770600),I_rms_Line1(713601:770601),'Color','#C31E2D');
        hold on
        plot(time_5MS(713600:770600),I_rms_Line2(713601:770601),'Color','#2773C8');
        hold on
        plot(time_5MS(713600:770600),I_rms_Line3(713601:770601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(713600:770600),Ripple_Voltage(713601:770601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(713600:770600),Ripple_Line1(713601:770601),'Color','#C31E2D');
        hold on
        plot(time_5MS(713600:770600),Ripple_Line2(713601:770601),'Color','#2773C8');
        hold on
        plot(time_5MS(713600:770600),Ripple_Line3(713601:770601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(17840:19265);
        yyaxis left
        plot(time_200MS(17840:19265),RDF_total_V(17841:19266),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(17840:19265),RDF_total_L1(17841:19266),'Color','#C31E2D');
        hold on
        plot(time_200MS(17840:19265),RDF_total_L2(17841:19266),'Color','#2773C8');
        hold on
        plot(time_200MS(17840:19265),RDF_total_L3(17841:19266),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')     
figure(6)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(833000:844800),Urms_main(833001:844801),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(833000:844800),I_mean_Line1(833001:844801),'Color','#C31E2D');
        hold on
        plot(time_5MS(833000:844800),I_mean_Line2(833001:844801),'Color','#2773C8');
        hold on
        plot(time_5MS(833000:844800),I_mean_Line3(833001:844801),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(833000:844800),Urms_main(833001:844801),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(833000:844800),I_rms_Line1(833001:844801),'Color','#C31E2D');
        hold on
        plot(time_5MS(833000:844800),I_rms_Line2(833001:844801),'Color','#2773C8');
        hold on
        plot(time_5MS(833000:844800),I_rms_Line3(833001:844801),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(833000:844800),Ripple_Voltage(833001:844801),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(833000:844800),Ripple_Line1(833001:844801),'Color','#C31E2D');
        hold on
        plot(time_5MS(833000:844800),Ripple_Line2(833001:844801),'Color','#2773C8');
        hold on
        plot(time_5MS(833000:844800),Ripple_Line3(833001:844801),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(20825:21120);
        yyaxis left
        plot(time_200MS(20825:21120),RDF_total_V(20826:21121),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(20825:21120),RDF_total_L1(20826:21121),'Color','#C31E2D');
        hold on
        plot(time_200MS(20825:21120),RDF_total_L2(20826:21121),'Color','#2773C8');
        hold on
        plot(time_200MS(20825:21120),RDF_total_L3(20826:21121),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')       
figure(7)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(845600:854600),Urms_main(845601:854601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(845600:854600),I_mean_Line1(845601:854601),'Color','#C31E2D');
        hold on
        plot(time_5MS(845600:854600),I_mean_Line2(845601:854601),'Color','#2773C8');
        hold on
        plot(time_5MS(845600:854600),I_mean_Line3(845601:854601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(845600:854600),Urms_main(845601:854601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(845600:854600),I_rms_Line1(845601:854601),'Color','#C31E2D');
        hold on
        plot(time_5MS(845600:854600),I_rms_Line2(845601:854601),'Color','#2773C8');
        hold on
        plot(time_5MS(845600:854600),I_rms_Line3(845601:854601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(845600:854600),Ripple_Voltage(845601:854601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(845600:854600),Ripple_Line1(845601:854601),'Color','#C31E2D');
        hold on
        plot(time_5MS(845600:854600),Ripple_Line2(845601:854601),'Color','#2773C8');
        hold on
        plot(time_5MS(845600:854600),Ripple_Line3(845601:854601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(21140:21365);
        yyaxis left
        plot(time_200MS(21140:21365),RDF_total_V(21141:21366),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(21140:21365),RDF_total_L1(21141:21366),'Color','#C31E2D');
        hold on
        plot(time_200MS(21140:21365),RDF_total_L2(21141:21366),'Color','#2773C8');
        hold on
        plot(time_200MS(21140:21365),RDF_total_L3(21141:21366),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off
        title('RDF')   
figure(8)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(857600:866600),Urms_main(857601:866601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(857600:866600),I_mean_Line1(857601:866601),'Color','#C31E2D');
        hold on
        plot(time_5MS(857600:866600),I_mean_Line2(857601:866601),'Color','#2773C8');
        hold on
        plot(time_5MS(857600:866600),I_mean_Line3(857601:866601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(857600:866600),Urms_main(857601:866601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(857600:866600),I_rms_Line1(857601:866601),'Color','#C31E2D');
        hold on
        plot(time_5MS(857600:866600),I_rms_Line2(857601:866601),'Color','#2773C8');
        hold on
        plot(time_5MS(857600:866600),I_rms_Line3(857601:866601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(857600:866600),Ripple_Voltage(857601:866601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(857600:866600),Ripple_Line1(857601:866601),'Color','#C31E2D');
        hold on
        plot(time_5MS(857600:866600),Ripple_Line2(857601:866601),'Color','#2773C8');
        hold on
        plot(time_5MS(857600:866600),Ripple_Line3(857601:866601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(21400:21665);
        yyaxis left
        plot(time_200MS(21400:21665),RDF_total_V(21401:21666),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(21400:21665),RDF_total_L1(21401:21666),'Color','#C31E2D');
        hold on
        plot(time_200MS(21400:21665),RDF_total_L2(21401:21666),'Color','#2773C8');
        hold on
        plot(time_200MS(21400:21665),RDF_total_L3(21401:21666),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')       
figure(9)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(870400:920600),Urms_main(870401:920601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(870400:920600),I_mean_Line1(870401:920601),'Color','#C31E2D');
        hold on
        plot(time_5MS(870400:920600),I_mean_Line2(870401:920601),'Color','#2773C8');
        hold on
        plot(time_5MS(870400:920600),I_mean_Line3(870401:920601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(870400:920600),Urms_main(870401:920601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(870400:920600),I_rms_Line1(870401:920601),'Color','#C31E2D');
        hold on
        plot(time_5MS(870400:920600),I_rms_Line2(870401:920601),'Color','#2773C8');
        hold on
        plot(time_5MS(870400:920600),I_rms_Line3(870401:920601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(870400:920600),Ripple_Voltage(870401:920601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(870400:920600),Ripple_Line1(870401:920601),'Color','#C31E2D');
        hold on
        plot(time_5MS(870400:920600),Ripple_Line2(870401:920601),'Color','#2773C8');
        hold on
        plot(time_5MS(870400:920600),Ripple_Line3(870401:920601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(21760:23015);
        yyaxis left
        plot(time_200MS(21760:23015),RDF_total_V(21761:23016),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(21760:23015),RDF_total_L1(21761:23016),'Color','#C31E2D');
        hold on
        plot(time_200MS(21760:23015),RDF_total_L2(21761:23016),'Color','#2773C8');
        hold on
        plot(time_200MS(21760:23015),RDF_total_L3(21761:23016),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')    
figure(10)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(926600:968600),Urms_main(926601:968601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(926600:968600),I_mean_Line1(926601:968601),'Color','#C31E2D');
        hold on
        plot(time_5MS(926600:968600),I_mean_Line2(926601:968601),'Color','#2773C8');
        hold on
        plot(time_5MS(926600:968600),I_mean_Line3(926601:968601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(926600:968600),Urms_main(926601:968601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(926600:968600),I_rms_Line1(926601:968601),'Color','#C31E2D');
        hold on
        plot(time_5MS(926600:968600),I_rms_Line2(926601:968601),'Color','#2773C8');
        hold on
        plot(time_5MS(926600:968600),I_rms_Line3(926601:968601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(926600:968600),Ripple_Voltage(926601:968601),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(926600:968600),Ripple_Line1(926601:968601),'Color','#C31E2D');
        hold on
        plot(time_5MS(926600:968600),Ripple_Line2(926601:968601),'Color','#2773C8');
        hold on
        plot(time_5MS(926600:968600),Ripple_Line3(926601:968601),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(23165:24215);
        yyaxis left
        plot(time_200MS(23165:24215),RDF_total_V(23166:24216),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(23165:24215),RDF_total_L1(23166:24216),'Color','#C31E2D');
        hold on
        plot(time_200MS(23165:24215),RDF_total_L2(23166:24216),'Color','#2773C8');
        hold on
        plot(time_200MS(23165:24215),RDF_total_L3(23166:24216),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')      
figure(11)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(984600:995200),Urms_main(984601:995201),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(984600:995200),I_mean_Line1(984601:995201),'Color','#C31E2D');
        hold on
        plot(time_5MS(984600:995200),I_mean_Line2(984601:995201),'Color','#2773C8');
        hold on
        plot(time_5MS(984600:995200),I_mean_Line3(984601:995201),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(984600:995200),Urms_main(984601:995201),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(984600:995200),I_rms_Line1(984601:995201),'Color','#C31E2D');
        hold on
        plot(time_5MS(984600:995200),I_rms_Line2(984601:995201),'Color','#2773C8');
        hold on
        plot(time_5MS(984600:995200),I_rms_Line3(984601:995201),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(984600:995200),Ripple_Voltage(984601:995201),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(984600:995200),Ripple_Line1(984601:995201),'Color','#C31E2D');
        hold on
        plot(time_5MS(984600:995200),Ripple_Line2(984601:995201),'Color','#2773C8');
        hold on
        plot(time_5MS(984600:995200),Ripple_Line3(984601:995201),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(24615:24880);
        yyaxis left
        plot(time_200MS(24615:24880),RDF_total_V(24616:24881),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(24615:24880),RDF_total_L1(24616:24881),'Color','#C31E2D');
        hold on
        plot(time_200MS(24615:24880),RDF_total_L2(24616:24881),'Color','#2773C8');
        hold on
        plot(time_200MS(24615:24880),RDF_total_L3(24616:24881),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')   
figure(12)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(1007000:1062000),Urms_main(1007001:1062001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1007000:1062000),I_mean_Line1(1007001:1062001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1007000:1062000),I_mean_Line2(1007001:1062001),'Color','#2773C8');
        hold on
        plot(time_5MS(1007000:1062000),I_mean_Line3(1007001:1062001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(1007000:1062000),Urms_main(1007001:1062001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1007000:1062000),I_rms_Line1(1007001:1062001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1007000:1062000),I_rms_Line2(1007001:1062001),'Color','#2773C8');
        hold on
        plot(time_5MS(1007000:1062000),I_rms_Line3(1007001:1062001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(1007000:1062000),Ripple_Voltage(1007001:1062001),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1007000:1062000),Ripple_Line1(1007001:1062001),'Color','#C31E2D');
        hold on
        plot(time_5MS(1007000:1062000),Ripple_Line2(1007001:1062001),'Color','#2773C8');
        hold on
        plot(time_5MS(1007000:1062000),Ripple_Line3(1007001:1062001),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(25175:26550);
        yyaxis left
        plot(time_200MS(25175:26550),RDF_total_V(25176:26551),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(25175:26550),RDF_total_L1(25176:26551),'Color','#C31E2D');
        hold on
        plot(time_200MS(25175:26550),RDF_total_L2(25176:26551),'Color','#2773C8');
        hold on
        plot(time_200MS(25175:26550),RDF_total_L3(25176:26551),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')      
figure(13)
    subplot(2,2,1)

        yyaxis left
        plot(time_5MS(1274600:end),Urms_main(1274601:end),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1274600:end),I_mean_Line1(1274601:end),'Color','#C31E2D');
        hold on
        plot(time_5MS(1274600:end),I_mean_Line2(1274601:end),'Color','#2773C8');
        hold on
        plot(time_5MS(1274600:end),I_mean_Line3(1274601:end),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Average')
    subplot(2,2,2)
        yyaxis left
        plot(time_5MS(1274600:end),Urms_main(1274601:end),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1274600:end),I_rms_Line1(1274601:end),'Color','#C31E2D');
        hold on
        plot(time_5MS(1274600:end),I_rms_Line2(1274601:end),'Color','#2773C8');
        hold on
        plot(time_5MS(1274600:end),I_rms_Line3(1274601:end),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RMS')
    subplot(2,2,3)
        yyaxis left
        plot(time_5MS(1274600:end),Ripple_Voltage(1274601:end),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_5MS(1274600:end),Ripple_Line1(1274601:end),'Color','#C31E2D');
        hold on
        plot(time_5MS(1274600:end),Ripple_Line2(1274601:end),'Color','#2773C8');
        hold on
        plot(time_5MS(1274600:end),Ripple_Line3(1274601:end),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('Ripple')    
    subplot(2,2,4)
        time = time_200MS(31865:end);
        yyaxis left
        plot(time_200MS(31865:end),RDF_total_V(31866:end),'Color','#633736');
        ylabel('V')
        yyaxis right
        plot(time_200MS(31865:end),RDF_total_L1(31866:end),'Color','#C31E2D');
        hold on
        plot(time_200MS(31865:end),RDF_total_L2(31866:end),'Color','#2773C8');
        hold on
        plot(time_200MS(31865:end),RDF_total_L3(31866:end),'Color','#9CC38A');
        ylabel('A')
        xlabel('time')         
        legend('Voltage','Line 1','Line 2','Line 3');
        hold off

        title('RDF')      