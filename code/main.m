clc
clear all
close all
net = NetworkBase;
node = Node(1,2,3,4);
node = node.setPos(0,0);
net = net.addNode(node);
node = Node();
node = node.setPos(1,1);
net = net.addNode(node);
net = net.connectAstoBs(1,2); %directed connection frm A to B
net = net.connectAstoBs(2,1);
plotNet(net)