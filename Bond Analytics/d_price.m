function y = d_price(x);
% function to give the price of the bond given
% the discount yield function.  x represents the
% disc_ind discount factor.

global coupon matur disc_times disc_yield disc_ind target

disc_mat             = [ disc_times  disc_yield ];
if (disc_ind > 0)  disc_mat(disc_ind,2) = x; end;
if (disc_ind == 2) disc_mat(1,2) = x; end;

semi_cpn  = coupon/2;
n_cash_f  = ceil(2*matur);

t1        = matur - floor(matur);
if (t1 > 0.5) t1 = t1 - 0.5; end;
if (t1 == 0)  t1 = 0.5;      end;

cash_flow             = semi_cpn*ones(n_cash_f,1);
cash_flow(n_cash_f,1) = 1 + semi_cpn;

time                  = 0.5*ones(n_cash_f,1);
time(1)               = t1;
time                  = cumsum(time);

pv                    = interp1(disc_mat(:,1), disc_mat(:,2), time);
pv                    = 1 ./ (1 + pv/2).^(2*time);

y   = cash_flow'*pv - target;

% end of d_price.m
