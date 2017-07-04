% ZMAP script show_map.m. Creates Dialog boxes for Z-map calculation
% does the calculation and makes displays the map
% stefan wiemer 11/94
%
% make dialog interface and call maxzlta
%

% Input Rubberband
%
report_this_filefun(mfilename('fullpath'));

if in2 ~= 'calma'

    %initial values
    nustep = 10;
    iwl3 = 1.5;
    it = t0b +1;
    figure_w_normalized_uicontrolunits(mess)
    clf
    set(gca,'visible','off')
    set(gcf,'Units','pixel','NumberTitle','off','Name','Input Parameters');

    set(gcf,'pos',[ wex  wey welx+200 wely-50])


    % creates a dialog box to input some parameters
    %

    inp2_field=uicontrol('Style','edit',...
        'Position',[.80 .80 .18 .15],...
        'Units','normalized','String',num2str(nustep),...
        'Callback','nustep=str2double(get(inp2_field,''String'')); set(inp2_field,''String'',num2str(nustep));');

    txt2 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.9 0 ],...
        'Rotation',0 ,...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Please input Number of Frames:');

    if in == 'rub' | in == 'lta'

        txt3 = text(...
            'Color',[0 0 0 ],...
            'EraseMode','normal',...
            'Position',[0. 0.65 0 ],...
            'Rotation',0 ,...
            'FontWeight','bold',...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'String','Please input window length in years (e.g. 1.5):');
        inp3_field=uicontrol('Style','edit',...
            'Position',[.80 .575 .18 .15],...
            'Units','normalized','String',num2str(iwl2),...
            'Callback','iwl2=str2double(get(inp3_field,''String'')); set(inp3_field,''String'',num2str(iwl2));');

    end   % if in = rub

    close_button=uicontrol('Style','Pushbutton',...
        'Position', [.60 .05 .15 .15 ],...
        'Units','normalized','Callback','welcome','String','Cancel');

    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.25 .05 .15 .15 ],...
        'Units','normalized',...
        'Callback','nustep=str2num(get(inp2_field,''String''));iwl2=str2num(get(inp3_field,''String''));welcome,think,watchon;drawnow,in2 = ''calma'';fixaxmo;',...
        'String','Go');

    set(gcf,'visible','on');watchoff

    % do the calculations:
    %

else     % if in2 ~=calma

    % check if time are with limits
    %


    % initial parameter
    iwl = iwl2* 365/par1; ti = (it -t0b)*365/par1;
    var1 = zeros(1,ncu);
    var2 = zeros(1,ncu);
    mean1 = zeros(1,ncu);
    mean2 = zeros(1,ncu);
    as = zeros(1,ncu);
    [len, ncu] = size(cumuall); len = len-2;
    len = len -2;
    step = len/nustep;


    % loop over all frames

    j = 0;
    figure
    rect = [0.10 0.30 0.55 0.50 ];
    rect1 = rect;
    axes('position',rect1)
    axis('off')
    m = moviein(length(1:step:len-iwl));
    for ti = iwl:step:len-iwl;
        j = j+1

        var1 = zeros(1,ncu);
        var2 = zeros(1,ncu);
        mean1 = zeros(1,ncu);
        mean2 = zeros(1,ncu);
        as = zeros(1,ncu);

        % loop over all grid points for percent
        %
        %
        if in =='per'

            for i = 1:ncu
                mean1(i) = mean(cumuall(1:ti,i));
                mean2(i) = mean(cumuall(ti:len,i));
            end    %for i
            as = -((mean1-mean2)./mean1)*100;

            strib = 'Change in Percent';
            stri2 = ['ti=' num2str(ti*par1/365 + t0b)  ];



        end  % if in = = per

        % loop over all point for rubber band
        %
        if in =='rub'

            for i = 1:ncu
                mean1(i) = mean(cumuall(1:ti,i));
                mean2(i) = mean(cumuall(ti+1:ti+iwl,i));
                var1(i) = cov(cumuall(1:ti,i));
                var2(i) = cov(cumuall(ti+1:ti+iwl,i));
            end %  for i ;
            as = (mean1 - mean2)./(sqrt(var1/ti+var2/iwl));

        end % if in = rub

        % make the AST function map
        if in =='ast'
            for i = 1:ncu
                mean1(i) = mean(cumuall(1:ti,i));
                var1(i) = cov(cumuall(1:ti,i));
                mean2(i) = mean(cumuall(ti+1:len,i));
                var2(i) = cov(cumuall(ti+1:len,i));
            end    %for i
            as = (mean1 - mean2)./(sqrt(var1/ti+var2/(len-ti)));
        end % if in = ast

        if in =='lta'
            disp('Calculate LTA')
            %cu = [cumuall(1:ti-1,:) ; cumuall(ti+iwl+1:len,:)];
            mean1 = mean([cumuall(1:ti-1,:) ; cumuall(ti+iwl+1:len,:)]);
            mean2 = mean(cumuall(ti:ti+iwl,:));
            for i = 1:ncu
                var1(i) = cov([cumuall(1:ti-1,i) ; cumuall(ti+iwl+1:len,i)]);
                var2(i) = cov(cumuall(ti:ti+iwl,i));
            end     % for i
            as = (mean1 - mean2)./(sqrt(var1/(len-iwl)+var2/iwl));
        end % if in = lta


        normlap1=ones(length(tmpgri(:,1)),1)*nan;
        normlap2=ones(length(tmpgri(:,1)),1)*nan;
        normlap2(ll)= as(:);
        %construct a matrix for the color plot
        re3=reshape(normlap2,length(yvect),length(xvect));


        %plot imge
        % set values gretaer tresh = nan
        %
        re4 = re3;
        [len, ncu] = size(cumuall);
        [n1, n2] = size(cumuall);
        s = cumuall(n1,:);
        normlap2(ll)= s(:);
        r=reshape(normlap2,length(yvect),length(xvect));
        l = r > tresh;
        re4(l) = zeros(1,length(find(l)))*nan;

        orient landscape
        set(gcf,'PaperPosition',[ 0.1 0.1 8 6])
        axes('position',rect1)
        hold on
        pco1 = pcolor(gx,gy,re4);
        caxis([minc maxc]);
        axis([ s2 s1 s4 s3])
        hold on
        %overlay
        if in == 'ast'
            tx2 = text(0.07,0.85 ,['AS; t=' num2str(ti*par1/365+t0b)  ] ,...
                'Units','Norm','FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','bold');
        end

        if in == 'lta'
            tx2 = text(0.07,0.85 ,['LTA; t=' num2str(ti*par1/365+t0b)  ] ,...
                'Units','Norm','FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','bold');
        end

        if in == 'rub'
            tx2 = text(0.07,0.85 ,['RUB; t=' num2str(ti*par1/365+t0b)  ] ,...
                'Units','Norm','FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','bold');
        end

        set(gca,'FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
            'FontWeight','bold','LineWidth',1.5,...
            'Box','on','SortMethod','childorder')


        shading interp
        has = gca;
        disp('now getting frame...')
        m(:,j) = getframe(has);
        delete(gca);delete(gca);delete(gca)
        fs = get(gcf,'pos');

    end  % loop over frames

    close(gcf)

    showmovi
end   % if calma ~| in2

