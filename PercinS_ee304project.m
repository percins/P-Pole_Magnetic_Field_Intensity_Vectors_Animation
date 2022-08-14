%P-pole Magnetic field Intensity Vectors Animation Generator
clc;
clear;
%The number of the poles should be stated
pole=8;
%Magnitudes of the currents can be changed to observe the affect
Bm1 =1;
Bm2 =1;
Bm3 =1;
freq =0.1; 
w = 2*pi*freq;
t = 0:1/20:1/0.1;
angle1=(2*pi)/pole;
angle2=(2*pi)/(pole*2);
angle3=(2*pi*2)/(pole*3);
circle = 1.5 * (cos(w*t) + j*sin(w*t));
Bxy=[];
I=[];
color=[];
point=[];
if pole==2
    n=1;
else
    n=pole;
end
%generating the magnetic field density equations and the values
for ph=1:3
    for p=1:n
        if ph==1
            color=[color; 'b'];
            Bm=Bm1;
        elseif ph==2 
            color=[color; 'g'];
            Bm=Bm2;
        elseif ph==3
            color=[color; 'r'];
            Bm=Bm3;
        end
        imangle=(-pi/2)+angle2+angle1*(p-1)+angle3*(ph-1);
        toadd=Bm*sin(w*t-(2*pi/3)*(ph-1)).*(cos(imangle) + j*sin(imangle));
        I=[I; sign((Bm*sin(w*t-(2*pi/3)*(ph-1))))];
        Bxy=[Bxy; toadd];
        point=[point; (1.5*cos(imangle)*cos(angle2)) (1.5*sin(imangle)*cos(angle2))];
    end
end
%arranging the windings
if pole>2
    for m=1:n*3
        Bxy(m,:)=Bxy(m,:)*(-1)^(m-1);
    end
end
%net magnetic field density vector
Bnet=sum(Bxy,1);
%stating colors for plotting operations
col=[];
for k=1:pole*3
    if(mod(k,3)==1)
        col(k)='b';
    elseif(mod(k,3)==2)
        col(k)='r';
    elseif(mod(k,3)==0)
        col(k)='g';
    end
end 
%generating the direcitons of the currents to plot later
shape=[];
for ii = 1:length(t)
    formshape=[];
    signs=ones(pole*3,1);
    for k=1:3
       if pole==2
           index=k;
       else
           index=1+pole*(k-1);
       end
       start=I(index,ii);
       signs(2*k-1)=start;
       for j=1:pole-1
          if ((2*k-1)+j*3>pole*3)
              index2=mod((2*k-1)+j*3,pole*3)+1;
          else
              index2=(2*k-1)+j*3;
          end
          if mod((2*k-1)+j*3,2)==1
             signs(index2)=start;
          else
             signs(index2)=start*(-1);
          end
       end
    end
    for k=1:pole*3
        if signs(k)==1
            formshape=[formshape;'x'];
        elseif signs(k)==-1
            formshape=[formshape;'.'];
        else
            formshape=[formshape;'s'];
        end
    end
    shape=[shape formshape];
end
%plotting all the vectors and the informations that is generated before
for ii = 1:length(t)
plot(circle,'k') ; hold on;
    for k=1:pole*3
        plot(1.5*cos(-pi/2+(k-1)*2*pi/(pole*3)),1.5*sin(-pi/2+(k-1)*2*pi/(pole*3)),strcat(col(k),'o'),'MarkerSize',(20/pole*3));
        plot(1.5*cos(-pi/2+(k-1)*2*pi/(pole*3)),1.5*sin(-pi/2+(k-1)*2*pi/(pole*3)),strcat(col(k),shape(k,ii)),'MarkerSize',(20/pole*3*4/5));  
    end
    for k=1:n*3
        plot([point(k,1) point(k,1)+real(Bxy(k,ii))],[point(k,2) point(k,2)+imag(Bxy(k,ii))],color(k),'LineWidth', 2 ) ;
    end
    plot([0 real(Bnet(1,ii))],[0 imag(Bnet(1,ii))],'k','LineWidth', 3 ) ;
axis square;
axis([-2 2 -2 2]) ;
drawnow;
hold off;
end
