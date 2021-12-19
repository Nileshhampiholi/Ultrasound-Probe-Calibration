function [X]=liang(AA,BB)

[m,n]=size(AA); n = n/4;

A = zeros(9*n,9);
b = zeros(9*n,1);
for i = 1:n
    Ra = AA(1:3,4*i-3:4*i-1);
    Rb = BB(1:3,4*i-3:4*i-1);
    A(9*i-8:9*i,:) = [kron(Ra,eye(3))+kron(-eye(3),Rb')];
end
[u,s,v]=svd(A);
x = v(:,end);
R=reshape(x(1:9),3,3)';
R = sign(det(R))/abs(det(R))^(1/3)*R;
[u,s,v]=svd(R); R = u*v'; if det(R)<0, R = u*diag([1 1 -1])*v'; end
C = zeros(3*n,3);
d = zeros(3*n,1);
I = eye(3);
for i = 1:n
    C(3*i-2:3*i,:) = I - AA(1:3,4*i-3:4*i-1);
    d(3*i-2:3*i,:) = AA(1:3,4*i)-R*BB(1:3,4*i);
end
t = C\d;
%Put everything together to form X
X = [R t;0 0 0 1];