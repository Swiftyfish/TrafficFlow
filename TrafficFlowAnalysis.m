%% Standard program, multiple lanes
clear all
% Main Variables
density=0.8;
RoadLength=100;
T=1000;
vmax=5;
pslow=0.5;
pReturn=0.8;
NLanes=5;
%Starting Positions
[PosStart,NCars]=StartPos2(density,RoadLength);
VMax=vmax.*ones(1,NCars);
PSlow=pslow.*ones(1,NCars);
PReturn=pReturn*ones(1,NCars);
%Initialisation runthrough
[P,V,L]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,RoadLength*10,PosStart,NLanes);
PosStart=P(end,:);
PosStart(2,:)=V(end,:);
PosStart(3,:)=L(end,:);
% Main simulation
[PosPlot,VelPlot,LanePlot]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,T,PosStart,NLanes);
VBar=mean(VelPlot(:))*density;
%% Spacetime Plot of standard program
% To be used with data from one lane simulations
sqrplot(T,RoadLength,PosPlot,VelPlot)
axis on
axis([0 RoadLength 0 T])
set (gca,'ydir','reverse')
xlabel('Position (Sites)')
ylabel('Time (Timesteps)')
%% Animation
% Takes PosPlot, VelPlot and LanePlot to produce animated plot
for t=1:T
    RoadWidth=2*NLanes+1;
    SiteOcc=zeros(RoadWidth,RoadLength);
    SiteVel=zeros(RoadWidth,RoadLength);
    Pos=PosPlot(t+1,:);
    Lane=LanePlot(t+1,:);
    Vel=VelPlot(t+1,:)+1;
    for i=1:NLanes
        logLane(i,:)=Lane==i;
        N(i)=sum(logLane(i,:));
        PosLane{i}=Pos(logLane(i,:));
        VelLane{i}=Vel(logLane(i,:));
    end
    for j=1:NLanes
        RoadLane=2*j;
        SiteOcc(RoadLane,PosLane{j})=1;
        SiteVel(RoadLane,PosLane{j})=VelLane{j};
    end
    imagesc(SiteVel)
    colormap([0,0,0;parula(5)])
    colorbar
    axis equal
    axis([0 RoadLength 0 RoadWidth])
    set(gca,'ytick',[])
    xlabel('Position (Sites)')
    pause(0.2)
end
%% Varying Density, only one lane(slightly more efficient)
clear all
%Variable Setup
pslow=0.5;
RoadLength=250;
T=100;
vmax=5;
N=250;
VBar=zeros(1,N);
for i=1:N
    idx=i;
    density=i/N;
    %Starting Positions
    [PosStart,NCars]=StartPos(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    % Initialisation runthrough
    [P,V]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,RoadLength,PosStart);
    PosStart(1,:)=P(end,:);
    PosStart(2,:)=V(end,:);
    %Main simulation
    [PosPlot,VelPlot]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,T,PosStart);
    VBar(idx)=mean(VelPlot(:))*density;
    disp(density)
end
k=1/N:1/N:1;
plot(k,VBar,'k.')
%% Changing Density, one lane,combination of low res and high res plots
clear all
pslow=0.5;
RoadLength=500;
T=100;
vmax=5;
N=500;
VBar1=zeros(1,N);
for i=1:N
    idx=i;
    density=i/N;
    [PosStart,NCars]=StartPos(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    [P,V]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,RoadLength,PosStart);
    PosStart(1,:)=P(end,:);
    PosStart(2,:)=V(end,:);
    [PosPlot,VelPlot]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,T,PosStart);
    VBar1(idx)=mean(VelPlot(:))*density;
    disp(density)
end
k=1/N:1/N:1;
hold on
plot(k,VBar1,'k.')
T=1000;
N=100;
VBar2=zeros(1,N);
for i=1:N
    idx=i;
    density=i/N;
    [PosStart,NCars]=StartPos(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    [P,V]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,1*RoadLength,PosStart);
    PosStart(1,:)=P(end,:);
    PosStart(2,:)=V(end,:);
    [PosPlot,VelPlot]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,T,PosStart);
    VBar2(idx)=mean(VelPlot(:))*density;
    disp(density)
