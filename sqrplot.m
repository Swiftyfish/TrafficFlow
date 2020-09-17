function sqrplot(T,RoadLength,PosPlot,VelPlot)
% Plots a square grid of points.
% Uses PosPlot and VelPlot produced by program
SiteOcc=zeros(T,RoadLength);
SiteVel=zeros(T,RoadLength);
V=VelPlot+1;
for i=1:T
    SiteOcc(T+1-i,PosPlot(T+1-i,:))=1;
    SiteVel(T+1-i,PosPlot(T+1-i,:))=V(T+1-i,:);
end
hold on
axis off
color=hsv(6);
colormap(circshift(color,-1,1))
SiteVel1=(SiteVel)/6;
A=SiteVel1;
A(:,:,2)=SiteOcc;
A(:,:,3)=ones(T,RoadLength);
I=hsv2rgb(A);
image(I)
caxis([0 5])
colorbar
end