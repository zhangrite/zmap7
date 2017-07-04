%  doinvers
% This file calculates orintation of the stress tensor
% based on Gephard's algorithm.
% stress tensor orientation. The actual calculation is done
% using a call to a fortran program.
%
% Stefan Wiemer 03/96


global mi mif1 mif2  hndl3 a newcat2 mi2
global tmp cumu2
report_this_filefun(mfilename('fullpath'));
think

tmp = [a(:,10:14)];
save /home/stefan/ZMAP/invers/data.inp tmp -ascii
infi = ['/home/stefan/ZMAP//invers/data.inp'];
outfi = ['/home/stefan/ZMAP/tmpout.dat'];

cd /home/stefan/ZMAP/invers
comm = ['!/home/lu/stress/src/tmp data.inp ' num2str(length(tmp(:,1))) ' ' num2str(length(tmp(:,1))) '&']
eval(comm)
return

load /home/stefan/ZMAP/tmpout.dat
mi = tmpout;

[existFlag,figNumber]=figure_exists('Misfit Map',1);

% addded by Zhong for temperary use
%existFlag = 0;
%

newmif1WindowFlag=~existFlag;


if newmif1WindowFlag
    mif1 = figure_w_normalized_uicontrolunits( ...
        'Name','Misfit Map',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','off', ...
        'Position',[ (fipo(3:4) - [600 500]) ZmapGlobal.Data.map_len]);

    
    matdraw

    %
    omp2= uimenu('Label','Tools');
    uimenu(omp2,'label','Misfit-Magnitude',...
         'Callback','misfit_magnitude;');
    uimenu(omp2,'label','Misfit-Depth',...
         'Callback','misfit_depth;');
    uimenu(omp2,'label','Earthquake-Depth',...
         'Callback','earthquake_depth;');
    uimenu(omp2,'label','Earthquake-Strike',...
         'Callback','earthquake_strike;');
    %

    labelList=['Size | Size + Thickness | Size +Thickness +color  '];
    labelPos = [0.2 0.93 0.35 0.05];
    hndl2=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'Callback','in2 =get(hndl2,''Value''); plotmima(in2)');

    labelList=['1 | 1/2 | 1/3 | 1/4 | 1/5 | 1/6| 1/7| 1/8 | 1/9 | 1/10'];
    labelPos = [0.9 0.93 0.10 0.05];
    hndl3=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',4,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'Callback','in3 =get(hndl3,''Value'');in2 =get(hndl2,''Value''); plotmima(in2) ');

    uicontrol(...
        'Style','pushbutton',...
        'Units','normalized',...
        'Position',[0.9 0.7 0.08 0.08],...
        'String','Grid',...
        'Callback','var1 = 1;mificrgr');
    hold on
end

figure_w_normalized_uicontrolunits(mif1)

plotmima(3)

[existFlag,figNumber]=figure_exists('Misfit ',1);
newmif2WindowFlag=~existFlag;


if newmif2WindowFlag
    mif2 = figure_w_normalized_uicontrolunits( ...
        'Name','Misfit ',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','off', ...
        'Position',[ (fipo(3:4) - [300 500]) ZmapGlobal.Data.map_len]);

    
    matdraw
    omp1= uimenu('Label','Tools');
    uimenu(omp1,'label','Save sorted catalog',...
         'Callback','save_sortpere;');
    uimenu(omp1,'label','AS Function',...
         'Callback','ast_misfit;');
    uimenu(omp1,'label','Compare',...
         'Callback','compare_misfit;');
    labelList=['Longitude | Latitude | Time | Magnitude | Depth | Strike | Default'];
    labelPos = [0.7 0.9 0.25 0.08];
    hndl1=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'Callback','in2 =get(hndl1,''Value''); plotmi(in2)');
    hold on
end

figure_w_normalized_uicontrolunits(mif2)

delete(gca);delete(gca);
delete(gca);delete(gca);

plotmi(1)

done
