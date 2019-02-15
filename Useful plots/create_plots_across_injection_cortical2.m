load('D:\Rat_055\Whisker All\Protocol\Protocol_cortex.mat');
load('D:\Rat_055\Whisker All\Processed Data\EIT_cortex_all.mat');

bad = [];
load('chns_cortex.mat');

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


Protocol_map = Protocol;

% for iPrt = 1:size(Protocol,1)
%     for jPrt = 1:size(Protocol,2)
%         Protocol_map(iPrt,jPrt) = find(Protocol(iPrt,jPrt)==chns_probe1_inv);
%     end
% end

inj_data = NaN(size(EIT_avg{1,1}.dZ_avg,1),1);
inj_data2 = zeros(size(EIT_avg{1,1}.dZ_avg,1),1);


all_chn = chns_cortex2+32;


for m = 1:length(Protocol_map)
    for i = [2,6:7,10:12,14:16,18:28]
        if ismember(all_chn(i),(Protocol_map(m,:))) 
            dZ_all{1,all_chn(i)}(:,m) = inj_data;
            EP_all{1,all_chn(i)}(:,m) = inj_data;
%           elseif m == 12
%               dZ_all{1,all_chn(i)}(:,m) = inj_data;
%               EP_all{1,all_chn(i)}(:,m) = inj_data;
        else
            dZ_all{1,all_chn(i)}(:,m) = EIT_avg{1,m}.dZ_avg(:,all_chn(i));
            EP_all{1,all_chn(i)}(:,m) = EIT_avg{1,m}.EP_avg(:,all_chn(i));
        end
    end
end

%%
figure('Position',[200,100,750,850]);
ha = tight_subplot(7,4,[.02 .02],[.08 .03],[.08 .03]);

for i = [2,6:7,10:12,14:16,18:28]
     axes(ha(i));
     hold on;
     idx = find(std(dZ_all{1,all_chn(i)},0,1) < 0.75);
    if ismember(all_chn(i), bad)
         plot(T,inj_data2, 'k', 'LineWidth', 2);
       
        %title('8 Shunt Whisker Backward 2.5uA');
    else 
            plot(T,dZ_all{1,all_chn(i)}(:,idx), 'Color', [0.8,0,0]);
            plot(T,nanmean(dZ_all{1,all_chn(i)}(:,idx),2), 'k', 'LineWidth', 2);
           
        end
    
    hold off
     %ylim([-1,1]);
     ylim([-10,10]);
     xlim([-10,100]);
     
      if i ~= [25]
         set(ha(i),'XTickLabel','');
         set(ha(i),'YTickLabel','');
         
      end
     
    if i == 25
         ylabel('dZ/uV');
         xlabel('T/ms');
    end
    
 for i = [1,3:5,8:9,13,17]
    axes(ha(i))
    axis off
    end
    
    
    set(gca,'FontSize', 12);
end

%%
%print(gcf,'Whisker_cortex1_dZ_T.png','-dpng','-r500');
%print(gcf,'8shunt_whisker_EIT_002_backward_dZ.pdf','-dpdf','-r500');

%%
figure('Position',[200,100,750,850]);
ha = tight_subplot(7,4,[.02 .02],[.08 .03],[.08 .03]);

for i = [2,6:7,10:12,14:16,18:28]
     axes(ha(i));
     hold on;
    if ismember(all_chn(i), bad)
        plot(T,inj_data2, 'k', 'LineWidth', 2);
        %title('8 Shunt Whisker Backward 2.5uA');
    else 
            plot(T,EP_all{1,all_chn(i)}, 'Color', [0.8,0,0]);
            plot(T,nanmean(EP_all{1,all_chn(i)},2), 'k', 'LineWidth', 2);
        end
    
    hold off
     %ylim([-1,1]);
     ylim([-500,500]);
     xlim([-10,100]);
     
      if i ~= [25]
         set(ha(i),'XTickLabel','');
         set(ha(i),'YTickLabel','');
      end
     
    if i == 25
         ylabel('dZ/uV');
         xlabel('T/ms');
    end
    
    
    for i = [1,3:5,8:9,13,17]
    axes(ha(i))
    axis off
    end
    
    
    set(gca,'FontSize', 12);
end
%%
%print(gcf,'Whisker_cortex1_EP_T.png','-dpng','-r500');
%print(gcf,'8shunt_whisker_EIT_002_backward_EP.pdf','-dpdf','-r500');

