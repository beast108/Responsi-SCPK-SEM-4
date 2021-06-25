% mengambil data dari real_estate.xlsx
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (3:5);
data1 = readmatrix('real_estate.xlsx', opts);
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (8);
data2 = readmatrix('real_estate.xlsx', opts);

% menggabungkan kolom-kolom
data = [data1 data2];
data = data(1:50,:);
x = data;

% Nilai bobot tiap kriteria (1= sangat buruk, 2=buruk,
% 3=cukup, 4= tinggi, 5= sangat tinggi)
nilaiC1 = 3;
nilaiC2 = 5;
nilaiC3 = 4;
nilaiC4 = 1;
w = [nilaiC1 nilaiC2 nilaiC3 nilaiC4];

% rating kecocokan dari masing-masing alternatif
% atribut jika 1 maka dimaksimalkan (menguntungkan) 
% jika 0 maka diminimalkan (biaya)
atributC1 = 0;
atributC2 = 0;
atributC3 = 1;
atributC4 = 0;
k = [atributC1 atributC2 atributC3 atributC4];

% tahapan pertama, memperbaiki bobot
[m, n]=size (x); 
w=w./sum(w); % membagi bobot per kriteria dengan jumlah total seluruh bobot

% tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for j=1:n
        if k(j)==0, w(j)=-1*w(j);
    end
end
for i=1:m
        S(i)=prod(x(i,:).^w);
end

%tahapan ketiga, proses perangkingan & penampilan data
V= S/sum(S);

Vtranspose=V.';
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (1);
data2 = readmatrix('real_estate.xlsx',opts);
data2 =data2(1:50,:);
data2 =[data2 Vtranspose];
data2 =sortrows(data2,-2);
data2 = data2(1:5,1); % menampilkan ranking 1-5

disp ('Real Estate yang paling alternatif =')
disp (data2)