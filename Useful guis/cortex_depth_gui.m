

function [S] = cortex_depth_gui(ABS, info)

S.fh = figure('units','normalized', 'Position', [0.05 0 0.95 0.9],'name','slider_plot');

% Define axes so that room is available in figure window for sliders           
S.ax1 = axes('unit','normalized', 'position',[0.0 0.5 0.35 0.4]); 
%trimesh(S.srf_d(S.idx_d,:), S.nodes_d(:,1), S.nodes_d(:,2), S.nodes_d(:,3), -200*ones(size(S.nodes_d,1),1));      
S.ax1.View = [0 0];
% S.ax1.XLim = [S.orig_d(1) - S.zdef_d, S.orig_d(1) + S.zdef_d]; 
% S.ax1.YLim = [S.orig_d(2) - S.zdef_d, S.orig_d(2) + S.zdef_d]; 
% S.ax1.ZLim = [S.orig_d(3) - S.zdef_d, S.orig_d(3) + S.zdef_d];
% daspect([1,1,1])

%N.B siwtch around y and z axis to make it so it appears in right direction           
S.ax2 = axes('unit','normalized', 'position',[0.0 0.05 0.35 0.4]); 
%trimesh(S.srf_d(S.idx_d,:), S.nodes_d(:,1), S.nodes_d(:,3), S.nodes_d(:,2), -200*ones(size(S.nodes_d,1),1));  
S.ax2.View = [90 0];
% S.ax2.XLim = [S.orig_d(1) - S.zdef_d, S.orig_d(1) + S.zdef_d]; 
% S.ax2.YLim = [S.orig_d(3) - S.zdef_d, S.orig_d(3) + S.zdef_d]; 
% 
% S.ax2.ZLim = [S.orig_d(2) - S.zdef_d, S.orig_d(2) + S.zdef_d];
% daspect([1,1,1])



S.ax3 = axes('unit','normalized','position',[0.45 0.5 0.35 0.4]);
%trimesh(S.srf_c(S.idx_c,:), S.nodes_c(:,1), S.nodes_c(:,2), S.nodes_c(:,3), -200*ones(size(S.nodes_c,1),1));    
S.ax3.View = [0 -86];
% S.ax3.XLim = [S.orig_c(1) - S.zdef_c, S.orig_c(1) + S.zdef_c]; 
% S.ax3.YLim = [S.orig_c(2) - S.zdef_c, S.orig_c(2) + S.zdef_c]; 
% S.ax3.ZLim = [S.orig_c(3) - S.zdef_c, S.orig_c(3) + S.zdef_c]; 
% daspect([1,1,1])
            
S.ax4 = axes('unit','normalized','position',[0.45 0.05 0.35 0.4]);
%trimesh(S.srf_c(S.idx_c,:), S.nodes_c(:,1), S.nodes_c(:,3), S.nodes_c(:,2), -200*ones(size(S.nodes_c,1),1));    
S.ax4.View = [-180 15];
% S.ax4.XLim = [S.orig_c(1) - S.zdef_c, S.orig_c(1) + S.zdef_c]; 
% S.ax4.YLim = [S.orig_c(3) - S.zdef_c, S.orig_c(3) + S.zdef_c]; 
% S.ax4.ZLim = [S.orig_c(2) - S.zdef_c, S.orig_c(2) + S.zdef_c]; 
% daspect([1,1,1])

