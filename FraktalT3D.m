function FraktalT3D(n,r,phi,chi,xb,yb,zb)
% This function allow you to build  3D-fractal trees
%  by using modified algorithms based on the so-called Kantor`s array
%  and method of inverse trace
%  These methods allow you to economise time and computer memory
%  considerably
% It`s arguments:
%  FraktalTM3D(n,r,phi,chi,xb,yb,zb)
%     n - number of iterations
%     r - scale factor 
%       in case of nonuniform fractals where different scale-factors take
%       place, r may be vector 
%     phi - vector of azimuth angles in fractal generator that are calculated
%     chi - vector of polar angles in fractal generator relative to the
%     trunk
%     xb, yb and zb - coordinates of trunk
%       
%   For example for famous Pifagorus`s tree in it`s vertical position the call of this function is
%   so:
%   FraktalTM3DM(n,[0.5,0.8,0.8],[0,2*pi/3,4*pi/3],[pi/3,pi/3,pi/3],[0,0],[0,0],[0,1])
%       n is recommended to be in range 1..10 not to call the overloaded of stack 



 h=figure;
 axes('Parent',h,'Color',[1,1,1]);
view(3); %view 3D

%axis equal
 

mN=length(phi);%off the x-axis
if length(r)==1
    rM=ones(1,mN)*r;
elseif length(r)==mN
    rM=r;
else 
    warndlg('The sizes of scale vector and vector of angles in fraktal`s generator don`t equal');
end


% --------------call to the system to ignore divide by zero-----------------

warning off MATLAB:divideByZero


% ----------------The matrix for coordinates for  each branch-----------------

   A=ones(n+1,mN^n,3); 
   
   
% ----------------- Coordinates of trunk ------------------

   A(1,:,1)=ones(1,mN^n)*xb(1);
   A(1,:,2)=ones(1,mN^n)*yb(1);
   A(1,:,3)=ones(1,mN^n)*zb(1);
   A(2,:,1)=ones(1,mN^n)*xb(2);
   A(2,:,2)=ones(1,mN^n)*yb(2);
   A(2,:,3)=ones(1,mN^n)*zb(2);
   
   
   
 % ------------The calculating of coordinates of branches on the base of Kantor`s array--------------
    
    
   NC=zeros(3,mN); 
   
   for i=2:1:n
         z=1;
       for j=1:1:mN^(i-2)
           for k=1:1:mN
               for m=1:1:mN^(n-i)
               
                 % --------------- Length of last branch --------------
                 a=sqrt((A(i-1,z,1)-A(i,z,1))^2+(A(i-1,z,2)-A(i-1,z,2))^2+(A(i-1,z,3)-A(i,z,3))^2);%3D
                 b=sqrt((A(i,z,1)-A(i-1,z,1))^2+(A(i,z,2)-A(i-1,z,2))^2);%2D


                  theta1=acos((A(i,z,3)-A(i-1,z,3))/a);%z/a
                     k2=(A(i,z,2)-A(i-1,z,2))/b;
                     k1=(A(i,z,1)-A(i-1,z,1))/b;

                   if (A(i,z,1)==A(i-1,z,1))&(A(i,z,2)==A(i-1,z,2))
                            k2=0;
                            k1=1;
                   end

                      % the matrix of turning (k2 - sin(asimute), k1 - cos(asimute), theta1 - angle of bending)
                     % B=[k1*cos(theta1),k2,sin(theta1)*k1;k2*cos(theta1),k1,k2*sin(theta1);-sin(theta1),0,cos(theta1)];
                      B=[k1*cos(theta1),0.5*k2,sin(theta1)*k1;0.5*k2*cos(theta1),-k1,k2*sin(theta1);-sin(theta1),0,cos(theta1)];
                      %0=z doesnt depend on y/x
                      %B=[cos(theta1),0,sin(theta1);0,1,0;-sin(theta1),0,cos(theta1)];
                      %B=[1,0,0;0,1,0;0,0,1];

                    for h=1:1:mN
  
                        % the coordinates of base of branches 
                        x2=a*rM(h)*sin(chi(h))*cos(phi(h));
                        y2=a*rM(h)*sin(chi(h))*sin(phi(h));
                        z2=a*rM(h)*cos(chi(h));
  
                        NC(:,h)=B*[x2,y2,z2]'+[A(i,z,1),A(i,z,2),A(i,z,3)]'; %B=what length/angle...how to branch out
    
                   end
                                         
                  % define following coordinates
                   A(i+1,z,1)=NC(1,k);
                   A(i+1,z,2)=NC(2,k);
                   A(i+1,z,3)=NC(3,k);
                   z=z+1;
               end
           end
       end
   end
   
      
 % -----------The bilding of tree by using method of inverse trace-------------
d=0;
    for i=1:mN:mN^(n-1)
          z=2;
           for k=1:1:mN-1
                for j=z:1:n-1
                   line([A(j,i,1),A(j+1,i,1)],[A(j,i,2),A(j+1,i,2)],[A(j,i,3),A(j+1,i,3)],'Color',[0.8,0.5,0.5],'LineWidth',3);
                   d=d+1;
                 %pause(0.2);
                   %line([A(j,i,1),A(j+1,i,1)],[A(j,i,2),A(j+1,i,2)],'Color',[0.8,0.8,0.8],'LineWidth',2);
                end
              z=z+1;
          end       
    end
   
     
% --------------- The end branches of tree ---------------

   
     for i=1:1:mN^n
        line([A(n,i,1),A(n+1,i,1)],[A(n,i,2),A(n+1,i,2)],[A(n,i,3),A(n+1,i,3)],'Color',[i/mN^n,0.75,sin(i/mN^n)],'LineWidth',2);
      end  
      
      
 % ------------The trunk of the tree---------------
 
   line([xb(1),xb(2)],[yb(1),yb(2)],[zb(1),zb(2)],'LineWidth',6,'Color',[0.6,0.5,0.5]);
   
   
 % ----------------- The marking of frame of reference ---------------------   
     
   grid on
