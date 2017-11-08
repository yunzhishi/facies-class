function new_facies = plotRoG(facies, facies_names, ang, combine)
%PLOTROG plots the Ro and G from AVO reflectivity samples.
%
%   PLOTROG(facies, facies_names, ang, [combine]) uses the previously computed
%   AVO reflectivity curves to estimate two AVO attributes: zero-offset
%   R_pp (intercept) and gradient. These attributes can be used for facies
%   classification later.
%
%   new_facies = PLOTROG(...) outputs the "new_facies" cell containing the
%   estimated Ro and G values.
%
%   See also PLOTMC, PLOTAVO.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
xlabel_preset = {'Intercept'};
ylabel_preset = {'Gradient'};
faciesNum = length(facies);
plotRGB = jet(faciesNum);  % RGB values

% Set up forward modeling matrix -> A * [Ro,G]' = Rpp'
%forward_matrix = [ones(size(ang')), sin(ang').^2];

ndraws = length(facies{1}.sampVp);
for i = 1:faciesNum
    if ~exist('combine', 'var')  % subplot all facies
        subplot(floor(sqrt(faciesNum)), ...
                ceil(faciesNum / floor(sqrt(faciesNum))), ...
                i);
    end
    
    facies{i}.Ro = zeros(ndraws, 1);
    facies{i}.G = zeros(ndraws, 1);
    for samp = 1:ndraws
        x = polyfit(sin(ang'*pi/180.).^2, facies{i}.AVORpp(samp,:)', 1);
        facies{i}.Ro(samp) = x(2);
        facies{i}.G(samp) = x(1);
    end
    hold on;
    h = scatter(facies{i}.Ro, facies{i}.G, 12, 'filled');
    h.MarkerFaceColor = plotRGB(i,:);
    h.MarkerEdgeColor = 'none';

    % Compute average values and display
    h = scatter(mean(facies{i}.Ro), mean(facies{i}.G), 15, 'filled');
    h.MarkerFaceColor = 'k';
    h.MarkerEdgeColor = 'none';

    xlim([-0.25, 0.25]);
    ylim([-0.4, 0.3]);
    xlabel(xlabel_preset{1});
    ylabel(ylabel_preset{1});
    grid on;
    if ~exist('combine', 'var')
        title(['Facies ', facies_names{i}]);
    else
        title('All facies')
    end
end

new_facies = facies;
