function mifigrid() % autogenerated function wrapper
    %function mifigrid(var1)
    % mifigrid.m                              Alexander Allmann
    % This function creates a grid with spacing dx, dy (in degrees)
    % The size is selected interactively in an input window.
    % The relative quiescence will be calculated for every grid point
    % for a specific time and plotted in a Seismolap-Quiescence map
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    
    
    global freq_field1 freq_field2 freq_field3 freq_field4 freq_field5
    global freq_field6 ni mi me1 va1
    global a h1 map dx dy Mmin stime lap1 seismap
    global normlap1 normlap2 mif1 mifmap
    
    if var1==1
        
        
        %input window
        %
        %default parameters
        dx= .5;                      %grid spacing east-west
        dy= .5;                      %grid spacing north-south
        % ldx=100;                     %side length of interaction zone in km (for seislap)
        % tlap=300;                    %interaction time in days (for seislap)
        Mmin=3;                      %minimum magnitude
        stime=a(find(ZG.a.Magnitude==max(ZG.a.Magnitude)),3);
        stime=stime(1);
        
        
        %create a input window
        figure_w_normalized_uicontrolunits(...
            'Name','Grid Input Parameter',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'units','points',...
            'Visible','off', ...
            'Position',[ ZG.wex+200 ZG.wey-200 450 250]);
        axis off
        
        %create a dialog box for the input
        freq_field1=uicontrol('Style','edit',...
            'Position',[.60 .36 .15 .08],...
            'Units','normalized','String',num2str(dx),...
            'callback',@callbackfun_001);
        
        freq_field2=uicontrol('Style','edit',...
            'Position',[.60 .27 .15 .08],...
            'Units','normalized','String',num2str(dy),...
            'callback',@callbackfun_002);
        
        freq_field3=uicontrol('Style','edit',...
            'Position',[.60 .48 .15 .08],...
            'Units','normalized','String',num2str(ni),...
            'callback',@callbackfun_003);
        
        close_button=uicontrol('Style','Pushbutton',...
            'Position',[.70 .05 .15 .12 ],...
            'Units','normalized','callback',@callbackfun_004,'String','Cancel');
        
        
        go_button1=uicontrol('Style','Pushbutton',...
            'Position',[.20 .05 .15 .12 ],...
            'Units','normalized',...
            'callback',@callbackfun_005,...
            'String','Go');
        
        txt4 = text(...
            'Position',[0.50 0.74 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.l ,...
            'FontWeight','bold',...
            'String',' Grid Parameter');
        txt5 = text(...
            'Position',[0. 0.35 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Spacing in x (dx) in deg:');
        
        txt6 = text(...
            'Position',[0. 0.25 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Spacing in y (dy) in deg:');
        
        txt2 = text(...
            'Position',[0. 0.5 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String',' # of EQ Ni:');
        
        set(gcf,'visible','on');
        watchoff
        
    elseif var1==2           %area selection
        
        messtext=...
            ['To select a polygon for a grid.       '
            'Please use the LEFT mouse button of   '
            'or the cursor to the select the poly- '
            'gon. Use the RIGTH mouse button for   '
            'the final point.                      '];
        zmap_message_center.set_message('Select Polygon for a grid',messtext);
        
        figure(map);
        hold on
        ax = findobj('Tag','main_map_ax');
        [x,y, mouse_points_overlay] = select_polygon(ax);
        zmap_message_center.set_info('Message',' Thank you .... ')
        
        %figure_w_normalized_uicontrolunits(mif1)
        
        plos2 = plot(x,y,'b-');        % plot outline
        sum3 = 0.;
        pause(0.3)
        
        %create a rectangular grid
        xvect=[min(x):dx:max(x)];
        yvect=[min(y):dy:max(y)];
        tmpgri=zeros((length(xvect)*length(yvect)),2);
        n=0;
        for i=1:length(xvect)
            for j=1:length(yvect)
                n=n+1;
                tmpgri(n,:)=[xvect(i) yvect(j)];
            end
        end
        %extract all gridpoints in chosen polygon
        XI=tmpgri(:,1);
        YI=tmpgri(:,2);
        ll = polygon_filter(x,y, XI, YI, 'inside');
        %grid points in polygon
        newgri=tmpgri(ll,:);
        
        % Plot all grid points
        gcf
        plot(newgri(:,1),newgri(:,2),'+k')
        drawnow
        
        think
        if length(xvect) < 2  ||  length(yvect) < 2
            errordlg('Selection too small! (not a matrix)');
            return
        end
        
        %calculate lap1(relative quiescence) at every grid point
        %
        ZG.newcat=a;                   %ZG.newcat is only a local variable
        bcat=ZG.newcat;
        
        me1=zeros(length(newgri(:,1)),1);
        va1=zeros(length(newgri(:,1)),1);
        
        wai = waitbar(0,' Please Wait ...  ');
        set(wai,'NumberTitle','off','Name','Makegrid - Percent completed');;
        drawnow
        
        
        
        for i= 1:length(me1)   %all eqs which are in spacewindow in east-west direction
            l = sqrt(((ZG.newcat.Longitude-newgri(i,1))*cosd(newgri(i,2))*111).^2 +...
                ((ZG.newcat.Latitude-newgri(i,2))*111).^2) ;
            [s,is] = sort(l);
            b = ZG.newcat(is(:,1),:) ;       % re-orders matrix to agree row-wise
            mi2 = mi(is(:,1),2);    % take first ni points
            mi2 = mi2(1:ni);
            me1(i) = mean(mi2);
            va1(i) = std(mi2);
            if rem(i,20)==0;  waitbar(i/length(me1));end
            
        end
        
        
        close(wai)
        %make a color map
        % Find out if figure already exists
        %
        mifmap=findobj('Type','Figure','-and','Name','Misfit-Map 2');
        
        % Set up the Seismicity Map window Enviroment
        %
        if isempty(mifmap)
            mifmap = figure_w_normalized_uicontrolunits( ...
                'Name','Misfit-Map 2',...
                'NumberTitle','off', ...
                'NextPlot','replace', ...
                'backingstore','on',...
                'Visible','off', ...
                'Position',[ 600 400 500 650]);
            % make menu bar
            
            
            
            hold on
        end
        figure(mifmap)
        delete(findobj(mifmap,'Type','axes'));
        
        set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
            'FontWeight','bold','LineWidth',1.5,...
            'Box','on','SortMethod','childorder')
        
        %minimum and maximum of normlap2 for automatic scaling
        ZG.maxc = max(normlap2);
        ZG.minc = min(normlap2);
        
        %construct a matrix for the color plot
        normlap1=ones(length(tmpgri(:,1)),1);
        normlap2=nan(length(tmpgri(:,1)),1)
        normlap3=nan(length(tmpgri(:,1)),1)
        normlap1(ll)=me1;
        normlap2(ll)=normlap1(ll);
        normlap1(ll)=va1;
        normlap3(ll)=normlap1(ll);
        
        normlap2=reshape(normlap2,length(yvect),length(xvect));
        normlap3=reshape(normlap3,length(yvect),length(xvect));
        
        %plot color image
        orient tall
        memifig2
        done
        return
        
        rect = [0.25,  0.60, 0.7, 0.35];
        axes('position',rect)
        hold on
        pco1 = pcolor(xvect,yvect,normlap2);
        shading interp
        colormap(jet)
        axis([ s2 s1 s4 s3])
        hold on
        colorbar
        overlay
        title('Mean of the Misfit','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        xlabel('Longitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Latitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        
        set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
            'FontWeight','bold','LineWidth',1.5,...
            'Box','on','TickDir','out')
        
        rect = [0.25,  0.10, 0.7, 0.35];
        axes('position',rect)
        hold on
        pco1 = pcolor(xvect,yvect,normlap3);
        axis([ s2 s1 s4 s3])
        hold on
        shading interp
        colormap(jet)
        hold on
        colorbar
        title(' Variance of the Misfit','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        xlabel('Longitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        ylabel('Latitude [deg]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
        
        set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
            'FontWeight','bold','LineWidth',1.5,...
            'Box','on','TickDir','out')
        
        overlay
        memifig2
    end
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dx=str2double(freq_field1.String);
        freq_field1.String=num2str(dx);
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dy=str2double(freq_field2.String);
        freq_field2.String=num2str(dy);
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ni=str2double(freq_field3.String);
        freq_field3.String=num2str(ni);
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        done;
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        var1 = 2;
        mifigrid;
    end
    
end