end
k=1/N:1/N:1;
plot(k,VBar2,'k-')
xlabel('Density (cars per site)')
ylabel('Flow Rate (sites per timestep)')
%% Changing Density, multiple lanes with high and low res combined plot
clear all
%Variable setup
pslow=0.5;
RoadLength=250;
T=100;
vmax=5;
N=250;
NLanes=2;
pReturn=0.7;
VBar=zeros(1,N);
tic
%High resolution, low time period test
for i=1:N
    idx=i;
    density=i/N;
    [PosStart,NCars]=StartPos2(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    PReturn=pReturn.*ones(1,NCars);
    [P,V,L]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,RoadLength,PosStart,NLanes);
    PosStart(1,:)=P(end,:);
    PosStart(2,:)=V(end,:);
    PosStart(3,:)=L(end,:);
    [PosPlot,VelPlot]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,T,PosStart,NLanes);
    VBar1(idx)=mean(VelPlot(:))*density;
    disp(density)
end
k=1/N:1/N:1;
hold on
plot(k,VBar1,'k.')
T=1000;
N=125;
VBar=zeros(1,N);
%Low resolution, high time period test
for i=1:N
    idx=i;
    density=i/N;
    [PosStart,NCars]=StartPos2(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    PReturn=pReturn.*ones(1,NCars);
    [P,V,L]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,RoadLength,PosStart,NLanes);
    PosStart(1,:)=P(end,:);
    PosStart(2,:)=V(end,:);
    PosStart(3,:)=L(end,:);
    [PosPlot,VelPlot]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,T,PosStart,NLanes);
    VBar2(idx)=mean(VelPlot(:))*density;
    disp(density)
end
toc
k=1/N:1/N:1;
plot(k,VBar2,'k-')
xlabel('Density (cars per site)')
ylabel('Flow Rate (sites per timestep)')
%% Smart Cars (Cars with no random braking) ONE LANE
clear all
%Variable setup
density=0.2;
RoadLength=250;
T=1000;
vmax=5;
pslow=0.5;
N=density*RoadLength;
tic
Nt=20;
for k=0:1/Nt:1
    %Calculate number of 'smart' cars
    NSmart=floor(N*k);
    [PosStart,NCars]=StartPos(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    PSlow(1:NSmart)=0;
    %Initialisation runthrough
    [P,V]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,RoadLength*10,PosStart);
    PosStart=P(end,:);
    PosStart(2,:)=V(end,:);
    %Main simulation
    [PosPlot,VelPlot]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,T,PosStart);
    VBar(round(20*k+1))=mean(VelPlot(:));
end
toc
VBar2=density*mean(VBar,2)/1.14;
plot(1:round(20*k+1),VBar2,'k-',[0 1],[VBar2(1) VBar2(1)],'r--')
axis([0 Nt+1 0 vmax*density/1.14])
ylabel('Flow rate (cars per second)')
xlabel('Proportion of smart cars (%)')
%% Smart Cars multiple Lanes
clear all
%Variable Setup
density=1.5;
RoadLength=250;
T=1000;
vmax=5;
pslow=0.5;
NLanes=2;
pReturn=0.7;
N=density*RoadLength;
tic
for k=0:0.05:1
    %Calculate number of smart cars
    idx=round(20*k+1);
    NSmart=floor(k*N);
    %Starting Positions
    [PosStart,NCars]=StartPos2(density,RoadLength);
    VMax=vmax.*ones(1,NCars);
    PSlow=pslow.*ones(1,NCars);
    PReturn=pReturn*ones(1,NCars);
    %Set random braking probability of smart cars to zero
    PSlow(1:NSmart)=0;
    %Initialisation runthrough
    [P,V,L]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,RoadLength,PosStart,NLanes);
    PosStart=P(end,:);
    PosStart(2,:)=V(end,:);
    PosStart(3,:)=L(end,:);
    %Main simulations
    [PosPlot,VelPlot]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,T,PosStart,NLanes);
    %Record mean time averaged velocity
    VBar(idx)=mean(VelPlot(:));
    disp(k) %Used to keep track of progress for longer runtimes
end
toc
VBar2=density*VBar/1.14;
plot(0:5:100,VBar2,'k-',[0 100],[VBar2(1) VBar2(1)],'r--')
axis([0 100 VBar2(1)*0.9 vmax*density/1.14])
ylabel('Flow rate (cars per second)')
xlabel('Proportion of smart cars (%)')