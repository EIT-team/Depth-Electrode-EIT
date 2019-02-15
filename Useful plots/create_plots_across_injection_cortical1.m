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


bad = [];

inj_data = NaN(size(EIT_avg{1,1}.dZ_avg,1),1);
inj_data2 = zeros(size(EIT_avg{1,1}.dZ_avg,1),1);

all_chn = chns_cortex1;


for m = 1:length(Protocol_map)
    for i = [1:3,6:9,11:30]
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
ha = tight_subplot(6,5,[.02 .02],[.08 .03],[.08 .03]);

for i = [1:3,6:9,11:30]
     axes(ha(i));
     hold on;
     idx = find(std(dZ_all{1,all_chn(i)},0,1) < 2);
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
    %xlim([-30,150]);
     xlim([-10,60]);
     
      if i ~= [26]
         set(ha(i),'XTickLabel','');
         set(ha(i),'YTickLabel','');
         
      end
     
    if i == 26
         ylabel('dZ/uV');
         xlabel('T/ms');
    end
    
    axes(ha(4))
    axis off
    axes(ha(5))
    axis off
    axes(ha(10))
    axis off
    
    
    set(gca,'FontSize', 12);
end

%%
%print(gcf,'Whisker_all_dZ.png','-dpng','-r500');
%print(gcf,'8shunt_whisker_EIT_002_backward_dZ.pdf','-dpdf','-r500');

%%
figure('Position',[200,100,750,850]);
ha = tight_subplot(6,5,[.02 .02],[.08 .03],[.08 .03]);

for i = [1:3,6:9,11:30]
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
    %xlim([-30,150]);
     xlim([-10,60]);
     
      if i ~= [26]
         set(ha(i),'XTickLabel','');
         set(ha(i),'YTickLabel','');
      end
     
    if i == 26
         ylabel('EP/uV');
         xlabel('T/ms');
    end
    
    axes(ha(4))
    axis off
    axes(ha(5))
    axis off
    axes(ha(10))
    axis off
    
    
    set(gca,'FontSize', 12);
end
%%
%print(gcf,'Whisker_cortex2_EP_T.png','-dpng','-r500');
%print(gcf,'8shunt_whisker_EIT_002_backward_EP.pdf','-dpdf','-r500');

