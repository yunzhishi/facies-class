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

ndraws = 100;  % Number of simulations
% approx = ;  % Choice of Zoeppritz Eqns or approximation
% ang = ;  % Angle Range
%
% %%%%%% Specify minimum and maximum values (ranges) for Vp, Vs, Rhob, Ip, and Vp/Vs
%
Vpmin = 2.0;
Vpmax = 3.5;
Vsmin = 0.5;
Vsmax = 2.0;
% Rhobmin = ;
% Rhobmax = ;
Ipmin = 3.5;
Ipmax = 7.5;
VpVsmin = 1.4;
VpVsmax = 3.0;
%
% %%%%%%%

% MakeBrinePDFsCDFs;  % Makes CDFs and PDFs for the 9 facies
% figure(1);  % --> PDF for brine wells
%
% subplot(2,1,1);
% for i = 1:brineNum
%     x_val = linspace(Ipmin, Ipmax, 100);
%     pdf_val = pdf(fitdist(brineWell{i}.Ip, 'Normal'), x_val);
%     hold on;
%     plot(x_val, pdf_val);
% end
% legend(brineName);
% xlabel('AI km/s*g/cc');
% ylabel('Probability density');
% title('Ip PDF (brine wells)');
%
% subplot(2,1,2);
% for i = 1:brineNum
%     x_val = linspace(VpVsmin, VpVsmax, 100);
%     pdf_val = pdf(fitdist(brineWell{i}.VpVs, 'Normal'), x_val);
%     hold on;
%     plot(x_val, pdf_val);
% end
% legend(brineName);
% xlabel('Vp/Vs');
% ylabel('Probability density');
% title('Vp/Vs ratio PDF (brine wells)');
%
% figure(2);  % --> CDF for brine wells
%
% subplot(2,1,1);
% for i = 1:brineNum
%     x_val = linspace(Ipmin, Ipmax, 100);
%     pdf_val = cdf(fitdist(brineWell{i}.Ip, 'Normal'), x_val);
%     hold on;
%     plot(x_val, pdf_val);
% end
% legend(brineName);
% xlabel('AI km/s*g/cc');
% ylabel('Cumulative probability');
% title('Ip CDF (brine wells)');
%
% subplot(2,1,2);
% for i = 1:brineNum
%     x_val = linspace(VpVsmin, VpVsmax, 100);
%     pdf_val = cdf(fitdist(brineWell{i}.VpVs, 'Normal'), x_val);
%     hold on;
%     plot(x_val, pdf_val);
% end
% legend(brineName);
% xlabel('Vp/Vs');
% ylabel('Cumulative probability');
% title('Vp/Vs ratio CDF (brine wells)');
%
%
%
% figure(3);  % --> PDF for saturation pairs
%
% subplot(2,1,1);
% for i = 1:pairNum
%     x_val = linspace(Ipmin, Ipmax, 100);
%     pdf_val = pdf(fitdist(pairWell{i}.Ip, 'Normal'), x_val);
%     hold on;
%     if i < 4  % brine wells
%         plot(x_val, pdf_val);
%     else  % oil wells
%         plot(x_val, pdf_val, '--');
%     end
% end
% legend(pairName);
% xlabel('AI km/s*g/cc');
% ylabel('Probability density');
% title('Ip PDF (saturation pairs)');
%
% subplot(2,1,2);
% for i = 1:pairNum
%     x_val = linspace(VpVsmin, VpVsmax, 100);
%     pdf_val = pdf(fitdist(pairWell{i}.VpVs, 'Normal'), x_val);
%     hold on;
%     if i < 4  % brine wells
%         plot(x_val, pdf_val);
%     else  % oil wells
%         plot(x_val, pdf_val, '--');
%     end
% end
% legend(pairName);
% xlabel('Vp/Vs');
% ylabel('Probability density');
% title('Vp/Vs ratio PDF (saturation pairs)');
%
% figure(4);  % --> CDF for saturation pairs
%
% subplot(2,1,1);
% for i = 1:pairNum
%     x_val = linspace(Ipmin, Ipmax, 100);
%     pdf_val = cdf(fitdist(pairWell{i}.Ip, 'Normal'), x_val);
%     hold on;
%     if i < 4  % brine wells
%         plot(x_val, pdf_val);
%     else  % oil wells
%         plot(x_val, pdf_val, '--');
%     end
% end
% legend(pairName);
% xlabel('AI km/s*g/cc');
% ylabel('Cumulative probability');
% title('Ip CDF (saturation pairs)');
%
% subplot(2,1,2);
% for i = 1:pairNum
%     x_val = linspace(VpVsmin, VpVsmax, 100);
%     pdf_val = cdf(fitdist(pairWell{i}.VpVs, 'Normal'), x_val);
%     hold on;
%     if i < 4  % brine wells
%         plot(x_val, pdf_val);
%     else  % oil wells
%         plot(x_val, pdf_val, '--');
%     end
% end
% legend(pairName);
% xlabel('Vp/Vs');
% ylabel('Cumulative probability');
% title('Vp/Vs ratio CDF (saturation pairs)');


figure(5);  % --> Vp, Vs: Gaussian mixture model

allGMM = cell(allNum);
for i = 1:allNum
    subplot(3,3,i)

    % Fit GMM
    GMM = fitgmdist([allWell{i}.Vp, allWell{i}.Vs], 1);
    allGMM{i} = GMM;
    hold on;
    ezcontour(@(Vp,Vs)pdf(GMM, [Vp,Vs]));
    legend OFF;
    title([]);

    % Draw scatters
    scatter(allWell{i}.Vp, allWell{i}.Vs, '.');
    xlabel('Vp km/s');
    ylabel('Vs km/s');
    xlim([Vpmin, Vpmax]);
    ylim([Vsmin, Vsmax]);
    grid on;
    title(['Facies ', allName{i}]);
end

figure(6);  % --> Vp, Vs: Monte Carlo sampling
for i = 1:allNum
    subplot(3,3,i)

    % Draw samples from previously computed GMM
    samples = random(allGMM{i}, ndraws);
    scatter(samples(:,1), samples(:,2), '.');
    xlabel('Vp km/s');
    ylabel('Vs km/s');
    xlim([Vpmin, Vpmax]);
    ylim([Vsmin, Vsmax]);
    grid on;
    title(['Facies ', allName{i}]);
end


% MCDraw;  % Draws ndraws values from the PDFs made from the previous step
% MakeAVOpdfs;  % Generates AVO curves, Int-Grad values,
% ClassesMahal;  % Assigns to facies based on Mahal distance

% save Mahal_Classification.mat
