load('D:\Rat_055\Whisker All\Protocol\Protocol_depth.mat');
load('D:\Rat_055\Whisker All\Processed Data\EIT_depth_all.mat');

bad = [];
load('chns_matlab.mat');

%With actichamp
%Fs = 50000;
% T = [1:50000]-50000/2;
% %T = [1:25000]-25000/2;
% T = T./25000;
% T = T*1e3;

%With biosemi
Fs = 16384;
%T = [1:16384]-16384/2;
T = [1:16417]-16417/2;
T = T./Fs;
T = T*1e3;


for iPrt = 1:size(Protocol,1)
    for jPrt = 1:size(Protocol,2)
        Protocol_map(iPrt,jPrt) = find(Protocol(iPrt,jPrt)==chns_probe1_inv);
    end
end

inj_data = NaN(size(EIT_avg{1,1}.dZ_avg,1),1);
inj_data2 = zeros(size(EIT_avg{1,1}.dZ_avg,1),1);

all_chn = [chns_probe1, (chns_probe2)];

%%
for i = 1:16
figure('Position',[200,100,1450,850]);

%%Rat_050
% ha = tight_subplot(4,7,[.04 .02],[.06 .03],[.06 .03]);
% dZ_pos = [1,2,3,8,9,10,15,16,17,22,23,24];
% EP_pos = [5,6,7,12,13,14,19,20,21,26,27,28];

%%Rat_052
ha = tight_subplot(4,11,[.04 .02],[.06 .03],[.06 .03]);
dZ_pos = [1,2,3,4,5,12,13,14,15,16,23,24,25,26,27,34,35,36,37,38];
EP_pos = [7,8,9,10,11,18,19,20,21,22,29,30,31,32,33,40,41,42,43,44];


    for j = 1:20%size(Protocol,1)
     axes(ha(dZ_pos(j)));
     hold on;
     if ismember(all_chn(i), Protocol_map(j,:))
           plot(T,inj_data2, 'r', 'LineWidth', 2);
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     else
            plot(T,EIT_avg{1,j}.dZ_avg(:,all_chn(i)), 'Color', [0,0.5,0.5]);
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     end
     hold off
     ylim([-5,5]);
     xlim([-10,50]);
     
    %if j ~= [10]
    if j ~= [16]
         set(ha(dZ_pos(j)),'XTickLabel','');
         set(ha(dZ_pos(j)),'YTickLabel','');
      end
     
    %if j == 10
    if j == [16]
         ylabel('dZ/uV', 'FontSize', 12);
         xlabel('T/ms', 'FontSize', 12);
    end
    %set(gca,'FontSize', 10);
     
      axes(ha(EP_pos(j)));
          hold on;
     if ismember(all_chn(i), Protocol_map(j,:))
            plot(T,inj_data2, 'r', 'LineWidth', 2);
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     else
            plot(T,EIT_avg{1,j}.EP_avg(:,all_chn(i)), 'Color', [0.8,0,0.8]);
           
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
    end    
    hold off
     ylim([-100,150]);
     xlim([-10,50]);
     
      %if j ~= [10]
      if j ~= [16]
         set(ha(EP_pos(j)),'XTickLabel','');
         set(ha(EP_pos(j)),'YTickLabel','');
      end
     
    %if j == 10
    if j == [16]
         ylabel('EP/uV','FontSize', 12);
         xlabel('T/ms','FontSize', 12);
    end
    %set(gca,'FontSize', 10);
    end
    
    %axes(ha(4))
    axes(ha(6))
    axis off
    title(['Probe 1 Chn ' num2str(chns_probe1_inv(all_chn(i)))], 'FontSize', 12);
    %axes(ha(11))
    axes(ha(17))
    axis off
    %axes(ha(18))
    axes(ha(28))
    axis off
    %axes(ha(25))
    axes(ha(39))
    axis off

    
%print(gcf,['Whisker_all_probe1_chn' num2str(chns_probe1_inv(all_chn(i))) '.png'],'-dpng','-r500');
%close all
end

%%
for i = 17:32
figure('Position',[200,100,1450,850]);

%Rat_050
% ha = tight_subplot(4,7,[.04 .02],[.06 .03],[.06 .03]);
% dZ_pos = [1,2,3,8,9,10,15,16,17,22,23,24];
% EP_pos = [5,6,7,12,13,14,19,20,21,26,27,28];

%%Rat_052
ha = tight_subplot(4,11,[.04 .02],[.06 .03],[.06 .03]);
dZ_pos = [1,2,3,4,5,12,13,14,15,16,23,24,25,26,27,34,35,36,37,38];
EP_pos = [7,8,9,10,11,18,19,20,21,22,29,30,31,32,33,40,41,42,43,44];


    for j = 1:20
     axes(ha(dZ_pos(j)));
     hold on;
     if ismember(all_chn(i), Protocol_map(j,:))
            plot(T,inj_data2, 'r', 'LineWidth', 2);
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     else
            plot(T,EIT_avg{1,j}.dZ_avg(:,all_chn(i)), 'Color', [0.8,0,0]);
         title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     end
     hold off
     ylim([-15,15]);
     xlim([-10,50]);
     
    %if j ~= [10]
    if j ~= [16]
         set(ha(dZ_pos(j)),'XTickLabel','');
         set(ha(dZ_pos(j)),'YTickLabel','');
      end
     
    %if j == 10
    if j == [16]
         ylabel('dZ/uV', 'FontSize', 12);
         xlabel('T/ms', 'FontSize', 12);
    end
    %set(gca,'FontSize', 10);
     
      axes(ha(EP_pos(j)));
          hold on;
    if ismember(all_chn(i), Protocol_map(j,:))
            plot(T,inj_data2, 'r', 'LineWidth', 2);
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     else
            plot(T,EIT_avg{1,j}.EP_avg(:,all_chn(i)), 'Color', [0,0,0.8]);
          
            title(['Inj ' num2str(j) '  BV = ' num2str(round((EIT_avg{1,j}.BV0(all_chn(i),1)/1e3),2))],'FontSize', 10);
     end    
    hold off
     ylim([-100,100]);
     xlim([-10,50]);
     
      %if j ~= [10]
      if j ~= [16]
         set(ha(EP_pos(j)),'XTickLabel','');
         set(ha(EP_pos(j)),'YTickLabel','');
      end
     
    %if j == 10
    if j == [16]
         ylabel('EP/uV','FontSize', 12);
         xlabel('T/ms','FontSize', 12);
    end
    %set(gca,'FontSize', 10);
    end
    
     
    %axes(ha(4))
    axes(ha(6))
    axis off
    title(['Probe 2 Chn ' num2str(chns_probe1_inv(all_chn(i))-32)], 'FontSize', 12);
    %axes(ha(11))
    axes(ha(17))
    axis off
    %axes(ha(18))
    axes(ha(28))
    axis off
    %axes(ha(25))
    axes(ha(39))
    axis off

    
%print(gcf,['Whisker_all_probe2_chn' num2str(chns_probe1_inv(all_chn(i))-32) '.png'],'-dpng','-r500');
%close all
end

