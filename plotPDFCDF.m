function plotPDFCDF(wells, ranges, type, well_names, oil)
%PLOTPDFCDF plots the PDF or CDF of given well log data.
%   PLOTPDFCDF(wells, ranges, type, well_names, [oil]) fits the given well
%   log data to the normal distribution and plot out the probability
%   density function (PDF) or cumulative density function (CDF).
%
%Written by Yunzhi Shi (Oct, 2017).

set(gcf, 'Position', [100,100,600,500]);
sampling = 100;  % plot x_val sampling
xlabel_preset = {'AI km/s*g/cc', 'Vp/Vs'};
ylabel_preset = {'Probability density', 'Probability density'};
title_preset = {'Ip', 'Vp/Vs ratio'};
fields = {'Ip', 'VpVs'};
num_property = length(fields);

for property = 1:num_property  % loop between properties
    subplot (num_property,1,property);

    for i = 1:length(wells)
        x_val = linspace(ranges{property}{1}, ranges{property}{2}, sampling);
        values = wells{i}.(fields{property});
        if strcmp(type, 'PDF')
            dist_func = pdf(fitdist(values, 'Normal'), x_val);
        elseif strcmp(type, 'CDF')
            dist_func = cdf(fitdist(values, 'Normal'), x_val);
        else
            error(message(['Invalid type from argument: ', type]));
        end
        hold on;
        h = plot(x_val, dist_func, 'LineWidth', 2.0);
        if exist('oil', 'var') && i > 3  % oil saturated wells
            h.LineStyle = '--';
        end
    end
    
    legend(well_names);
    xlabel(xlabel_preset{property});
    ylabel(ylabel_preset{property});
    if ~exist('oil', 'var')
        info='(brine wells)';
    else
        info='(saturation pairs)';
    end
    title([title_preset{property}, ' ', type, ' ', info]);
end
