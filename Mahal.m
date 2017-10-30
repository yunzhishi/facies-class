close all;
clear all;

load('./Input_Data.mat')
allWell = {FaciesIIaOil, FaciesIIbOil, FaciesIIcOil, ...
           FaciesIIa, FaciesIIb, FaciesIIc, FaciesIII, FaciesIV, FaciesV};
brineWell = {FaciesIIa, FaciesIIb, FaciesIIc, FaciesIII, ...
             FaciesIV, FaciesV};
pairWell = {FaciesIIa, FaciesIIb, FaciesIIc, ...
            FaciesIIaOil, FaciesIIbOil, FaciesIIcOil};
allNum = length(allWell);
brineNum = length(brineWell);
pairNum = length(pairWell);
allName = {'IIa-Oil', 'IIb-Oil', 'IIc-Oil', 'IIa', 'IIb', 'IIc', ...
           'III', 'IV', 'V'};
brineName = {'IIa', 'IIb', 'IIc', 'III', 'IV', 'V'};
pairName = {'IIa', 'IIb', 'IIc', 'IIa-Oil', 'IIb-Oil', 'IIc-Oil'};
plotRGB = jet(allNum);  % RGB values

top = 8;  % Use FaciesIV as top layer
ndraws = 100;  % Number of simulations
% approx = ;  % Choice of Zoeppritz Eqns or approximation
% ang = ;  % Angle Range

%%%%%% Specify minimum and maximum values (ranges) for Vp, Vs, Rhob, Ip, and Vp/Vs
Vpmin = 2.0;
Vpmax = 3.5;
Vsmin = 0.5;
Vsmax = 2.0;
Rhobmin = 1.9;
Rhobmax = 2.4;
Ipmin = 3.5;
Ipmax = 7.5;
VpVsmin = 1.4;
VpVsmax = 3.0;
%%%%%%%

% MakeBrinePDFsCDFs;  % Makes CDFs and PDFs for the 9 facies
ranges = {{Ipmin, Ipmax}, {VpVsmin, VpVsmax}};

figure(1);  % --> PDF for brine wells
plotPDFCDF(brineWell, ranges, 'PDF', brineName);
figure(2);  % --> CDF for brine wells
plotPDFCDF(brineWell, ranges, 'CDF', brineName);

figure(3);  % --> PDF for saturation pairs
plotPDFCDF(pairWell, ranges, 'PDF', pairName, 'oil');
figure(4);  % --> CDF for saturation pairs
plotPDFCDF(pairWell, ranges, 'CDF', pairName, 'oil');


% MCDraw;  % Draws ndraws values from the PDFs made from the previous step
ranges = {{Vpmin, Vpmax}, {Vsmin, Vsmax}, {Rhobmin, Rhobmax}};

figure(5);  % --> Vp, Vs: Gaussian mixture model
allWell = plotMC(allWell, ranges, 'VpVs', allName);
figure(6);  % --> Vp, Vs: Monte Carlo sampling
allWell = plotMC(allWell, ranges, 'VpVs', allName, 'draw', ndraws);

figure(7);  % --> Rhob: Gaussian PDF
allWell = plotMC(allWell, ranges, 'Rhob', allName);
figure(8);  % --> Rhob: Monte Carlo sampling
allWell = plotMC(allWell, ranges, 'Rhob', allName, 'draw', ndraws);


% MakeAVOpdfs;  % Generates AVO curves, Int-Grad values,


% ClassesMahal;  % Assigns to facies based on Mahal distance


% save Mahal_Classification.mat
