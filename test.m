%%
clc


Columns = ["№солонца", "Полная дата", "Пол", "Возраст", ...
    "Продолжительность посещения, мин"];

MooseDB = DBTable("Moose1.xlsx", 'Основная');


PhotoDB = DBTable("Photo1.xlsx", 'Основная');

%%

clc

% MooseDB.get_header
% MooseDB.get_unique("№солонца")
% col = MooseDB.get_col_content("№солонца")
% MooseDB.get_table_size





%%

clc
DBFilter('1.1.', 1, '1.2.', 0)


Ref_T = DBTable(PhotoDB,  DBFilter('1.1.', 1));


%%

Ref_T.dereference

% MooseDB.counter











