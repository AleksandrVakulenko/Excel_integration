


classdef DBTable < handle
    
    methods (Access = public)
        function obj = DBTable(filename, varargin)
            narginchk(1, 2);
            C = readcell(filename, 'Sheet', 'Основная');
            Header = C(1,:);
            obj.Header = string(Header)';
            obj.Table = readtable(filename, 'Sheet', 'Основная', ...
                'VariableNamingRule', 'preserve');
            if nargin == 2
                Columns = varargin{1};
                Columns = reshape(Columns, [1, numel(Columns)]);
                indexes = (obj.Header == Columns);
                indexes = (sum(indexes, 2) > 0);
                rev_indexes = logical(1 - indexes);
                obj.Header(rev_indexes) = [];
                obj.Table(:, rev_indexes) = [];
            end
            disp(['DBTable loaded from file "' char(filename) '"'])
        end

        function Header = get_header(obj)
            Header = obj.Header;
        end

        function Unique = get_unique(obj, Column)
            if isnumeric(Column) && numel(Column) == 1
                col_ind = Column;
            elseif isnumeric(Column) && numel(Column) ~= 1
                error('err placeholder'); % fixme
            else
                col_ind = find(obj.Header == string(Column));
            end
            Unique = unique(obj.Table{:, col_ind});
            Unique = string(Unique);
        end


    end
    
    


    properties (Access = public)
        Header string
        Table table
    end

end

















