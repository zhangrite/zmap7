%function plotmima(var1)

report_this_filefun(mfilename('fullpath'));

global  a mi mif2 mif1 hndl3

%var1 = 4;
sc = get(hndl3,'Value');
figure

delete(gca);delete(gca);
rect = [0.15,  0.20, 0.75, 0.65];
axes('position',rect)
watchon

% check if cross-section exists
[existFlag,figNumber]=figure_exists('Cross -Section',1);
newMapWindowFlag=~existFlag;
if newMapWindowFlag
    errordlg('Please create a cross-section first, then rerun the last selection');
    nlammap
    return
end


% check if cross-section is still current
if max(mi(:,1)) > length(mi(:,1));
    errordlg('Please rerun the cross-section first, then rerun the last selection');
    nlammap
    return
end


mic = mi(inde,:);
le = length(newa(1,:));

if var1 == 1
    for i = 1:length(newa(:,6))
        pl =  plot(newa(i,le),-newa(i,7),'ro');
        hold on
        set(pl,'MarkerSize',mic(i,2)/sc)
    end

elseif var1 == 2

    for i = 1:length(newa(:,6))
        pl =  plot(newa(i,le),-newa(i,7),'bx');
        hold on
        set(pl,'MarkerSize',mic(i,2)/sc,'LineWidth',mic(i,2)/sc)
    end

elseif var1 == 3

    for i = 1:length(newa(:,6))
        pl =  plot(newa(i,le),-newa(i,7),'bx');
        hold on
        c = mic(i,2)/max(mic(:,2));
        %c = newa(i,15)*10;
        set(pl,'MarkerSize',mic(i,2)/sc+3,'LineWidth',mic(i,2)/sc+0.5,'Color',[ c c c ] )
    end

elseif var1 == 4

    g = jet;
    for i = 1:length(newa(:,6))
        pl =  plot(newa(i,le),-newa(i,7),'bx');
        hold on
        c = floor(mic(i,2)/max(mic(:,2))*63+1);
        set(pl,'MarkerSize',4,'LineWidth',2,'Color',[ g(c,:) ] )
    end
    colorbar
    colormap(jet)
end

if exist('maex', 'var')
    hold on
    pl = plot(maex,-maey,'*m');
    set(pl,'MarkerSize',8,'LineWidth',2)
end

if exist('maex', 'var')
    hold on
    pl = plot(maex,-maey,'*m');
    set(pl,'MarkerSize',8,'LineWidth',2)
end

xlabel('Distance [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
ylabel('Depth [km]','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
strib = [  'Misfit '];
title2(strib,'FontWeight','bold',...
    'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k')

 set(gca,'Color',color_bg);
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.2)
uicontrol(...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',[0.9 0.7 0.08 0.08],...
    'String','Grid',...
    'Callback','var1 = 1;mificrgr');

uicontrol(...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',[0.9 0.6 0.08 0.08],...
    'String','Sel EQ',...
    'Callback','pickinv');

matdraw

watchoff
