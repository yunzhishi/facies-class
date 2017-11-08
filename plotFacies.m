function plotFacies(data, facies_names, type)
%PLOTFACIES plots the facies classification results in time slice.
%
%   PLOTFACIES(data, facies_names, [type]) visualizes the facies classification
%   from the function "classifyMahal". The individual and grouped facies are
%   plotted out in a time slice.
%   If input with argument 'input', then instead of classification results,
%   the inputs (intercept and gradient) will be displayed.
%
%   See also CLASSIFYMAHAL.
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,350,450]);
xlabel_preset = {'Crossline'};
ylabel_preset = {'Inline'};
title_preset = {{'Intercept', 'Gradient'}, ...
                {'Most likely facies', 'Most likely grouped facies'}};

for i = 1:2
    subplot(2,1,i);

    if exist('type', 'var')  % plot original inputs
        title_flag = 1;
        if i==1 attr=data.Int; else attr=data.Grad; end
    else  % plot likely facies
        title_flag = 2;
        if i == 1  % individual facies
            attr = reshape(data.facies, size(data.Int));
        else
            % Make grouped facies
            group = data.facies;
            group(find(group<=3)) = 2;  % 1,2,3 -> 2
            group(find(group>=7)) = 8;  % 7,8,9 -> 8
            group(find(group>2 & group<8)) = 5;  % 4,5,6 -> 5
            attr = reshape(group, size(data.Int));
        end 
    end

    imagesc(data.xline, data.inline, attr);
    ax = gca;
    ax.Position(3) = 0.95 * ax.Position(3);
    c = colorbar;
    c.Position(1) = c.Position(1) + 0.22 * ax.Position(3);
    c.Position(3) = 0.5 * c.Position(3);

    axis xy;
    colormap(ax, flipud(gray));
    xlabel(xlabel_preset{1});
    ylabel(ylabel_preset{1});
    title(title_preset{title_flag}{i});

    % Customize colorbar labels for facies
    if ~exist('type', 'var')  % plot likely facies
        if i == 1  % individual facies
            colormap(ax, gray);
            c.TickLabels = facies_names;
        elseif i == 2  % grouped facies
            mycmap = colormap(gray);
            for val = 1:64
                if val<=21 mycmap(val, :) = mycmap(round(64./8), :);
                elseif val>21&&val<43 mycmap(val, :) = mycmap(round(64./2), :);
                else mycmap(val, :) = mycmap(round(64.*7/8), :);
                end
            end
            colormap(ax, mycmap);
            c.TickLabels = {[],'Oil',[],[],'Brine',[],[],'Shale',[]};
            caxis([1,9]);
        end
    end
end
