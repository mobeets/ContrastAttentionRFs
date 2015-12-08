function obj = oneCell(X, Y, D, fitType)
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

if strcmpi(fitType, 'ML')
    obj = reg.getObj_ML(X, Y, obj);
elseif strcmpi(fitType, 'Ridge')
    obj.wML = (X'*X + 1e-5*eye(size(X,2)))\(X'*(Y-mean(Y)));
    obj = reg.getObj_ML_Ridge(X, Y, scoreObj, obj);
elseif strcmpi(fitType, 'ARD')    
    objRdg = ft.oneCell(X, Y, D, 'Ridge');
    obj.wML = objRdg.w;
    obj.pRdg = objRdg.hyper;
    obj = reg.getObj_ML_ARD(X, Y, scoreObj, obj);
elseif strcmpi(fitType, 'ASD')
    obj = reg.getObj_ASD(X, Y, D, scoreObj, obj);
end

obj = reg.fitAndScore(X, Y, obj, scoreObj);
end
