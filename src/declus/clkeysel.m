%function clkeysel
%clkeysel.m                         A.Allmann
%provides a interface for some selection options by a polygon
%works on the equivalent events for a cluster catalog(complete,swarms,etc)
%selects clusters which equivalent events are inside selection area
%
%Last modification 6/95
global x y n clu mess plot1_h plot2_h clust file1
global  h5 xcordinate ycordinate equi newclcat clsel
global equi_button backbgevent original backcat backequi
global decc


xcordinate=0;
ycordinate=0;
axes(h5)
x = [];
y = [];

n = 0;


figure_w_normalized_uicontrolunits(mess)
set(gcf,'visible','off')
clf;
cla;
set(gca,'visible','off');
set(gcf, 'Name','Polygon Input Parameters');

%creates dialog box to input some parameters
%

inp1_field=uicontrol('Style','edit',...
    'Position',[.70 .60 .17 .10],...
    'Units','normalized','String',num2str(xcordinate),...
    'Callback','xcordinate=str2double(get(inp1_field,''String''));set(inp1_field,''String'',num2str(xcordinate));');

inp2_field=uicontrol('Style','edit',...
    'Position',[.70 .40 .17 .10],...
    'Units','normalized','String',num2str(ycordinate),...
    'Callback','ycordinate=str2double(get(inp2_field,''String''));set(inp2_field,''String'',num2str(ycordinate));');

more_button=uicontrol('Style','Pushbutton',...
    'Position', [.60 .05 .15 .15],...
    'Units','normalized',...
    'Callback','set(mouse_button,''visible'',''off'');set(load_button,''visible'',''off'');clpickp(1);',...
    'String','More');
last_button=uicontrol('Style','Pushbutton',...
    'Position',[.40 .05 .15 .15],...
    'Units','normalized',...
    'Callback','clpickp(2);',...
    'String','Last');

mouse_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .05 .15 .15],...
    'Units','normalized',...
    'Callback','clpickp(4);',...
    'String','Mouse');

load_button=uicontrol('Style','Pushbutton',...
    'Position',[.80 .05 .15 .15],...
    'Units','normalized',...
    'Callback','clpickp(3);',...
    'String','load');
cancel_button=uicontrol('Style','Pushbutton',...
    'Position',[.05 .80 .15 .15],...
    'Units','normalized',...
    'Callback','welcome;done',...
    'String','cancel');
txt1 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0. 0.65 0 ],...
    'Rotation',0,...
    'FontSize',12,...
    'String','Longitude:');
txt2 = text(...
    'Color',[0 0 0],...
    'EraseMode','normal',...
    'Position',[0. 0.45 0 ],...
    'Rotation',0,...
    'FontSize',12,...
    'String','Latitude:');


set(mess,'visible','on')
