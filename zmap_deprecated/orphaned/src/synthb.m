%This is synthetic219
%This program generates a synthetic catalog of given total number of events, b-value, minimum magnitude,
%and magnitude increment.
%The synthetic catalog will be sotred in a file "synt.mat"
% Yuzo Toya 2/1999

report_this_filefun(mfilename('fullpath'));

TN = length(a);%total number of events
B = 1 ;%b-value
IM= 1;%starting magnitude (hypothetical Mc)
inc = 0.1 ;%magnitude increment
define = {num2str(TN),num2str(B),num2str(IM),num2str(inc)};
title2 ='Synthetic Catalog';
prompt={
    'total number of events',...
    'b-value',...
    'hypothetical Mc',...
    'increment along magnitude axis',...
    };
qq = inputdlg(prompt,title2,1,define);
l = qq{1}; TN= str2double(l);
l = qq{2}; B= str2double(l);
l = qq{3}; IM= str2double(l);
l = qq{4}; inc= str2double(l);

%  Create new figure
% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('Synthetic Catalog');
newsyntFlag=~existFlag;
if newsyntFlag,
    syntf=figure_w_normalized_uicontrolunits( ...
        'Name','Synthetic Catalog',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','replace', ...
        'backingstore','on',...
        'Visible','off', ...
        'Position',[10 20 500 500]);
    %        'Position',[ 0 300 (ZmapGlobal.Data.map_len - [275 200]) ]);
    %        'Position',[ 50 650 (ZmapGlobal.Data.map_len - [250 170]) ]);
    matdraw;
else
    figure_w_normalized_uicontrolunits(syntf);
    delete(gcf);
    matdraw;
end
hold on;
figure_w_normalized_uicontrolunits(syntf);
delete(gca);
delete(gca);
reset(gca);
cla;
hold off;
watchon;


% log10(N)=A-B*M
M=[IM:inc:10];
N=10.^(log10(TN)-B*(M-IM));
aval=(log10(TN)-B*(0-IM));
N=round(N);
%N=floor(N);
%N=ceil(N);

syn = ones(TN,9)*nan;
new = ones(TN,1)*nan;

%[ttt,indt]=sortrows(new,3);
%new=ttt;
%new=a
ct1=1;
while N(ct1+1)~=0
    ct1=ct1+1;
end
ctM=M(ct1);
count=0;
ct=0;
swt=0;
sc=0;
for I=IM:inc:ctM;
    ct=ct+1;
    if I~=ctM
        for sc=1:(N(ct)-N(ct+1))
            count=count+1;
            new(count)=I;
        end
    else
        count=count+1;
        new(count)=I;
    end
end
%end
count
TN
figure_w_normalized_uicontrolunits(syntf);
axis off;
text(.3,.5,'Please Wait ...');
text(.3,.4,'Generating a Synthetic Catalog');

PM=M(1:ct);
PN=log10(N(1:ct));
figure_w_normalized_uicontrolunits(syntf);
plot(PM,PN);
xleb=xlabel('Magnitude');
set(xleb,'FontSize',12);
yleb=ylabel('Cumulative Frequency (10^#)');
set(yleb,'FontSize',12);
text(.7*max(PM),.9*max(PN),['target b-value: ' num2str(B,4)])
text(.7*max(PM),.8*max(PN),['targeta-value: ' num2str(aval,4)])
rng('shuffle');
l=rand(length(new),1);
[ii, is] =sort(l);
tmpo=new(is);
syn(:,6)=tmpo(1:TN);

rng('shuffle');
%if TN==length(a)
%	syn(:,3)=rand(TN,1)*(max(a.Date-min(a.Date)))  + min(a.Date);
%	syn(:,1)=a.Longitude;
%	syn(:,2)=a.Latitude;
%	syn(:,7)=a.Depth;
%else
syn(:,3)=rand(TN,1)*(max(a.Date-min(a.Date)))  + min(a.Date);
syn(:,1)=rand(TN,1)*(max(a.Longitude-min(a.Longitude)))  + min(a.Longitude);
syn(:,2)=rand(TN,1)*(max(a.Latitude-min(a.Latitude)))  + min(a.Latitude);
syn(:,7)=rand(TN,1)*(max(a.Depth-min(a.Depth)))  + min(a.Depth);
%The ranges of random generation for hours and minutes were increased, because this random generator
%seems to generate non-random numbers near the boundaries (max and min values).
rng('shuffle');
%	synh=rand(TN*2,1)*(30)+(-4);
%   synm=rand(TN*2,1)*(70)+(-10);
%   l=synh>=0 & synh<24;
%   synh2=synh(l);
%   lnn=
%   syn(:,8)=synh2(1:TN);
%   l=synm>=0 & synm<60;
%   synm2=synm(l);
%   syn(:,9)=synm2(1:TN);
%   clear synh;%clear synh2;%clear synm;%clear synm2;%clear l;
syn(:,8)=rand(TN,1)*(24)+0;
syn(:,9)=rand(TN,1)*(60)+0;
%end
%changing decimal year to year,month,day,hour,minute.

