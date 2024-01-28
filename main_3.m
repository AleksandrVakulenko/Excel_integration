
clc
PhotoDB = DBTable("Photo1.xlsx", 'Основная');
MooseDB = DBTable("Moose1.xlsx", 'Основная');

%%

clc

Place_list = ["1.1.", "1.2.", "1.3.", "1.4.", "1.7.", "1.8.", "2.0.", "2.1.", ...
    "2.2.", "2.3.", "2.4.", "2.5.", "3.1.", "3.2.", "4.1.", "4.2.", "4.5.", "5.1.", ...
    "5.2.", "7.1.", "8.1.", "8.2.", "9.1.", "10.1.", "11.2.", "11.3.", "11.4.", "15.1.", ...
    "16.1.", "17.1.", "18.1."];

% 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
% + + - - - 0 + - 0  +  -  +  +  -  +  +  +  +  +  -  +  0  +  +  +  +  -  +  -  +  0

N = 18;
Current_place = Place_list(N);

Photo_table_part = DBTable(PhotoDB, DBFilter(Current_place, "1"));
Moose_table_part = DBTable(MooseDB, DBFilter("№солонца", Current_place));

Valid_dates = Photo_table_part.get_unique("Полная дата");

Final_part = DBTable.empty(0, numel(Valid_dates));
for K = 1:numel(Valid_dates)
    disp([num2str(K) '/' num2str(numel(Valid_dates))]);
    Current_date = Valid_dates(K);
    Final_part(K) = DBTable(Moose_table_part, DBFilter("Полная дата", Current_date));
end


%%

Filter = DBFilter('Пол', 'Самец');

Count = [];
Date = string.empty;
for K = 1:numel(Final_part)
    disp([num2str(K) '/' num2str(numel(Final_part))]);
   
    tmp = Final_part(K).counter([]);
    if tmp ~= 0
        Count(K) = tmp;
        Date(K) = Final_part(K).get_unique("Полная дата");
    else
        Count(K) = 0;
        Date(K) = Valid_dates(K);
    end
end
Date = datetime(Date);

[~, m, d] = ymd(Date);
y = repmat(2024, 1, numel(m));
Date_year = datetime(y, m, d);


%%
clc

figure
stem(Date, Count, '.')

% figure
% stem(Date_year, Count, '.')

% plot(Date_year, Count)

% Count_conv = conv(Count, ones(1, 7), 'same');
% stem(Date_year, Count_conv, '.')

%%

Count_mm = movmax(Count, 7);

figure
plot(Date, Count_mm, '.-')








