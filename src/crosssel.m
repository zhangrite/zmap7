function [newa2, pl]=crosssel(catalog)
    %crosssel select earthquakes in a cross-section and make them the current catalog in the main map window
    % [newa2, pl]=crosssel(catalog)
    % crosssel.m                      Alexander Allmann
    %
    % turned into function by Celso G Reyes 2017
    report_this_filefun();
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    figure(xsec_fig());
    
    %loop to pick points
    set(gca,'NextPlot','add')
    ax=findobj(gcf,'Tag','mainmap_ax');
    [x,y, mouse_points_overlay] = select_polygon(ax);
    

    plot(ax,x,y,'b-');
    YI = -catalog.Depth;          % this substitution just to make equation below simple
    XI = catalog(:,catalog.Count); % ??
    ll = polygon_filter(x,y, XI, YI, 'inside');
    
    newa2 = catalog.subset(ll);
    pl=plot( newa2(:,newa2.Count), -newa2.Depth,'xk')
    
end
