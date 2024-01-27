

classdef DBTable < handle
% --------------------------------- PUPLIC METHODS ---------------------------------
    methods (Access = public)
        % create DBTable by opening a file
        % 2nd arg is a sheetname of excel
        % 3rd arg is a name of columns to save
        %
        % create DBTable by other DBTable if calss of 1st arg is "DBTable"
        % 2nd arg is required and means an action: filter (for now it has only one value)
        % fixme: delete or append this list of actions
        function obj = DBTable(source, varargin)
            narginchk(1, 3);
            if class(source) == "string" || class(source) == "char"
                obj.load_from_file(source, varargin{:});
            elseif class(source) == "DBTable"
                action = varargin{1};
                if class(action) == "DBFilter"
                    obj.Referencing = true;
                    obj.Header = source.Header;
                    obj.Ref_dbtable = source.get_dbtable_ref;
                    obj.Virtual_indexes = source.filter(action);
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

        % get indexes there any of dbfilter conditions are true
        function indexes = filter(obj, dbfilter_obj)
            range = true(obj.get_table_size, 1);
            for i = 1:dbfilter_obj.size
                col_name = dbfilter_obj.col{i};
                value = dbfilter_obj.val{i};
                Column = obj.get_col_content(col_name);
%                 range = range & string(table2cell(Column)) == string(value);
                [~, Column_string_name] = obj.find_column(col_name);
                range = range & ismember(Column.(Column_string_name), value);
            end
            indexes = find(range);
            if obj.Referencing
                indexes = obj.Virtual_indexes(indexes);
            end
        end

        % returns content (table type) of 'col_name' column
        function column_content = get_col_content(obj, col_name)
            table_ref = obj.get_dbtable_ref;
            col_ind = obj.find_column(col_name);
            if obj.Referencing
                column_content = table_ref.Table(obj.Virtual_indexes, col_ind);
            else
                column_content = table_ref.Table(:, col_ind);
            end
        end

        function row_size = get_table_size(obj)
            if obj.Referencing
                row_size = numel(obj.Virtual_indexes);
            else
                row_size = size(obj.Table, 1);
            end
        end
    end

% --------------------------------- PRIVATE METHODS ---------------------------------
    methods (Access = private)
        % get reference on table
        function table_ref = get_dbtable_ref(obj)
            if obj.Referencing
                table_ref = obj.Ref_dbtable;
            else
                table_ref = obj;
            end
        end

        function load_from_file(obj, source, varargin)
            if nargin > 1+1
                Sheetname = char(varargin{1});
            else
                Sheetname = '';
            end
            C = readcell(source, 'Sheet', Sheetname);
            obj.Header = string(C(1, :))';
            obj.Table = readtable(source, 'Sheet', Sheetname, ...
                'VariableNamingRule', 'preserve');
            if nargin > 2+1
                Columns = varargin{2};
                Columns = reshape(Columns, [1, numel(Columns)]);
                indexes = (obj.Header == Columns);
                indexes = (sum(indexes, 2) > 0);
                inv_indexes = logical(1 - indexes);
                obj.Header(inv_indexes) = [];
                obj.Table(:, inv_indexes) = [];
            end
            disp(['DBTable loaded from file "' char(source) '"'])
        end

        % find column index by name or just passes input index
        function [col_ind, col_name] = find_column(obj, Column)
            if isnumeric(Column) && numel(Column) == 1
                col_ind = Column;
            elseif isnumeric(Column) && numel(Column) ~= 1
                error('undefined error'); % fixme
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
            col_name = obj.Header(col_ind);
        end
    end

% --------------------------------- PROPERTIES ---------------------------------
    % all properties are public but modifying any of them
    % leads to undefined behavior
    properties (Access = public)
        % ---- for ref table ------
        Referencing logical = false;
        Ref_dbtable DBTable;
        Virtual_indexes double = [];
        % ---- for data table -----
        Header string
        Table table
    end

end
