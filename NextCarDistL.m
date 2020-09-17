function d=NextCarDistL(Pos,RoadLength,NLanes)
% Calculates distances to next cars in the same lane for each car
Dist=cell(1,NLanes);
%Create cell array for each lane with the cars in that lane
for i=1:NLanes
    logLane(i,:)=Pos(3,:)==i;
    PosLane{i}=Pos([1,2],logLane(i,:));
end
%Find distance to closest car behind for each car in each lane
for j=1:NLanes
    PosTest=PosLane{j};
    if isempty(PosTest)
        Dist{j}=[];
        continue
    end
    [sortPos,idx]=sortrows(PosTest');
    Pos2=sortPos';
    PosTest=circshift(Pos2(1,:),-1);
    PosTest(end)=PosTest(end)+RoadLength;
    D=PosTest-Pos2(1,:);
    D(idx)=D;
    Dist{j}=D;
end
for k=1:NLanes
    d(logLane(k,:))=Dist{k};
end
end