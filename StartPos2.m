function [Pos,NCars]=StartPos2(density,RoadLength)
% Calculates starting array with velocities zero and all cars in first
% lane, unless density is greater than one in which case cars are split
% between the first and second lanes
NCars=floor(density*RoadLength);
if NCars>=RoadLength
    perlane1=floor(NCars/2);
    perlane2=ceil(NCars/2);
    Start1=randperm(RoadLength,perlane1);
    Start2=randperm(RoadLength,perlane2);
    Pos=[Start1,Start2;zeros(1,NCars);ones(1,perlane1),2*ones(1,perlane2)];
else
    Start=randperm(RoadLength,NCars);
    Pos=[Start;zeros(1,NCars);ones(1,NCars)];
end
end