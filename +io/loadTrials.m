function Z = loadTrials(fnm, keepTrialCode)
if nargin < 2
    keepTrialCode = 150;
end

Z = load(fnm);
Z = Z.TrialInfo;

ixGood = cellfun(@(z) any(z.codes(:,1) == keepTrialCode), Z);
Z = Z(ixGood);

end
