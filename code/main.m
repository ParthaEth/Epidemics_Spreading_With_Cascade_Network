%% This forms the main part of simulation where the network data is read from the file,
%% and within a loop each node is infected, and the network is simulated until specified 
%% stopping criteria is fulfilled.

%% 
time = .5; % time/timeStep gives the number of iterations the simulation is run
timeStep = .1;
stopCriteria = 0.01;
initHealth = .6; % Initial health of infected node
strengthMat = load('edge_strength1.txt');
connectionDelayMat = load('edge_timedelay1.txt');
nNodes = size(strengthMat,1);
originalNet = NetworkBase;
maxConnectionDelay = max(connectionDelayMat(:))/timeStep;

% Add Nodes to Network
for i = 1:(nNodes)
    node = Node(maxConnectionDelay, 0.1, 0.025, 0.5, 4);
    originalNet = originalNet.addNode(node);
end

% Connect Nodes in Network
for i = 1:(nNodes)
    for j =  1:(nNodes)
        %if strengthMat(i,j)>0
        originalNet = originalNet.connectAstoBs(i, j, strengthMat(i,j), connectionDelayMat(i,j));
        %end
    end
end
% Loop to disease a node
% simulate
maxIterations = zeros(1,nNodes);
for n = 1:(nNodes)
    % Reset to original network
    net = originalNet;
    % For single node (n)
    % disease one node and keep others healthy
    for h = 1:length(net.list_nodes)
        net.list_nodes{h} = net.list_nodes{h}.setCurrentHealth(0);
    end
    net.list_nodes{n} = net.list_nodes{n}.setCurrentHealth(initHealth);
    aPrevious = zeros(1, nNodes);
    aCurrent = zeros(1, nNodes);
    aCurrent(n) = initHealth;
    i = 0;
    maxIterations;
    while max(abs(aCurrent - aPrevious)) > stopCriteria
        i = i + 1;
        aPrevious = aCurrent;
        net = net.simulateNetwork(timeStep);
        % write results to file
        fileName = sprintf('WriteData/time%d_infectednode%d.txt', i,n);
        fileID = fopen(fileName, 'w');
        for j = 1:length(net.list_nodes)
            fprintf(fileID, '%d %d %d\n', j, net.list_nodes{j}.health_(1), ...
                net.list_nodes{j}.health_(1) > net.list_nodes{j}.Settings_.resistanceThreshold);
            aCurrent(j)= net.list_nodes{j}.health_(1);
        end
        fclose(fileID);
    end
    maxIterations(n) = i;
end
maxIterations