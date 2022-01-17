l_a=.177;
l_b=.007;
l_c = 0.01;
l_r=0.29;
l_pm=.198;
l_p=.233;
J_M = 6.75e-6;          % Inertia Motor 6.75e-6
J_Enc1 = 6e-14;         % Inertia Encoder Theta1
J_Enc2 = 0.1e-6;        % Inertia Encoder Theta2
J_m_b = 3.8281e-6;      % Inertia m_b about theta2 (= 1/2 * m_b *r_b^2)


m_sens = 0.084;
m_horzArm=0.263;
m_r = m_horzArm - m_sens;
m_b=0.025;

m_pm=0.0383;
m_p=0.0107;

L1 = l_a;
L2 = l_p;
l1 = l_a-l_b;
l2 = l_p;
m1 = m_b+m_r+m_sens;
m2 = m_p+m_pm;
J1 = 2.48 *10^-2;
J2 = 3.86 *10^-3;
J1cap =J;
J2cap = J2 + m2*(l2^2);
J0cap = J1cap + m2*(L1^2);
b1 = 1.00 *10^-4;
b2 = 2.80 *10^-4;
g = 9.81;
Lm = 0.005;
Rm = 7.80;
Km = 0.090;

w1 = J0cap*J2cap;
w2 = J2cap^2;
w3 = -(m2^2)*(L1^2)*(l2^2);

x1  = (-J2cap * b1) ; %theta1_d
x2 = (m2* L1* l2* b2); %thet2_d
x3 = - J2cap^2;
x4 = - 0.5 *J2cap *m2 *L1* l2;
x5 = J2cap *m2*L1*l2;
x6 = J2cap;
x7 = -m2*L1*l2;
x8 = 0.5* (m2^2)*(L1)*(l2^2);

y1 = (m2 * L1 *l2 *b1);
y2 = (-J0cap *b2);
y3 = -b2* J2cap;
y4 =  (m2 * L1* l2 *J2cap);
y5 = 0.5*J0cap* J2cap;
y6 = 0.5* J2cap^2;
y7 = -0.5 * (m2^2)*(L1^2)*(l2^2);
y8 = -(m2 * L1* l2);
y9 = J0cap;
y10 = J2cap;
y11 = -m2*l2*J0cap;
y12 = -m2*l2*J2cap;

z1 = -Km/Lm;
z2 = -Rm/Lm;
z3 =-1/Lm;
z4 = Km;

E0 = 0.05;
n = 10;

a32 = (g*(m2^2)*(l2^2)*L1)/(w1+w3);
a33 = x1/(w1+w3);
a34 = -x1/(w1+w3);
a42 = (g*m2*l2*J0cap)/(w1+w3);
a43 = - y1/(w1+w3);
a44 = y2/(w1+w3);

b31 = x6/(w1+w3);
b32 = -x7/(w1+w3);
b41 = -y8/(w1+w3);
b42 = -y9/(w1+w3);

sen1_reg = pi;

sen2_reg = 0.0175/50;

Rh =Km/Rm;

A = [0  0    1    0;
     0  0    0    1;
     0  a32  a33  a34;
     0  a42  a43  a44];
 
B = [0   ;
     0   ;
     b31 ;
     b41 ];
 
B = (Km/Rm)*B;

 
C = [ 1 0 0 0;
      0 1 0 0];
 
D = [0];

Qh = [1/(sen1_reg) 0              ;
      0             1/(sen2_reg) ];

Q = C'*Qh*Qh'*C;

R =200000* B'*Rh'*Rh*B;

K = -lqr(A,B,Q,R);