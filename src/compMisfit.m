%  compMisfit
% August 95 by Zhong Lu and Alex Allmann

report_this_filefun(mfilename('fullpath'));

global xNumber yMisfit cumuMisfit loopNumber obsNum StressPara

[existFlag,figNumber]=figure_exists('Compare Misfits of Different Stress Models',1);

newWindowFlag=~existFlag;

if newWindowFlag
    mif99 = figure_w_normalized_uicontrolunits( ...
        'Name','Compare Misfits of Different Stress Models',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','off', ...
        'Position',[ (fipo(3:4) - [300 500]) ZmapGlobal.Data.map_len]);

    
    matdraw
    hold on

    %initiate variables
    loopNumber = 0;
    xNumber = [];
    yMisfit = [];
    cumuMisfit = [];
    stressPara =[];
    xNumber = [1:length(mi2(:,1))]';
    obsNum = length(mi2);
else
    delete(pl);
end %if newWindowFlag

figure_w_normalized_uicontrolunits(mif99)

hold on

loopNumber = loopNumber + 1;
yMisfit(:,loopNumber) = mi2(:,2);
cumuMisfit(:,loopNumber) = cumsum(yMisfit(:,loopNumber));

% save the parameters of the stress model
stressPara(loopNumber,:) = [sig,plu,az,R,phi];
%

increment = 100;  % offset between curves.

%strtext = ['/',num2str(sig),'/',num2str(az),'/',num2str(plu),...
%           '/',num2str(R),'/',num2str(phi)];
%text(obsNum-offsetX, offsetY, '/Sig/Az/Plu/R/Phi/');

if loopNumber == 1
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro');
    set(pl,'MarkerSize',[ 4]);
    %  pl = plot(xNumber,cumuMisfit(:,loopNumber), 'ro');
    %  set(pl,'LineWidth',2.0);

elseif loopNumber == 2
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);

elseif loopNumber == 3
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);

elseif loopNumber == 4
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);

elseif loopNumber == 5
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);

elseif loopNumber == 6
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.',...
        xNumber,cumuMisfit(:,colI( 6)) + increment * 5, 'r.');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);
    set(pl( 6),'MarkerSize',17);

elseif loopNumber == 7
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.',...
        xNumber,cumuMisfit(:,colI( 6)) + increment * 5, 'r.',...
        xNumber,cumuMisfit(:,colI( 7)) + increment * 6, 'y*');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);
    set(pl( 6),'MarkerSize',17);
    set(pl( 7),'MarkerSize',[ 5]);

elseif loopNumber == 8
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.',...
        xNumber,cumuMisfit(:,colI( 6)) + increment * 5, 'r.',...
        xNumber,cumuMisfit(:,colI( 7)) + increment * 6, 'y*',...
        xNumber,cumuMisfit(:,colI( 8)) + increment * 7, 'm*');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);
    set(pl( 6),'MarkerSize',17);
    set(pl( 7),'MarkerSize',[ 5]);
    set(pl( 8),'MarkerSize',[ 8]);

elseif loopNumber == 9
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.',...
        xNumber,cumuMisfit(:,colI( 6)) + increment * 5, 'r.',...
        xNumber,cumuMisfit(:,colI( 7)) + increment * 6, 'y*',...
        xNumber,cumuMisfit(:,colI( 8)) + increment * 7, 'm*',...
        xNumber,cumuMisfit(:,colI( 9)) + increment * 8, 'c+');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);
    set(pl( 6),'MarkerSize',17);
    set(pl( 7),'MarkerSize',[ 5]);
    set(pl( 8),'MarkerSize',[ 8]);
    set(pl( 9),'MarkerSize',[ 5]);

elseif loopNumber == 10
    [lastRow,colI] = sort(cumuMisfit(obsNum,:));
    pl = plot(xNumber,cumuMisfit(:,colI( 1)) + increment * 0, 'ro',...
        xNumber,cumuMisfit(:,colI( 2)) + increment * 1, 'yo',...
        xNumber,cumuMisfit(:,colI( 3)) + increment * 2, 'mo',...
        xNumber,cumuMisfit(:,colI( 4)) + increment * 3, 'c.',...
        xNumber,cumuMisfit(:,colI( 5)) + increment * 4, 'b.',...
        xNumber,cumuMisfit(:,colI( 6)) + increment * 5, 'r.',...
        xNumber,cumuMisfit(:,colI( 7)) + increment * 6, 'y*',...
        xNumber,cumuMisfit(:,colI( 8)) + increment * 7, 'm*',...
        xNumber,cumuMisfit(:,colI( 9)) + increment * 8, 'c+',...
        xNumber,cumuMisfit(:,colI(10)) + increment * 9, 'b+');
    set(pl( 1),'MarkerSize',[ 4]);
    set(pl( 2),'MarkerSize',[ 7]);
    set(pl( 3),'MarkerSize',10);
    set(pl( 4),'MarkerSize',[ 7]);
    set(pl( 5),'MarkerSize',12);
    set(pl( 6),'MarkerSize',17);
    set(pl( 7),'MarkerSize',[ 5]);
    set(pl( 8),'MarkerSize',[ 8]);
    set(pl( 9),'MarkerSize',[ 5]);
    set(pl(10),'MarkerSize',[ 8]);

end %if loopNumber
stress = stressPara.subset(colI);
grid;


%set(gca,'box','on',...
%        'SortMethod','childorder','TickDir','out','FontWeight',...
%        'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2);

xlabel('Number of Earthquake','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m);
ylabel('Cumulative Misfit ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m);
hold off;

done
