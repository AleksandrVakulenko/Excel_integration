

clc


Columns = ["№солонца", "Полная дата", "Пол", "Возраст", ...
    "Продолжительность посещения, мин"];
MooseDB = DBTable("Moose1.xlsx", 'Основная', Columns);

PhotoDB = DBTable("Photo1.xlsx", 'Основная');

%%

clc

Ref_T = DBTable(PhotoDB,  DBFilter)


%%

clc

MooseDB.get_header
MooseDB.get_unique("№солонца")


filter_obj.header_name = "№солонца";
filter_obj.value = "1.1.";

Table = MooseDB.filter(filter_obj);


%%






















