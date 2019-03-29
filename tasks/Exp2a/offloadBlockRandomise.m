function result_list = offloadBlockRandomise (original_list, blockNum, r)
% Put word pairs into different blocks.
% The parameter r (0 or 1) will only be taken into account when blockNum =
% 2 and the length of word list is an odd number.

if nargin ==2
   r = []; 
end

% Block randomisation
blockOrder=randperm(blockNum);
result_list={};

if isempty(original_list)
    for i=1:blockNum
       result_list{i}=[];
    end
    return;
end

% Identify the structure of original list
    
if iscell(original_list{1}) && size(original_list,2)==2
    
    if mod(size(original_list{1},1),blockNum) == 0
        
        eachBlockItems=size(original_list{1},1)/blockNum;
        
        for i=1:blockNum
            result_list{i}(:,1)=original_list{1}((blockOrder(i)-1)*eachBlockItems+1:blockOrder(i)*eachBlockItems);
            result_list{i}(:,2)=original_list{2}((blockOrder(i)-1)*eachBlockItems+1:blockOrder(i)*eachBlockItems);
        end
        
    else
        
        if isempty(r)
           r = round(rand()); 
        end
            
        result_list{1}(:,1)=original_list{1}(1:(size(original_list{1},1)-1)/2+r);
        result_list{1}(:,2)=original_list{2}(1:(size(original_list{1},1)-1)/2+r);
            
        result_list{2}(:,1)=original_list{1}((size(original_list{1},1)-1)/2+r+1:size(original_list{1},1));
        result_list{2}(:,2)=original_list{2}((size(original_list{1},1)-1)/2+r+1:size(original_list{1},1));
        
    end
    
elseif ~iscell(original_list{1}) && size(original_list,2)==2
    
    if mod(size(original_list,1),blockNum) == 0
    
        eachBlockItems=size(original_list,1)/blockNum;
        
        for i=1:blockNum
            result_list{i}(:,1)=original_list((blockOrder(i)-1)*eachBlockItems+1:blockOrder(i)*eachBlockItems,1);
            result_list{i}(:,2)=original_list((blockOrder(i)-1)*eachBlockItems+1:blockOrder(i)*eachBlockItems,2);
        end
        
    else
        
        if isempty(r)
           r = round(rand()); 
        end
            
        result_list{1}(:,1)=original_list(1:(size(original_list,1)-1)/2+r,1);
        result_list{1}(:,2)=original_list(1:(size(original_list,1)-1)/2+r,2);
            
        result_list{2}(:,1)=original_list((size(original_list,1)-1)/2+r+1:size(original_list,1),1);
        result_list{2}(:,2)=original_list((size(original_list,1)-1)/2+r+1:size(original_list,1),2);
        
    end
end