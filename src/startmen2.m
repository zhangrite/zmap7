%
report_this_filefun(mfilename('fullpath'));
%
%  This file display the original menu
%
%  Stefan Wiemer 12/94


%  Create new figure
% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('ZMAP 5.0 - Menu');
newmenuFlag=~existFlag;
my_dir = ' ';

% Set up the Seismicity Map window Enviroment
%
if newmenuFlag
    menu  = figure_w_normalized_uicontrolunits( ...
        'Name','ZMAP 5.0 - Menu',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','new', ...
        'Color',color_fbg,...
        'Visible','off', ...
        'Position',[ wex wey-300 (ZmapGlobal.Data.map_len - [300 150]) ]);
    orient tall
    axis off

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','showweb(''new'');',...
        'String','Introduction',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.90 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;load_zmapfile()',...
        'String','Load *.mat  Datafile and go',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.80 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;setup',...
        'String','Create or modify *.mat Datafile',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.70 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;datinf',...
        'String','Current Dataset Info ',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.60 0.80 0.09]);

    % uicontrol(gcf,...
    %'Units','normalized',...
    %'Callback','think;loadcal;',...
    %'String','Load new NCEC catalog ',...
    %'BackgroundColor' ,[0.8 0.8 0.8]',...
    %'Position',[0.10 0.50 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;newccat=[];clusmenu',...
        'String','Load Cluster datafile ',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.50 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','web(''http://www.seismo.ethz.ch/staff/stefan/zmapnews/papers.html'');',...
        'String',' Papers written using ZMAP',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.40 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;dosl = ''newf'';slshow ',...
        'String','Sample Slide Show',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.30 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;startwebd',...
        'String','Start WEB Doumentation ',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.20 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','think;working_dir_in',...
        'String','Set working directory ',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.10 0.10 0.80 0.09]);

    uicontrol(gcf,...
        'Units','normalized',...
        'Callback','close(menu);zmap_message_center.set_info('' '','' '');done',...
        'String','Close this window ',...
        'BackgroundColor' ,[0.8 0.8 0.8]',...
        'Position',[0.15 0.00 0.70 0.09]);

end   % if fig exist

figure_w_normalized_uicontrolunits(menu)
set(gcf,'visible','on')

