%% load movies (the long way)

fnms = io.getFilenames();
fnm = fnms{end};
[~, ~, M] = io.loadTrialsAndStimuli(fnm);

%% load behavior

B = behav.loadBehav('jah_20151214-1500');
prefix = strrep(unique({B.prefix}), 'example/', '');
prefix = prefix{1}(1:end-1);
if ~isfield(M, prefix)
    error('Prefix not found.');
end
X = M.(prefix);

%%

pos = behav.stimPosNearTargPos(B, X);
stimCoords = tools.stimCoords([150 -150], size(X{1}{1},1), 8);

stimX = nan(size(pos(:,1)));
ixx = ~isnan(pos(:,1));
stimX(ixx) = stimCoords(1,pos(ixx,1));

stimY = nan(size(pos(:,2)));
ixy = ~isnan(pos(:,2));
stimY(ixy) = stimCoords(2,pos(ixy,2));

B = tools.structArrayAppend(B, 'stimx', stimX);
B = tools.structArrayAppend(B, 'stimy', stimY);

B = tools.structArrayAppend(B, 'targstim_distx', ([B.stimx] - [B.targx]));
B = behav.addBinnedField(B, 'targstim_distx', 'targstim_distxbin', 6);
B = tools.structArrayAppend(B, 'targstim_disty', ([B.stimy] - [B.targy]));
B = behav.addBinnedField(B, 'targstim_disty', 'targstim_distybin', 6);

targstimdist = sqrt([B.targstim_distx].^2 + [B.targstim_disty].^2);
B = tools.structArrayAppend(B, 'targstim_dist', targstimdist);

% plot
B = behav.behavHitAndMissOnly(B);
close all;

B = behav.addBinnedField(B, 'targstim_dist', 'targstim_distbin', 10);
figure;
subplot(2,2,1); hold on;
behav.plotPctCor1d(B, 'targstim_distbin');
subplot(2,2,2); hold on;
behav.plotPctCor2d(B, 'targstim_distxbin', 'targstim_distybin');
subplot(2,2,3); hold on;
behav.plotPctCor1d(B, 'targstim_distxbin');
subplot(2,2,4); hold on;
behav.plotPctCor1d(B, 'targstim_distybin');

