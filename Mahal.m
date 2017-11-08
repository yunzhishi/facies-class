close all;
clear all;

load('./Input_Data.mat')
allFacies = {FaciesIIaOil, FaciesIIbOil, FaciesIIcOil, ...
             FaciesIIa, FaciesIIb, FaciesIIc, FaciesIII, FaciesIV, FaciesV};
brineFacies = {FaciesIIa, FaciesIIb, FaciesIIc, FaciesIII, ...
               FaciesIV, FaciesV};
pairFacies = {FaciesIIa, FaciesIIb, FaciesIIc, ...
              FaciesIIaOil, FaciesIIbOil, FaciesIIcOil};
allName = {'IIa-Oil', 'IIb-Oil', 'IIc-Oil', 'IIa', 'IIb', 'IIc', ...
           'III', 'IV', 'V'};
brineName = {'IIa', 'IIb', 'IIc', 'III', 'IV', 'V'};
pairName = {'IIa', 'IIb', 'IIc', 'IIa-Oil', 'IIb-Oil', 'IIc-Oil'};

rng(2017);  % Lock up random seed
top = 8;  % Use FaciesIV as top layer
ndraws = 1000;  % Number of simulations
approx = 4;  % Choice of Zoeppritz Eqns or approximation
ang = linspace(0, 15, 15);  % Angle Range

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

figure(1);  % --> PDF for brine facies
plotPDFCDF(brineFacies, ranges, 'PDF', brineName);
figure(2);  % --> CDF for brine facies
plotPDFCDF(brineFacies, ranges, 'CDF', brineName);

figure(3);  % --> PDF for saturation pairs
plotPDFCDF(pairFacies, ranges, 'PDF', pairName, 'oil');
figure(4);  % --> CDF for saturation pairs
plotPDFCDF(pairFacies, ranges, 'CDF', pairName, 'oil');


% MCDraw;  % Draws ndraws values from the PDFs made from the previous step
ranges = {{Vpmin, Vpmax}, {Vsmin, Vsmax}, {Rhobmin, Rhobmax}};

figure(5);  % --> Vp, Vs: Gaussian mixture model
allFacies = plotMC(allFacies, ranges, 'VpVs', allName);
figure(6);  % --> Vp, Vs: Monte Carlo sampling
allFacies = plotMC(allFacies, ranges, 'VpVs', allName, 'draw', ndraws);

figure(7);  % --> Rhob: Gaussian PDF
allFacies = plotMC(allFacies, ranges, 'Rhob', allName);
figure(8);  % --> Rhob: Monte Carlo sampling
allFacies = plotMC(allFacies, ranges, 'Rhob', allName, 'draw', ndraws);


% MakeAVOpdfs;  % Generates AVO curves, Int-Grad values,
figure(9);  % --> Reflectivity modeling
allFacies = plotAVO(allFacies, allName, ang, approx, top);
figure(10);  % --> Gradient and intercept estimation
allFacies = plotRoG(allFacies, allName, ang);

figure(11);  % --> Putting all facies together and real data
subplot(1,2,1);
plotRoG(allFacies, allName, ang, 'combine');
subplot(1,2,2);
plotRoG(allFacies, allName, ang, 'combine');
hold on;
h = scatter(Seismic.Int(:), Seismic.Grad(:), 4, 'filled');
h.MarkerFaceColor = 'k';
h.MarkerEdgeColor = 'none';
title('All facies and real data');
set(gcf, 'Position', [100,100,800,300]);


% ClassesMahal;  % Assigns to facies based on Mahal distance
figure(12);  % --> Real data facies classification
subplot(1,2,1);
plotRoG(allFacies, allName, ang, 'combine');
subplot(1,2,2);
Seismic = classifyMahal(Seismic, allFacies, allName);

figure(13);  % --> Time slice intercept and gradient
plotFacies(Seismic, allName, 'input');
figure(14);  % --> Time slice facies classification
plotFacies(Seismic, allName);


% save Mahal_Classification.mat
