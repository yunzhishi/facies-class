function new_wells = plotAVO(wells, well_names, ang, approx, top)
%PLOTAVO plots the AVO R_pp from Monte-Carlo samplings.
%
%   PLOTAVO(wells, well_names, ang, approx, top) uses the previously computed
%   Monte-Carlo property samplings, including Rhob, Vp and Vs, to model the
%   AVO P-P reflectivities. The intercept and gradient of the reflectivity
%   curve can later be used in facies classification.
%
%   new_wells = PLOTAVO(...) outputs the "new_wells" cell containing the
%   computed AVO reflectivities.
%
%   See also PLOTMC, PLOTROG.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
xlabel_preset = {'Angle'};
ylabel_preset = {'R_{PP}(\theta)'};
wellNum = length(wells);
plotRGB = jet(wellNum);  % RGB values

% Generate top layer samplings
topLayer = wells{top};
ndraws = length(topLayer.sampVp);  % number of Monte-Carlo samplings
VpVsSamp = random(topLayer.GMM, ndraws);
RhobSamp = random(topLayer.UniGM, ndraws);
topLayer.sampVp = VpVsSamp(:,1);
topLayer.sampVs = VpVsSamp(:,2);
topLayer.sampRhob = RhobSamp(:);

for i = 1:wellNum
    subplot(floor(sqrt(wellNum)), ...
            ceil(wellNum / floor(sqrt(wellNum))), ...
            i);
    
    wells{i}.AVORpp = zeros(ndraws, length(ang));
    for samp = 1:ndraws
        vp1 = topLayer.sampVp(samp);
        vs1 = topLayer.sampVs(samp);
        d1 = topLayer.sampRhob(samp);
        vp2 = wells{i}.sampVp(samp);
        vs2 = wells{i}.sampVs(samp);
        d2 = wells{i}.sampRhob(samp);

        wells{i}.AVORpp(samp,:) = avopp(vp1,vs1,d1,vp2,vs2,d2,ang,approx);
        hold on;
        h = plot(ang, wells{i}.AVORpp(samp, :));
        h.Color = plotRGB(i,:);
        h.LineWidth = 2.;
    end

    ylim([-0.4, 0.3]);
    xlabel(xlabel_preset{1});
    ylabel(ylabel_preset{1});
    grid on;
    title(['Facies ', well_names{i}]);
end

new_wells = wells;
