% Script: plot_McBwtime.m
%
% Script to plot Mc and b as a function of time using the bootstrap
% approach
% Uses the result matrix from calc_McBwtime
% last update: 14.02.2005
% J. Woessner

% Get input
if selt == 'in'
    % Initial values
    nSampleSize = 500;
    nOverlap = 4;
    nMethod = 1;
    nBstSample = 200;
    nMinNumberevents = 50;
    fBinning = 0.1;
    nWindowSize = 5;
    fMcCorr = 0;

    figure_w_normalized_uicontrolunits(...
        'Name','Mc Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','new', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ 200 200 500 200]);
    axis off

    % Input parameters
    % Get list of Mc computation possibilities
    [labelList2] = calc_Mc;
    %labelList2=[' Max. curvature (MAXC) |Fixed Mc (Mc = Mmin) | GFT-90% | GFT-95% | Best (?) combination (Mc95 - Mc90 - max curvature) | EMR-method | MBS-method (Shi) | MBS-method (Bst)'];
    labelPos = [0.08 0.86  0.8  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'Callback','nMethod = get(hndl2,''Value''); ');
    set(hndl2,'value',1);

    field1 = uicontrol('Style','edit',...
        'Position',[.35 .75 .12 .08],...
        'Units','normalized','String',num2str(nSampleSize),...
        'Callback','nSampleSize=str2double(get(field1,''String'')); set(field1,''String'',num2str(nSampleSize));');

    field2 = uicontrol('Style','edit',...
        'Position',[.35 .65 .12 .08],...
        'Units','normalized','String',num2str(nOverlap),...
        'Callback','nOverlap=str2double(get(field2,''String'')); set(field2,''String'',num2str(nOverlap));');

    field3 = uicontrol('Style','edit',...
        'Position',[.35 .55 .12 .08],...
        'Units','normalized','String',num2str(nBstSample),...
        'Callback','nBstSample=str2double(get(field3,''String'')); set(field3,''String'',num2str(nBstSample));');

    field4 = uicontrol('Style','edit',...
        'Position',[.35 .35 .12 .08],...
        'Units','normalized','String',num2str(fBinning),...
        'Callback','fBinning=str2double(get(field4,''String'')); set(field4,''String'',num2str(fBinning));');

    field5 = uicontrol('Style','edit',...
        'Position',[.35 .25 .12 .08],...
        'Units','normalized','String',num2str(nWindowSize),...
        'Callback','nWindowSize=str2double(get(field5,''String'')); set(field5,''String'',num2str(nWindowSize));');

    field6 = uicontrol('Style','edit',...
        'Position',[.35 .45 .12 .08],...
        'Units','normalized','String',num2str(fMcCorr),...
        'Callback','fMcCorr=str2double(get(field6,''String'')); set(field6,''String'',num2str(fMcCorr));');

    field7 = uicontrol('Style','edit',...
        'Position',[.7 .75 .12 .08],...
        'Units','normalized','String',num2str(nMinNumberevents),...
        'Callback','nMinNumberevents=str2double(get(field1,''String'')); set(field1,''String'',num2str(nMinNumberevents));');

    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Cancel');

    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'Callback',' inpr1 =get(hndl2,''Value'');close,selt =''ca'';, plot_McBwtime',...
        'String','Go');

    txt1 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.82 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String',' Sample window size');

    txt2 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.7 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String',' Overlap');

    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.58 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String',' Bootstraps');

    txt4 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.34 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String',' Binning');

    txt5 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.23 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String',' Smooth plot');

    txt6 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.01 0.46 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String','Mc correction');

    txt7 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.50 0.82 0 ],...
        'Rotation',0 ,...
        'HorizontalAlignment','Left',...
        'FontSize',ZmapGlobal.Data.fontsz.s ,...
        'FontWeight','bold',...
        'String','Minimum number');

    set(gcf,'visible','on');
    watchoff
end

if selt == 'ca'

    % Set minimum number to number of moving window
    %nMinNumberevents = nSampleSize;
    % Calulate time series
    [mResult] = calc_McBwtime(newt2, nSampleSize, nOverlap, nMethod, nBstSample, nMinNumberevents, fBinning,fMcCorr);

    % Plot Mc time series
    if sPar == 'mc'
        figure_w_normalized_uicontrolunits('tag','Mc time series', 'visible','on')
        mMc = filter(ones(1,nWindowSize)/nWindowSize,1,mResult(:,2));
        mMc(1:nWindowSize,1)=mResult(1:nWindowSize,2);
        mMcstd1 = filter(ones(1,nWindowSize)/nWindowSize,1,mResult(:,3));
        mMcstd1(1:nWindowSize,1)=mResult(1:nWindowSize,3);

        plot(mResult(:,1),mMc,'-','Linewidth',2,'Color',[0.2 0.2 0.2]);
        hold on;
        plot(mResult(:,1),mMc-mMcstd1,'-.','Linewidth',2,'Color',[0.5 0.5 0.5]);
        plot(mResult(:,1),mMc+mMcstd1,'-.','Linewidth',2,'Color',[0.5 0.5 0.5]);
        ylabel('Mc','Fontweight','bold','FontSize',12)
        set(gca,'tag','smooth_btime_n1000')
        %set(gca,'XTickLabel',[])
        xlim([(min(mResult(:,1))) (max(mResult(:,1)))])
        ylim([floor(min(mMc(:,1))) ceil(max(mMc(:,1)))])
        xlabel('Time / [dec. year]','Fontweight','bold','FontSize',12)% ylim([0.85 1.1])
        l1=legend('Mc','\delta Mc');
        %l1=legend('EMR','Std(EMR)','MaxM');
        set(l1,'Fontweight','bold')
        set(gca,'Fontweight','bold','FontSize',10,'Linewidth',2,'Tickdir','out')

    % Plot b time series
    else
        figure_w_normalized_uicontrolunits('tag','b-value time series', 'visible','on')
        mB = filter(ones(1,nWindowSize)/nWindowSize,1,mResult(:,4));
        mB(1:nWindowSize,1)=mResult(1:nWindowSize,4);
        mBstd1 = filter(ones(1,nWindowSize)/nWindowSize,1,mResult(:,3));
        mBstd1(1:nWindowSize,1)=mResult(1:nWindowSize,3);

        hp1=plot(mResult(:,1),mB,'-','Linewidth',2,'Color',[0.2 0.2 0.2]);
        hold on;
        hp2=plot(mResult(:,1),mB-mBstd1,'-.','Linewidth',2,'Color',[0.5 0.5 0.5]);
        plot(mResult(:,1),mB+mBstd1,'-.','Linewidth',2,'Color',[0.5 0.5 0.5]);
        ylabel('b-value','Fontweight','bold','FontSize',12)
        xlim([(min(mResult(:,1))) (max(mResult(:,1)))])
        ylim([floor(min(mB(:,1))) ceil(max(mB(:,1)))])
        xlabel('Time / [dec. year]','Fontweight','bold','FontSize',12)
        l1=legend([hp1 hp2],'b-value','\delta b');
        set(l1,'Fontweight','bold')
        set(gca,'Fontweight','bold','FontSize',10,'Linewidth',2,'Tickdir','out')
    end
end
