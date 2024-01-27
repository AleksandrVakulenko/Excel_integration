
clc
PhotoDB = DBTable("Photo1.xlsx", 'Основная');
MooseDB = DBTable("Moose1.xlsx", 'Основная');

%%

clc

Place_list = ["1.1.", "1.2.", "1.3.", "1.4.", "1.7.", "1.8.", "2.0.", "2.1.", ...
    "2.2.", "2.3.", "2.4.", "2.5.", "3.1.", "3.2.", "4.1.", "4.2.", "4.5.", "5.1.", ...
    "5.2.", "7.1.", "8.1.", "8.2.", "9.1.", "10.1.", "11.2.", "11.3.", "11.4.", "15.1.", ...
    "16.1.", "17.1.", "18.1."];

N = 1;
Photo_table_part = DBTable(PhotoDB, DBFilter(Place_list(N), "1"));
Moose_table_part = DBTable(MooseDB, DBFilter("№солонца", Place_list(N)));

Valid_dates = Photo_table_part.get_unique("Полная дата");


%%

K = 821;
Current_date = Valid_dates(K);
Final_part = DBTable(Moose_table_part, DBFilter("Полная дата", Current_date));


%%

Final_part.dereference


