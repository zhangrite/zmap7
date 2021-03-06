function [catalog, OK] = zdataimport()
    % ZDATAIMPORT imports a ZmapCatalog from any format provided in the 'importfilters' directory
    % 
    % turned into function by Celso G Reyes 2017
    OK = false;
    catalog = ZmapCatalog();
    
    % start filters
    
    [catalog] = import_start(fullfile(ZmapGlobal.Data.hodi, 'importfilters'));
    if isnumeric(catalog) && all(isnan(catalog(:)))
        % import cancelled / failed
        return
    end
    if isnumeric(catalog)
        catalog=ZmapCatalog(catalog);
    end
    OK= ~isempty(catalog);
    disp(['Catalog loaded with ' num2str(catalog.Count) ' events ']);
    
end
