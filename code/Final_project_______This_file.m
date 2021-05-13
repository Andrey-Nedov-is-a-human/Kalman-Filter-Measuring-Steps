%25.7 cm lifting
%load('lift.mat');

%5 step walking
%load('walking.mat');

%50 m walking
load('longwalking1.mat');
%load('longwalking2.mat');
%load('running.mat');

N = size(ya,2);
ra = 0.005;
rg = 0.001;
T = 0.01;

% zero velocity detection

yanorm = zeros(1,N);
ygnorm = zeros(1,N);

sqA = 0;
sqG = 0;

for i=1:N
    yanorm(i) = norm(ya(:,i));
    ygnorm(i) = norm(yg(:,i));
    sqA = sqA + yanorm(i)^2;
    sqG = sqG + ygnorm(i)^2;
end

sA = sqrt(sqA/N);
sG = sqrt(sqG/N);

A = sA*0.5;     
G = sG*0.5;

Azerovel = zeros(1,N);
Gzerovel = zeros(1,N);

Bzerovel = zeros(1,N);
for i = 1:N
    if ( (yanorm(i) < 10+A) && (yanorm(i) > 10-A))
        Azerovel(i) = 1;
    end
    
    if ( (ygnorm(i) < G) && (ygnorm(i) > -G))
        Gzerovel(i) = 1;
    end
end

Azerovel = filter_1_2(Azerovel);

for i = 1:N 
    if ((Azerovel(i) == Gzerovel(i))&&(Gzerovel(i)==1))
        Bzerovel(i) = 1;
    end
end

Bzerovel = filter_2(Bzerovel);

%zerovel = length_filter(Bzerovel);

zerovel = Bzerovel;

L = N;
S = 1;
tt = S:L;

        %there is a plot

        subplot(2,1,1);
        plot(tt, yanorm(S:L), 'b', tt, ygnorm(S:L), 'g', tt, A*Bzerovel(S:L), '*');

qhat = zeros(4,N);
vhat = zeros(3,N);
rhat = zeros(3,N);

Q = diag([0.25 * rg,0.25 * rg,0.25 * rg,0,0,0,ra,ra,ra]);
A = zeros(9,9);
A(4:6,7:9) = eye(3);

qhat(:,1) = quaternionya(ya(:,1));
gtilde = [0 ; 0 ; 9.8];
H = zeros(4,9);
H(1:3,7:9) = eye(3);
H(4,6) = 1;
R = 0.001 * eye(4);
P = diag([0.001 0.001 0.001 0 0 0 0 0 0 ]);
oldomega4 = zeros(4,4);

for i = 2:N
    Cq = quaternion2dcm( qhat(:,i-1) );
    
    A(1:3,1:3) = -vec2product(yg(:,i-1));
    A(7:9,1:3) = - 2 * Cq' * vec2product(ya(:,i-1));
    Qd = Q * T + (T^2 / 2) * A * Q + (T^2/2) * Q * A';

    dA = eye(9) + A * T + A * A * T^2 / 2;
    P = dA * P * dA' + Qd;
    omega4 = compute_44(yg(:,i-1));
    qhat(:,i) = ( eye(4) + 0.75 * omega4 * T - 0.25 * oldomega4 * T - (1/6) * norm(yg(:,i-1))^2 * T^2 * eye(4) - (1/24) * omega4 * oldomega4 * T^2  - (1/48)*norm(yg(:,i-1))^2 *omega4 * T^3) * qhat(:,i-1);
    qhat(:,i) = qhat(:,i) / norm(qhat(:,i));
    oldomega4 = omega4;
    vhat(:,i) = vhat(:,i-1) +  0.5* T * ( quaternion2dcm(qhat(:,i-1))' * ya(:,i-1) + quaternion2dcm(qhat(:,i))' * ya(:,i) )  -  T * [ 0 ; 0 ; 9.8];
    rhat(:,i) = rhat(:,i-1) + 0.5* T * (vhat(:,i) + vhat(:,i-1));
    
    if ( zerovel(i) == 1 )
        z = [zeros(3,1) - vhat(:,i); zeros(1,1) - [0,0,1]*rhat(:,i)];
        K = P * H' * inv(H * P * H' + R);
        x = K * z;
    
        P = ( eye(9) - K * H) * P;
        P = 0.5 * (P + P');
        
        vhat(:,i) = vhat(:,i) + x(7:9);
        rhat(:,i) = rhat(:,i) + x(4:6);

        qe = [ 1 ; x(1:3)];
        qhat(:,i) = quaternionmul(qhat(:,i),qe);
        qhat(:,i) = qhat(:,i) / norm(qhat(:,i));
    end
end        

%how many lines we have?
line_counter = 0;
h_true = 0;

for i=1:N
    if(zerovel(i) == 1)
        if(h_true == 0)
            h_true = 1;
            line_counter = line_counter + 1;
        end
    else
        h_true = 0;
    end
end

%making center points

length_counter = 0;
line_num = 0;
centers = zeros(1, line_counter);
h_true = 0;

arr = zeros(1,N);

for i=1:N
    if((zerovel(i) == 1)&&(i~=N))
        h_true = 1;
        length_counter = length_counter + 1;
    else
        if((h_true == 1))
            line_num = line_num + 1;
            centers(line_num) = i - int16(length_counter/2);
            arr(centers(line_num)) = 1;
            length_counter = 0;
            h_true = 0;
        end        
    end
end

sum = 0;

for i=2:line_counter
    length = abs(norm(rhat(:,int64(centers(i-1))) - rhat(:,int64(centers(i)))));
    sum = sum + length;
end

sum

%subplot(2,1,1);
%plot(tt, yanorm(S:L), 'b', tt, ygnorm(S:L), 'g', tt, 7*zerovel(S:L), '*', tt, 4*arr(S:L), '*');
%subplot(3,1,2);
%plot(tt, yanorm(S:L), tt, G*zerovel(S:L), '*');

%plotsensor(rhat);

%dist = norm(rhat(1:2,N))
%plot(rhat(1,:),rhat(2,:))

