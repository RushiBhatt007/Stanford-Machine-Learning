clear;
clc;

v = ones(7,1)
w = ones(7,1)

z1 = sum(v.*w)

z2 = w'*v

z3 = v*w'

z4 = w*v'