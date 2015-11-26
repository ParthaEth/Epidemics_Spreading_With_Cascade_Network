%clc
%clear all
%close all

time = .5;
timeStep = .1;
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
for n = 1:(nNodes)
	% Reset to original network
    net = originalNet;
    % For single node (n)
	% disease one node and keep others healthy
	for h = 1:length(net.list_nodes)
       net.list_nodes{h} = net.list_nodes{h}.setCurrentHealth(0);
    end
    net.list_nodes{n} = net.list_nodes{n}.setCurrentHealth(0.6);
    
	% simulate network
	for i = 1:(time/timeStep)
		net = net.simulateNetwork(timeStep);
        % write results to file
		fileName = sprintf('WriteData/time%d_infectednode%d.txt', i,n);
        fileID = fopen(fileName, 'w');
		for j = 1:length(net.list_nodes)
            fprintf(fileID, '%d %d %d\n', j, net.list_nodes{j}.health_(1), net.list_nodes{j}.health_(1) > net.list_nodes{j}.Settings_.resistanceThreshold);
        end
    end
end


%{
timeStep = 0.1;
maxConnectionDelay = 3; %in unit of timeSteps
net = NetworkBase;
node = Node(maxConnectionDelay, 0.1, 0.025, 0.5, 4);
%node = node.setPos(0,0);
net = net.addNode(node);
node = Node(maxConnectionDelay, 0.1, 0.025, 0.5, 4);
%node = node.setPos(1,1);
net = net.addNode(node);
net = net.connectAstoBs(1,2,.5, .1);
net = net.connectAstoBs(2,1,.5, .1);
net.list_nodes{1} = net.list_nodes{1}.setCurrentHealth(0.6);
net.list_nodes{2} = net.list_nodes{2}.setCurrentHealth(0.6);
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
% plotNet(net)
%}