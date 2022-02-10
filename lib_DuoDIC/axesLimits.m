function [xl,yl,zl]=axesLimits(V)
%% calculate axes limits for plotting
% V can be a nX3 matrix of 3D vertices or a cell array which contains nX3
% matrices representing different time frames.
%%
if ~iscell(V)
    Vtemp=V;
    V=cell(1);
    V{1}=Vtemp;
end

xl=[min(V{1}(:,1)) max(V{1}(:,1))]; yl=[min(V{1}(:,2)) max(V{1}(:,2))]; zl=[min(V{1}(:,3)) max(V{1}(:,3))];
for it=1:numel(V)
    xl(1)=min([min(V{it}(:,1)) xl(1)]);
    xl(2)=max([max(V{it}(:,1)) xl(2)]);
    yl(1)=min([min(V{it}(:,2)) yl(1)]);
    yl(2)=max([max(V{it}(:,2)) yl(2)]);
    zl(1)=min([min(V{it}(:,3)) zl(1)]);
    zl(2)=max([max(V{it}(:,3)) zl(2)]);
end


end


%% DuoDIC: 2-camera 3D-DIC toolbox
%% Copyright (C) 2022 Dana Solav - All rights reserved.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%% If used in published OR commercial work, please contact [danas@technion.ac.il] for citation and license information