for I=1:TN
    tdays=zeros(12,2);
    tdays(:,1)=transpose([31 59 90 120 151 181 212 243 273 304 334 365]);
    tdays(:,2)=transpose([31 60 91 121 152 182 213 244 274 305 335 366]);
    swt=0;
    if (floor(syn(I,3))>=100);
        yrr=floor(syn(I,3));
    elseif (floor(syn(I,3))<=99)
        yrr=floor(syn(I,3))+1900;
    else
        yrr=floor(syn(I,3))+2000;      disp('Y3K problem?');
    end

    % This routine is from /matlab/toolbox/finance/calendar/yeardays.m
    % (For some reason, the routine did not run well on SUN, so I copied it here.)
    mts_dys = ones(size(yrr));      % Month and day values to pass to datenum function
    next_y = yrr+1;                 % Next year values
    first = datenum(yrr,mts_dys,mts_dys);      % Start date
    last = datenum(next_y,mts_dys,mts_dys);    % End date
    yrdys = last-first;
    %
    %      yrdys=yeardays(yrr);

    dys=(syn(I,3)-floor(syn(I,3)))*yrdys;
    feb=28+(yrdys-365);
    if feb==29
        swt=2;
    elseif feb==28
        swt=1;
    else
        disp('error in dates');
    end
    if dys<=tdays(1,swt)
        moo=1;
        dayy=floor(dys);
        %        hrr=floor((dys-dayy)*24);
        %        minn=round(((dys-dayy)*24-hrr)*60);
    elseif dys>tdays(1,swt)  &&  dys<=tdays(2,swt)
        moo=2;
        dayy=floor(dys-tdays(1,swt));
        %        hrr=floor((dys-dayy-tdays(1,swt))*24);
        %        minn=round(((dys-dayy-tdays(1,swt))*24-hrr)*60);
    elseif dys>tdays(2,swt)  &&  dys<=tdays(3,swt)
        moo=3;
        dayy=floor(dys-tdays(2,swt));
        %        hrr=floor((dys-tdays(2,swt)-dayy)*24);
        %        minn=round(((dys-tdays(2,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(3,swt)  &&  dys<=tdays(4,swt)
        moo=4;
        dayy=floor(dys-tdays(3,swt));
        %        hrr=floor((dys-tdays(3,swt)-dayy)*24);
        %        minn=round(((dys-tdays(3,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(4,swt)  &&  dys<=tdays(5,swt)
        moo=5;
        dayy=floor(dys-tdays(4,swt));
        %        hrr=floor((dys-tdays(4,swt)-dayy)*24);
        %        minn=round(((dys-tdays(4,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(5,swt)  &&  dys<=tdays(6,swt)
        moo=6;
        dayy=floor(dys-tdays(5,swt));
        %        hrr=floor((dys-tdays(5,swt)-dayy)*24);
        %        minn=round(((dys-tdays(5,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(6,swt)  &&  dys<=tdays(7,swt)
        moo=7;
        dayy=floor(dys-tdays(6,swt));
        %        hrr=floor((dys-tdays(6,swt)-dayy)*24);
        %        minn=round(((dys-tdays(6,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(7,swt)  &&  dys<=tdays(8,swt)
        moo=8;
        dayy=floor(dys-tdays(7,swt));
        %        hrr=floor((dys-tdays(7,swt)-dayy)*24);
        %        minn=round(((dys-tdays(7,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(8,swt)  &&  dys<=tdays(9,swt)
        moo=9;
        dayy=floor(dys-tdays(8,swt));
        %        hrr=floor((dys-tdays(8,swt)-dayy)*24);
        %        minn=round(((dys-tdays(8,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(9,swt)  &&  dys<=tdays(10,swt)
        moo=10;
        dayy=floor(dys-tdays(9,swt));
        %        hrr=floor((dys-tdays(9,swt)-dayy)*24);
        %        minn=round(((dys-tdays(9,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(10,swt)  &&  dys<=tdays(11,swt)
        moo=11;
        dayy=floor(dys-tdays(10,swt));
        %        hrr=floor((dys-tdays(10,swt)-dayy)*24);
        %        minn=round(((dys-tdays(10,swt)-dayy)*24-hrr)*60);
    elseif dys>tdays(11,swt)  &&  dys<=tdays(12,swt)
        moo=12;
        dayy=floor(dys-tdays(11,swt));
        %        hrr=floor((dys-tdays(11,swt)-dayy)*24);
        %        minn=round(((dys-tdays(11,swt)-dayy)*24-hrr)*60);
    else
        disp('error in dates');
    end
    syn(I,3)=floor(syn(I,3));
    syn(I,4)=moo;
    syn(I,5)=dayy;
end
[ttt,indt]=sortrows(syn,3);
synt=ttt;
aa=a;
a=synt;
a = ZmapCatalog(a); % col 3 was just year, not decyear
a.sort('Date');

str = [];

clear s
return

a=aa ;
done

