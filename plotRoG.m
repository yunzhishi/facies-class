function new_wells = plotRoG(wells, well_names, ang, combine)
%PLOTROG plots the Ro and G from AVO reflectivity samples.
%
%   PLOTROG(wells, well_names, ang, [combine]) uses the previously computed
%   AVO reflectivity curves to estimate two AVO attributes: zero-offset
%   R_pp (intercept) and gradient. These attributes can be used for facies
%   classification later.
%
%   new_wells = PLOTROG(...) outputs the "new_wells" cell containing the
%   estimated Ro and G values.
%
%   See also PLOTMC, PLOTAVO.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
xlabel_preset = {'Intercept'};
ylabel_preset = {'Gradient'};
wellNum = length(wells);
plotRGB = jet(wellNum);  % RGB values

% Set up forward modeling matrix -> A * [Ro,G]' = Rpp'
forward_matrix = [ones(size(ang')), sin(ang').^2];

ndraws = length(wells{1}.sampVp);
for i = 1:wellNum
    if ~exist('combine', 'var')  % subplot all facies
        subplot(floor(sqrt(wellNum)), ...
                ceil(wellNum / floor(sqrt(wellNum))), ...
                i);
    end
    
    wells{i}.Ro = zeros(ndraws, 1);
    wells{i}.G = zeros(ndraws, 1);
    for samp = 1:ndraws
        x = forward_matrix \ wells{i}.AVORpp(samp,:)';
        wells{i}.Ro(samp) = x(1);
        wells{i}.G(samp) = x(2)*50;
    end
    hold on;
    h = scatter(wells{i}.Ro, wells{i}.G, 12, 'filled');
    h.MarkerFaceColor = plotRGB(i,:);
    h.MarkerEdgeColor = 'none';

    % Compute average values and display
    h = scatter(mean(wells{i}.Ro), mean(wells{i}.G), 15, 'filled');
    h.MarkerFaceColor = 'k';
    h.MarkerEdgeColor = 'none';

    xlim([-0.25, 0.25]);
    ylim([-0.4, 0.3]);
    xlabel(xlabel_preset{1});
    ylabel(ylabel_preset{1});
    grid on;
    if ~exist('combine', 'var')
        title(['Facies ', well_names{i}]);
    else
        title('All facies')
    end
end

new_wells = wells;
