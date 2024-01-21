

% fixme: add method for .size / delete Table_size prop
classdef DBTable < handle
    
    methods (Access = public)
        % create DBTable by opening a file
        % 2nd arg is a sheetname of excel
        % erd arg is a name of columns to save
        %
        % create DBTable by other DBTable if calss of 1st arg is "DBTable"
        % 2nd arg is required and means an action: filter (for now it has only one value)
        % fixme: delete or append this list of actions
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
                obj.Table_size = size(obj.Table, 1);
                disp(['DBTable loaded from file "' char(source) '"'])

            elseif class(source) == "DBTable" %fixme: add referencing case
                    action = varargin{1};
                    if class(action) == "DBFilter"
                        obj.Referencing = true;
                        obj.Header = source.Header;
                        obj.Ref_table = source.get_table_ref;
                        obj.Virtual_indexes = source.filter(action);
                        obj.Table_size = numel(obj.Virtual_indexes);
                        % fixme: maybe add ref_on_me_counter?
                    else
                        error('Wrong filter class in DBTable constructor')
                    end

            else
                error('Wrong source class in DBTable constructor')
            end
        end
    
        % get all of column names
        function Header = get_header(obj)
            Header = obj.Header;
        end

        % returns unique values of <Column> content
        % <Column> is an integer value of column (>=1, <=size)
        % OR <Column> is a string (or char array) name
        function Unique = get_unique(obj, Column)
            Unique = unique(obj.get_col_content(Column));
            Unique = string(Unique{:, 1});
        end

        % produces a new table by filtering current
%         function Table = filter(obj, filter_obj)
%             % fixme: add referencing case
%             % fixme: replace filter_obj from struct to class DBFilter
%             temp_pbj = obj;
%             col_ind = temp_pbj.find_column(filter_obj.header_name);
%             Table = temp_pbj.Table;
%             Column = Table(:, col_ind);
%             range = string(table2cell(Column)) == string(filter_obj.value);
%             Table(~range, :) = [];
%         end

        % get indexes there any of dbfilter conditions are true
        function indexes = filter(obj, dbfilter_obj)
            % fixme: add referencing case
            range = false(obj.Table_size, 1);
            for i = 1:dbfilter_obj.size
                col_name = dbfilter_obj.col{i};
                value = dbfilter_obj.val{i};
                Column = obj.get_col_content(col_name);
                range = range | string(table2cell(Column)) == string(value); % filter point
            end
            indexes = find(range);
            if obj.Referencing
                indexes = obj.Virtual_indexes(indexes);
            end
        end

        % find column index by name or just passes input index
        % fixme: put to private
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
    
        % returns content (table type) of 'col_name' column
        function column_content = get_col_content(obj, col_name)
            table_ref = obj.get_table_ref;
            col_ind = obj.find_column(col_name);
            if obj.Referencing
                column_content = table_ref.Table(obj.Virtual_indexes, col_ind);
            else
                column_content = table_ref.Table(:, col_ind);
            end
        end

    end
    

    methods (Access = private)
        % get reference on table
        function table_ref = get_table_ref(obj)
            if obj.Referencing
                table_ref = obj.Ref_table;
            else
                table_ref = obj;
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
        Table_size double = 0;
    end

end

















