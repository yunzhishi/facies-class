function new_data = classifyMahal(data, wells, well_names)
%CLASSIFYMAHAL computes Mahalanobis distance and classify to facies.
%
%   CLASSIFYMAHAL(data, wells, well_names) uses the previously computed
%   AVO reflectivity curves to estimate two AVO attributes: zero-offset
%   R_pp (intercept) and gradient. These attributes can be used for facies
%   classification later.
%
%   new_data = CLASSIFYMAHAL(...) outputs the "new_data" cell containing
%   the calculated Mahalanobis distances.
%
%   See also PLOTMC, PLOTAVO, PLOTROG.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,800,300]);
xlabel_preset = {'Intercept'};
ylabel_preset = {'50x Gradient'};
ndata = length(data.Int(:));
nfacies = length(wells);
plotRGB = jet(nfacies);  % RGB values

% Calculate Mahalanobis distance for each facies
data.Mahal = zeros(ndata, nfacies);
for i = 1:nfacies
    data.Mahal(:,i) = mahal([data.Int(:), data.Grad(:)], ...
                            [wells{i}.Ro, wells{i}.G]);
end

% Classify real data to facies and plot out colored scatter
[~,data.facies] = min(data.Mahal, [], 2);  % takes index only
for i = 1:nfacies
    data_int = data.Int(:);
    data_grad = data.Grad(:);
    hold on;
    h = scatter(data_int(find(data.facies==i)), ...
                data_grad(find(data.facies==i)), ...
                4, 'filled');
    h.MarkerFaceColor = plotRGB(i,:);
    h.MarkerEdgeColor = 'none';
end

legend(well_names);
xlim([-0.25, 0.25]);
ylim([-0.4, 0.3]);
xlabel(xlabel_preset{1});
ylabel(ylabel_preset{1});
grid on;
title('Real data classification');

new_data = data;
