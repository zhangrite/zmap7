report_this_filefun(mfilename('fullpath'));


% read hypoellipse and other formated  data into a matrix a that can be used
% in zmap!
%
% Stefan Wiemer; 6/95

report_this_filefun(mfilename('fullpath'));
% This is the info window text
%
par1 = 28;
minmag = 6;
titstr='The Data Input Window                        ';
hlpStr= ...
    ['                                                '
    ' Allows you ti Import data into zmap. At this   '
    ' You can either Import the data as ASCII colums '
    ' separated by blanks or as hypoellipse.         '
    ' To load an ASCII file seperated by blanks      '
    ' switch the popup Menu FORMAT to ASCII COLUMNS. '];


% add a new label to the list
labelList=[' Choose a data format | Ascii columns | Read formatted (Hypo 88 char - NCEDC format) | Read formatted (Hypo 36 char - AEIC Format)| Read formatted (your format) |  Hypoellipse (string conversion) | JMA Format '];

if in == 'initf'
    % add a new option for your own data file format like that
    if in2 == 5
        da = 'eq';close; inda =1;yourload; return
    end

    if in2 == 4
        da = 'eq';close; inda =1;myload36; return
    end
    if in2 == 3
        da = 'eq';close; inda =1;myload88; return
    end
    if in2 == 7
        in='initf';inda=1;mylojma; return
    end
    if in2 == 6
        in='initf';hypo_de;loadhypo; return
    end
    if in2 == 2
        da = 'eq';close; loadasci; return
    end

end  % if in

% set up the figure
[existFlag,figNumber]=figure_exists('Data Import',1);
newinpWindowFlag=~existFlag;

% Set up the window Enviroment
%
if newinpWindowFlag

    lohy = figure(...
        'Units','centimeter','pos',[0 3 18 6],...
        'Name','Data Import',...
        'visible','on',...
        'NumberTitle','off',...
        'MenuBar','none',...
        'Color',color_fbg,...
        'NextPlot','add');
    axis off
end  % if figure exist

figure(lohy)
clf

uicontrol('BackGroundColor',[0.9 0.9 0.9],'Style','Frame',...
    'Units','centimeter',...
        'Position',[0.6 0.5   17  4.5]);

uicontrol('Style','text',...
    'Units','centimeter','Position',[1 3.0   3  0.8],...
    'String','Format:');

labelPos = [5 3.0 11 0.8];
hndl1=uicontrol(...
    'Style','popup',...
    'Units','centimeter',...
    'Position',labelPos,...
    'String',labelList,...
    'Callback','in2 =get(hndl1,''Value''); in = ''initf''; dataimpo');

