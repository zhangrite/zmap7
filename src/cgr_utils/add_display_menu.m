function add_display_menu(version)
    % adds a display menu to the current figure
    %
    % appently mostly used by the view_  functions
    
    % when called, hzma is the current axes;
    
    
    switch version
        case 1
            op2e = uimenu('Label','Display');
            uimenu(op2e,'Label','Fix color (z) scale', 'Callback','fixax2 ');
            uimenu(op2e,'Label','Plot Map in lambert projection using m_map ', 'Callback','plotmap ');
            uimenu(op2e,'Label','Show Grid ',...
                'Callback','hold on;plot(newgri(:,1),newgri(:,2),''+k'')');
            uimenu(op2e,'Label','Show Circles ', 'Callback','plotci2');
            uimenu(op2e,'Label','Colormap InvertGray',...
                'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)');
            uimenu(op2e,'Label','Colormap Invertjet',...
                'Callback','g=jet; g = g(64:-1:1,:);colormap(g)');
            uimenu(op2e,'Label','shading flat',...
                'Callback','axes(hzma); shading flat;sha=''fl'';');
            uimenu(op2e,'Label','shading interpolated',...
                'Callback','axes(hzma); shading interp;sha=''in'';');
            uimenu(op2e,'Label','Brigten +0.4',...
                'Callback','axes(hzma); brighten(0.4)');
            uimenu(op2e,'Label','Brigten -0.4',...
                'Callback','axes(hzma); brighten(-0.4)');
            uimenu(op2e,'Label','Redraw Overlay',...
                'Callback','hold on;overlay');
        case 2
            op2e = uimenu('Label',' Display ');
            uimenu(op2e,'Label','Fix color (z) scale', 'Callback','fixax_vertical'); % this one is different from case#1
            uimenu(op2e,'Label','Plot Map in lambert projection using m_map ', 'Callback','plotmap ');
            uimenu(op2e,'Label','Show Grid ',...
                'Callback','hold on;plot(newgri(:,1),newgri(:,2),''+k'')');
            uimenu(op2e,'Label','Show Circles ', 'Callback','plotci2');
            uimenu(op2e,'Label','Colormap InvertGray',...
                'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)');
            uimenu(op2e,'Label','Colormap Invertjet',...
                'Callback','g=jet; g = g(64:-1:1,:);colormap(g)');
            uimenu(op2e,'Label','shading flat',...
                'Callback','axes(hzma); shading flat;sha=''fl'';');
            uimenu(op2e,'Label','shading interpolated',...
                'Callback','axes(hzma); shading interp;sha=''in'';');
            uimenu(op2e,'Label','Brigten +0.4',...
                'Callback','axes(hzma); brighten(0.4)');
            uimenu(op2e,'Label','Brigten -0.4',...
                'Callback','axes(hzma); brighten(-0.4)');
            uimenu(op2e,'Label','Redraw Overlay',...
                'Callback','hold on;overlay');
        case 3
            op2e = uimenu('Label',' Display ');
            uimenu(op2e,'Label','Fix color (z) scale', 'Callback','fixax2 ');
            uimenu(op2e,'Label','Show Grid ',...
                'Callback','hold on;plot(newgri(:,1),newgri(:,2),''+k'')');
            uimenu(op2e,'Label','Show Circles ', 'Callback','plotci3'); %this one is different from case #1
            uimenu(op2e,'Label','Colormap InvertGray',...
                'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)');
            uimenu(op2e,'Label','Colormap Invertjet',...
                'Callback','g=jet; g = g(64:-1:1,:);colormap(g)');
            uimenu(op2e,'Label','shading flat',...
                'Callback','axes(hzma); shading flat;sha=''fl'';');
            uimenu(op2e,'Label','shading interpolated',...
                'Callback','axes(hzma); shading interp;sha=''in'';');
            uimenu(op2e,'Label','Brigten +0.4',...
                'Callback','axes(hzma); brighten(0.4)');
            uimenu(op2e,'Label','Brigten -0.4',...
                'Callback','axes(hzma); brighten(-0.4)');
            uimenu(op2e,'Label','Redraw Overlay',...
                'Callback','hold on;overlay_'); % this is also different
        case 4
            op2e = uimenu('Label',' Display ');
            uimenu(op2e,'Label','Fix color (z) scale', 'Callback','fixax2 ')
            uimenu(op2e,'Label','Plot Map in lambert projection using m_map ', 'Callback','plotmap ')
            uimenu(op2e,'Label','Plot map on top of topography (white background)',...
                'Callback','colback = 1; dramap2_z'); % this is different from case #1
            uimenu(op2e,'Label','Plot map on top of topography (black background)',...
                'Callback','colback = 2; dramap2_z'); % this is different from case #1
            uimenu(op2e,'Label','Show Grid ',...
                'Callback','hold on;plot(newgri(:,1),newgri(:,2),''+k'')')
            uimenu(op2e,'Label','Show Circles ', 'Callback','plotci2')
            uimenu(op2e,'Label','Colormap InvertGray',...
                'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)')
            uimenu(op2e,'Label','Colormap Invertjet',...
                'Callback','g=jet; g = g(64:-1:1,:);colormap(g)')
            uimenu(op2e,'Label','shading flat',...
                'Callback','axes(hzma); shading flat;sha=''fl'';')
            uimenu(op2e,'Label','shading interpolated',...
                'Callback','axes(hzma); shading interp;sha=''in'';')
            uimenu(op2e,'Label','Brigten +0.4',...
                'Callback','axes(hzma); brighten(0.4)')
            uimenu(op2e,'Label','Brigten -0.4',...
                'Callback','axes(hzma); brighten(-0.4)')
            uimenu(op2e,'Label','Redraw Overlay',...
                'Callback','hold on;overlay')
        case 5
            
            op2e = uimenu('Label',' Display ');
            uimenu(op2e,'Label','Fix color (z) scale', 'Callback','fixax2 ')
            uimenu(op2e,'Label','Show Grid ',...
                'Callback','hold on;plot(newgri(:,1),newgri(:,2),''+k'')')
            uimenu(op2e,'Label','Show Circles ', 'Callback','plotci2')
            uimenu(op2e,'Label','Colormap InvertGray',...
                'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)')
            uimenu(op2e,'Label','Colormap Invertjet',...
                'Callback','g=jet; g = g(64:-1:1,:);colormap(g)')
            uimenu(op2e,'Label','shading flat',...
                'Callback','axes(hzma); shading flat;sha=''fl'';')
            uimenu(op2e,'Label','shading interpolated',...
                'Callback','axes(hzma); shading interp;sha=''in'';')
            uimenu(op2e,'Label','Brigten +0.4',...
                'Callback','axes(hzma); brighten(0.4)')
            uimenu(op2e,'Label','Brigten -0.4',...
                'Callback','axes(hzma); brighten(-0.4)')
            uimenu(op2e,'Label','Redraw Overlay',...
                'Callback','hold on;overlay_'); % this is different from case #1
    end
end