S.view1 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.3 0.71 0.08 0.03],...
                   'String', ['Original View'],... 
                   'FontSize', 11,'FontWeight','bold',...
                   'Callback', 'S.ax1.View = [0 0]; S.zSlider1.Value = 70; S.ax1.XLim = [S.orig_d(1) - S.zdef_d, S.orig_d(1) + S.zdef_d]; S.ax1.YLim = [S.orig_d(2) - S.zdef_d, S.orig_d(2) + S.zdef_d]; S.ax1.ZLim = [S.orig_d(3) - S.zdef_d, S.orig_d(3) + S.zdef_d];');   

 S.view2 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.3 0.26 0.08 0.03],...
                   'String', ['Original View'],...
                   'FontSize', 11,'FontWeight','bold',...
                   'Callback', 'S.ax2.View = [90 0]; S.zSlider2.Value = 70; S.ax2.XLim = [S.orig_d(1) - S.zdef_d, S.orig_d(1) + S.zdef_d]; S.ax2.YLim = [-1*S.orig_d(3) - S.zdef_d, -1*S.orig_d(3) + S.zdef_d]; S.ax2.ZLim = [-1*S.orig_d(2) - S.zdef_d, -1*S.orig_d(2) + S.zdef_d];');
               
S.view3 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.75 0.71 0.08 0.03],...
                   'String', ['Original View'],...
                   'FontSize', 11,'FontWeight','bold',...
                   'Callback', 'S.ax3.View = [0 -86]; S.zSlider3.Value = 75; S.ax3.XLim = [S.orig_c(1) - S.zdef_c, S.orig_c(1) + S.zdef_c]; S.ax3.YLim = [S.orig_c(2) - S.zdef_c, S.orig_c(2) + S.zdef_c]; S.ax3.ZLim = [S.orig_c(3) - S.zdef_c, S.orig_c(3) + S.zdef_c];');
               
S.view4 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.75 0.26 0.08 0.03],...
                   'String', ['Original View'],...
                   'FontSize', 11,'FontWeight','bold',...
                   'Callback', 'S.ax4.View = [-180 15]; S.zSlider4.Value = 60; S.ax4.XLim = [S.orig_a(3) - S.zdef_a, S.orig_a(3) + S.zdef_a]; S.ax4.YLim = [S.orig_a(2) - S.zdef_a, S.orig_a(2) + S.zdef_a]; S.ax4.ZLim = [S.orig_a(1) - S.zdef_a, S.orig_a(1) + S.zdef_a];');

               
S.zdef_d = (100-70)/10000;
S.zdef_c = (100-75)/10000;
S.zdef_a = (100-60)/10000;    

min_zoom = 0;
max_zoom = 80;
steps_zoom = (max_zoom - min_zoom);
S.z1 = 70; %N.B. this goes in opposite direction
S.z2 = 70;
S.z3 = 75;
S.z4 = 60;


S.zSlider1 = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.3 0.61 0.08 0.03],...
                      'min',min_zoom,'max',max_zoom,'value', S.z1,...
                      'sliderstep',[1,1]/steps_zoom,...
                      'callback', {@SliderCB, 'z1'});
                  
S.txtzSlider1 = uicontrol('style','text',...
                         'unit','normalized',...
                         'position',[0.3 0.64 0.08 0.03],...
                         'String', 'Zoom',...  
                         'FontSize', 11,'FontWeight','bold');
                     
S.zSlider2 = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.3 0.16 0.08 0.03],...
                      'min',min_zoom,'max',max_zoom,'value', S.z2,...
                      'sliderstep',[1,1]/steps_zoom,...
                      'callback', {@SliderCB, 'z2'});
                  
S.txtzSlider2 = uicontrol('style','text',...
                         'unit','normalized',...
                         'position',[0.3 0.19 0.08 0.03],...
                         'String', 'Zoom',...  
                         'FontSize', 11,'FontWeight','bold');
                     
S.zSlider3 = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.75 0.61 0.08 0.03],...
                      'min',min_zoom,'max',max_zoom,'value', S.z3,...
                      'sliderstep',[1,1]/steps_zoom,...
                      'callback', {@SliderCB, 'z3'});
                  
S.txtzSlider3 = uicontrol('style','text',...
                         'unit','normalized',...
                         'position',[0.75 0.64 0.08 0.03],...
                         'String', 'Zoom',...  
                         'FontSize', 11,'FontWeight','bold');
                     
                     
S.zSlider4 = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.75 0.16 0.08 0.03],...
                      'min',min_zoom,'max',max_zoom,'value', S.z4,...
                      'sliderstep',[1,1]/steps_zoom,...
                      'callback', {@SliderCB, 'z4'});
                  
