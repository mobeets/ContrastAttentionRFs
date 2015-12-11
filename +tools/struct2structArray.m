function S = struct2structArray(B)
% 
%     showedWarning = false;
    fns = fieldnames(B);
    vls = cell(numel(fns)*2,1);
    for ii = 1:numel(fns)
        vls{2*ii-1} = fns{ii};
        b = B.(fns{ii});
        if isa(b, 'double')
            b = num2cell(b);
        elseif isa(b, 'char')
            if ii > 1 && size(b,1) == size(vls{2},1)
                % n.b. this only works if it's not the first field
                b = cellstr(b);
            end
%             if ~showedWarning
%                 warning('Can only handle doubles. Sorry.');
%                 showedWarning = true;
%             end
        end
        vls{2*ii} = b;
    end
    S = struct(vls{:});
end
