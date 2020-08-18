% discount.m
% program to solve for the discount function
% inputs:  price, coupon, and maturity of n bonds
% outputs: spot yield curve and the discount function 

global coupon matur disc_times disc_yield disc_ind target

% specify inputs
price_vec  = [ 93.4684 102.2183 100.359 100.9906 102.488 104.183 100.665 106.518 ];   % per $100 face amount
coupon_vec = [0 7.25 7.5 7 8 8.5 8.25 8.75];       % in percent
matur_vec  = [1 1.75 2.5 3.75 4.75 6.25 9.75 29.25];       % in years

coupon_vec = coupon_vec/100;
price_vec  = price_vec/100;

disc_times = [ 0.0  matur_vec ]';
disc_yield = 0.07*ones(length(disc_times),1);

disp('Solving for the discount function ...');

for i = 1 : length(price_vec);
    coupon          = coupon_vec(i);
    matur           = matur_vec(i);
    target          = price_vec(i);
    disc_ind        = i + 1;
    disc_yield(i+1) = fzero('d_price', 0.07);
    end;

% plot the discount function
t = [0 : 0.5 : max(matur_vec)]';
disc_mat  = [ disc_times  disc_yield ];
d_yield   = interp1(disc_mat(:, 1),disc_mat(:, 2), t);
d_prc     = 1 ./ (1 + d_yield/2).^(2*t);

disp('    time    spot yld    disc factor');
disp([ t  d_yield  d_prc]);

% end of discount.m
