function [wts_p, mu_p, sig_p] = mv_eff(n, r_mat, mu, sig, corr)
% MV_EFF  solves for the mean-variance efficient frontier
% input parameters:
% n       number of points on the efficient frontier,
%         from min variance (1) to max return (n)
% r_mat   return matrix:  rows = scenarios, columns = securities
% mu      vector of mean returns
% sig     vector of standard deviation of returns
% corr    correlation matrix of returns
% Note:   mv uses either (1) r_mat, or (2) mu, sig, and corr.
%         in the second case, call mv with r_mat = 0.
% outputs:
% wts_p   matrix of portfolio weights of efficient portfolios
% mu_p    vector of mean returns of efficient portfolios
% sig_p   vector of std dev of returns of efficient portfolios
% sample calling sequences:
%    [wts_p, mu_p, sig_p] = mv(10, 0, mu, sig, corr);
%    [wts_p] = mv(20, r_mat);

% Optional algorithm for quadprog (not used because of matlab version)
algo = optimset('Algorithm','interior-point-convex');
warning off

if (min(size(r_mat)) >= 2)
   mu   = mean(r_mat)';
   sig  = std(r_mat)';
   corr = corrcoef(r_mat); 
   end;
nsecur  = length(mu);
wts_p   = zeros(n, nsecur);
mu_p    = zeros(n, 1);
sig_p   = zeros(n, 1);

% set up variables for the call to quadprog
H     = diag(sig)*corr*diag(sig);
f       = zeros(1, nsecur);
A       = [];
b       = [];
Aeq	  = ones(1, nsecur);
beq	  = 1;
vlb     = zeros(nsecur, 1);
vub     = ones(nsecur, 1);
x       = ones(nsecur, 1) / nsecur;  % guess equal weights

% first solve for minimum variance portfolio
x       = quadprog(H, f, A, b, Aeq, beq, vlb, vub, x);
wts_p(1,:) = x';
mu_p(1)    = mu'*x;
sig_p(1)   = sqrt(x'*H*x);

mu_max = max(mu);
A      = -mu';
% Start at i=2 because we already calculate i=1 which is the min VarP above
for i = 2 : n;
    % set rmin by taking a convex combination of the two extremes
    % mu_max and mu_p
    % rmin = alpha*mu_max + (1-alpha)*mu_p
    b = -( (n-i)/n*mu_p(1) + i/n*mu_max );
    
    % resolve optimal portfolio for new rmin
    x       = quadprog(H, f, A, b, Aeq, beq, vlb, vub, x);
    wts_p(i,:) = x';
    mu_p(i)    = mu'*x;
    sig_p(i)   = sqrt(x'*H*x);
end;

% end of mv_eff.m
