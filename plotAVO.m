function new_facies = plotAVO(facies, facies_names, ang, approx, top)
%PLOTAVO plots the AVO R_pp from Monte-Carlo samplings.
%
%   PLOTAVO(facies, facies_names, ang, approx, top) uses the previously computed
%   Monte-Carlo property samplings, including Rhob, Vp and Vs, to model the
%   AVO P-P reflectivities. The modeling comes from the function "avopp".
%   The intercept and gradient of the reflectivity curve can later be used in
%   facies classification.
%
%   new_facies= PLOTAVO(...) outputs the "new_facies" cell containing the
%   computed AVO reflectivities.
%
%   See also AVOPP, PLOTMC, PLOTROG.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
xlabel_preset = {'Angle'};
ylabel_preset = {'R_{PP}(\theta)'};
faciesNum = length(facies);
plotRGB = jet(faciesNum);  % RGB values

% Generate top layer samplings
topLayer = facies{top};
ndraws = length(topLayer.sampVp);  % number of Monte-Carlo samplings
VpVsSamp = random(topLayer.GMM, ndraws);
RhobSamp = random(topLayer.UniGM, ndraws);
topLayer.sampVp = VpVsSamp(:,1);
topLayer.sampVs = VpVsSamp(:,2);
topLayer.sampRhob = RhobSamp(:);

for i = 1:faciesNum
    subplot(floor(sqrt(faciesNum)), ...
            ceil(faciesNum / floor(sqrt(faciesNum))), ...
            i);
    
    facies{i}.AVORpp = zeros(ndraws, length(ang));
    for samp = 1:ndraws
        vp1 = topLayer.sampVp(samp);
        vs1 = topLayer.sampVs(samp);
        d1 = topLayer.sampRhob(samp);
        vp2 = facies{i}.sampVp(samp);
        vs2 = facies{i}.sampVs(samp);
        d2 = facies{i}.sampRhob(samp);

        facies{i}.AVORpp(samp,:) = avopp(vp1,vs1,d1,vp2,vs2,d2,ang,approx);
        hold on;
        h = plot(ang, facies{i}.AVORpp(samp, :));
        h.Color = plotRGB(i,:);
        h.LineWidth = 2.;
        plot([30,30], [-0.4,0.3], 'k--');
    end

    xlim([min(ang), max(ang)]);
    ylim([-0.4, 0.3]);
    xlabel(xlabel_preset{1});
    ylabel(ylabel_preset{1});
    grid on;
    title(['Facies ', facies_names{i}]);
end

new_facies = facies;
