clc
clear all
close all
% TODO(Dinesh) : Can you write some unit tests?
%%%%%%%%%Set parameters%%%%%%%%
timeStep = 0.1;
maxConnectionDelay = 2; %in unit of timeSteps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
net = NetworkBase;
node = Node(maxConnectionDelay, 0.1, 0.025, 0.5, 0.1);
node = node.setPos(0,0);
net = net.addNode(node);
node = Node(maxConnectionDelay, 0.1, 0.025, 0.5, 0.2);
node = node.setPos(1,1);
net = net.addNode(node);
net = net.connectAstoBs(1,2,[0, 0.3; 0.3, 0]); %directed connection frm A to B
net = net.connectAstoBs(2,1,[0, 0.3; 0.3, 0]);
net.list_nodes{1} = net.list_nodes{1}.setCurrentHealth(0.5);
net.list_nodes{2} = net.list_nodes{2}.setCurrentHealth(0);
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
net = net.simulateNetwork(timeStep);
net.list_nodes{1}.health_
net.list_nodes{2}.health_
% plotNet(net)