function result = createArrays(nArrays, arraySize)
% http://stackoverflow.com/questions/466972/array-of-matrices-in-matlab
result = cell(1, nArrays);
for i = 1 : nArrays
    result{i} = zeros(arraySize);
end
end