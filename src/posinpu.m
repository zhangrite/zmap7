function posinpu() % autogenerated function wrapper
    %[lat1 lon1 lat2,  lon2] =posinpu
    % function posinpu.m               Alexander Allmann
    % Position input of two coordinates to build a crossection
    %
    %
    % last update: 20.10.2004
    % j.woessner@sed.ethz.ch
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    
    %...
    
    hInpuCoord = figure_w_normalized_uicontrolunits( ...
        'Name','Cross-section Input Coordinates',...
        'tag','InpuCoordX','Position',[260 504 300 300],...
        'NumberTitle','off', ...
        'backingstore','on',...
        'Visible','on');
    set(gca,'Box','off','visible','off')
    
    txt1 = text(...
        'Position',[0. 0.65 0 ],...
        'FontSize',12,...
        'String','Point 1: ');
    txt2 = text(...
        'Position',[0. 0.45 0 ],...
        'FontSize',12,...
        'String','Point 2: ');
    
    txt3 = text(...
        'Position',[0.35 0.8 0 ],...
        'FontSize',12,...
        'String','Longitude:');
    txt4 = text(...
        'Position',[0.75 0.8 0 ],...
        'FontSize',12,...
        'String','Latitude:');
    
    inp1_field=uicontrol('Style','edit',...
        'Position',[.70 .60 .25 .10],...
        'Units','normalized','String',num2str(lat1,5),...
        'callback',@callbackfun_001);
    
    inp2_field=uicontrol('Style','edit',...
        'Position',[.70 .40 .25 .10],...
        'Units','normalized','String',num2str(lat2,5),...
        'callback',@callbackfun_002);
    
    inp3_field=uicontrol('Style','edit',...
        'Position',[.40 .60 .25 .10],...
        'Units','normalized','String',num2str(lon1,6),...
        'callback',@callbackfun_003);
    
    inp4_field=uicontrol('Style','edit',...
        'Position',[.40 .40 .25 .10],...
        'Units','normalized','String',num2str(lon2,6),...
        'callback',@callbackfun_004);
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.40 .05 .15 .15],...
        'Units','normalized',...
        'callback',@callbackfun_005,...
        'String','Go');
    
    cancel_button=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .15],...
        'Units','normalized',...
        'callback',@callbackfun_006,...
        'String','Cancel');
    
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lat1=str2double(inp1_field.String);
        inp1_field.String=num2str(lat1);
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lat2=str2double(inp2_field.String);
        inp2_field.String=num2str(lat2);
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lon1=str2double(inp3_field.String);
        inp3_field.String=num2str(lon1);
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        lon2=str2double(inp4_field.String);
        inp4_field.String=num2str(lon2);
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        [xsecx xsecy,  inde] =mysect(tmp1,tmp2,ZG.a.Depth,ZG.xsec_width_km,0,lat1,lon1,lat2,lon2);
        nlammap2;
        zmap_message_center();
        close(hInpuCoord);
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        figure(mapl);
    end
    
end
