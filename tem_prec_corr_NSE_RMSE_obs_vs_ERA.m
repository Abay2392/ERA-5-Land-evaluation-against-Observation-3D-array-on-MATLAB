

load clipped_prec_obs.mat;
load ERA_prec_inter_final.mat;
load ERA_temp_inter_final.mat;
load fliped_obs_temp.mat; 
temp_obs = fliplr(rot90(fliped_obs_temp, -1));  % Rotate 90 degrees clockwise, then flip left-to-right
temp_ERA= fliplr(rot90(ERA_temp_inter_final, -1));
prec_obs = fliplr(rot90(clippedData, -1));
prec_ERA = fliplr(rot90(ERA_prec_inter_final, -1));
prec_ERA = fillmissing(prec_ERA, 'linear', 3); % Linear interpolation along the 3rd dimension
prec_obs = fillmissing(prec_obs, 'linear', 3);

% temp_obs = fliped_obs_temp; % Rotate 90 degrees clockwise, then flip left-to-right
% temp_ERA= ERA_temp_inter_final;
% prec_obs = clippedData;
% prec_ERA = ERA_prec_inter_final;


% Assuming prec_ERA, prec_obs, temp_ERA, temp_obs are already defined
% Dimensions: lon × lat × time
[lon, lat, time] = size(temp_ERA);

% Preallocate result arrays for precipitation
prec_rmse = nan(lon, lat);
prec_nse = nan(lon, lat);
prec_corr = nan(lon, lat);

% Preallocate result arrays for temperature
temp_rmse = nan(lon, lat);
temp_nse = nan(lon, lat);
temp_corr = nan(lon, lat);

% Loop through each grid cell
for i = 1:lon
    for j = 1:lat
        % Extract time series for precipitation
        prec_ERA_cell = squeeze(prec_ERA(i, j, :));
        prec_obs_cell = squeeze(prec_obs(i, j, :));
        
        % Calculate metrics for precipitation
        if all(~isnan(prec_ERA_cell)) && all(~isnan(prec_obs_cell))
            prec_rmse(i, j) = rmse(prec_ERA_cell, prec_obs_cell);
            prec_nse(i, j) = NSE(prec_ERA_cell, prec_obs_cell); % Your defined NSE function
            prec_corr(i, j) = corr(prec_ERA_cell, prec_obs_cell);
        end

        % Extract time series for temperature
        temp_ERA_cell = squeeze(temp_ERA(i, j, :));
        temp_obs_cell = squeeze(temp_obs(i, j, :));
        
        % Calculate metrics for temperature
        if all(~isnan(temp_ERA_cell)) && all(~isnan(temp_obs_cell))
            temp_rmse(i, j) = rmse(temp_ERA_cell, temp_obs_cell);
            temp_nse(i, j) = NSE(temp_ERA_cell, temp_obs_cell); % Your defined NSE function
            temp_corr(i, j) = corr(temp_ERA_cell, temp_obs_cell);
        end
    end
end

% Example output
%disp('Metrics calculated successfully.');

% Visualization example for precipitation RMSE
% Assuming prec_rmse, prec_nse, prec_corr, temp_rmse, temp_nse, temp_corr are already computed
% Create a tiled layout for visualization
figure;
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
rmin=0.7;
rmax=1;
NSEmin=-1.5;
NSEmax=1;
% zMin
% zMax
% Precipitation RMSE
nexttile;
h1 = imagesc(prec_rmse);
axis off;
set(h1, 'AlphaData', ~isnan(prec_rmse)); % Transparent NaN
title('Precipitation RMSE', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);

