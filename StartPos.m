function [Pos,NCars]=StartPos(density,RoadLength)
% Calculates starting array with velocities zero
NCars=floor(density*RoadLength);
Start=randperm(RoadLength,NCars);
Pos=[Start;zeros(1,NCars)];
end