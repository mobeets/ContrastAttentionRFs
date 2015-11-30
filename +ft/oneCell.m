function obj = evaluateLinearModel(X, Y, D, fitType)
% X - [nt x nw] - stimulus
% Y - [nt x 1] - spikes
% 
% obj - struct - model fit and scores
% 

obj.llstr = 'gauss'; % noise model; could be 'poiss' or 'bern' as well
obj.nfolds = 10;
[~, obj.foldinds] = tools.trainAndTestKFolds(X, Y, obj.nfolds);

obj.isLinReg = strcmpi(obj.llstr, 'gauss');
scoreObj = reg.getScoreObj(obj.isLinReg);

switch fitType
    case 'ML'
        obj = reg.getObj_ML(X, Y, obj); % ML
    case 'ridge'
        obj = reg.getObj_ML_Ridge(X, Y, scoreObj, obj); % ML + Ridge
    case 'ASD'
        obj = reg.getObj_ASD(X, Y, D, scoreObj, obj);
end

obj = reg.fitAndScore(X, Y, obj, scoreObj);
end
