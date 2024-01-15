


classdef DBTable < handle
    
    methods (Access = public)
        % create DBTable by opening a file
        % 2nd arg is a sheetname of excel
        % erd arg is a name of columns to save
        function obj = DBTable(filename, varargin)
            narginchk(1, 3);
            if nargin > 1
                Sheetname = char(varargin{1});
            else
                Sheetname = '';
            end
            C = readcell(filename, 'Sheet', Sheetname);
            Header = C(1, :);
            obj.Header = string(Header)';
            obj.Table = readtable(filename, 'Sheet', Sheetname, ...
                'VariableNamingRule', 'preserve');
            if nargin > 2
                Columns = varargin{2};
                Columns = reshape(Columns, [1, numel(Columns)]);
                indexes = (obj.Header == Columns);
                indexes = (sum(indexes, 2) > 0);
                inv_indexes = logical(1 - indexes);
                obj.Header(inv_indexes) = [];
                obj.Table(:, inv_indexes) = [];
            end
            disp(['DBTable loaded from file "' char(filename) '"'])
        end
    
        % get all of column names
        function Header = get_header(obj)
            Header = obj.Header;
        end

        % returns unique values of <Column> content
        % <Column> is an integer value of column (>=1, <=size)
        % OR <Column> is a string (or char array) name
        function Unique = get_unique(obj, Column)
            col_ind = obj.find_column(Column);
            Unique = unique(obj.Table{:, col_ind});
            Unique = string(Unique);
        end

        % produces a new table by filtering current
        function Table = filter(obj, filter_obj)
            temp_pbj = obj;
            col_ind = temp_pbj.find_column(filter_obj.header_name);
            Table = temp_pbj.Table;
            Column = Table(:, col_ind);
            range = table2cell(Column) == filter_obj.value;
            Table(~range, :) = [];
        end

        % find column index by name or just passes input index
        function col_ind = find_column(obj, Column)
            if isnumeric(Column) && numel(Column) == 1
                col_ind = Column;
            elseif isnumeric(Column) && numel(Column) ~= 1
                error('error placeholder'); % fixme
            else
                col_ind = find(obj.Header == string(Column));
            end
            if isempty(col_ind)
                error('no such column')
            end
            if col_ind < 1
                error('column index must be >= 1')
            end
            if col_ind > numel(obj.Header)
                error(['column index must be <= ' num2str(numel(obj.Header))])
            end
        end


    end
    
    


    properties (Access = public)
        Header string
        Table table
    end

end

















