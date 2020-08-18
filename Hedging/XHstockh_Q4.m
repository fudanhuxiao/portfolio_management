clear all; %delete all existing variables from memory
load stockh_4.prn;  %loads text file containing data into a matrix called 
                   %"stockh_4"

% Store data
dates = stockh_4(:,1); %dates
P_F = stockh_4(:,2); %Future prices
R_F = stockh_4(:,3); %Return on the Future
P_Y = stockh_4(:,4); %Daily Stock portfolio prices
R_Y = stockh_4(:,5); %Return on the Stock portfolio

% stores the size of tb_hed matrix
[ndays, ncol] = size(stockh_4);  
% Define hedging "as of" date (in-sample data size)
today = 64 ;

% stock is 'y', futures is 'x'
% Define in-sample vs. out-of-sample data
y_ret = R_Y(1:today);  y_ret_out = R_Y(today+1:ndays);
x_ret = R_F(1:today);  x_ret_out = R_F(today+1:ndays); % out of sample are the data to test the resulst latter 

obj_4 = @(b) sqrt(var(y_ret + b * x_ret ));

[bmin_4, oval_4, cv_4] = fminsearch(obj_4,0);

% Display the optimal betas
disp('The optimal betas are:');
disp1([bmin_4])

% Run linear regression to calcualte optimal beta
% Use polyfit function, polyfit(x,y,polynomial_degree)
% c is a vector storing the slope and intercept
c = polyfit(x_ret,y_ret,1);
disp(' '); disp1('a. The variance minimizing hedge ratio beta is  ', -c(1));
% Calculate #of futures contracts I recommend that the investor buy or sell
Qf = -c(1)*115411000/(250*969.5);
disp(' '); disp1('a. The number of futures contracts I recommend that the investor buy or sale is ', Qf);

% define in-sample hedged returns with beta obtained from variance
% minimization
h_ret = y_ret - c(1)*x_ret;     % in-sample hedged returns

% Descriptive statistics
disp(' '); disp('Descriptive statistics:')
disp1('mean return of bond                      ', mean(y_ret));
disp1('std. dev. of return of bond              ', std(y_ret));
disp1('mean return of hedged portfolio          ', mean(h_ret));
disp1('std. dev. of return of hedged portfolio  ', std(h_ret));
disp1('ratio of spread of returns               ', ...
           std(h_ret)/std(y_ret));   
       
% Compute out-of-sample results
h_ret_out = y_ret_out - c(1)*x_ret_out;   
% Normalize out of sample hedged portfolio and y_returns to 1 (stocks do not
% have face value)
y_val     = cumprod([1; (1 + y_ret_out)]); 
h_val     = cumprod([1; (1 + h_ret_out)]);

disp(' '); disp('Out-of-sample results:');
disp1('std. dev. of return of bond              ', std(y_ret_out));
disp1('std. dev. of return of hedged portfolio  ', std(h_ret_out));
disp1('ratio of spread of returns               ', ...
            std(h_ret_out)/std(y_ret_out)); 
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotme=1;
if plotme==1
    

    % Plot Histogram of unhedged returns
    figure;
    subplot(2,1,1), hist(y_ret), title('Histogram of Unhedged Returns (Aug.1~Oct.31, 2008)');
    xlabel('Unhedged Return'), ylabel('Frequency'), grid;
    a = axis;

    % Plot Histogram of hedged returns
    subplot(2,1,2), hist(h_ret), axis(a);
    title('Histogram of Hedged Returns  (Aug.1~Oct.31, 2008)');
    xlabel('Hedged Return'), ylabel('Frequency'), grid;

    % Plot out-of-sample results
    figure;
    plot(today:ndays,y_val,'--g',today:ndays,h_val,'-r');
    title('Comparison of Hedged and Unhedged Portfolio Values');
    % Find the right location to place text labels "hedged" and "unhedged"
    x_val = fix(0.5*ndays+0.5*today); x_ind = fix(0.5*(ndays-today));
    text(x_val,y_val(x_ind),'Unhedged'); text(x_val,h_val(x_ind),'Hedged');
    xlabel('Day'), ylabel('Portfolio Value'), grid;
end
% end of tbhedge.m