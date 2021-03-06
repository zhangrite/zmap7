function bwithmag(catalog) 
    % calculate b-value with magnitude
    
    % turned into function by Celso G Reyes 2017
    
    report_this_filefun();
    myFigName='b-value with magnitude';
    BV = [];
    BV3 = [];
    mag = [];
    me = [];
    av2=[];
    Nmin = 20;
    
    
    newt1=catalog;
    newt1.sort('Magnitude');
    
    for t = min(newt1.Magnitude):0.1:max(newt1.Magnitude)
        % calculate b-value based an weighted LS
        l = newt1.Magnitude >= t -0.05;
        b = newt1.subset(l);
        
        if b.Count >= Nmin
            [bv, magco, stan, av] =  bvalca3(b.Magnitude, McAutoEstimate.manual);
            [bv, stan2, av] = calc_bmemag(b.Magnitude, 0.1);
            
        else
            [bv, bv2, magco, av, av2] = deal(nan);
        end
        BV3 = [BV3 ; bv t stan ];
        
    end
    
    watchoff
    
    % Find out if figure already exists
    %
    bdep=findobj('Type','Figure','-and','Name',myFigName);
    % Set up the Cumulative Number window
    
    if isempty(bdep)
        bdep = figure_w_normalized_uicontrolunits( ...
            'Name',myFigName,...
            'NumberTitle','off', ...
            'NextPlot','add', ...
            'backingstore','on',...
            'Visible','on', ...
            'Position',[ 150 150 600 500]);
    end
    
    figure(bdep);
    delete(findobj(bdep,'Type','axes'));
    axis off
    set(gca,'NextPlot','add')
    orient tall
    rect = [0.15 0.15 0.7 0.7];
    axes('position',rect)
    ple = errorbar(BV3(:,2),BV3(:,1),BV3(:,3),BV3(:,3),'k')
    set(ple(1),'color',[0.5 0.5 0.5]);
    
    set(gca,'NextPlot','add')
    
    pl = plot(BV3(:,2),BV3(:,1),'sk')
    
    set(pl,'LineWidth',1.0,'MarkerSize',4,...
        'MarkerFaceColor','w','MarkerEdgeColor','k','Marker','s');
    
    set(gca,'box','on',...
        'SortMethod','childorder','TickDir','out','FontWeight',...
        'bold','FontSize',ZmapGlobal.Data.fontsz.m,'Linewidth',1,'Ticklength',[ 0.02 0.02])
    
    bax = gca;
    %ni doesn't seem to have a place here:
    strib = [catalog.Name ', Mmin = ' num2str(min(catalog.Magnitude)) ];
    ylabel('b-value')
    xlabel('Magnitude')
    title(strib,'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m,...
        'Interpreter','none',...
        'Color','k')
    
    xl = get(gca,'Xlim');
    
end
