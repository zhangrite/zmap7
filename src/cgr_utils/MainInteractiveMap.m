classdef MainInteractiveMap
    %MainInteractiveMap controls the display of the main map window
    %  plotting of all features, overlays, and events happens through
    %  class.
    %
    %
    
    properties
        Features
    end
    
    methods
        function obj = MainInteractiveMap()
            
            %% define the map features
            % each MapFeature is something that can be overlain on the main map
            %
            disp('MainInteractiveMap construction');
            obj.Features = MapFeature('coast', @load_coast_and_borders, [],...
                struct('Tag','mainmap_coastline',...
                'DisplayName', 'Coastline/Borders',...
                'HitTest','off','PickableParts','none',...
                'LineWidth',1.0,...
                'Color',[0.1 0.1 0.1])...
                );
            
            obj.Features(2) = MapFeature('volcanoes', @load_volcanoes, [],...
                struct('Tag','mainmap_volcanoes',...
                'Marker','^',...
                'DisplayName','Volcanoes',...
                'LineWidth', 1.5,...
                'MarkerSize', 6,...
                'LineStyle','none',...
                'MarkerFaceColor','w',...
                'MarkerEdgeColor','r')...
                );
            
            obj.Features(3) = MapFeature('plates', @load_plates, [],...
                struct('Tag','mainmap_plates',...
                'DisplayName','plate boundaries',...
                'LineWidth', 3.0,...
                'Color',[.2 .2 .5])...
                );
            %{
            obj.Features(4) = MapFeature('faults', @load_faults, [],...
                struct('Tag','mainmap_faultlines',...
                    'DisplayName','main faultine',...
                    'LineWidth', 3.0,...
                    'Color','b')...
                );
            
            obj.Features(5) = MapFeature('wells', @load_wells, [],...
                struct('Tag','mainmap_wells',...
                    'DisplayName','Wells',...
                    'Marker','d',...
                    'LineWidth',1.5,...
                    'MarkerSize',6,...
                    'LineStyle','none',...
                    'MarkerFaceColor','k',...
                    'MarkerEdgeColor','k')...
                );            
            obj.Features(6) = MapFeature('minor_faults', @load_minorfaults, [],...
                struct('Tag','mainmap_faults',...
                    'DisplayName','faults',...
                    'LineWidth',0.2,...
                    'Color','k')...
                );
                
                %}
                
                for i=1:numel(obj.Features)
                    obj.Features(i).load();
                end
                obj.initial_setup()
                
        end
        function update(obj)
            global a
            gh=ZmapGlobal.Data; %handle to globals;
            watchon; drawnow;
            disp('MainInteractiveMap.update()');
            %h=figureHandle();
            ax = mainAxes();
            if isempty(ax)
                % we have to redraw the whole thing, instead.
                obj.createFigure()
                return
            end
            MainInteractiveMap.plotEarthquakes(a)
            xlim(ax,[min(a.Longitude) max(a.Longitude)])
            ylim(ax,[min(a.Latitude) max(a.Latitude)]);
            ax.FontSize=ZmapGlobal.Data.fontsz.s;
            axis(ax,'manual');
            for i=1:numel(obj.Features)
                obj.Features(i).refreshPlot();
            end
            % bring selected events to front
            uistack(findobj('DisplayName','Selected Events'),'top');
            
                tolegend=findobj(ax,'Type','line');
                tolegend=tolegend(~ismember(tolegend,findNoLegendParts(ax)));
                legend(ax,tolegend,'Location','southeastoutside');
                ax.Legend.Title.String='Seismic Map';
            if strcmp(gh.lock_aspect,'on')
                daspect(ax, [1 cosd(mean(ax.YLim)) 10]);
            end
            grid(ax,gh.mainmap_grid);
            
            align_supplimentary_legends(ax);
    
    
            % make sure we're back in a 2-d view
            view(ax,2); %reset to top-down view
            grid(ax,'on');
            zlabel(ax,'Depth [km]');
            rotate3d(ax,'off'); %activate rotation tool
            set(findobj(figureHandle(),'Label','2-D view'),'Label','3-D view');
            
            watchoff;
            drawnow;
        end
        function createFigure(obj)
            % will delete figure if it exist
            global main mainfault faults coastline vo maepi well plates
            global a % primary event catalog
            disp('MainInterativeMap.createFigure()');
            h=figureHandle();
            if ~isempty(h)
                delete(h);
            end
            h=figure_w_normalized_uicontrolunits( ...
                'Name','Seismicity Map',...
                'NumberTitle','off', ...
                'backingstore','on',...
                'NextPlot','add', ...
                'Visible','on', ...
                'Tag','seismicity_map',...
                'Position',[10 10 900 650]);
            watchon; drawnow;
            ax = axes('Parent',h,'Position',[.09 .09 .85 .85],...
                'Tag','mainmap_ax',...
                'FontSize',ZmapGlobal.Data.fontsz.s,...
                'FontWeight','normal',...
                'Ticklength',[0.01 0.01],'LineWidth',1.0,...
                'Box','on','TickDir','out');
            xlabel(ax,'Longitude [deg]','FontSize',ZmapGlobal.Data.fontsz.m)
            ylabel(ax,'Latitude [deg]','FontSize',ZmapGlobal.Data.fontsz.m)
            strib = [  ' Map of '  a.Name '; '  char(min(a.Date),'uuuu-MM-dd HH:mm:ss') ' to ' char(max(a.Date),'uuuu-MM-dd HH:mm:ss') ];
            title(ax,strib,'FontWeight','normal',...
                ...%'FontSize',ZmapGlobal.Data.fontsz.m,...
                'Color','k')
            if ~isempty(mainAxes())
                % create the main earthquake axis
            end
            disp('setting up main map:');
            disp('preplotting catalog');
            MainInteractiveMap.plotEarthquakes(a)
            xlim(ax,'auto')
            ylim(ax,'auto');
            axis(ax,'manual');
            disp('     "      features');
            for i=1:numel(obj.Features)
                obj.Features(i).plot(ax);
            end
            MainInteractiveMap.plotMainshocks(main);
            disp('     "      "big" earthquakes');
            MainInteractiveMap.plotBigEarthquakes(maepi);
            try
                % to keep lines out of the legend, append a '_nolegend' to the item's Tag
                tolegend=findobj(ax,'Type','line');
                tolegend=tolegend(~ismember(tolegend,findNoLegendParts(ax)));
                legend(ax,tolegend,'Location','southeastoutside');
                ax.Legend.Title.String='Seismic Map';
            catch ME
                disp(ax.Children);
                rethrow(ME);
            end
            gh = ZmapGlobal.Data; % handle to "globals"
            if strcmp(gh.lock_aspect,'on')
                daspect(ax, [1 cosd(mean(ax.YLim)) 10]);
            end
            grid(ax,gh.mainmap_grid);
            align_supplimentary_legends(ax);
            disp('adding menus to main map')
            obj.create_all_menus(true);
            disp('done')
            watchoff; drawnow;
        end
        
        function show(obj, featurename)
            idx = strcmp(featurename, {obj.Features.Name});
            if any(idx)
                % make the feature visible
                set(obj.Feature(idx).handle,'Visible','on');
            else
                disp(['MainInteractiveMap: Feature "' featurename '" doesn''t exist']);
            end
        end
        
        function hide(obj, featurename)
            idx = strcmp(featurename, {obj.Features.Name});
            if any(idx)
                % make the feature invisible
                set(obj.Feature(idx).handle,'Visible','off');
            else
                disp(['MainInteractiveMap: Feature "' featurename '" doesn''t exist']);
            end
        end
        
        function initial_setup(obj)
            
            h = figureHandle();
            %% load/create features to be used in map
            
            if isempty(h)
                obj.createFigure();
            end
        end
            
        %% create menus
        function create_all_menus(obj, force)
            % create menus for main zmap figure
            % create_all_menus() - will create all menus, if they don't exist
            % create_all_menus(force) - will delete and recreate menus if force is true
            h = findobj(figureHandle(),'Tag','mainmap_menu_divider');
            if ~isempty(h) && exist('force','var') && force
                delete(h); h=[];
            end
            if isempty(h)
                add_menu_divider('mainmap_menu_divider');
            end
            obj.create_overlay_menu(force);
            obj.create_select_menu(force);
            obj.create_catalog_menu(force);
            obj.create_ztools_menu(force);
        end
        
        function create_overlay_menu(obj,force)
            global coast plates vo
            h = findobj(figureHandle(),'Tag','mainmap_menu_overlay');
            if ~isempty(h) && exist('force','var') && force
                delete(h); h=[];
            end
            if ~isempty(h)
                return
            end
            
            % Make the menu to change symbol size and type
            %
            mapoptionmenu = uimenu('Label','Map Options','Tag','mainmap_menu_overlay');
            
            uimenu(mapoptionmenu,'Label','Refresh map window',...
                'Callback','update(mainmap())');
            
            uimenu(mapoptionmenu,'Label','3-D view',...
                'Callback',@set_3d_view); % callback was plot3d
            %TODO use add_symbol_menu(...) instead of creating all these menus
            symbolsubmenu = uimenu(mapoptionmenu,'Label','Map Symbols');
            
            uimenu(symbolsubmenu,'Label','Symbol Size ...',...
                'Callback',@(~,~)symboledit_dlg(mainAxes(),'MarkerSize'));
            uimenu(symbolsubmenu,'Label','Symbol Type ...',...
                'Callback',@(~,~)symboledit_dlg(mainAxes(),'Marker'));
            uimenu(symbolsubmenu,'Label','Change Symbol Color ...',...
                'Callback', @(~,~)change_color);
            
            ovmenu = uimenu(mapoptionmenu,'Label','Layers');
            for i=1:numel(obj.Features)
                obj.Features(i).addToggleMenu(ovmenu);
            end
                uimenu(ovmenu,'Label','Load a coastline  from GSHHS database',...
                    'Callback','selt = ''in'';  plotmymap;');
                uimenu(ovmenu,'Label','Add coastline/faults from existing *.mat file',...
                    'Callback','think; addcoast;done');
                uimenu(ovmenu,'Label','Plot stations + station names',...
                    'Callback','think; plotstations;done');
                
                lemenu = uimenu(mapoptionmenu,'Label','Legend by ...  ');
                
                uimenu(lemenu,'Label','Change legend breakpoints',...
                    'Callback',@change_legend_breakpoints);
                legend_types = {'Legend by time','tim';...
                    'Legend by depth','depth';...
                    'Legend by magnitudes','mag';...
                    'Mag by size, Depth by color','mad' %;...
                    % 'Symbol color by faulting type','fau'...
                    };
                    
                for i=1:size(legend_types,1)
                    wrapped_leg = ['''' legend_types{i,2} ''''];
                    uimenu(lemenu,'Label',legend_types{i,1},...
                        'Callback', ['zg=ZmapGlobal.Data;zg.mainmap_plotby=' wrapped_leg ';update(mainmap());']);
                end
                clear legend_types
                
                uimenu(mapoptionmenu,'Label','Change font size ...',...
                    'Callback',@change_map_fonts);
                
                uimenu(mapoptionmenu,'Label','Change background colors',...
                    'Callback',@(~,~)setcol,'Enable','off'); %
                
                uimenu(mapoptionmenu,'Label','Mark large event with M > ??',...
                    'Callback',@(s,e) plot_large_quakes);
                uimenu(mapoptionmenu,'Label','Set aspect ratio by latitude',...
                    'callback',@toggle_aspectratio,'checked',ZmapGlobal.Data.lock_aspect);
                uimenu(mapoptionmenu,'Label','Toggle Grid',...
                    'callback',@toggle_grid,'checked',ZmapGlobal.Data.mainmap_grid);
        end
        
        function create_select_menu(obj,force)
            
            h = findobj(figureHandle(),'Tag','mainmap_menu_select');
            if ~isempty(h) && exist('force','var') && force
                delete(h); h=[];
            end
            if ~isempty(h)
                return
            end
            submenu = uimenu('Label','Select ','Tag','mainmap_menu_select');
            uimenu(submenu,'Label','Select EQ in Polygon (Menu)',...
                'Callback','global noh1 newt2 a;noh1 = gca;newt2 = a; stri = ''Polygon''; keyselect');
            
            uimenu(submenu,'Label','Select EQ inside Polygon',...
                'Callback',@(~,~) selectp('inside'));
            
            uimenu(submenu,'Label','Select EQ outside Polygon',...
                'Callback',@(~,~) selectp('outside'));
            
            uimenu(submenu,'Label','Select EQ in Circle (fixed ni)',...
                'Callback',' h1 = gca;set(gcf,''Pointer'',''watch''); stri = [''  '']; stri1 = ['' ''];circle');
            
            uimenu(submenu,'Label','Select EQ in Circle (Menu)',...
                'Callback','h1 = gca;set(gcf,''Pointer'',''watch''); stri = ['' '']; stri1 = ['' '']; incircle');
        end
        function create_catalog_menu(obj,force)
            h = findobj(figureHandle(),'Tag','mainmap_menu_catalog');
            if ~isempty(h) && exist('force','var') && force
                delete(h); h=[];
            end
            if ~isempty(h)
                return
            end
            submenu = uimenu('Label','Catalog','Tag','mainmap_menu_catalog');
            
            uimenu(submenu,'Label','Crop catalog to window',...
                'Callback','a.setFilterToAxesLimits(findobj(0, ''Tag'',''mainmap_ax''));a.cropToFilter();update(mainmap())');
            
            uimenu(submenu,'Label','Open new catalog',...
                'Callback','think;hold off;load_zmapfile();done');
            
            uimenu(submenu,'Label','Keep this catalog in memory (use reset below to recall)',...
                'Callback','storedcat = a; ');
            
            uimenu(submenu,'Label','Reset catalog to the one saved in memory previously',...
                'Callback','think;clear plos1 mark1 ;global a newcat newt2; a = storedcat; newcat = storedcat; newt2= storedcat;update(mainmap());done');
            
            uimenu(submenu,'Label','Select new parameters (reload last catalog)',...
                'Callback','think; load(lopa);if max(a(:,decyr_idx)) < 100; a(:,decyr_idx) = a(:,decyr_idx)+1900; end, if length(a(1,:))== 7,a(:,decyr_idx) = decyear(a(:,3:5));elseif length(a(1,:))>=9,a(:,decyr_idx) = decyear(a(:,[3:5 8 9]));end;inpu;done');
            
            uimenu(submenu,'Label','Combine two catalogs',...
                'Callback','think;comcat;done');
            
            uimenu(submenu,'Label','Compare two catalogs - find identical events',...
                'Callback','do = ''initial''; comp2cat');
            
            
            uimenu(submenu,'Label','Save current catalog (ASCII format)',...
                'Callback','save_ca;');
            
            uimenu(submenu,'Label','Save current catalog (mat format)',...
                'Callback','eval(catSave);');
        end
        function create_ztools_menu(obj,force)
            h = findobj(figureHandle(),'Tag','mainmap_menu_ztools');
            if ~isempty(h) && exist('force','var') && force
                delete(h); h=[];
            end
            if ~isempty(h)
                return
            end
            submenu = uimenu('Label','ZTools','Tag','mainmap_menu_ztools');
            
            uimenu(submenu,'Label','Show main message window',...
                'Callback', @(s,e)zmap_message_center());
            
            uimenu(submenu,'Label','Analyse time series ...',...
                'Callback','global newt2 a newcat; stri = ''Polygon''; newt2 = a; newcat = a; timeplot');
            
            obj.create_topo_map_menu(submenu);
            obj.create_random_data_simulations_menu(submenu);
            
            uimenu(submenu,'Label','Create cross-section',...
                'Callback','nlammap');
            
            
            obj.create_histogram_menu(submenu);
            obj.create_mapping_rate_changes_menu(submenu);
            obj.create_map_ab_menu(submenu);
            obj.create_map_p_menu(submenu);
            obj.create_quarry_detection_menu(submenu);
            obj.create_decluster_menu(submenu);
            
            uimenu(submenu,'Label','Map stress tensor',...
                'Callback','sel = ''in''; stressgrid');
            
            uimenu(submenu,'Label','Misfit calculation',...
                'Callback','inmisfit;');
            
        end
        function create_topo_map_menu(obj,parent)
            submenu   =  uimenu(parent,'Label','Plot topographic map  ');
            
            uimenu(submenu,'Label','Open DEM GUI',...
                'Callback',' prepinp ');
            
            uimenu(submenu,'Label','3 arc sec resolution (USGS DEM)',...
                'Callback','plt = ''lo3'' ; pltopo;');
            
            uimenu(submenu,'Label','30 arc sec resolution (GLOBE DEM)',...
                'Callback','plt = ''lo1'' ; pltopo;');
            
            uimenu(submenu,'Label','30 arc sec resolution (GTOPO30)',...
                'Callback','plt = ''lo30'' ; pltopo;');
            
            uimenu(submenu,'Label','2 deg resolution (ETOPO 2)',...
                'Callback','plt = ''lo2'' ; pltopo;');
            uimenu(submenu,'Label','5 deg resolution (ETOPO 5, Terrain Base)',...
                'Callback','plt = ''lo5''; pltopo;');
            uimenu(submenu,'Label','Your topography (mydem, mx, my must be defined)',...
                'Callback','plt = ''yourdem''; pltopo;');
            uimenu(submenu,'Label','Help on plotting topography',...
                'Callback','plt = ''genhelp''; pltopo;');
        end
        function create_random_data_simulations_menu(obj,parent)
            submenu  =   uimenu(parent,'Label','Random data simulations');
            uimenu(submenu,'label','Create permutated catalog (also new b-value)...', 'Callback','global storedcat a newt2; storedcat = a; [a] = syn_invoke_random_dialog(a); newt2 = a;timeplot; update(mainmap()); bdiff(a); revertcat');
            uimenu(submenu,'label','Create synthetic catalog...', 'Callback','global storedcat a newt2; storedcat = a; [a] = syn_invoke_dialog(a); newt2 = a; timeplot; update(mainmap()); bdiff(a); revertcat');
            
            uimenu(submenu,'Label','Evaluate significance of b- and a-values',...
                'Callback','brand');
            uimenu(submenu,'Label','Calculate a random b map and compare to observed data',...
                'Callback','brand2');
            uimenu(submenu,'Label','Info on synthetic catalogs',...
                'Callback','web([''file:'' hodi ''/zmapwww/syntcat.htm''])');
        end
        function create_mapping_rate_changes_menu(obj,parent)
            submenu  =   uimenu(parent,'Label','Mapping rate changes');
            uimenu(submenu,'Label','Compare two periods (z, beta, probabilty)',...
                'Callback','sel= ''in''; comp2periodz')
            
            uimenu(submenu,'Label','Calculate a z-value map',...
                'Callback','sel= ''in''; inmakegr')
            uimenu(submenu,'Label','Calculate a z-value cross-section',...
                'Callback','nlammap');
            uimenu(submenu,'Label','Calculate a 3D  z-value distribution',...
                'Callback','sel = ''in''; zgrid3d');
            uimenu(submenu,'Label','Load a z-value grid (map-view)',...
                'Callback','sel= ''lo'';loadgrid')
            uimenu(submenu,'Label','Load a z-value grid (cross-section-view)',...
                'Callback','sel= ''lo'';magrcros')
            uimenu(submenu,'Label','Load a z-value movie (map-view)',...
                'Callback','loadmovz')
        end
        
        function create_map_ab_menu(obj,parent)
            submenu  =   uimenu(parent,'Label','Mapping a- and b-values');
            % TODO have these act upon already selected polygons (as much as possible?)
            uimenu(submenu,'Label','Calculate a Mc, a- and b-value map',...
                'Callback','sel= ''in'';,bvalgrid')
            uimenu(submenu,'Label','Calculate a differential b-value map (const R)',...
                'Callback','sel= ''in'';,bvalmapt')
            uimenu(submenu,'Label','Calculate a b-value cross-section',...
                'Callback','nlammap');
            uimenu(submenu,'Label','Calculate a 3D  b-value distribution',...
                'Callback','sel = ''i1''; bgrid3dB');
            uimenu(submenu,'Label','Calculate a b-value depth ratio grid',...
                'Callback','sel= ''in'';,bdepth_ratio')
            uimenu(submenu,'Label','Load a b-value grid (map-view)',...
                'Callback','sel= ''lo'';bvalgrid')
            %RZ
            uimenu(submenu,'Label','Load a differential b-value grid',...
                'Callback','sel= ''lo'';bvalmapt')
            %RZ
            uimenu(submenu,'Label','Load a b-value grid (cross-section-view)',...
                'Callback','sel= ''lo'';bcross')
            uimenu(submenu,'Label','Load a 3D b-value grid',...
                'Callback','sel= ''no'';ac2 = ''load''; myslicer')
            uimenu(submenu,'Label','Load a b-value depth ratio grid',...
                'Callback','sel= ''lo'';,bdepth_ratio')
        end
        
        function create_map_p_menu(obj,parent)
            submenu  =   uimenu(parent,'Label','Mapping p-values');
            uimenu(submenu,'Label','Calculate p and b-value map',...
                'Callback','sel= ''in'';bpvalgrid');
            uimenu(submenu,'Label','Load existing p and b-value map',...
                'Callback','sel= ''lo'';bpvalgrid');
            uimenu(submenu,'Label','Rate change, p-,c-,k-value map in aftershock sequence (MLE)',...
                'Callback','sel= ''in'';rcvalgrid_a2');
            uimenu(submenu,'Label','Load existing  Rate change, p-,c-,k-value map (MLE)',...
                'Callback','sel= ''lo'';rcvalgrid_a2');
        end
        
        function create_quarry_detection_menu(obj,parent)
            submenu  = uimenu(parent,'Label','Detect quarry contamination');
            uimenu(submenu,'Label','Map day/nighttime ration of events',...
                'Callback','sel = ''in'';findquar;');
            uimenu(submenu,'Label','Info on detecting quarries.',...
                'Callback','web([''file:'' hodi ''/help/quarry.htm''])');
        end

        function create_histogram_menu(obj,parent)
            
            submenu = uimenu(parent,'Label','Histograms');
            
            uimenu(submenu,'Label','Magnitude',...
                'Callback','global histo;hisgra(a.Magnitude,''Magnitude '');');
            uimenu(submenu,'Label','Depth',...
                'Callback','global histo;hisgra(a.Depth,''Depth '');');
            uimenu(submenu,'Label','Time',...
                'Callback','global histo;hisgra(a.Date,''Time '');');
            uimenu(submenu,'Label','Hr of the day',...
                'Callback','global histo;hisgra(a.Date.Hour,''Hr '');');
            % uimenu(submenu,'Label','Stress tensor quality',...
            %    'Callback','global histo;hisgra(a(:,13),''Quality '');');
        end
        function create_decluster_menu(obj,parent)
            submenu = uimenu(parent,'Label','Decluster the catalog');
            uimenu(submenu,'Label','Decluster using Reasenberg',...
                'Callback','inpudenew;');
            uimenu(submenu,'Label','Decluster using Gardner & Knopoff',...
                'Callback','declus_inp;');
        end
        
        
    end
    methods(Static)
        function h = borderHandle()
            h = findobj(0, 'Tag');
        end
        
           
        %% plot CATALOG layer
        function plotEarthquakes(catalog, divs)
            disp('MainInteractiveMap.plotEarthquakes(...)');
            if ~exist('divs','var')
                divs=[];
            end
            switch ZmapGlobal.Data.mainmap_plotby
                
                case {'tim','time'}
                    %delete(extralegends);
                    MainInteractiveMap.plotQuakesByTime(catalog,divs);
                case {'dep','depth'}
                    %delete(extralegends);
                    MainInteractiveMap.plotQuakesByDepth(catalog,divs);
                case {'mad','magdepth'}
                    MainInteractiveMap.plotQuakesByMagAndDepth(catalog);
                case {'mag','magnitude'}
                    %delete(extralegends)
                    MainInteractiveMap.plotQuakesByMagnitude(catalog,divs);
                otherwise
                    error('unanticipated legend type');
            end
            
            ax = mainAxes();
            %set aspect ratio
            gh = ZmapGlobal.Data; % handle to "globals"
            if strcmp(gh.lock_aspect,'on')
                daspect(ax, [1 cosd(mean(ax.YLim)) 10]);
            end
            align_supplimentary_legends(ax);
            % TODO show subset also
        end
        function plotQuakesByMagnitude(mycat, divs)
            % magdivisions: magnitude split points
            
            % deletes existing event plots from the current axis
            
            global event_marker_types ms6
            if isempty(event_marker_types)
                event_marker_types='ooooooo'; %each division gets next type.
            end
            
            if isempty(divs)
                divs = linspace(min(mycat.Magnitude),max(mycat.Magnitude),4);
                divs([1 4])=[]; % no need for min, no quakes greater than max...
            end
            
            assert(numel(divs) < 8); % else, too many for our colormap.
            
            cmapcolors = colormap('lines');
            cmapcolors=cmapcolors(1:7,:); %after 7 it starts repeating
            
            
            mask = mycat.Magnitude <= divs(1);
            
            ax = mainAxes();
            clear_quake_plotinfo();
            washeld = ishold(ax); hold(ax,'on');
            h = plot(ax, mycat.Longitude(mask), mycat.Latitude(mask),...
                'Marker',event_marker_types(1),...
                'Color',cmapcolors(1,:),...
                'LineStyle','none',...
                'MarkerSize',ms6,...
                'Tag','mapax_part0');
            h.DisplayName = sprintf('M ≤ %3.1f', divs(1));
            h.ZData=-mycat.Depth(mask);
            
            for i = 1 : numel(divs)
                mask = mycat.Magnitude > divs(i);
                if i < numel(divs)
                    mask = mask & mycat.Magnitude <= divs(i+1);
                end
                dispname = sprintf('M > %3.1f', divs(i));
                h=plot(ax, mycat.Longitude(mask), mycat.Latitude(mask),...
                    'Marker',event_marker_types(i+1),...
                    'Color',cmapcolors(i+1,:),...
                    'LineStyle','none',...
                    'MarkerSize',ms6*(i+1),...
                    'Tag',['mapax_part' num2str(i)],...
                    'DisplayName',dispname);
                h.ZData=-mycat.Depth(mask);
            end
            if ~washeld; hold(ax,'off');end
        end
        
        function plotQuakesByDepth(mycat, divs)
            % plotQuakesByDepth
            % plotQuakesByDepth(catalog)
            % plotQuakesByDepth(catalog, divisions)
            %   divisions is a vector of depths (up to 7)
            
            % magdivisions: magnitude split points
            global event_marker_types ms6
            if isempty(event_marker_types)
                event_marker_types='+++++++'; %each division gets next type.
            end
            
            % eg. cat mags -0.5 to 5.2 ; magdiv= [1];
            %  M <= 1 and M >1
            % eq > 1
            
            if isempty(divs)
                divs = linspace(min(mycat.Depth),max(mycat.Depth),4);
                divs([1 4])=[]; % no need for min, andno quakes greater than max...
            end
            
            assert(numel(divs) < 8); % else, too many for our colormap.
            
            cmapcolors = colormap('lines');
            cmapcolors=cmapcolors(1:7,:); %after 7 it starts repeating
            
            
            mask = mycat.Depth <= divs(1);
            
            ax = mainAxes();
            clear_quake_plotinfo();
            washeld = ishold(ax); hold(ax,'on')
            
            h = plot(ax, mycat.Longitude(mask), mycat.Latitude(mask),...
                'Marker',event_marker_types(1),...
                'Color',cmapcolors(1,:),...
                'LineStyle','none',...
                'MarkerSize',ms6,...
                'Tag','mapax_part0');
                h.ZData=-mycat.Depth(mask);
            h.DisplayName = sprintf('Z ≤ %.1f km', divs(1));
            
            for i = 1 : numel(divs)
                mask = mycat.Depth > divs(i);
                if i < numel(divs)
                    mask = mask & mycat.Depth <= divs(i+1);
                end
                dispname = sprintf('Z > %.1f km', divs(i));
                myline=plot(ax, mycat.Longitude(mask), mycat.Latitude(mask),...
                    'Marker',event_marker_types(i+1),...
                    'Color',cmapcolors(i+1,:),...
                    'LineStyle','none',...
                    'MarkerSize',ms6,...
                    'Tag',['mapax_part' num2str(i)],...
                    'DisplayName',dispname);
                myline.ZData=-mycat.Depth(mask);
            end
            if ~washeld; hold(ax,'off'); end
        end
        
        function plotQuakesByMagAndDepth(mycat)
            % colorized by depth, with size dictated by magnitude 
            persistent colormapName
            
            ax = mainAxes();
            hquakes = findobj(ax,'DisplayName','Events by Mag & Depth');
            if isempty(hquakes)
                clear_quake_plotinfo();
            end
            if isempty(colormapName)
                colormapName = colormapdialog();  %todo: move into menu.
            end
            switch colormapName
                case 'jet'
                    c = jet;
                    c = c(64:-1:1,:);
                otherwise
                    c = colormap(colormapName);
            end % switch
            colormap(c)
            % sort by depth
            mycat.sort('Depth');
            
            % set all sizes by mag
            sm = mag2dotsize(mycat.Magnitude);
            
            washeld = ishold(ax); hold(ax,'on')
            if isvalid(hquakes)
                plund=findobj('Tag','mapax_part1_bg_nolegend');
                set(plund, 'XData',mycat.Longitude,'YData',mycat.Latitude,'SizeData',sm*1.2);
            else
                plund = scatter(ax, mycat.Longitude, mycat.Latitude, sm*1.2,'o','MarkerEdgeColor','k');
                plund.ZData=-mycat.Depth;
                plund.Tag='mapax_part1_bg_nolegend';
                plund.DisplayName='';
                plund.LineWidth=2;
            end
            if isvalid(hquakes)
                set(hquakes, 'XData',mycat.Longitude,'YData',mycat.Latitude,'SizeData',sm,...
                    'CData',mycat.Depth);
            else
                pl = scatter(ax, mycat.Longitude, mycat.Latitude, sm, mycat.Depth,'o','filled');
                pl.ZData=-mycat.Depth;
                pl.Tag='mapax_part0';
                pl.DisplayName='Events by Mag & Depth';
                pl.MarkerEdgeColor = 'flat';
            end
            if ~washeld; hold(ax,'off'); end
            %set(ax,'pos',[0.13 0.08 0.65 0.85]) %why?
            drawnow
            watchon;
            
            % resort by time
            mycat.sort('Date');
            
            % make a depth legend
            c=findobj(groot,'Tag','mainmap_supplimentary_deplegend');
            if isempty(c)
                c=colorbar('Direction','reverse','Position',[0.87 0.7 0.06 0.2],...
                    ...'Ticks',[0 5 10 15 20 25 30],
                    'Tag','mainmap_supplimentary_deplegend');
                c.Label.String='Depth [km]';
            end
            
            % make a mag legend:
            eventsizes = floor(min(mycat.Magnitude)) : ceil(max(mycat.Magnitude));
            eqmarkersizes = mag2dotsize(eventsizes);
            eqmarkerx = zeros(size(eqmarkersizes));
            eqmarkery = linspace(0,10,numel(eqmarkersizes));
            magleg_ax = findobj(groot,'Tag','mainmap_supplimentary_maglegend');
            if ~isempty(magleg_ax)
                pl = findobj(groot,'Tag','eqsizesamples');
                set(pl,'XData',eqmarkerx, 'YData', eqmarkery, 'SizeData',eqmarkersizes);
                delete(findobj(magleg_ax,'Type','Text'));
                
                %do nothing?
            else
                rect = [0.87 0.5 0.06 0.2];
                magleg_ax = axes(figureHandle,'Position',rect,'Tag','mainmap_supplimentary_maglegend');
                axes(magleg_ax);
                hold(magleg_ax,'on');
                pl=scatter(magleg_ax, eqmarkerx, eqmarkery, eqmarkersizes, [0 0 0],'filled','Tag','eqsizesamples');
                magleg_ax.YLim = [-1 11];
                magleg_ax.XLim = [-1 2];
                magleg_ax.XTick=[];
                magleg_ax.YTick=[];
                magleg_ax.Box='on';
                set(magleg_ax,'FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal','yaxislocation','right');
                ylabel(magleg_ax,'Magnitude');
                xlabel(magleg_ax,'Events');
            end
            for ii=1:numel(eqmarkersizes)
                mytxt = ['   M ',num2str(eventsizes(ii))];
                text(magleg_ax, eqmarkerx(ii), eqmarkery(ii), mytxt);
            end
            align_supplimentary_legends(ax);
            hold(magleg_ax,'off');
            
        end
        
        function plotQuakesByTime(mycat, divs)
            global event_marker_types ms6
            if isempty(event_marker_types)
                event_marker_types='+++++++'; %each division gets next type.
            end
            if isnumeric(divs) && ~isempty(divs)
                divs = linspace(min(mycat.Date),max(mycat.Date),divs);
            elseif isa(divs,'datetime')
                % do nothing...
            elseif isa(divs,'duration')
                %plot at intervals
                divs = min(mycat.Date):divs:max(mycat.Date);
            elseif isempty(divs)
                divs = linspace(min(mycat.Date),max(mycat.Date),4);
                divs([1])=[]; % no need for min, andno quakes greater than max...
            end
            
            
            % make sure the ends are accounted for
            if any(mycat.Date < divs(1))
                % first category is DD < timedivisions(1)
                divs = [min(mycat.Date); divs(:)];
            end
            if any(mycat.Date > divs(end))
                divs = [divs(:); max(mycat.Date)];
            end
            
            assert(numel(divs) < 8); % else, too many for our colormap.
            
            cmapcolors = colormap('lines');
            cmapcolors=cmapcolors(1:7,:); %after 7 it starts repeating
            
            ax = mainAxes();
            clear_quake_plotinfo();
            washeld=ishold(ax); hold(ax,'on');
            for i=1:numel(divs)-1
                if i == numel(divs)-1
                    % inclusive of last value
                    mask = divs(i) <= mycat.Date & mycat.Date <= divs(i+1);
                    dispname = sprintf('%s ≤ t ≤ %s ',...
                        char(divs(i),'uuuu-MM-dd hh:mm'),...
                        char(divs(i+1),'uuuu-MM-dd hh:mm'));
                else
                    % exclusive of last value
                    mask = divs(i) <= mycat.Date & mycat.Date < divs(i+1);
                    dispname = sprintf('%s ≤ t < %s ',...
                        char(divs(i),'uuuu-MM-dd hh:mm'),...
                        char(divs(i+1),'uuuu-MM-dd hh:mm'));
                end
                h = plot(ax, mycat.Longitude(mask), mycat.Latitude(mask),...
                    'Tag',['mapax_part' num2str(i)]);
                set(h,'Marker',event_marker_types(i),...
                    'MarkerSize',ms6,...
                    'Color',cmapcolors(i,:),...
                    'LineStyle','none',...
                    'DisplayName', dispname);
            end
            if ~washeld, hold(ax,'off');end
        end
        
        %% plot NON-catalog layers
        function plotOtherEvents(catalog, idx, varargin)
            %plotOtherEvents will plot the events from a catalog on the map
            % using the name-value pairs from varargin
            % tag: 'mainmap_otherN' (where N is the value provided to idx)
            %  this allows the plotting of a variety of clusters.
            % if varargin includes the pair {'DisplayName',..}
            % then that is how this would be represented in the legend
            ax = mainAxes();
            if isempty(idx), idx=0;end
            thisTag = ['mainmap_other' num2str(idx)];
            h = findobj(ax,'Tag',thisTag);
            delete(h);
            
            washeld=ishold(ax); hold(ax,'on');
            h=plot(catalog.Longitude, catalog.Latitude, varargin{:});
            
            h.ZData=-catalog.Depth(mask);
            h.Tag = thisTag;
            if ~washeld, hold(ax,'off'),end
        end
        
        function plotBigEarthquakes(maepi, reset)
            % plot big earthquake epicenters labeled with the data/magnitude
            % DisplayName: Events > M [something]
            % Tag: 'mainmap_big_events'
            global minmag
            % TODO: dump the global reference, and maybe make maepi a view into the catalog
            
            persistent big_events defaults textdefaults
            
            if isempty(defaults)
                defaults = struct('Tag','mainmap_big_events',...
                    'DisplayName',sprintf('Events > M%2.1f',minmag),...
                    'Marker','h',...
                    'Color','m',...
                    'LineWidth',1.5,...
                    'MarkerSize',12,...
                    'LineStyle','none',...
                    'MarkerFaceColor','y',...
                    'MarkerEdgeColor','k');
            end
            
            if isempty(textdefaults)
                textdefaults = struct('FontWeight','bold',...
                    'Color','k',...
                    'FontSize',9,...
                    'Clipping','on');
            end
            
            if nargin
                big_events = maepi;
            end
            
            if isempty(big_events)
                big_events = ZmapCatalog();
            end
            
            defaults.DisplayName = sprintf('Events > M %2.1f', minmag);
            
            if big_events.Count > 0
                % show events
                h = plot_helper(big_events,defaults,exist('reset','var')&&reset);
                
                evlabels = event_labels(maepi);
                ax = mainAxes();
                te1 = text(ax,maepi.Longitude,maepi.Latitude,evlabels);
                set(te1,textdefaults);
                set(h,'Visible','on');
            end
            
            function ev_labels = event_labels(catalog)
                % label with YYYY-DOY HH:MM M=X.X
                doy=ceil(days(catalog.Date- dateshift(catalog.Date,'start','year')));
                
                ev_labels = cell(catalog.Count,1);
                for idx = 1:catalog.Count
                    if isempty(catalog.MagnitudeType{idx})
                        mag='m'; % default magnitude description
                    else
                        mag = catalog.MagnitudeType{idx}; % use catalog's magnitude
                    end
                    ev_labels(idx)={sprintf(' %4d-%03d %5s %s=%3.1f',...
                        year(catalog.Date(idx)),doy(idx),...
                        char(catalog.Date(idx),'hh:mm'), mag)};
                end
            end
        end
        
        function plotMainshocks(xycoords, reset)
            % plot mainshock(s)
            % DisplayName: 'mainshocks'
            % Tag: 'mainmap_mainshocks'
            persistent xydata defaults
            
            if isempty(defaults)
                defaults=struct('Tag','mainmap_mainshocks',...
                    'Marker','*',...
                    'DisplayName','mainshocks',...
                    'LineStyle','none',...
                    'LineWidth', 2.0,...
                    'MarkerSize', 12,...
                    'MarkerEdgeColor','k');
            end
            
            if nargin
                xydata = replace_xy_if_exists(xydata, xycoords);
            end
            
            reset = exist('reset','var') && reset;
            plot_helper(xydata, defaults, reset);
            
        end
        
    end
    
end

function h = figureHandle()
    h = findobj(0, 'Tag','seismicity_map');
end
function h = mainAxes()
    h = findobj(0, 'Tag','mainmap_ax');
end

function xy_list = replace_xy_if_exists(xy_list, new_xy_list)
    % replaces list of [lon,lat] with new list, if it exist.
    % if the new list is actually a ZmapCatalog, then Longitude and Latitude
    % are extracted
    if nargin==1
        return
    end
    
    if isa(new_xy_list,'ZmapCatalog') || isstruct(new_xy_list) || istable(new_xy_list)
        xy_list = [new_xy_list.Longitude, new_xy_list.Latitude];
    else
        xy_list = new_xy_list;
    end
    
    if isempty(xy_list)
        xy_list = [nan nan];
    end
end
function clear_quake_plotinfo()
    delete(findMapaxParts());
    delete(findobj(0,'Tag','mainmap_supplimentary_maglegend'));
    delete(findobj(0,'Tag','mainmap_supplimentary_deplegend'));
end

function h=plot_helper(xy, defaults, reset)
    % plot_helper
    % linehandle = plot_helper(xy, defaults, reset)
    % xy is a list of [x(:),y(:)] positions ie.(lon,lat)
    % Defaults contain all the plotting defaults necessary
    % reset - if true, then all default values are re-applied
    
    ax = mainAxes();
    h = findobj(ax,'Tag',defaults.Tag);
    if ~isempty(h)
        isEmptyNumeric = (isnumeric(xy) && (isempty(xy) || all(isnan(xy(:)))));
        isEmptyCatalog = isa(xy,'ZmapCatalog') && xy.Count==0;
        if isEmptyNumeric || isEmptyCatalog
            delete(h);
            return
        end
    end
    if isempty(h)
        hold(ax,'on');
        if isa(xy,'ZmapCatalog')|| istable(xy) || isstruct(xy)
            h=plot(ax, xy.Longitude, xy.Latitude, defaults);
        else
            h=plot(ax, xy(:,1), xy(:,2), defaults);
        end
        hold(ax,'off');
    else
        %simply change the data
        if isa(xy,'ZmapCatalog')
            h.XData = xy.Longitude;
            h.YData = xy.Latitude;
        else
            h.XData = xy(:,1);
            h.YData=xy(:,2);
        end
        if exist('reset','var') && reset
            set(h,defaults);
        end
    end
end


function choice = colormapdialog()
    % allow user to choose colormap
    persistent colormap_choice
    
    if isempty(colormap_choice)
        colormap_choice = 'jet';
    end
    color_maps = {'parula';'jet';'hsv';'hot';'cool';'spring';'summer';'autumn';'winter'};
    % provide a simple dialog allowing the user to choose a colormap
    d = dialog('Position',[300 300 250 150], 'Name', 'Choose Colormap');
    uicontrol('Parent',d, 'Style','Popup','Position',[20 80 210 40],...
        'String',color_maps,...
        'Value',find(strcmp(color_maps,colormap_choice)),...
        'Callback', @popup_callback);
    uicontrol('Parent',d,...
        'Position',[89 20 70 25],...
        'String','Close',...
        'Callback','delete(gcf)');
    uiwait(d);
    choice = colormap_choice;
    
    function popup_callback(popup, ~)
        idx = popup.Value;
        popup_items = popup.String;
        colormap_choice = char(popup_items(idx,:));
    end
end


%% % % % callbacks
function catSave()
    zmap_message_center.set_message('Save Data', ' ');
    try
        think;
        [file1, path1] = uiputfile(fullfile(hodi, 'eq_data', '*.mat'), 'Earthquake Datafile');
        if length(file1) > 1
            wholePath=[path1 file1];
            save('WholePath', 'a', 'faults','main','mainfault','coastline','infstri','well');
        end
        done
    catch ME
        warning(ME)
    end
end

function change_markersize(val)
    global ms6
    ms6 = val;
    ax = findobj(0,'Tag','mainmap_ax');
    set(findobj(ax,'Type','Line'),'MarkerSize',val);
end

function change_symbol(~, clrs, symbs)
    global ms6
    ax = findobj(0,'Tag','mainmap_ax');
    lines = findMapaxParts(ax);
    %line_tags = {'mapax_part1','mapax_part2','mapax_part3'};
    for n=1:numel(lines)
        if ~isempty(clrs)
            set(lines(n),'MarkerSize',ms6,...
                'Marker',symbs(n),...
                'Color',clrs(n,:),...
                'Visible','on');
        else
            set(lines(n),'MarkerSize',ms6,...
                'Marker',symbs(n),...
                'Visible', 'on');
        end
    end
end

function change_color(c)
    lines = findMapaxParts();
    n =listdlg('PromptString','Change color for which item?',...
        'SelectionMode','multiple',...
        'ListString',{lines.DisplayName})
    if ~isempty(n)
        c = uisetcolor(lines(n(1)));
        set(lines(n),'Color',c,'Visible','on');
    end
end
    

function plot_large_quakes()
    global minmag maex maix maey maiy maepi a
    mycat=ZmapCatalog(a);
    def = {'6'};
    ni2 = inputdlg('Mark events with M > ? ','Choose magnitude threshold',1,def);
    l = ni2{:};
    minmag = str2double(l);
    
    clear maex maix maey maiy
    maepi = mycat.subset(mycat.Magnitude > minmag);
    update(mainmap())
end
function align_supplimentary_legends(ax)
    % reposition supplimentary legends, if they exist
    try
        le = ax.Legend;
    catch
        return
    end
    if isempty(le) 
        return;
    end
    tags = {'mainmap_supplimentary_deplegend','mainmap_supplimentary_maglegend'};
    for i=1:numel(tags)
        c=findobj(0,'Tag',tags{i});
        if ~isempty(c)
            c.Position([1]) = le.Position([1]); % scoot it over to match the legend
        end
    end
end


function toggle_grid(src, ~)
    ax = mainAxes();
    switch src.Checked
        case 'off'
            ax = mainAxes();
            src.Checked = 'on';
            grid(ax,'on');
        case 'on'
            src.Checked = 'off';
            grid(ax,'off');
    end
    gh = ZmapGlobal.Data;
    gh.lock_aspect = src.Checked;
    drawnow
    align_supplimentary_legends();
    drawnow
    
end

function toggle_aspectratio(src, ~)
    ax = mainAxes();
    switch src.Checked
        case 'off'
            src.Checked = 'on';
            daspect(ax, [1 cosd(mean(ax.YLim)) 10]);
        case 'on'
            src.Checked = 'off';
            daspect(ax,'auto');
    end
    gh = ZmapGlobal.Data;
    gh.lock_aspect = src.Checked;
    align_supplimentary_legends();
    
end
function hide_events()
    set(findMapaxParts(),'visible','off'); 
end
function h=findMapaxParts(ax)
    if ~exist('ax','var'), ax=0; end
    h = findobj(ax,'-regexp','Tag','\<mapax_part[0-9].*\>');
end
function h=findNoLegendParts(ax)
    % to keep lines out of the legend, append a '_nolegend' to the item's Tag
    if ~exist('ax','var'), ax=0; end
    h = findobj(ax,'-regexp','Tag','\<.*_nolegend.*\>');
end
    
function change_legend_breakpoints(~, ~)
    % TODO fix this, breakpoints aren't changed
    switch ZmapGlobal.Data.mainmap_plotby
        case {'tim','time'}
            setleg;
        case {'dep','depth'}
            setlegm;
        case {'mad'}
            % pick new color?
        case {'mag'}
            setlegm;
        case {'fau'}
            % donno
        otherwise
            error('unrecognized legend type');
            % donno
                
    end
            
end

function change_map_fonts(~,~)
    ax = findobj(0,'Tag','mainmap_ax');
    f = uisetfont(ax,'Change Font Size');
    fontsz = ZmapGlobal.Data.fontsz;
    fontsz.base_size = f.FontSize;
    % TODO note, this does not change the font (maybe later)
    set(ax,'FontSize',f.FontSize);
    set(ax.Legend,'FontSize', f.FontSize);
    axmag=findobj(0,'Tag','mainmap_supplimentary_maglegend');
    set(axmag,'FontSize',f.FontSize);
end

function set_3d_view(src,~)
    watchon
    drawnow;
    switch src.Label
        case '3-D view'
            ax=mainAxes();
            hold on
            view(ax,3);
            grid(ax,'on');
            zlim(ax,'auto');
            %axis(ax,'tight');
            zlabel(ax,'Depth [km]');
            rotate3d(ax,'on'); %activate rotation tool
            hold off
            src.Label = '2-D view';
        otherwise
            ax=mainAxes();
            view(ax,2);
            grid(ax,'on');
            rotate3d(ax,'off'); %activate rotation tool
            src.Label = '3-D view';
    end
    watchoff
    drawnow;
end