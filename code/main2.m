clc
clear all
close all

time = .5;
timeStep = .1;
stopCriteria = 0.01;
initHealth = .6;
strengthMat = load('wattson20_21_strength.txt');
connectionDelayMat = load('wattson20_21_delay.txt');
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
health_array=[];
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
    % simulate network
    % while loop for matrix
    %for i = 1:(time/timeStep)
    aPrevious = zeros(1, nNodes);
    aCurrent = zeros(1, nNodes);
    aCurrent(n) = initHealth;
    i = 0;
    maxIterations;
    while max(abs(aCurrent - aPrevious)) > stopCriteria
        %while i < 6
        i = i + 1;
        %aPrevious
        %aCurrent
        aPrevious = aCurrent;
        net = net.simulateNetwork(timeStep);
        % write results to file
        %fileName = sprintf('time%d_infectednode%d.txt', i,n);
        %fileID = fopen(fileName, 'w');
        for j = 1:length(net.list_nodes)
            %fprintf(fileID, '%d %d %d\n', j, net.list_nodes{j}.health_(1), ...
                %net.list_nodes{j}.health_(1) > net.list_nodes{j}.Settings_.resistanceThreshold);
            aCurrent(j)= net.list_nodes{j}.health_(1);
            
        end
        %fclose(fileID);
        health_array=[health_array aCurrent'];
    end
    maxIterations(n) = i;
end
maxIterations;

conc_micro=health_array;
full_it_node=maxIterations;

sum_cumulative_health=sum(conc_micro,1)./6;
%C = mat2cell(sum_cumulative_health', full_it_node)
SUM_cumulative_health=sum_cumulative_health';FULL_it_node=full_it_node;
C = mat2cell(SUM_cumulative_health, FULL_it_node); % C array concatenates all health array from each iter.

%this part takes care of making the evolution plot in each iteration
maximum=max(FULL_it_node)+1;
B=[];
D=[];
for i=1:nNodes
    C{i}(maximum)=0;
    if size(C{i})==[1 maximum];
        C{i}=C{i}'
    end
    B=[B;C{i}];
    D=[D C{i}];
end
B=B';
D=D;

%cdfplot(SUM_cumulative_health)
entry=[];
for j=1:maximum-1
    entry=[entry;nnz(D(j,:))];
end

%entry=entry'; how likely is the network to enter the next iteration is
%quantified by entry array
entry=1:1:maximum-1;
strin=strread(num2str(entry),'%s');
strin=strin';

colorVec = hsv(maximum-1)
legendset = [];
ProbDensity=B(1:maximum:(maximum*nNodes));
% for i=2:maximum
%     plt=cdfplot(M);
%     legendset = [legendset '' num2str(entry(i-1))];
%     set(plt,'color',colorVec(i-1,:))
%     %set(plt,'color',[0 0 0])
%     hold on;
%     M=[M B(i:maximum:(maximum*nNodes))];
% end
% legend(strin,'Location','NW')
% xlab=xlabel('average node health')
% ylab=ylabel('% cases')
% title('Small World Beta=1')
% set(xlab,'FontSize',12)
% set(ylab,'FontSize',12)

%concatenates all the area betwen evolution plots
Area=[];
for i=2:maximum
    [faxes,zaxes]=ecdf(ProbDensity);
    Area=[Area;trapz(zaxes, faxes)];
    ProbDensity=[ProbDensity B(i:maximum:(maximum*nNodes))]; 
end

%the rate of disaster
diff_area=[];
for i=2:numel(Area)
    diff_area=[diff_area; Area(i)-Area(i-1)];
end

plte=plot(diff_area,'LineWidth',2)
axH = findall(gcf,'type','axes');set(axH,'ylim',[7e-04 16e-04]);set(axH,'xlim',[0,16])
set(plte,'color',[0 0 0])
xlab=xlabel('iteration')
ylab=ylabel('average node health')
set(xlab,'FontSize',16)
set(ylab,'FontSize',16)
set(gca,'FontSize',16);

num_area=numel(diff_area);
total_area=sum(diff_area);
infection_rate=total_area/num_area

