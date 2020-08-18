%Binomial Pricer
%Example 2: American Put Option
clear all;
tic;

% Parameters
N = 100; %Number of periods in tree
S0 = 50; %stock price today
sigma = 0.3; %implied vol from options prices
r = 0.05; %Risk-free rate
T = 0.4; %maturity
K = 45; %Strike
t_vec = linspace(0,T,N+1)'; %N+1 total points, including t=0
dt = t_vec(2)-t_vec(1); %time step
df = exp(-r * dt); %Discount factor
u = exp(sigma*sqrt(dt));  
d = 1/u; 
q = (exp(r*dt)-d)/(u-d); %Risk-neutral probability


%%tree
% S_grid: Build Binomial stock price grid
S_grid = zeros(N+1,N+1);
for j = N+1:-1:1
    S_vec = zeros(j,1);
    S_vec = cumprod([S0*u^(j-1); (d/u)*ones(j-1,1)]);
   
    % Store S at time i, in S_grid tree
    S_grid(1:j,j) = S_vec;
end


% Put Payoff
H_maturity = max( K - S_grid(:,end), 0 );

% H_grid: Option value grid
H_grid = zeros(N+1, N+1); 
H_grid(:,end) = H_maturity;


for j = N:-1:1

    % Up/Down Prices in next period j+1
    P_up = H_grid(1:j,j+1);
    P_down = H_grid(2:j+1,j+1);
    
    H_grid(1:j,j) = max( K-S_grid(1:j,j), df .* ( q*P_up+ (1-q).*P_down ) )   ; %American
    
end
c = zeros(N+1,N+1);
bound = ones(N+1,1);
bound(N+1) = max(S_grid(1:end,end) .* (H_grid(1:end,end) == K - S_grid(1:end,end)));
% Find the points in S_grid for which conversion becomes optimal
for j = N:-1:N/2+1
    c(1:j,j) = S_grid(1:j,j) .* (H_grid(1:j,j) == K - S_grid(1:j,j));
    % defines the barrier
    bound(j) = max(c(1:j,j));
end

%% Display

fprintf('\n')
fprintf('>>>>>>>>>>>>>>>>>>>> Results: \n')
fprintf('\n')

plot(dt*[N/2+1:N]'-0.2, bound(N/2+1:N),'r')
title('American put option with barrier')

toc;