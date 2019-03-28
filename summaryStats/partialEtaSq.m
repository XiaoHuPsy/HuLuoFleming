function etaSq = partialEtaSq(F, df1, df2)
% function etaSq = partialEtaSq(F, df1, df2)
% Compute partial eta squared based on F statistic and degrees of freedom.
%
% INPUTS:
%
% F = F statistic
% df1 = Degree of freedom for numerator
% df2 = Degree of freedom for denominator
%
% For more information please see:
%
% Richardson, J. T. (2011). Eta squared and partial eta squared as measures
% of effect size in educational research. Educational Research Review,
% 6(2), 135-147.

etaSq = (df1*F)/(df1*F+df2);