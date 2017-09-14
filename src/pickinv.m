function pickinv() % autogenerated function wrapper
    %function crosssel
    % crosssel.m                      Alexander Allmann
    % function to select earthquakes in a cross-section and make them the
    % current catalog in the main map windo
    %
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    global xsec_fig h2 newa newa2
    
    report_this_filefun(mfilename('fullpath'));
    ZG=ZmapGlobal.Data;
    
    figure(gcf);
    
    %loop to pick points
    %axes(h2)
    hold on
    
    ax = findobj('Tag','mainmap_ax');
    [x,y, mouse_points_overlay] = select_polygon(ax);
    
    plot(x,y,'b-');
    YI = -newa.Depth;          % this substitution just to make equation below simple
    XI = newa(:,newa.Count); % ??
    ll = polygon_filter(x,y, XI, YI, 'inside');
    
    newa2 = newa.subset(ll);
    plot( newa2(:,newa2.Count), -newa2.Depth,'xk')
    ZG.newt2=newa2;
    ZG.newcat=newa2;
    timeplot(ZG.newt2);
end
