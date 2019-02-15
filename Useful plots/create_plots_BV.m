load('D:\Rat_055\Whisker All\Protocol\Protocol_depth.mat');
load('D:\Rat_055\Whisker All\Processed Data\EIT_depth_all.mat');

bad = [];
load('chns_matlab.mat');

for iPrt = 1:size(Protocol,1)
    for jPrt = 1:size(Protocol,2)
        Protocol_map(iPrt,jPrt) = find(Protocol(iPrt,jPrt)==chns_probe1_inv);
    end
end

inj_data = NaN(size(EIT_avg{1,1}.dZ_avg,1),1);
inj_data2 = zeros(size(EIT_avg{1,1}.dZ_avg,1),1);

all_chn = [chns_probe1, (chns_probe2)];
%%
for m = 1%:size(Protocol,1)
figure('Position',[200,100,750,850]);
ha = tight_subplot(8,4,[.04 .02],[.03 .03],[.03 .03]);
for i = 1:32
    
    axes(ha(i));
    if ismember(all_chn(i),(Protocol_map(m,:))) 
       bar(EIT_avg{1,m}.BV0(all_chn(i),1)/1000, 'r');
       title(['BV = ' num2str(round((EIT_avg{1,m}.BV0(all_chn(i),1)/1e3),2))]);

    elseif ismember(all_chn(i), bad)
        plot(T,inj_data, 'k', 'LineWidth', 2);
        title(['4 Shunt Forepaw BV Inj ' num2str(m)]);
    else
        bar(EIT_avg{1,m}.BV0(all_chn(i),1)/1000);
        title(['BV = ' num2str(round((EIT_avg{1,m}.BV0(all_chn(i),1)/1e3),2))]);

    end
    %ylim([0,20])
    ylim([0,5])
    
    if i ~= 29
        
         set(gca,'XTick',[]);
         set(gca,'YTick',[]);
    end
    
    if i == 29
        set(gca, 'Xtick', []);
        ylabel('BV/mV');
    end

    daspect([0.2,1,1]);
    
    set(gca,'color','none')
     set(gca,'FontSize', 12);
   
end
%print(gcf,['4shunt_whisker_EIT_001_BV_inj' num2str(m) '.png'],'-dpng','-r500');
end