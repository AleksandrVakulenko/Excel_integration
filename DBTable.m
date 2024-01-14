


classdef DBTable < handle
    
    methods (Access = public)
        function obj = DBTable(filename, varargin)
            narginchk(1, 3);
            if nargin > 1
                Sheetname = char(varargin{1});
            else
                Sheetname = '';
            end
            C = readcell(filename, 'Sheet', Sheetname);
            Header = C(1,:);
            obj.Header = string(Header)';
            obj.Table = readtable(filename, 'Sheet', Sheetname, ...
                'VariableNamingRule', 'preserve');
            if nargin > 2
                Columns = varargin{2};
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
            col_ind = obj.find_column(Column);
            Unique = unique(obj.Table{:, col_ind});
            Unique = string(Unique);
        end

        function Table = filter(obj, filter_obj)
            temp_pbj = obj;
            col_ind = temp_pbj.find_column(filter_obj.header_name);
            Table = temp_pbj.Table;
            Column = Table(:, col_ind);
            range = table2cell(Column) == filter_obj.value;
            Table(~range, :) = [];
        end

        % find column index by name or just passes input index
        % fixme: add range check
        function col_ind = find_column(obj, Column)
            if isnumeric(Column) && numel(Column) == 1
                col_ind = Column;
            elseif isnumeric(Column) && numel(Column) ~= 1
                error('err placeholder'); % fixme
            else
                col_ind = find(obj.Header == string(Column));
            end
        end


    end
    
    


    properties (Access = public)
        Header string
        Table table
    end

end

















