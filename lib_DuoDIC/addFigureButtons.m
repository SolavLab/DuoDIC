function []=addFigureButtons(varargin)
%% Adding buttons to toolbar
% addFigureButtons
% addFigureButtons(hf)
%%
nargin=numel(varargin);

switch nargin
    case 0
        hf=gcf;
    case 1
        hf=varargin{1};
    otherwise
        error('wrong number of input arguments');
end

addColorbarLimitsButton(hf);
addColormapButton(hf);
end