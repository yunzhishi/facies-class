function new_facies = plotMC(facies, ranges, type, facies_names, draw, ndraws)
%PLOTMC plots the Monte Carlo fitting/sampling of given facies data.
%
%   PLOTMC(facies, ranges, type, facies_names, [draw], [ndraws]) fits the
%   given facies data to the multivariate Gaussian model and plot out the
%   probability density function (PDF); or, when flag DRAW is set to be
%   true, draws Monte-Carlo samplings according to the previously computed
%   distribution.
%
%   new_facies = PLOTMC(...) outputs the "new_facies" cell containing the
%   distribution models.
%
%   See also PLOTAVO, PLOTROG.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
sampling = 20;  % histogram sampling
xlabel_preset = {'Vp km/s', 'Density g/cc'};
ylabel_preset = {'Vs km/s', 'PDF'};
fields = {{'Vp','Vs'}, 'Rhob'};
faciesNum = length(facies);
plotRGB = jet(faciesNum);  % RGB values

for i = 1:faciesNum
    subplot(floor(sqrt(faciesNum)), ...
            ceil(faciesNum / floor(sqrt(faciesNum))), ...
            i);

    if strcmp(type, 'VpVs')  % Vp, Vs bivariate distribution
        property = 1;
        if ~exist('draw', 'var')  % Compute distribution
            % Fit GMM
            param1 = facies{i}.(fields{1}{1});
            param2 = facies{i}.(fields{1}{2});
            facies{i}.GMM = fitgmdist([param1, param2], 1);
            hold on;
            ezcontour(@(x,y)pdf(facies{i}.GMM, [x,y]));
            legend OFF;
            title([]);
            % Draw scatters from facies data
            h = scatter(param1, param2, 12, 'filled');
        else  % Monte-Carlo sampling
            samples = random(facies{i}.GMM, ndraws);
            facies{i}.sampVp = samples(:,1);
            facies{i}.sampVs = samples(:,2);
            h = scatter(samples(:,1), samples(:,2), 12, 'filled');
        end
        h.MarkerFaceColor = plotRGB(i,:);
        h.MarkerEdgeColor = 'none';
        xlim([ranges{1}{1}, ranges{1}{2}]);
        ylim([ranges{2}{1}, ranges{2}{2}]);

    elseif strcmp(type, 'Rhob')  % Rhob univariate distribution
        property = 2;
        if ~exist('draw', 'var')  % Compute distribution
            % Fit univariate Gaussian model
            param = facies{i}.(fields{2});
            facies{i}.UniGM = fitdist(param, 'Normal');
            % Draw fitting curves and histograms
            h = histfit(param, sampling);
            h(1).FaceColor = plotRGB(i,:);
            h(2).Color = 'k';
        else % Monte-Carlo sampling
            samples = random(facies{i}.UniGM, ndraws);
            facies{i}.sampRhob = samples(:);
            h = histogram(samples(:), sampling);
            h.Normalization = 'probability';
            h.FaceColor = plotRGB(i,:);
            ylim([0, 0.2]);
        end
        xlim([ranges{3}{1}, ranges{3}{2}]);

    else
        error(message(['Invalid type from argument: ', type]));
    end

    xlabel(xlabel_preset{property});
    ylabel(ylabel_preset{property});
    if strcmp(type, 'Rhob') && exist('draw', 'var')
        ylabel('Probability');
    end
    grid on;
    title(['Facies ', facies_names{i}]);
end

new_facies = facies;
