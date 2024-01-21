

clc


Columns = ["№солонца", "Полная дата", "Пол", "Возраст", ...
    "Продолжительность посещения, мин"];
MooseDB = DBTable("Moose1.xlsx", 'Основная', Columns);

PhotoDB = DBTable("Photo1.xlsx", 'Основная');

%%

clc

Ref_T = DBTable(PhotoDB,  DBFilter('1.1.', 0))

%%

clc

% PhotoDB.filter(DBFilter('1.1.', 0));

Ref_on_PhotoDB = DBTable(PhotoDB, DBFilter('1.1.', 1));
Ref_on_PhotoDB2 = DBTable(Ref_on_PhotoDB, DBFilter('День', 1));

% PhotoDB.get_col_content('1.1.')
% Ref_on_PhotoDB.get_col_content('1.1.')

%%

clc

MooseDB.get_header
MooseDB.get_unique("№солонца")


% filter_obj.header_name = "1.1.";
% filter_obj.value = "0";

% Table = MooseDB.filter(filter_obj);
% Table = PhotoDB.filter(filter_obj);

%%






















