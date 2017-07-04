report_this_filefun(mfilename('fullpath'));

BV = [];
BV3 = [];
mag = [];
me = [];
av2=[];
Nmin = 20;


think
[s,is] = sort(newt2.Magnitude);
newt1 = newt2(is(:,1),:) ;
watchon;

for t = min(newt1(:,6)):0.1:max(newt1(:,6))
    % calculate b-value based an weighted LS
    l = newt1(:,6) >= t -0.05;
    b = newt1(l,:);

    if length(b(:,1)) >= Nmin
        [bv magco stan av me mer me2,  pr] =  bvalca3(b,2,2);
        [mea bv stan2,  av] =  bmemag(b);

    else
        bv = nan; bv2 = nan, magco = nan; av = nan; av2 = nan;
    end
    BV3 = [BV3 ; bv t stan ];

end

watchoff

% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('b-value with magnitude',1);
newdepWindowFlag=~existFlag;
bdep= figNumber;

% Set up the Cumulative Number window

if newdepWindowFlag
    bdep = figure_w_normalized_uicontrolunits( ...
        'Name','b-value with magnitude',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','add', ...
        'backingstore','on',...
        'Visible','on', ...
        'Position',[ 150 150 600 500]);

    

    matdraw
end

figure_w_normalized_uicontrolunits(bdep)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
hold off

axis off
hold on
orient tall
%rect = [0.15 0.65 0.7 0.25];
rect = [0.15 0.15 0.7 0.7];
axes('position',rect)
ple = errorbar(BV3(:,2),BV3(:,1),BV3(:,3),BV3(:,3),'k')
set(ple(1),'color',[0.5 0.5 0.5]);

hold on

pl = plot(BV3(:,2),BV3(:,1),'sk')

set(pl,'LineWidth',1.0,'MarkerSize',4,...
    'MarkerFaceColor','w','MarkerEdgeColor','k','Marker','s');

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1.,'Ticklength',[ 0.02 0.02])

bax = gca;
strib = [name ', ni = ' num2str(ni), ', Mmin = ' num2str(min(newt2.Magnitude)) ];
ylabel('b-value')
xlabel('Magnitude')
title(strib,'FontWeight','bold',...
    'FontSize',ZmapGlobal.Data.fontsz.m,...
    'Color','k')

xl = get(gca,'Xlim');
