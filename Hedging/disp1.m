function disp1(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
% DISP1
% displays up to ten arguments on the screen
% e.g., x = 2.3;
%       disp1('x =', x, '; 2*x =', 2*x);
% will print 'x = 2.3 ; 2*x = 4.6' on the screen

s = [];
for i = 1 : nargin;
    x = eval(['s',int2str(i)]);

    % num2str.m code follows with '%.6g' replacing '%.4g'
    if isstr(x)
            t = [x ' '];
    else
            t = sprintf('%.6g ',x);
    end

    s = [s t];
    end;

disp(s);

% end of disp1.m
