clc;
clear;

vo = 12.6; % O/P voltage (V)
vi = 50; % I/P voltage (V)
f = 50000; % switching frequency (Hz)
R = 1; % load resistance (ohm)
delta_vo = 1; % ripple voltage (%) calculated as (vo_max - vo_min)/vo, i.e peak to peak value of output voltage ripple

D = (vo/vi); % Duty Cycle

Lmin = (1-D)*(R)/(2*f) % Min value of Inductor
% L = 1.25*Lmin % Taking inductor value 25% higher than min value
L = 33/1000000
Cmin = (1-D)/(8*L*(delta_vo/100)*f*f) % Min value of Capacitor, any value higher than this will produce lesser ripple in output voltage.

L_val = 33/1000000
C_val = 220/1000000

d_vo = (1-D)*100/(8*L_val*C_val*f*f)

%% Rectifier
Vm = 50; % max supply voltage (V)
Vr = 0.1; % voltage ripple (V)
R_rect = 100000; % Ohm
f_supply = 50; % supply frequency (Hz)

C_rect =  Vm/(2*f_supply*R_rect*Vr)

R_rect_val = 100000;
C_rect_val = 100/1000000;
V_rip = Vm/(2*f_supply*R_rect_val*C_rect_val)

%% Transmitter and Reciever Coil 

% Lt = 15/1000;
% Lr = 15/1000;
Ct = 100/1000000;
Cr = 100/1000000;
% Rt = 1.1;
% Rr = 1.1;
d = 0.01; % distance between transmitter and receiver coils (m)
mu0 = 4*pi*(10^(-7)); % premeability of free space
mur = 1; % relative permeability
Do = 0.1; % Outer Dia (m)
Di = 0.02; % Inner Dia (m)
N = 5; % Number of turns in the single layer spiral
sigma = 59800000; % conductivity of copper
r = 0.0025; % radius of copper wire (half of wire thickness)
% another way to do is multiply radius of each strand and number of strands

gama = (Do - Di)/(Do + Di);
Davg = (Do + Di)/2;
% Lt = (mu0*mur*N*N*Davg)*(log(2.46/gama) + (0.2*gama*gama))
Lt = 1/(4*pi*pi*20000*(100e-6));
Lr = Lt

l = pi*Davg; % length of copper coil (perimeter)
% Rt = l/(sigma*pi*r*r)
Rt = Davg/2
Rr = Rt

w = 1/sqrt(Lt*Ct)

k = 1/(1+(2^(2/3)*(D/sqrt(Rt*Rr))^2))

M = k*sqrt(Lt*Lr)

%% AC Voltage Regulator (Two resistor - R load)

Vi_ac = 220; % Supply voltage
alpha_th = 143.2281; % Thyristor firing angle

alpha_th = alpha_th*(pi/180);

Vo_ac_rms = Vi_ac*sqrt(((1/(pi))*(pi - alpha_th + (sin(2*alpha_th)/2))))


