function D2=PrevCarDist(Pos,RoadLength,NLanes,NCars,Dir)
% Calculates the distance to the car behind in either the next or previous
% lane depending on whether Dir is +1 or -1.
%
% Lane test logic
Lane=Pos(3,:);
LaneT=Lane;
if Dir==1
    LaneT(LaneT~=NLanes)=LaneT(LaneT~=NLanes)+Dir;
else
    LaneT(LaneT~=1)=LaneT(LaneT~=1)+Dir;
end
if isempty(LaneT)
    D2=[];
    return
end
SameLane=LaneT==Lane;
% Create cell array for each lane of which cars are testing whether they
% can move into that lane/stay in that lane
for i=1:NLanes
    logLane(i,:)=Pos(3,:)==i;
    PosLane{i}=Pos(1,logLane(i,:));
end
% For each car, create a test lane with the cars currently in that lane and
% the car itself, then calculate the distance to the previous car.
for j=1:NCars
    PosCar=Pos(1,j);
    PosTest=PosLane{LaneT(j)};
    PosTest1=PosTest(1,:);
    if SameLane(j)==0
        PosTest2=[PosTest1,Pos(1,j)];
    else
        PosTest2=PosTest1;
    end
    % Sort by position row
    sortPos=sortrows(PosTest2');
    Pos2=sortPos';
    Pos2(end+1)=Pos2(1)+RoadLength;
    Pos3=[Pos2(end-1)-RoadLength,Pos2];
    D1=PosCar-Pos3;
    D1(D1<=0)=NaN;
    D2(j)=min(D1);
end
end