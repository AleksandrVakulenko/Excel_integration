


classdef DBTable < handle
    
    methods (Access = public)
        % create DBTable by opening a file
        % 2nd arg is a sheetname of excel
        % erd arg is a name of columns to save
        %
        % create DBTable by other DBTable if calss of 1st arg is "DBTable"
        % 2nd arg is required and means an action: filter (for now it has only one value)
        %
        function obj = DBTable(source, varargin)
            narginchk(1, 3);
            if class(source) == "string" || class(source) == "char"
                if nargin > 1
                    Sheetname = char(varargin{1});
                else
                    Sheetname = '';
                end
                C = readcell(source, 'Sheet', Sheetname);
                Header = C(1, :);
                obj.Header = string(Header)';
                obj.Table = readtable(source, 'Sheet', Sheetname, ...
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
                disp(['DBTable loaded from file "' char(source) '"'])
            elseif class(source) == "DBTable"
                    action = varargin{1};
                    if class(action) == "DBFilter"
                        obj.Referencing = true;
                        obj.Header = source.Header;
                        obj.Ref_table = source;
                        % fixme:
                        % filter here
                        % place results into Virtual_indexes
                        % maybe add ref_on_me_counter?
                    else
                        error('Wrong filter class in DBTable constructor')
                    end
            else
                error('Wrong source class in DBTable constructor')
            end
        end
    
        % get all of column names
        function Header = get_header(obj)
            % fixme: add referencing case
            Header = obj.Header;
        end

        % returns unique values of <Column> content
        % <Column> is an integer value of column (>=1, <=size)
        % OR <Column> is a string (or char array) name
        function Unique = get_unique(obj, Column)
            % fixme: add referencing case
            col_ind = obj.find_column(Column);
            Unique = unique(obj.Table{:, col_ind});
            Unique = string(Unique);
        end

        % produces a new table by filtering current
        function Table = filter(obj, filter_obj)
            % fixme: add referencing case
            % fixme: replace filter_obj from struct to class DBFilter
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
    
    

    % all properties are public but modifying any of them
    % leads to undefined behavior
    properties (Access = public)
        Referencing logical = false;
        Ref_table DBTable;
        Virtual_indexes double = [];
        Header string
        Table table
    end

end

















