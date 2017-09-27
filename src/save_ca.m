function save_ca() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    str = [];
    [newmatfile, newpath] = uiputfile([ ZmapGlobal.Data.out_dir '*.dat'], 'Save As');  %Syntax change in the Matlab Version 7, window positiobibg does not functioning on a mac
    
    s = [ZG.primeCatalog.Longitude   ZG.primeCatalog.Latitude  ZG.primeCatalog.Date.Year  ZG.primeCatalog.Date.Month...
        ZG.primeCatalog.Date.Day  ZG.primeCatalog.Magnitude  ZG.primeCatalog.Depth ZG.primeCatalog.Date.Hour ZG.primeCatalog.Date.Minute  ];
    fid = fopen([newpath newmatfile],'w') ;
    fprintf(fid,'%8.3f   %7.3f %4.0f %6.0f  %6.0f %6.1f %6.2f  %6.0f  %6.0f\n',s');
    fclose(fid);
    clear s
    return
    
end