S.txtzSlider4 = uicontrol('style','text',...
                         'unit','normalized',...
                         'position',[0.75 0.19 0.08 0.03],...
                         'String', 'Zoom',...  
                         'FontSize', 11,'FontWeight','bold');
                     




%Threshold type option      

S.thresPop = uicontrol('Style', 'popup',...
                       'unit','normalized',...
                       'Position', [0.9 0.40 0.08 0.03],...
                       'String', {'max threshold','threshold at each time'},...
                       'FontSize', 10,'FontWeight','bold',...
                       'Callback', {@SliderCB, 't'});   
                
S.txtthresPop = uicontrol('style','text',...
                          'unit','normalized',...
                          'position',[0.9 0.43 0.08 0.03],...
                          'String', ['Threshold Type'],...  
                          'FontSize', 11,'FontWeight','bold');    
                      
%Negative show option

S.negPop = uicontrol('Style', 'popup',...
                     'unit','normalized',...
                     'Position', [0.9 0.50 0.08 0.03],...
                     'String', {'show negative','hide negative'},...
                     'FontSize', 10,'FontWeight','bold',...
                     'Callback', {@SliderCB, 'n'});   

S.txtnegPop = uicontrol('style','text',...
                        'unit','normalized',...
                        'position',[0.9 0.53 0.08 0.03],...
                        'String', ['Negative'],...  
                        'FontSize', 11,'FontWeight','bold'); 

%Threshold slider
min_thresh = 0;
max_thresh = 100;
steps_thresh = (max_thresh - min_thresh);
S.a = 50;

S.thresSlider = uicontrol('style','slider',...
               'unit','normalized',...
               'position',[0.92 0.65 0.03 0.25],...
               'min',min_thresh,'max',max_thresh,'value', S.a,...
               'sliderstep',[1,1]/steps_thresh,...
               'callback', {@SliderCB, 'a'}); 
           
%Update slider text with threshold  
S.txtthresSlider = uicontrol('style','text',...
                'unit','normalized',...
                'position',[0.9 0.9 0.08 0.03],...
                'String', ['Threshold = ' num2str(S.a)],...  
                'FontSize', 11,'FontWeight','bold',...
                'callback', @updatetext);
      
%Time Slider
min_time = 1;
max_time = size(ABS,2);
steps_time = (max_time - min_time);
S.b = 1;

S.timeSlider = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.05 0.95 0.7 0.04],...
                      'min',min_time,'max',max_time,'value', S.b,...
                      'sliderstep',[1,1]/steps_time,...
                      'callback', {@SliderCB, 'b'});

%Update slider text with time                  
S.txttimeSlider = uicontrol('style','text',...
                   'unit','normalized',...
                   'position',[0.32 0.9 0.15 0.03],...
                    'String', ['Time = ' num2str(S.b)],...  
                    'FontSize', 11,'FontWeight','bold',...
                    'callback', @updatetext);   
                



%Pass all information from info into structure so it can be seen in all functions     

S.cnts = info.cnts;
S.ABS = ABS;      
S.max = max(max(ABS(:,S.b)));
S.max_val = max(max(ABS));
S.idx = find(ABS(:,S.b) > ((S.a)/100)*S.max);
S.orig_d = info.orig_d;
S.srf_d = info.srf_d;
S.idx_d =info.idx_d;
S.nodes_d = info.nodes_d;
S.orig_c = info.orig_c;
S.srf_c = info.srf_c;
S.idx_c =info.idx_c;
S.nodes_c = info.nodes_c;
S.orig_a = info.orig_a;
S.srf_a = info.srf_a;
S.idx_a =info.idx_a;
S.nodes_a = info.nodes_a;





guidata(S.fh, S);  
update_thresh(S);
updatetext(S)


end               
                
  %%
 function SliderCB(timeSlider, EventData, Param)
