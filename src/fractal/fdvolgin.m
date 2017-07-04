%
% Creates the input window for the parameters of the factal dimension calculation.
%
%
figure_w_normalized_uicontrolunits('Units','pixel','pos',[300 400 350 100 ],'Name','Volume Geometry','visible','off',...
    'NumberTitle','off','MenuBar','none','Color',color_fbg,'NextPlot','new');
axis off;

input3 = uicontrol(,'Style','popupmenu','Position',[.77 .7 .20 .06],...
    'Units','normalized','String','box|sphere',...
    'Callback','vol=(get(input3,''Value'')); set(input3,''Value'',vol);');

tx3 = text('EraseMode','normal', 'Position',[0 .70 0 ], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Embedding Volume: ');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.37 .1 .30 .25 ],...
    'Units','normalized',...
    'Callback','close;think; org = [3]; startfd; ',...
    'String','Go');


set(gcf,'visible','on');
watchoff;

