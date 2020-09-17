function D=NextCarDist(Pos,RoadLength)
[sortPos,idx]=sortrows(Pos');
Pos2=sortPos';
PosTest=circshift(Pos2(1,:),-1);
PosTest(end)=PosTest(end)+RoadLength;
D=PosTest-Pos2(1,:);
D(idx)=D;
end