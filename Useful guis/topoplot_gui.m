
function [S] = topoplot_gui(topo, ABS, thres)
%%
S.fh = figure('units','normalized', 'Position', [0.05 0 0.95 0.9],'name','slider_plot');

% Define axes so that room is available in figure window for sliders           
S.ax1 = axes('unit','normalized', 'position',[0.05 0.38 0.3 0.6]); 
S.ax1.Color = 'none';
S.ax1.XColor = 'none';
S.ax1.YColor = 'none';
S.ax1.ZColor = 'none';
S.ax1.View = [49 -2];
%S.ax1.View = [0 -86];

   
S.ax2 = axes('unit','normalized', 'position',[0.35 0.38 0.3 0.6]); 
S.ax2.Color = 'none';
S.ax2.XColor = 'none';
S.ax2.YColor = 'none';
S.ax2.ZColor = 'none';
S.ax2.View = [49 -2];


S.ax3 = axes('unit','normalized', 'position',[0.7 0.38 0.3 0.6]); 
S.ax3.Color = 'none';
S.ax3.XColor = 'none';
S.ax3.YColor = 'none';
S.ax3.ZColor = 'none';
S.ax3.View = [49 -2];

S.ax4 = axes('unit','normalized', 'position',[0.05 0.04 0.3 0.4]); 
S.ax4.Color = 'none';
S.ax4.XColor = 'none';
S.ax4.YColor = 'none';
S.ax4.ZColor = 'none';
%S.ax1.View = [49 -2];
S.ax4.View = [0 -86];

S.ax5 = axes('unit','normalized', 'position',[0.4 0.08 0.25 0.3]); 

S.ax6 = axes('unit','normalized', 'position',[0.75 0.08 0.25 0.3]); 



S.view1 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.0 0.85 0.06 0.03],...
                   'String', ['Original View'],... 
                   'FontSize', 10,'FontWeight','bold',...
                   'Callback', 'S.ax1.View = [49 -2];'); 

 S.view2 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.35 0.85 0.06 0.03],...
                   'String', ['Original View'],...
                   'FontSize', 10,'FontWeight','bold',...
                   'Callback', 'S.ax2.View = [49 -2];'); 
               
S.view3 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.7 0.85 0.06 0.03],...
                   'String', ['Original View'],...
                   'FontSize', 10,'FontWeight','bold',...
                   'Callback', 'S.ax3.View = [49 -2];'); 
               
S.view4 = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.0 0.35 0.06 0.03],...
                   'String', ['Original View'],... 
                   'FontSize', 10,'FontWeight','bold',...
                   'Callback', 'S.ax1.View = [0 -86];'); 
               
%%
%Time Slider
min_time = 1;
max_time = 100;%size(ABS,2);
steps_time = (max_time - min_time);
S.b = 1;

S.timeSlider = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.15 0.95 0.7 0.04],...
                      'min',min_time,'max',max_time,'value', S.b,...
                      'sliderstep',[1,1]/steps_time,...
                      'callback', {@SliderCB, 'b'});

%Update slider text with time                  
S.txttimeSlider = uicontrol('style','text',...
                   'unit','normalized',...
                   'position',[0.4 0.92 0.15 0.03],...
                    'String', ['Time = ' num2str(S.b)],...  
                    'FontSize', 11,'FontWeight','bold',...
                    'callback', @updatetext);   
                %%



%Pass all information from info into structure so it can be seen in all functions     
S.srf = topo.srf;
S.idx_srf = topo.idx_srf;
S.Vq_mua = topo.Vq_mua ;
S.mua = topo.mua;
S.max_mua = max(max(S.mua));
S.lfp = topo.lfp;
S.Vq_lfp = topo.Vq_lfp;
S.max_lfp = max(max(S.lfp));
S.T = topo.T;
S.pos = topo.pos;
S.Nodes = topo.Nodes;
S.orig_c = topo.orig_c;
S.srf_c = topo.srf_c;
S.idx_c =topo.idx_c;
S.nodes_c = topo.nodes_c;
S.a = thres;
S.max_val = max(max(ABS));
S.ABS_c = ABS;    
S.cnts_c = topo.cnts_c;

guidata(S.fh, S);  
update_thresh(S);
updatetext(S);


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
S.txttimeSlider.String = ['Time = ' num2str((S.b))];
end


function update_thresh(S)
    
    view1 = S.ax1.View;
    view2 = S.ax2.View;
    view3 = S.ax3.View;
    view4 = S.ax4.View;
    
    S.idx_ABS_c = find((S.ABS_c(:,round(S.b))) > ((S.a)/100)*S.max_val); 
%     
       
    scatter3(S.ax1, S.cnts_c(S.idx_ABS_c,1),S.cnts_c(S.idx_ABS_c,2),S.cnts_c(S.idx_ABS_c,3), 70, S.ABS_c(S.idx_ABS_c, round(S.b)), 'filled');
      hold(S.ax1, 'on');
     scatter3(S.ax1,S.pos(:,1),S.pos(:,2),S.pos(:,3), 40, 'k', 'filled')
    hold(S.ax1, 'on');
    patch(S.ax1,'Faces',S.srf(S.idx_srf,:),'Vertices',S.Nodes(:,1:3), 'FaceColor', 'blue',...
    'FaceAlpha', .3,'EdgeColor', 'none');
  hold(S.ax1, 'off');   
