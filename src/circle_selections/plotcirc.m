function plotcirc() 
    %  plot a circle containing ni events
    %  around each grid point
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun();
    
    st = 2;
    [X,Y] = meshgrid(gx,gy);
    [m,n]= size(r);
    set(gca,'NextPlot','add')
    x = -pi-0.1:0.1:pi;
    for i = 1:st:m
        for k = 1:st:n
            if r(i,k) <= ZG.tresh_km
                plot(X(i,k)+r(i,k)*sin(x),Y(i,k)+r(i,k)*cos(x),'b')
                plot(X(i,k),Y(i,k),'+k')
            end
        end
    end
    
end
