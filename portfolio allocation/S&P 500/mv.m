function [wts_p, mu_p, sig_p] = mv(r_min, r_mat, mu, sig, corr)
% MV      gives min variance portfolio with return at least r_min
% input parameters:
% r_min   minimum portfolio return
% r_mat   return matrix:  rows = scenarios, columns = securities
% mu      vector of mean returns
% sig     vector of standard deviation of returns
% corr    correlation matrix of returns
% Note:   mv uses either (1) r_mat, or (2) mu, sig, and corr.
%         in the second case, call mv with r_mat = 0.
% outputs:
% wts_p   portfolio weights of optimal portfolio
% mu_p    mean return of optimal portfolio
% sig_p   std dev of return of optimal portfolios
% sample calling sequences:
%    [wts_p, mu_p, sig_p] = mv(0.10, 0, mu, sig, corr);
%    [wts_p, mu_p, sig_p] = mv(0.20, r_mat);

% Optional algorithm for quadprog (not used because of matlab version)
algo = optimset('Algorithm','interior-point-convex');
warning off

% Check if user specified r_mat or mu, sig and corr
if (min(size(r_mat)) >= 2)
   mu   = mean(r_mat)';
   sig  = std(r_mat)';
   corr = corrcoef(r_mat); 
   end;
nsecur  = length(mu);

% set up variables for the call to x quadprog
% Covariance matrix: Easy way to do it: H=cov(r_mat)
% However, if you want to use the correlation matrix instead then do:
H = 2*diag(sig)*corr*diag(sig); %gives same result as cov(r_mat)
% Note the factor 2 comes from the call to quadprog() which comes later
% qudrprog() uses 0.5 * x'*H*x as the input matrix


f       = zeros(1, nsecur);
% Min return constraint:
% Quadprog needs: Ax <= b
% We have: mu'x >= rmin
% which translates to: -mu'x <= -rmin
A       = -mu';
b       = -r_min;
% Budget constraint on weights
Aeq	  = ones(1, nsecur);
beq	  = 1;
% Lower and upper bounds on decision variables x_j
vlb     = zeros(nsecur, 1);
vub     = ones(nsecur, 1);
% Initial weight guess
x       = ones(nsecur, 1) / nsecur;  % guess equal weights
% Optimize
[x, FVAL, EXITFLAG]       = quadprog(H, f, A, b, Aeq, beq, vlb, vub, x);
% Solution
wts_p   = x;
mu_p    = mu'*x;
sig_p   = sqrt(x'*H*x);
% Display whether convergence happened or not
%EXITFLAG


% end of mv.m
