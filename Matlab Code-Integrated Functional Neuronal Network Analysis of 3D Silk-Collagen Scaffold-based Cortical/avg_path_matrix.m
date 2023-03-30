function [Len] = avg_path_matrix(M)

%a function to compute the average path length of a given matrix
%using the graphallshortestpaths built-in matlab function

%written by Eric Bridgeford
% set non positive values to 0
M(M<=0)=0;
n = length(M);
M = sparse(M);

% D = graphallshortestpaths(M);
% graphallshortedpaths has been deprecated; use distances instead
% graphallshortestpaths takes in an adjacency matrix, but distances
% does not, so we have to convert M into a graph object
% Convert M to a graph object
M = (M + M')/2;
G = graph(M);


D = distances(G);

% Display the result
disp(D);

%checks if a node is disconnected from the system, and replaces
%its value with 0
for i = 1:n
    for j = 1:n
        if isinf(D(i,j)) == 1
            D(i,j) = 0;
        end
    end
end

Len = mean(mean(D));
end
