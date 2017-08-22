function loadgrid() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    cupa = cd;
    try
        delete(pd);
    catch ME
        error_handler(ME, @do_nothing);
    end
    
    [file1,path1] = uigetfile(['*.mat'],'Gridfile');
    
    if length(path1) > 1
        think
        load([path1 file1])
        
        figure(map);
        d =  [min(gx) min(gy) ; min(gx) max(gy) ; max(gx) max(gy) ; max(gx) min(gy); min(gx) min(gy)];
        
        storedcat=a;
        update(mainmap());
        pl = plot(newgri(:,1),newgri(:,2),'+k');
        set(pl,'MarkerSize',8,'LineWidth',1)
        
        %pd = plot(d(:,1),d(:,2),'r-')
        zmapmenu
    else
        return
    end
    
end
