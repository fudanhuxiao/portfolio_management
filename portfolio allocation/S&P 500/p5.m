% index.m
% matlab program for the indexation problem
% the data in the file index.prn is in the format:
% The columns in the file index.prn are the date (column 1), 
% the closing daily price of 8 stocks (columns 4, 6, 8, ... , 18) 
% and the adjusted returns for splits and dividends (columns 5, 7, ... ,19)
% The 8 stocks, in order, are: British Petroleum (BP), Hewlett Packard
% (HPQ), Ely Lilly (LLY), Disney (DIS), Nucor (NUE), Citigroup (C), 
% Google (GOOG) and Walmart (WMT).
% The first two columns (2 and 3) contain the S&P500 price and returns.
% The dates run from 01/01/1980 12/31/1987.  
clear all
load index.prn;
%problem (a):
x_ret = index(1:96, 5:2:19);
y_ret = index(1:96, 3);

[nr, nc] = size(x_ret);
% New returns data
m_ret    = x_ret - y_ret*ones(1,nc);
disp('(a):');
disp('parameters for the indexation example');
disp('means: security returns - market return');
disp(mean(m_ret));
disp('standard deviation: security returns - market return');
disp(std(m_ret));
disp('correlation matrix: security returns - market return');
disp(corrcoef(m_ret));

% solve for minimum variance indexed portfolio 
[wts_p, mu_p, sig_p] = mv(-1000, m_ret);

disp('optimal portfolio weights'); disp(wts_p);
disp('standard deviation of daily difference in returns'); 
disp(sig_p);

% problem(b):
x_ret = index(97:end, 5:2:19);
y_ret = index(97:end, 3);

[nr, nc] = size(x_ret);

% How well does the portfolio track the S&P 500?
% Normalize all to 10
% S&P 500 normalized to 10:
y_val = cumprod( [10; (1+y_ret)]);
% portfolio normalized to 10:
p_ret = x_ret*wts_p;
p_val = cumprod( [10; (1+p_ret)]);

figure;
plot([0:nr], y_val, [0:nr], p_val);
title('(b) Comparison of S&P500 and Indexed Portfolio Values');
x_ind = fix(0.5*nr); text(x_ind,y_val(x_ind),'S&P500'); 
text(x_ind,p_val(x_ind),'Indexed Portfolio');
xlabel('Month'), ylabel('Value (in $mm)'), grid;
disp('(b):');
disp('final worth of indexed portfolio:');
disp(p_val(nr));
disp('final value of S&P500:');
disp(y_val(nr));


% Regression in matlab
% As per the help file, you need to use a vector of ones for the constant
% term a_0
reg_coef = regress(y_ret,[ones(length(x_ret),1) x_ret]);
% Alternative regression calculation:
% Regression in matlab, use "\" operator RHS \ LHS
% reg_coef = [ ones(nr,1) x_ret ] \ y_ret;
disp('multiple linear regression coefficients');
disp(reg_coef(2:nc+1));

% Plot regression portfolio
figure;
p_ret2 = x_ret*reg_coef(2:end);
p_val2 = cumprod( [100; (1+p_ret2)]);
plot([0:nr], p_val,[0:nr], p_val2);
title('(b) Comparison of Mean-Variance and Regression');

% problem(c):
x_ret = index([1:93 95:96], 5:2:19);
y_ret = index([1:93 95:96], 3);

[nr, nc] = size(x_ret);
% New returns data
m_ret    = x_ret - y_ret*ones(1,nc);
disp('(c):');
disp('parameters for the indexation example');
disp('means: security returns - market return');
disp(mean(m_ret));
disp('standard deviation: security returns - market return');
disp(std(m_ret));
disp('correlation matrix: security returns - market return');
disp(corrcoef(m_ret));

% solve for minimum variance indexed portfolio 
[wts_p, mu_p, sig_p] = mv(-1000, m_ret);
disp('optimal portfolio weights'); disp(wts_p);
disp('standard deviation of daily difference in returns'); 
disp(sig_p);
x_ret = index(97:end, 5:2:19);
y_ret = index(97:end, 3);

[nr, nc] = size(x_ret);

% How well does the portfolio track the S&P 500?
% Normalize all to 10
% S&P 500 normalized to 10:
y_val = cumprod( [10; (1+y_ret)]);
% portfolio normalized to 10:
p_ret = x_ret*wts_p;
p_val = cumprod( [10; (1+p_ret)]);

figure;
plot([0:nr], y_val, [0:nr], p_val);
title('(c) Comparison of S&P500 and Indexed Portfolio Values');
x_ind = fix(0.5*nr); text(x_ind,y_val(x_ind),'S&P500'); 
text(x_ind,p_val(x_ind),'Indexed Portfolio');
xlabel('Month'), ylabel('Value (in $mm)'), grid;
disp('final worth of indexed portfolio:');
disp(p_val(end));
disp('final value of S&P500:');
disp(y_val(end));

% Regression in matlab
% As per the help file, you need to use a vector of ones for the constant
% term a_0
reg_coef = regress(y_ret,[ones(length(x_ret),1) x_ret]);
% Alternative regression calculation:
% Regression in matlab, use "\" operator RHS \ LHS
% reg_coef = [ ones(nr,1) x_ret ] \ y_ret;
disp('multiple linear regression coefficients');
disp(reg_coef(2:nc+1));

% Plot regression portfolio
figure;
p_ret2 = x_ret*reg_coef(2:end);
p_val2 = cumprod( [100; (1+p_ret2)]);
plot([0:nr], p_val,[0:nr], p_val2);
title('(c) Comparison of Mean-Variance and Regression');