% Precipitation NSE
nexttile;
h2 = imagesc(prec_nse);
axis off;
set(h2, 'AlphaData', ~isnan(prec_nse));
title('Precipitation NSE', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis([NSEmin, NSEmax]);
% Precipitation Pearson Correlation

nexttile;
h3 = imagesc(prec_corr);
axis off;
set(h3, 'AlphaData', ~isnan(prec_corr));
title('Precipitation Correlation', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis([rmin, rmax]);

% Temperature RMSE
nexttile;
h4 = imagesc(temp_rmse);
axis off;
set(h4, 'AlphaData', ~isnan(temp_rmse));
title('Temperature RMSE', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);


% Temperature NSE
nexttile;
h5 = imagesc(temp_nse);
axis off;
set(h5, 'AlphaData', ~isnan(temp_nse));
title('Temperature NSE', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis([NSEmin, NSEmax]);
% Temperature Pearson Correlation
nexttile;
h6 = imagesc(temp_corr);
axis off;
set(h6, 'AlphaData', ~isnan(temp_corr));
title('Temperature Correlation', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
% caxis([zMin, zMax])
% Adjust color limits and colormap if needed
colormap('jet');
caxis([rmin, rmax]);



%%
% Calculate mean over the 3rd dimension (time)
mean_temp_obs = nanmean(temp_obs, 3);
mean_temp_ERA = nanmean(temp_ERA, 3);
mean_prec_obs = nanmean(prec_obs, 3);
mean_prec_ERA = nanmean(prec_ERA, 3);
annual_prec_obs = sum(prec_obs(:,:,1:end), 3);
annual_prec_ERA = sum(prec_ERA(:,:,1:end), 3);
% Calculate annual mean precipitation
% Calculate annual average precipitation (Assume 63 years of data)
num_years = 63; % Adjust this if the time span is different
annual_prec_obs_avg = annual_prec_obs / num_years;
annual_prec_ERA_avg = annual_prec_ERA / num_years;

% Prepare the figure and layout
figure;
t = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Adjust colormap range for temperature
temp_min = min([mean_temp_obs(:); mean_temp_ERA(:)], [], 'omitnan');
temp_max = max([mean_temp_obs(:); mean_temp_ERA(:)], [], 'omitnan');

% Adjust colormap range for monthly precipitation
prec_min = min([mean_prec_obs(:); mean_prec_ERA(:)], [], 'omitnan');
prec_max = max([mean_prec_obs(:); mean_prec_ERA(:)], [], 'omitnan');

% Adjust colormap range for annual precipitation
annual_prec_min = min([annual_prec_obs_avg(:); annual_prec_ERA_avg(:)], [], 'omitnan');
annual_prec_max = max([annual_prec_obs_avg(:); annual_prec_ERA_avg(:)], [], 'omitnan');

% Plot Mean Temperature (Observed)
nexttile;
h1 = imagesc(mean_temp_obs, [temp_min temp_max]);
axis off;
set(h1, 'AlphaData', ~isnan(mean_temp_obs));
title('Mean Observed Temperature', 'FontSize', 12, 'FontWeight', 'bold');

% Plot Mean Temperature (ERA)
nexttile;
h2 = imagesc(mean_temp_ERA, [temp_min temp_max]);
axis off;
set(h2, 'AlphaData', ~isnan(mean_temp_ERA));
title('Mean ERA Temperature', 'FontSize', 12, 'FontWeight', 'bold');

% Plot Mean Precipitation (Observed)
nexttile;
h3 = imagesc(mean_prec_obs, [prec_min prec_max]);
axis off;
set(h3, 'AlphaData', ~isnan(mean_prec_obs));
title('Mean Observed Precipitation', 'FontSize', 12, 'FontWeight', 'bold');

% Plot Mean Precipitation (ERA)
nexttile;
h4 = imagesc(mean_prec_ERA, [prec_min prec_max]);
axis off;
set(h4, 'AlphaData', ~isnan(mean_prec_ERA));
title('Mean ERA Precipitation', 'FontSize', 12, 'FontWeight', 'bold');

% Plot Annual Average Precipitation (Observed)
nexttile;
h5 = imagesc(annual_prec_obs_avg, [annual_prec_min annual_prec_max]);
axis off;
set(h5, 'AlphaData', ~isnan(annual_prec_obs_avg));
title('Annual  Observed Precipitation', 'FontSize', 12, 'FontWeight', 'bold');

% Plot Annual Average Precipitation (ERA)
nexttile;
h6 = imagesc(annual_prec_ERA_avg, [annual_prec_min annual_prec_max]);
axis off;
set(h6, 'AlphaData', ~isnan(annual_prec_ERA_avg));
title('Annual  ERA Precipitation', 'FontSize', 12, 'FontWeight', 'bold');

% Add Colorbars
% Colorbar for Mean Temperatures
cb1 = colorbar(t, 'southoutside');
cb1.Layout.Tile = 'south'; % Position across the bottom
ylabel(cb1, 'Temperature (°C)');
colormap(t, 'jet'); % Use consistent colormap
caxis(cb1, [temp_min temp_max]);

% Colorbar for Monthly Precipitation
cb2 = colorbar(t, 'southoutside');
cb2.Layout.Tile = 'south'; % Shared colorbar
ylabel(cb2, 'Precipitation (mm/month)');
caxis(cb2, [prec_min prec_max]);

% Colorbar for Annual Precipitation]
CVal
% Adjust colormap for Annual Precipitation and Add Colorbar
cb3 = colorbar(t, 'southoutside');
cb3.Layout.Tile = 'south';
ylabel(cb3, 'Annual Precipitation (mm/year)');
colormap(t, 'jet'); % Ensure consistent colormap
caxis(cb3, [annual_prec_min annual_prec_max]);

% Update colorbar labels and positions for clarity
cb1.Label.FontSize = 18;
cb2.Label.FontSize = 18;
cb3.Label.FontSize = 18;

% Set colorbar positions relative to grouped subplots
cb1.Position(2) = cb1.Position(2) - 0.1; % Adjust downward for Temperature
cb2.Position(2) = cb2.Position(2) - 0.2; % Adjust downward for Monthly Precipitation
cb3.Position(2) = cb3.Position(2) - 0.3; % Adjust downward for Annual Precipitation
%%
temp_ERA_mean=nanmean(temp_ERA, 3);
temp_obs_mean=nanmean(temp_obs, 3);
prec_obs_mean=nanmean(prec_obs, 3);
prec_ERA_mean=nanmean(prec_ERA, 3);
diff_temp_mean= temp_ERA_mean-temp_obs_mean;
diff_prec_mean=prec_ERA_mean-prec_obs_mean;
% Create a tiled layout
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% Colormap settings (adjust as needed)
colormap('jet');
caxis_limits = [min(temp_ERA_mean(:)), max(temp_ERA_mean(:))]; % Example range
diff_caxis_limits = [min(diff_temp_mean(:)), max(diff_temp_mean(:))]; % Example range

% Temperature ERA Mean
nexttile;
h1 = imagesc(temp_ERA_mean);
axis off;
set(h1, 'AlphaData', ~isnan(temp_ERA_mean)); % Transparent NaN
title('Temperature ERA Mean', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis(caxis_limits);

% Temperature Observed Mean
nexttile;
h2 = imagesc(temp_obs_mean);
axis off;
set(h2, 'AlphaData', ~isnan(temp_obs_mean)); % Transparent NaN
title('Temperature Observed Mean', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis(caxis_limits);

% Temperature Difference
nexttile;
h3 = imagesc(diff_temp_mean);
axis off;
set(h3, 'AlphaData', ~isnan(diff_temp_mean)); % Transparent NaN
title('Temperature Difference (ERA - Observed)', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis(diff_caxis_limits);

% Precipitation ERA Mean
nexttile;
h4 = imagesc(prec_ERA_mean);
axis off;
set(h4, 'AlphaData', ~isnan(prec_ERA_mean)); % Transparent NaN
title('Precipitation ERA Mean', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);

% Precipitation Observed Mean
nexttile;
h5 = imagesc(prec_obs_mean);
axis off;
set(h5, 'AlphaData', ~isnan(prec_obs_mean)); % Transparent NaN
title('Precipitation Observed Mean', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);

% Precipitation Difference
nexttile;
h6 = imagesc(diff_prec_mean);
axis off;
set(h6, 'AlphaData', ~isnan(diff_prec_mean)); % Transparent NaN
title('Precipitation Difference (ERA - Observed)', 'FontSize', 18, 'FontWeight', 'bold');
cb = colorbar; set(cb, 'FontSize', 18);
caxis(diff_caxis_limits);

% Adjust the colormap for all subplots
colormap('jet');
%%
