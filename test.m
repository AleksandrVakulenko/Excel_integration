

clc


Columns = ["№солонца", "Полная дата", "Пол", "Возраст", ...
    "Продолжительность посещения, мин"];
MooseDB = DBTable("Moose1.xlsx", 'Основная', Columns);

% PhotoDB = DBTable("Photo1.xlsx", 'Основная');


%% copy and reference differences:
clc
A = 3 % init A
B = A % copy A to B
% now B is copy of A
% B is a same class as A
% B has a same contens as A
% B is euqal to A
A == B % it is logical true

% if we do copy of DBTable
MooseDB2 = MooseDB;
% and check equality
MooseDB2 == MooseDB
% it is also logical true
% but in a different way
% now it means that MooseDB and MooseDB2 referencing the same object
% if we modify one of them
% it modifies all other "copy"
% in programming such variabels are called "reference to ..."
% in our case it is reference to DBTable object

% copy
Table = MooseDB.filter(filter_obj);


%%

clc

MooseDB.get_header
MooseDB.get_unique("№солонца")


filter_obj.header_name = "№солонца";
filter_obj.value = "1.1.";

Table = MooseDB.filter(filter_obj);


%%






















