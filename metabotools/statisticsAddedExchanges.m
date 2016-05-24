function [Ex_added_all_unique] = statisticsAddedExchanges(ResultsAllCellLines,samples)
% [Ex_added_all_unique] = statisticsAddedExchanges(ResultsAllCellLines,samples)
% This function performs statistics on the added exchange reactions using
% the structure ResultsAllCellLines generated by the function
% setQuantConstraints and across all samples.
%
%INPUTS
%    ResultsAllCellLines          Last output ResultsAllCellLines that contains
%                                 results of all samples (last in sampleResult.mat) e.g. in ,
%                                 Y:\Studies\Data_integration\Tutorial_paper\Toolbox\UACC_257_2Result.mat)
%
%
%OUTPUTS
%    Ex_added_all_unique         a table of exchange reactions which the models contain in addition to the
%                                mapped(metabolomics-based)-exchanges, ordered by the
%                                frequency of appearance. Comumn 1 = Exchange
%                                reactions, Comumn 2 = frequency of use, Comumn 3
%                                = secretion, Column = 4 uptake.
%
% Maike Aurich 07/2015


Ex_added_all = [];
Ex_added_all_unique{length(samples),6} =[];

for i=1:length(samples)
    i
    Ex_added_all = [Ex_added_all; eval(['ResultsAllCellLines.' samples{i} '.Ex_RxnsAdded'])];
    Ex_added_all_unique = unique(Ex_added_all);
end

for i=1:length(Ex_added_all_unique)
    A = find(ismember(Ex_added_all, Ex_added_all_unique(i,1)));
    Ex_added_all_unique{i,2} = length(A);
end

Frequencies= zeros(length(Ex_added_all_unique),2);
for i=1:length(samples)
    Ex_RxnsAdded = eval(['ResultsAllCellLines.' samples{i} '.Ex_RxnsAdded']);
    
    for j=1:size(Ex_added_all_unique,1)
        if find(ismember(Ex_added_all_unique{j,1}, Ex_RxnsAdded));
            m = find(ismember(Ex_RxnsAdded, Ex_added_all_unique(j,1)));
            span = eval(['ResultsAllCellLines.' samples{i} '.MinMaxAddedRxns(m,:)']);
            if span(1,1) >= 0 && span(1,2) > 0
                Ex_added_all_unique{j,3}= 'secretion';
                
                Frequencies(j,1) = Frequencies(j,1)+1;
                
            end
            if span(1,1) < 0 && span(1,2) <= 0
                
                Ex_added_all_unique{j,4}= 'uptake';
                
                Frequencies(j,2) = Frequencies(j,2)+1;
            end
            if span(1,1) < 0 && span(1,2) > 0
                
                Ex_added_all_unique{j,5} = 'both1';
            end
            if span(1,1) > 0 && span(1,2) < 0
                
                Ex_added_all_unique{j,6}= 'both1';
            end
        end
    end
end

EX_added_all_unique= {Ex_added_all_unique, Frequencies};

EX_added_all_unique=sortrows(Ex_added_all_unique,-2);

end