S = guidata(timeSlider);  % Get S structure from the figure
S.(Param) = get(timeSlider, 'Value');  % Any of the 'a', 'b', etc. defined
updatetext(S);
update_thresh(S);	% Update the plot values
guidata(timeSlider, S);  % Store modified S in figure
end

function updatetext(S)
S.txtthresSlider.String = ['Threshold = ' num2str(round(S.a))];
S.txttimeSlider.String = ['Time = ' num2str((S.b))];
end


function update_thresh(S)
    
    view1 = S.ax1.View;
    zoom1 = S.zSlider1.Value;
    view2 = S.ax2.View;
    zoom2 = S.zSlider2.Value;
    view3 = S.ax3.View;
    zoom3 = S.zSlider3.Value;
    view4 = S.ax4.View;
    zoom4 = S.zSlider4.Value;
    
    
    if S.thresPop.Value == 1 && S.negPop.Value == 1
        S.idx = find(abs(S.ABS(:,round(S.b))) > ((S.a)/100)*S.max_val); 
    elseif S.thresPop.Value == 2 && S.negPop.Value == 1
        S.max = max(max(S.ABS(:,round(S.b))));
        S.idx = find(abs(S.ABS(:,round(S.b))) > ((S.a)/100)*S.max);
    elseif S.thresPop.Value == 1 && S.negPop.Value == 2
        S.idx = find((S.ABS(:,round(S.b))) > ((S.a)/100)*S.max_val); 
    else
        S.max = max(max(S.ABS(:,round(S.b))));
        S.idx = find((S.ABS(:,round(S.b))) > ((S.a)/100)*S.max);
    end
    
    %plot updated figures
    %First figure
    scatter3(S.ax1, S.cnts(S.idx,1),S.cnts(S.idx,2),S.cnts(S.idx,3), 70, S.ABS(S.idx, round(S.b)), 'filled');
    hold on;
    patch(S.ax1, 'faces',S.srf_d(S.idx_d,:),'vertices',[S.nodes_d(:,1:3)],'facevertexcdata',-200*ones(size(S.nodes_d,1),1),...
    'facecolor',[1,1,1],'edgecolor','flat','facelighting', 'none', 'edgelighting', 'flat');
    %trimesh(S.srf_d(S.idx_d,:), S.nodes_d(:,1), S.nodes_d(:,2), S.nodes_d(:,3), -200*ones(size(S.nodes_d,1),1));  
    hold off;
    daspect(S.ax1,[1,1,1]);
    %Remove ticks
    S.ax1.XTick = [];
    S.ax1.YTick = [];
    S.ax1.ZTick = [];
    %Set view to last used view
    S.ax1.View = view1;
    
    %Set zoom to last used zoom
    z = (100-zoom1)/10000;
    S.ax1.XLim = [S.orig_d(1) - z,S.orig_d(1) + z];
    S.ax1.YLim = [S.orig_d(2) - z,S.orig_d(2) + z];
    S.ax1.ZLim = [S.orig_d(3) - z,S.orig_d(3) + z];
    
    %Sort out colormap
    colormap(S.ax1,jet);
    S.ax1.CLim = [-round(S.max_val),round(S.max_val)];
   % cb1 = colorbar(S.ax1, 'Location', 'southoutside', 'Position', [0.09, 0.14, 0.25, 0.03]);
    %cb = colorbar;
    %set(cb,'position','southoutside', 'FontSize', 11)
    %caxis([-round(S.max_val),round(S.max_val)]);
    
    %Second figure
    scatter3(S.ax2, S.cnts(S.idx,1),-1*S.cnts(S.idx,3),-1*S.cnts(S.idx,2), 70, S.ABS(S.idx, round(S.b)), 'filled');
    hold on;
    patch(S.ax2, 'faces',S.srf_d(S.idx_d,:),'vertices',[S.nodes_d(:,1), -1*S.nodes_d(:,3), -1*S.nodes_d(:,2)],'facevertexcdata',-200*ones(size(S.nodes_d,1),1),...
    'facecolor',[1,1,1],'edgecolor','flat','facelighting', 'none', 'edgelighting', 'flat');
    hold off;
    daspect(S.ax2,[1,1,1]);
    %Remove ticks
    S.ax2.XTick = [];
    S.ax2.YTick = [];
    S.ax2.ZTick = [];
    %Set view to last used view
    S.ax2.View = view2;
    
    %Set zoom to last used zoom
    z = (100-zoom2)/10000;
    S.ax2.XLim = [S.orig_d(1) - z,S.orig_d(1) + z];
    S.ax2.YLim = [-1*S.orig_d(3) - z,-1*S.orig_d(3) + z];
    S.ax2.ZLim = [-1*S.orig_d(2) - z,-1*S.orig_d(2) + z];
    
    %Sort out colormap
    colormap(S.ax2,jet);
    S.ax2.CLim = [-round(S.max_val),round(S.max_val)];
    %cb2 = colorbar(S.ax2, 'Location', 'southoutside', 'Position', [0.09, 0.14, 0.25, 0.03]);
    
    
    %Third figure
    scatter3(S.ax3, S.cnts(S.idx,1),S.cnts(S.idx,2),S.cnts(S.idx,3), 70, S.ABS(S.idx, round(S.b)), 'filled');
    hold on;
        patch(S.ax3, 'faces',S.srf_c(S.idx_c,:),'vertices',[S.nodes_c(:,1:3)],'facevertexcdata',-200*ones(size(S.nodes_c,1),1),...
    'facecolor',[1,1,1],'edgecolor','flat','facelighting', 'none', 'edgelighting', 'flat');  
    hold off;
    daspect(S.ax3,[1,1,1]);
    %Remove ticks
    S.ax3.XTick = [];
    S.ax3.YTick = [];
    S.ax3.ZTick = [];
    %Set view to last used view
    S.ax3.View = view3;
    
    %Set zoom to last used zoom
    z = (100-zoom3)/10000;
    S.ax3.XLim = [S.orig_c(1) - z,S.orig_c(1) + z];
    S.ax3.YLim = [S.orig_c(2) - z,S.orig_c(2) + z];
    S.ax3.ZLim = [S.orig_c(3) - z,S.orig_c(3) + z];
    
    %Sort out colormap
    colormap(S.ax3,jet);
    S.ax3.CLim = [-round(S.max_val),round(S.max_val)];
    %cb3 = colorbar(S.ax3, 'Location', 'southoutside', 'Position', [0.09, 0.14, 0.25, 0.03]);
    
    
    %Fouth figure
    scatter3(S.ax4, S.cnts(S.idx,3),S.cnts(S.idx,2),S.cnts(S.idx,1), 70, S.ABS(S.idx, round(S.b)), 'filled');
    hold on;
    patch(S.ax4, 'faces',S.srf_a(S.idx_a,:),'vertices',[S.nodes_a(:,3), S.nodes_a(:,2), S.nodes_a(:,1)],'facevertexcdata',-200*ones(size(S.nodes_a,1),1),...
    'facecolor',[1,1,1],'edgecolor','flat','facelighting', 'none', 'edgelighting', 'flat');  
    hold off;
    daspect(S.ax4,[1,1,1]);
    %Remove ticks
    S.ax4.XTick = [];
    S.ax4.YTick = [];
    S.ax4.ZTick = [];
    %Set view to last used view
    S.ax4.View = view4;
    
    %Set zoom to last used zoom
    z = (100-zoom4)/10000;
    S.ax4.XLim = [S.orig_a(3) - z,S.orig_a(3) + z];
    S.ax4.YLim = [S.orig_a(2) - z,S.orig_a(2) + z];
    S.ax4.ZLim = [S.orig_a(1) - z,S.orig_a(1) + z];
%     
%     %Sort out colormap
     colormap(S.ax4,jet);
     S.ax4.CLim = [-round(S.max_val),round(S.max_val)];
%     %cb4 = colorbar(S.ax4, 'Location', 'southoutside', 'Position', [0.09, 0.14, 0.25, 0.03]);

end
      
