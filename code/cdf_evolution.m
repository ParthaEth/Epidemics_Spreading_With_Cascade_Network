full_it_node=[5 5 5 5 5 5];
n_branches=6

conc_micro=[];

for j=1:6
    for k = 1:full_it_node(j)
        myfilename = sprintf('time%d_infectednode%d.txt',k,j);
        mat=importdata(myfilename);
        mat=mat(:,2);
        conc_micro = [conc_micro mat];
    end
    
end
conc_micro;

sum_cumulative_health=sum(conc_micro,1)./6;
%C = mat2cell(sum_cumulative_health', full_it_node)
sum_cumulative_load=sum_cumulative_health';count_macro=full_it_node;
C = mat2cell(sum_cumulative_load, count_macro);

maximum=max(count_macro)+1;
B=[];
D=[];
for i=1:n_branches
    C{i}(maximum)=0;
    if size(C{i})==[1 maximum];
        C{i}=C{i}'
    end
    B=[B;C{i}];
    D=[D C{i}];
end
B=B';
D=D;
%cdfplot(sum_cumulative_load)
entry=[];
for j=1:maximum-1
    entry=[entry;nnz(D(j,:))];
end

entry=entry';
strin=strread(num2str(entry),'%s');
strin=strin';

colorVec = hsv(maximum-1)
legendset = [];
M=B(1:maximum:(maximum*n_branches));
for i=2:maximum
    plt=cdfplot(M);
    legendset = [legendset '' num2str(entry(i-1))];
    set(plt,'color',colorVec(i-1,:))
    %set(plt,'color',[0 0 0])
    hold on;
    M=[M B(i:maximum:(maximum*n_branches))];
    
end
legend(strin,'Location','NW')



title('case5')

