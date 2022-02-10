function Vo = camview(varargin)

% function Vo = camview([hAx], [Vi])
% ------------------------------------------------------------------------
% CAMVIEW  Records or sets the viewpoint of the current axes
%
%   Vo = camview([hAx], [Vi])
%
% Records or sets the viewpoint of the current axes, including projection
% type. This is useful for giving multiple axes (with the same coordinate
% frame) the same viewpoint, or resetting the viewpoint to a known point.
% A data aspect ratio of [1 1 1] is assumed.
%
% The view is recorded and set using a 4x4 matrix. The upper 3x4 quadrant
% of this matrix is a projection matrix from the axes coordinate frame to
% the camera coordinate frame (the view frustrum coordinates range from -1
% to 1 in x and y directions). Padding the last row with [0 0 0 1] makes it
% possible to use projection matrices computed externally.
%
% IN:
%    hAx - Handle to the axes in question. Default: gca.
%    Vi - 4x4 matrix defining the viewpoint to set the current axes to. The
%         matrix should defined by calling camview on previous axes.
%
% OUT:
%    Vo - 4x4 matrix specifying the viewpoint of the current axes just
%         prior to the function being called.
%
% This code was written by Oliver Woodford and obtained from:
% http://www.mathworks.com/matlabcentral/fileexchange/34883-camview
%
% (C) Copyright Oliver Woodford 2006-2015
%
% Kevin Mattheus Moerman
% gibbon.toolbox@gmail.com
%
% 2015/04/15 %Added to external library for GIBBON toolbox
% ------------------------------------------------------------------------

%% Problem 1) zoom out 2) if move then exit and renter back to when botton press
% Set default inputs
hAx = gca;
Vi = [];
% Parse the inputs
for a = 1:nargin
    if ishandle(varargin{a})
        hAx = varargin{a};%varargin{1}->current axis ,
    else
        Vi = varargin{a}; %varargin{2}->caxUserDataStruct.defaultView) ,
    end 
end

if nargout > 0
    %{
    % Get the current viewpoint Veiw?      
    t = get(hAx, 'CameraPosition')
    d = get(hAx, 'CameraTarget') - t
    K = eye(3);
    K([1 5]) = 1 / tan(get(hAx, 'CameraViewAngle') *2*pi /360);% The greater the angle, the larger the field of view and the smaller objects appear in the scene
    %AYS ADDED 2 PI 
    R(:,3) = d / norm(d);%normilzed victor of CameraTarget 
    R(:,2) = get(hAx, 'CameraUpVector');%Vector defining upwards direction
    R(:,1) = cross(R(:,3), R(:,2));% R is the axis of th target 
    Vo = K * R' * [eye(3) -t'];
  
    Vo(4,:) = [norm(d) 0 0 strcmp(get(hAx, 'Projection'), 'perspective')];

    %}
    Vo=struct;
    Vo.CameraPosition=get(hAx, 'CameraPosition');
    Vo.CameraTarget=get(hAx, 'CameraTarget');
    Vo.CameraViewAngle=get(hAx, 'CameraViewAngle');
    Vo.CameraUpVector= get(hAx, 'CameraUpVector');
    Vo.Projection=get(hAx,'Projection');
    
end

if ~isempty(Vi)
    %{
    % Decompose the projection matrix
    st = @(M) M(end:-1:1,end:-1:1)';
    [R, K] = qr(st(Vi(1:3,1:3)));%R*K=qr()
    K = st(K);
    I = diag(K) < 0;
    K(:,I) = -K(:,I);% getting the orginal K?  not orginal
    R = st(R);
    R(I,:) = -R(I,:);% getting the orginal R?not orginal
    t = (K * R) \ -Vi(1:3,4);% getting the orginal t
    K = K / K(3,3);%somthing worng
    
    
    % Set the current viewpoint
    projection = {'perspective', 'orthographic'};
    
    CameraTarget = t'+R(3,:)*(Vi(4)+(Vi(4)==0));
    CameraUpVector = R(2,:);%here problem
    CameraViewAngle = atan(1/Vi(10))*360/(2*pi) %atan(1/K(5))*360/(2*pi);%here problem
    Projection= projection{(Vi(16)==0)+1};
     
    
    set(hAx, 'CameraTarget', t'+R(3,:)*(Vi(4)+(Vi(4)==0)), ...
             'CameraPosition', t, ...
             'CameraUpVector', R(2,:), ...
             'CameraViewAngle', atan(1/Vi(10))*360/(2*pi), ...
             'Projection', projection{(Vi(16)==0)+1});
    %}
     set(hAx, 'CameraTarget', Vi.CameraTarget, ...
             'CameraPosition', Vi.CameraPosition, ...
             'CameraUpVector',Vi.CameraUpVector, ...
             'CameraViewAngle',Vi.CameraViewAngle, ...
             'Projection', Vi.Projection);
end

return