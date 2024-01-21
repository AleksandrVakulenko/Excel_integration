


classdef DBFilter

methods (Access = public)

    % create filter object
    % arguments is in pairs col1, value1, col2, value2, ...
    % 
    function obj = DBFilter(varargin)
        if nargin == 0

        elseif mod(nargin, 2) == 1
            error('wrong number of arguments');
        else
            obj.col = varargin(1:2:end);
            obj.val = varargin(2:2:end);
            obj.size = nargin/2;
        end
    end

end

properties (Access = public)
    col cell = {};
    val cell = {};
    size double = 0;
end

end