%
% Creates the input window for the parameters of the factal dimension calculation.
%
%
figure_w_normalized_uicontrolunits('Units','pixel','pos',[200 400 550 200 ],'Name','Parameters','visible','off',...
    'NumberTitle','off','MenuBar','none','Color',color_fbg,'NextPlot','new');
axis off;


input1 = uicontrol(,'Style','popupmenu','Position',[.75 .75 .23 .09],...
    'Units','normalized','String','Automatic Range|Manual Fixed Range|Manual',...
    'Value',1,'Callback','range=(get(input1,''Value'')); set(input1,''Value'',range), actrange');

input2 = uicontrol('Style','edit','Position',[.34 .43 .10 .09],...
    'Units','normalized','String',num2str(radm), 'enable', 'off',...
    'Value',1,'Callback','radm=str2double(get(input2,''String'')); set(input2,''String'', num2str(radm));');

input3 = uicontrol('Style','edit','Position',[.75 .43 .10 .09],...
    'Units','normalized','String',num2str(rasm), 'enable', 'off',...
    'Value',1,'Callback','rasm=str2double(get(input3,''String'')); set(input3,''String'', num2str(rasm));');




tx1 = text('EraseMode','normal', 'Position',[0 .85 0 ], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Distance Range within which D is computed: ');

tx2 = text('EraseMode','normal', 'Position',[0 .45 0], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Minimum value: ', 'color', 'w');

tx3 = text('EraseMode','normal', 'Position',[.52 .45 0], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Maximum value: ', 'color', 'w');

tx4 = text('EraseMode','normal', 'Position',[.41 .45 0], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');

tx5 = text('EraseMode','normal', 'Position',[.94 .45 0], 'Rotation',0 ,...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');


close_button=uicontrol('Style','Pushbutton',...
    'Position',[.60 .05 .20 .15 ],...
    'Units','normalized','Callback','close;zmap_message_center.set_info('' '','' '');done','String','Cancel');


switch (gobut)

    case 1   %Defined in timeplot.m, dorand.m,

        go_button=uicontrol('Style','Pushbutton',...
            'Position',[.20 .05 .20 .15 ],...
            'Units','normalized',...
            'Callback','close;think; org = [2]; startfd;',...
            'String','Go');


    case 2  %defined in fdtimin.m

        go_button=uicontrol('Style','Pushbutton',...
            'Position',[.20 .05 .20 .15 ],...
            'Units','normalized',...
            'Callback','close;think; fdtime;',...
            'String','Go');


    case 3  %defined in Dcross.m

        go_button=uicontrol('Style','Pushbutton',...
            'Position',[.20 .05 .20 .15 ],...
            'Units','normalized',...
            'Callback','close;think; sel = ''ca''; Dcross;',...
            'String','Go');

end  %switch(gobut)

set(gcf,'visible','on');
watchoff;
