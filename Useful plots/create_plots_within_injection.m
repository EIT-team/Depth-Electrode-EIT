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
for n = 1%:size(Protocol,1)
clear dZ_all EP_all

%%
figure('Position',[200,100,1450,850]);
ha = tight_subplot(4,9,[.04 .02],[.06 .03],[.06 .03]);
dZ_pos = [1,2,3,4,10,11,12,13,19,20,21,22,28,29,30,31];
EP_pos = [6,7,8,9,15,16,17,18,24,25,26,27,33,34,35,36];                 

for i = 1:16
    axes(ha(dZ_pos(i)));
    hold on;
    if ismember(all_chn(i), bad)
        plot(T,inj_data2, 'k', 'LineWidth', 2);
    elseif ismember(all_chn(i), Protocol_map(n,:))
        plot(T,inj_data2, 'r', 'LineWidth', 2);
        title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
    else
            plot(T,EIT_avg{1,n}.dZ_avg(:,all_chn(i)), 'Color', [0,0.5,0.5]);
            title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);

     end
    hold off
      ylim([-15,15]);
       xlim([-10,90]);
     
      if i ~= [13]
         set(ha(dZ_pos(i)),'XTickLabel','');
         set(ha(dZ_pos(i)),'YTickLabel','');
      end
     
    if i == 13
         ylabel('dZ/uV');
         xlabel('T/ms');
    end
    set(gca,'FontSize', 12);
    
    
    axes(ha(EP_pos(i)));
    hold on;
    if ismember(all_chn(i), bad)
        plot(T,inj_data2, 'k', 'LineWidth', 2);
        title(['Inj = ' num2str(n)]);
    elseif ismember(all_chn(i), Protocol_map(n,:))
        plot(T,inj_data2, 'r', 'LineWidth', 2);
        title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
    else
            
            plot(T,EIT_avg{1,n}.EP_avg(:,all_chn(i)), 'Color', [0.8,0,0.8]);
            %plot(T,nanmean(EP_all{1,all_chn(i)},2), 'k', 'LineWidth', 2);
            title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);

     end
    hold off
      ylim([-100,100]);
       xlim([-10,90]);
     
      if i ~= [13]
         set(ha(EP_pos(i)),'XTickLabel','');
         set(ha(EP_pos(i)),'YTickLabel','');
      end
     
    if i == 13
         ylabel('EP/uV');
         xlabel('T/ms');
    end
    set(gca,'FontSize', 12);
    
    axes(ha(5))
    title(['Probe 1 Inj = ' num2str(n)], 'FontSize', 16);
    axis off
    axes(ha(14))
    axis off
    axes(ha(23))
    axis off
    axes(ha(32))
    axis off
    
    
end
%print(gcf,['4shunt_forepaw_EIT_002_probe1_inj' num2str(n) '.png'],'-dpng','-r500');



%%
figure('Position',[200,100,1450,850]);
ha = tight_subplot(4,9,[.04 .02],[.06 .03],[.06 .03]);
dZ_pos = [1,2,3,4,10,11,12,13,19,20,21,22,28,29,30,31];
EP_pos = [6,7,8,9,15,16,17,18,24,25,26,27,33,34,35,36];                 

for i = 17:32
    axes(ha(dZ_pos(i-16)));
    hold on;
    if ismember(all_chn(i), bad)
        plot(T,inj_data2, 'k', 'LineWidth', 2);
        title(['Inj = ' num2str(n)]);
    elseif ismember(all_chn(i), Protocol_map(n,:))
        plot(T,inj_data2, 'r', 'LineWidth', 2);
        title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
    else
         
            plot(T,EIT_avg{1,n}.dZ_avg(:,all_chn(i)), 'Color', [0.8,0,0]);
            title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
      
     end
    hold off
      ylim([-15,15]);
       xlim([-10,90]);
     
      if i-16 ~= [13]
         set(ha(dZ_pos(i-16)),'XTickLabel','');
         set(ha(dZ_pos(i-16)),'YTickLabel','');
      end
     
    if i-16 == 13
         ylabel('dZ/uV');
         xlabel('T/ms');
    end
    set(gca,'FontSize', 12);
    
    
    axes(ha(EP_pos(i-16)));
    hold on;
    if ismember(all_chn(i), bad)
        plot(T,inj_data2, 'k', 'LineWidth', 2);
        title(['Inj = ' num2str(n)]);
    elseif ismember(all_chn(i), Protocol_map(n,:))
        plot(T,inj_data2, 'r', 'LineWidth', 2);
        title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
    else
            plot(T,EIT_avg{1,n}.EP_avg(:,all_chn(i)), 'Color', [0,0,0.8]);
            
            title(['BV = ' num2str(round((EIT_avg{1,n}.BV0(all_chn(i),1)/1e3),2))]);
    end
    hold off
    ylim([-100,100]);
       xlim([-10,90]);
     
      if i-16 ~= [13]
         set(ha(EP_pos(i-16)),'XTickLabel','');
         set(ha(EP_pos(i-16)),'YTickLabel','');
      end
     
    if i-16 == 13
         ylabel('EP/uV');
         xlabel('T/ms');
    end
    set(gca,'FontSize', 12);
    
    axes(ha(5))
    title(['Probe 2 Inj = ' num2str(n)], 'FontSize', 16);
    axis off
    axes(ha(14))
    axis off
    axes(ha(23))
    axis off
    axes(ha(32))
    axis off
    
    
end
%print(gcf,['4shunt_forepaw_EIT_002_probe2_inj' num2str(n) '.png'],'-dpng','-r500');
%%
end


