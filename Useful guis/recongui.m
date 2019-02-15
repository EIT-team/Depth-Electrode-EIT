function [S] = recongui(ABS, info)

S.fh = figure('units','normalized',...
		'Position', [0.2 0.1 0.6 0.7],... %%%%
              'name','slider_plot');
% Define axes so that room is available in figure window for sliders
S.ax = axes('unit','normalized',...
          'position',[0.15 0.15 0.8 0.8]);

      
%Default view and zoom
S.view = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                   'unit','normalized',...
                   'Position', [0.01 0.9 0.15 0.03],...
                   'String', ['Original View'],... 
                   'FontSize', 10,'FontWeight','bold',...
                   'Callback', 'S.ax.View = [0 -50]; S.zSlider.Value = 70; S.ax.XLim = [S.orig(1) - S.zdef, S.orig(1) + S.zdef]; S.ax.YLim = [S.orig(2) - S.zdef, S.orig(2) + S.zdef]; S.ax.ZLim = [S.orig(3) - S.zdef, S.orig(3) + S.zdef];');   

%Zoom slider
min_zoom = 0;
max_zoom = 80;
steps_zoom = (max_zoom - min_zoom);
S.z = 70; %N.B. this goes in opposite direction
S.zdef = (100-70)/10000;
S.zSlider = uicontrol('style','slide',...
                      'unit','normalized',...
                      'position',[0.01 0.8 0.15 0.03],...
                      'min',min_zoom,'max',max_zoom,'value', S.z,...
                      'sliderstep',[1,1]/steps_zoom,...
                      'callback', {@SliderCB, 'z'});
                  
S.txtzSlider = uicontrol('style','text',...
                         'unit','normalized',...
                         'position',[0.01 0.83 0.15 0.03],...
                         'String', 'Zoom',...  
                         'FontSize', 11,'FontWeight','bold');

                     
%Threshold type option      

S.thresPop = uicontrol('Style', 'popup',...
                       'unit','normalized',...
                       'Position', [0.01 0.65 0.15 0.03],...
                       'String', {'max threshold','threshold at each time'},...
                       'FontSize', 10,'FontWeight','bold',...
                       'Callback', {@SliderCB, 't'});   
                
S.txtthresPop = uicontrol('style','text',...
                          'unit','normalized',...
                          'position',[0.01 0.68 0.15 0.03],...
                          'String', ['Threshold Type'],...  
                          'FontSize', 11,'FontWeight','bold');    
                      
%Negative show option

S.negPop = uicontrol('Style', 'popup',...
                     'unit','normalized',...
                     'Position', [0.01 0.55 0.15 0.03],...
                     'String', {'show negative','hide negative'},...
                     'FontSize', 10,'FontWeight','bold',...
                     'Callback', {@SliderCB, 'n'});   

S.txtnegPop = uicontrol('style','text',...
                        'unit','normalized',...
                        'position',[0.01 0.58 0.15 0.03],...
                        'String', ['Negative'],...  
                        'FontSize', 11,'FontWeight','bold');    
                     
%Threshold slider
min_thresh = 0;
max_thresh = 100;
steps_thresh = (max_thresh - min_thresh);
S.a = 50;

S.thresSlider = uicontrol('style','slider',...
               'unit','normalized',...
               'position',[0.01 0.2 0.04 0.3],...
               'min',min_thresh,'max',max_thresh,'value', S.a,...
               'sliderstep',[1,1]/steps_thresh,...
               'callback', {@SliderCB, 'a'}); 
           
%Update slider text with threshold  
S.txtthresSlider = uicontrol('style','text',...
                'unit','normalized',...
                'position',[0.05 0.335 0.15 0.03],...
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
                      'position',[0.15 0.08 0.8 0.05],...
                      'min',min_time,'max',max_time,'value', S.b,...
                      'sliderstep',[1,1]/steps_time,...
                      'callback', {@SliderCB, 'b'});

%Update slider text with time                  
S.txttimeSlider = uicontrol('style','text',...
                   'unit','normalized',...
                   'position',[0.475 0.03 0.15 0.03],...
                    'String', ['Time = ' num2str(S.b)],...  
                    'FontSize', 12,'FontWeight','bold',...
                    'callback', @updatetext);   
                

%Pass all information from info into structure so it can be seen in all functions     
S.srf = info.srf;
S.idx_srf = info.idx_srf;
S.cnts = info.cnts;
S.nodes = info.nodes;
S.orig = info.cnt_el;
S.ABS = ABS;      
S.max = max(max(ABS(:,S.b)));
S.max_val = max(max(ABS));
S.idx = find(ABS(:,S.b) > ((S.a)/100)*S.max);
S.ax.View = [0 -50];

guidata(S.fh, S);  
update(S);
updatetext(S)                
                
end

function SliderCB(timeSlider, EventData, Param)
S = guidata(timeSlider);  % Get S structure from the figure
S.(Param) = get(timeSlider, 'Value');  % Any of the 'a', 'b', etc. defined
updatetext(S);
update(S);	% Update the plot values
guidata(timeSlider, S);  % Store modified S in figure
end

function updatetext(S)
S.txtthresSlider.String = ['Threshold = ' num2str(round(S.a))];
S.txttimeSlider.String = ['Time = ' num2str(round(S.b))];
end

function update(S)
    
    view = S.ax.View;
    zoom = S.zSlider.Value;
    
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
    trimesh(S.srf(S.idx_srf,:),S.nodes(:,1),S.nodes(:,2),S.nodes(:,3),-200*ones(size(S.nodes,1),1));
    hold on;
    scatter3(S.cnts(S.idx,1),S.cnts(S.idx,2),S.cnts(S.idx,3), 70, S.ABS(S.idx, round(S.b)), 'filled');
    hold off;
    daspect([1,1,1]);
    %Remove ticks
    S.ax.XTick = [];
    S.ax.YTick = [];
    S.ax.ZTick = [];
    %Set view to last used view
    S.ax.View = view;
    
    %Set zoom to last used zoom
    z = (100-zoom)/10000;
    S.ax.XLim = [S.orig(1) - z,S.orig(1) + z];
    S.ax.YLim = [S.orig(2) - z,S.orig(2) + z];
    S.ax.ZLim = [S.orig(3) - z,S.orig(3) + z];
    
    %Sort out colormap
    colormap(jet);
    cb = colorbar;
    set(cb,'position',[0.95 0.2 0.02 0.7], 'FontSize', 11)
    caxis([-round(S.max_val),round(S.max_val)]);
    % caxis([-1,1]);  
end




