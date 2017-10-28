close all;
clear all;

load('./Input_Data.mat')
allWell = {FaciesIIa, FaciesIIaOil, FaciesIIb, FaciesIIbOil, ...
           FaciesIIc, FaciesIIcOil, FaciesIII, FaciesIV, FaciesV};
brineWell = {FaciesIIa, FaciesIIb, FaciesIIc, FaciesIII, ...
             FaciesIV, FaciesV};
oilWell = {FaciesIIaOil, FaciesIIbOil, FaciesIIcOil};
allNum = length(allWell);
brineNum = length(brineWell);
oilNum = length(oilWell);
allName = {'IIa', 'IIa-Oil', 'IIb', 'IIb-Oil', 'IIc', 'IIc-Oil', ...
           'III', 'IV', 'V'};
brineName = {'IIa', 'IIb', 'IIc', 'III', 'IV', 'V'};
oilName = {'IIa-Oil', 'IIb-Oil', 'IIc-Oil'};

% ndraws = ;  % Number of simulations
% approx = ;  % Choice of Zoeppritz Eqns or approximation
% ang = ;  % Angle Range
% 
% %%%%%% Specify minimum and maximum values (ranges) for Vp, Vs, Rhob, Ip, and Vp/Vs
% 
% Vpmin = ;
% Vpmax = ;
% Vsmin = ;
% Vsmax = ;
% Rhobmin = ;
% Rhobmax = ;
Ipmin = 3.5;
Ipmax = 7.5;
% VpVsmin = ;
% VpVsmax = ;
% 
% %%%%%%%

% MakeBrinePDFsCDFs;  % Makes CDFs and PDFs for the 9 facies
figure(1);
for i = 1:brineNum
    x_val = linspace(Ipmin, Ipmax, 100);
    pdf_val = pdf(fitdist(brineWell{i}.Ip, 'Normal'), x_val);
    hold on;
    plot(x_val, pdf_val);
end
legend(brineName);
xlabel('AI km/s*g/cc');
ylabel('Probability');
title('Ip PDF (Brine wells)');


% MCDraw;  % Draws ndraws values from the PDFs made from the previous step
% MakeAVOpdfs;  % Generates AVO curves, Int-Grad values,
% ClassesMahal;  % Assigns to facies based on Mahal distance

% save Mahal_Classification.mat
