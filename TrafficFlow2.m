function [PosPlot,VelPlot,Flow]=TrafficFlow2(NCars,VMax,RoadLength,PSlow,T,PosStart)
% For T timesteps, evalutes the motion of each car in parallel.
% This version has no overtaking and as such can only have one lane.
Pos=PosStart;
PosPlot=PosStart(1,:);
PosPlot(1,:)=Pos(1,:);
VelPlot=PosStart(2,:);
for i=1:T
    D=NextCarDist(Pos,RoadLength);
    %Acceleration
    logAccel=D>Pos(2,:)+1 & Pos(2,:)<VMax;
    Pos(2,:)=Pos(2,:)+logAccel;
    %Braking
    logBrake=D<=Pos(2,:) & D~=0;
    DBrake=D-1;
    BrakeDist=DBrake(logBrake);
    Pos(2,logBrake)=BrakeDist;
    %Random Braking
    num=rand(1,NCars);
    logRandBrake=num<PSlow & Pos(2,:)>0;
    NewVel=Pos(2,:);
    BrakeVel=NewVel-1;
    Pos(2,logRandBrake)=BrakeVel(logRandBrake);
    %Car Motion
    Pos1=Pos(1,:);
    Pos(1,:)=Pos(1,:)+Pos(2,:);
    Loop=Pos(1,:);
    RL=RoadLength*ones(1,NCars);
    Loop(Loop>RoadLength)=Loop(Loop>RoadLength)-RL(Loop>RoadLength);
    for j=1:NCars
        Pos1T=Pos1(j);
        Pos2=Pos(1,j);
        Flow{i,j}=Pos1T:Pos2-1;
    end
    Pos(1,:)=Loop;
    %
    PosPlot(i+1,:)=Pos(1,:);
    VelPlot(i+1,:)=Pos(2,:);

end
end