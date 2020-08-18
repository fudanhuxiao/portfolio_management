% surp.m
% mean-variance surplus optimization program
% the return data is in the form (column number in parenth.):
% common stock(2) small stock(3) LTCB(4) T-bill(5) LTGovt(6) real estate(7) 
%   liabilities(8)

%problem(a):
load SURPLUS.PRN;
ret_col = [ 2  3  4  5  6  7 ];   % only use these six assets
ret_mat = SURPLUS(1:96,ret_col);
mu      = mean(ret_mat);
sig     = std(ret_mat);

[wts_p, mu_p, sig_p] = mv_eff(10, ret_mat);
port1 = wts_p(1, :);  % minimum variance portfolio
disp('(a):');
disp('minimize variance of return, intermediate results:');
disp('means:');
disp(mu);
disp('standard deviation:');
disp(sig);
disp('correlation:');
disp(corrcoef(ret_mat));
disp('optimal portfolio weights that minimize the variance of returns'); 
disp(port1);
disp('standard deviation of daily difference in returns'); 
disp(sig_p);

% re-optimize using surplus
liab     = SURPLUS(1:96,8);
[nr, nc] = size(ret_mat);
surp_mat = ret_mat - liab(:,ones(1,nc));
mu       = mean(surp_mat);
sig      = std(surp_mat);

[wts_p, mu_p, sig_p] = mv_eff(10, surp_mat);
port2 = wts_p(1, :);   % min var relative to liabilities
disp('minimize variance of surplus return, intermediate results:');
disp('means:');
disp(mu);
disp('standard deviation:');
disp(sig);
disp('correlation:');
disp(corrcoef(surp_mat));
disp('optimal portfolio weights that minimize the variance of returns'); 
disp(port2);
disp('standard deviation of daily difference in returns'); 
disp(sig_p);

%problem(b):
ret_mat = SURPLUS(97:end,ret_col);
liab     = SURPLUS(97:end,8);
[nr, nc] = size(ret_mat);
surp_mat = ret_mat - liab(:,ones(1,nc));

% plot surplus values over time
asset1_val = cumprod( [210; (1 + 0.01*ret_mat*port1')] );
asset2_val = cumprod( [210; (1 + 0.01*ret_mat*port2')] );
% 
liab_val   = cumprod( [180; (1 + 0.01*liab)] );
surp1_val  = asset1_val - liab_val;
surp2_val  = asset2_val - liab_val;

plot(0:nr, surp1_val, 0:nr, surp2_val);
title('Surplus vs. Time'); xlabel('Time (in months)');
ylabel('Surplus (in millions)'); grid;
x_ind = fix(0.6*nr); 
text(x_ind, surp1_val(x_ind), 'Minimum Variance Strat 1');
text(x_ind, surp2_val(x_ind), 'Min Surplus Variance Strat 2');
disp('(b):');
disp('final surplus value under minimum variance Strat:');
disp(surp1_val(end));disp('million');
disp('final surplus value under min surplus variance Strat:');
disp(surp2_val(end));disp('million');
% end of surp.m
