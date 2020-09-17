function [PosPlot,VelPlot,LanePlot]=TrafficFlowLane(NCars,VMax,RoadLength,PSlow,PReturn,T,PosStart,NLanes)
% For T timesteps, evaluates the motion for each car in parallel.
% This function is capable of handing multiple lanes.
PosPlot=PosStart(1,:);
VelPlot=PosStart(2,:);
LanePlot=PosStart(3,:);
Pos=PosStart;
for i=1:T
    D1=NextCarDistL(Pos,RoadLength,NLanes); %Distance to next car in same lane
    num=rand(2,NCars); %Generates 2 random numbers, 1st for returning to slow lane and 2nd for random brake
    %ACCELERATION---------------------------------------------------------------------------------
    logAccel=D1>Pos(2,:)+1 & Pos(2,:)<VMax;
    Pos(2,:)=Pos(2,:)+logAccel; %Accelerated velocity
    %BRAKING/OVERTAKING---------------------------------------------------------------------------
    logBrake=D1<=Pos(2,:) & D1~=0;
    NextCarPos=D1+Pos(1,:);
    Loop1=NextCarPos(NextCarPos>RoadLength)-RoadLength;
    NextCarPos(NextCarPos>RoadLength)=Loop1;
    [~,idx]=ismember(NextCarPos,Pos(1,:));
    NextCarVel=Pos(2,idx);
    logOverTake1=(NextCarVel+2<=Pos(2,:) |NextCarVel==0) & logBrake==1 & (Pos(3,:)~=NLanes);
    D2=PrevCarDist(Pos,RoadLength,NLanes,NCars,1); %Distance to previous car in next lane
    logOverTake2=D2>VMax;
    logOverTake=logOverTake1 & logOverTake2;
    %
    %Overtake if all of these are true:
    %   Car ahead has a v=0 or v is 2 less than the overtaking car
    %   The car would brake because of the distance to the car ahead
    %   The car is not in the last lane
    %   The distance to the previous car in the target lane is greater than vmax
    %
    logBrake(logOverTake)=0; %Don't brake if the car is going to overtake
    DSlow=PrevCarDist(Pos,RoadLength,NLanes,NCars,-1); %Distance to previous car in previous lane
    logReturn1=DSlow>VMax & D2>VMax;
    logReturn2=logOverTake==0 & Pos(3,:)~=1 & num(1,:)<PReturn;
    logReturn=logReturn1 & logReturn2;
    %
    %Return to previous lane if all of these are true:
    %   The distance to the previous car in the lane is greater than vmax
    %   The distance to the next car in the lane is greater than vmax
    %   The car is not overtaking
    %   The car is not in the first lane
    %   The random number generated is less than pReturn for that car
    %
    DBrake=D1-1;
    BrakeDist=DBrake(logBrake);
    Pos(2,logBrake)=BrakeDist;
    %RANDOM BRAKING-------------------------------------------------------------------------------
    logRandBrake=num(2,:)<PSlow & Pos(2,:)>0;
    NewVel=Pos(2,:);
    BrakeVel=NewVel-1;
    Pos(2,logRandBrake)=BrakeVel(logRandBrake);
    %CAR MOTION---------------------------------------------------------------------------------
    Pos(1,:)=Pos(1,:)+Pos(2,:);
    Pos(3,:)=Pos(3,:)+logOverTake-logReturn;
    Loop=Pos(1,:);
    RL=RoadLength*ones(1,NCars);
    % Periodic road logic
    Loop(Loop>RoadLength)=Loop(Loop>RoadLength)-RL(Loop>RoadLength);
    Pos(1,:)=Loop;
    %Data Array Updates
    PosPlot(i+1,:)=Pos(1,:);
    VelPlot(i+1,:)=Pos(2,:);
    LanePlot(i+1,:)=Pos(3,:);
end
end