%     scatter3(S.ax1, S.cnts_c(S.idx_ABS_c,1),S.cnts_c(S.idx_ABS_c,2),S.cnts_c(S.idx_ABS_c,3), 70, S.ABS_c(S.idx_ABS_c, round(S.b)), 'filled');
    %hold off;

    daspect(S.ax1,[1,1,1]);
    %Remove ticks
    S.ax1.Color = 'none';
    S.ax1.XColor = 'none';
    S.ax1.YColor = 'none';
    S.ax1.ZColor = 'none';
    S.ax1.XTick = [];
    S.ax1.YTick = [];
    S.ax1.ZTick = [];

    %Set view to last used view
    S.ax1.View = view1;
    colormap(S.ax1,jet);
    S.ax1.CLim = [-round(S.max_val),round(S.max_val)];
    
    
    
    scatter3(S.ax2,S.pos(:,1),S.pos(:,2),S.pos(:,3), 40, 'k', 'filled')
    hold(S.ax2, 'on');
    patch(S.ax2,'Faces',S.srf(S.idx_srf,:),'Vertices',S.Nodes(:,1:3), 'FaceVertexCData', S.Vq_lfp(:, round(S.b)),...
       'FaceColor', 'flat', 'EdgeColor', 'none');
    hold(S.ax2, 'off');
    daspect(S.ax2,[1,1,1]);
    %Remove ticks
    S.ax2.Color = 'none';
    S.ax2.XColor = 'none';
    S.ax2.YColor = 'none';
    S.ax2.ZColor = 'none';
    S.ax2.XTick = [];
    S.ax2.YTick = [];
    S.ax2.ZTick = [];

    %Set view to last used view
    S.ax2.View = view2;
    
    %Sort out colormap
    %colormap(S.ax2,jet);
    S.ax2.CLim = [-round(S.max_lfp),round(S.max_lfp)];
   % cb1 = colorbar(S.ax1, 'Location', 'southoutside', 'Position', [0.09, 0.14, 0.25, 0.03]);
    %cb = colorbar;
    %set(cb,'position','southoutside', 'FontSize', 11)
    %caxis([-round(S.max_val),round(S.max_val)]);
    
    %Second figure
    scatter3(S.ax3,S.pos(:,1),S.pos(:,2),S.pos(:,3), 40, 'k', 'filled')
    hold(S.ax3, 'on');
    patch(S.ax3,'Faces',S.srf(S.idx_srf,:),'Vertices',S.Nodes(:,1:3), 'FaceVertexCData', S.Vq_mua(:, round(S.b)),...
       'FaceColor', 'flat', 'EdgeColor', 'none');
    hold(S.ax3, 'off');
    daspect(S.ax3,[1,1,1]);
    %Remove ticks
    S.ax3.Color = 'none';
    S.ax3.XColor = 'none';
    S.ax3.YColor = 'none';
    S.ax3.ZColor = 'none';
    S.ax3.XTick = [];
    S.ax3.YTick = [];
    S.ax3.ZTick = [];

    %Set view to last used view
    S.ax3.View = view3;
    
    %colormap(S.ax3,jet);
    S.ax3.CLim = [-round(S.max_mua),round(S.max_mua)];
    
    
    scatter3(S.ax4, S.cnts_c(S.idx_ABS_c,1),S.cnts_c(S.idx_ABS_c,2),S.cnts_c(S.idx_ABS_c,3), 70, S.ABS_c(S.idx_ABS_c, round(S.b)), 'filled');
    hold(S.ax4, 'on');
     patch(S.ax4, 'faces',S.srf_c(S.idx_c,:),'vertices',[S.nodes_c(:,1:3)],'facevertexcdata',-200*ones(size(S.nodes_c,1),1),...
    'facecolor',[1,1,1],'edgecolor','flat','facelighting', 'none', 'edgelighting', 'flat');  
    hold(S.ax4, 'off');
    daspect(S.ax4,[1,1,1]);
    %Remove ticks
    S.ax4.XTick = [];
    S.ax4.YTick = [];
    S.ax4.ZTick = [];
    %Set view to last used view
    S.ax4.View = view4;
    zoom = 70;
    z = (100-zoom)/10000;
    S.ax4.XLim = [S.orig_c(1) - z,S.orig_c(1) + z];
    S.ax4.YLim = [S.orig_c(2) - z,S.orig_c(2) + z];
    S.ax4.ZLim = [S.orig_c(3) - z,S.orig_c(3) + z];
    
    colormap(S.ax4,jet);
    S.ax4.CLim = [-round(S.max_val),round(S.max_val)];
    
    
    
    
    plot(S.ax5, S.T, S.lfp);
    hold(S.ax5, 'on'); 
    plot(S.ax5,[S.T(round(S.b)) S.T(round(S.b))], [-1500,1500], '--k');
    hold(S.ax5, 'off'); 

   
    plot(S.ax6, S.T, S.mua);
    hold(S.ax6, 'on'); 
    plot(S.ax6,[S.T(round(S.b)) S.T(round(S.b))], [-20,100], '--k');
    hold(S.ax6, 'off'); 

end
      
