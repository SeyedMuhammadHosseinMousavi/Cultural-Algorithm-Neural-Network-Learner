function [x,err]=ca(CostFunction,nVar)
VarSize = [1 nVar];   % Decision Variables Matrix Size
VarMin = -10;         % Decision Variables Lower Bound
VarMax = 10;         % Decision Variables Upper Bound
%% Cultural Algorithm Settings
MaxIt = 200;         % Maximum Number of Iterations
nPop = 30;            % Population Size
pAccept = 0.35;                   % Acceptance Ratio
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals
alpha = 0.3;
beta = 0.5;
Culture.Situational.Cost = inf;
Culture.Normative.Min = inf(VarSize);
Culture.Normative.Max = -inf(VarSize);
Culture.Normative.L = inf(VarSize);
Culture.Normative.U = inf(VarSize);
empty_individual.Position = [];
empty_individual.Cost = [];
pop = repmat(empty_individual, nPop, 1);
% Initial Solutions
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);
end
% Sort 
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Adjust Culture 
spop = pop(1:nAccept);
Culture = AdjustCulture(Culture, spop);
% Update  
BestSol = Culture.Situational;
BestCost = zeros(MaxIt, 1);
%% Cultural Algorithm Main Loop
for it = 1:MaxIt
% Influnce of Culture
for i = 1:nPop
for j = 1:nVar
sigma = alpha*Culture.Normative.Size(j);
dx = sigma*randn;
if pop(i).Position(j)<Culture.Situational.Position(j)
dx = abs(dx);
elseif pop(i).Position(j)>Culture.Situational.Position(j)
dx = -abs(dx);
end
pop(i).Position(j) = pop(i).Position(j)+dx;
end        
pop(i).Cost = CostFunction(pop(i).Position);
end
% Sort 
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Adjust Culture 
spop = pop(1:nAccept);
Culture = AdjustCulture(Culture, spop);
% Update Best Solution Ever Found
BestSol = Culture.Situational;
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
disp(['Itr ' num2str(it) ': Cost = ' num2str(BestCost(it))]);
end
x=BestSol.Position';
err=BestSol.Cost;
%% Plot ITR
figure;
plot(BestCost, 'k-', 'LineWidth', 1);
xlabel('ITR');
ylabel('COST');

