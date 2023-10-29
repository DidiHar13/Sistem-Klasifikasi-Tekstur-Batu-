clc; clear; close all; warning off all;

%%proses pengujian
%menetapkan lokasi folder
nama_folder = 'data uji';
%%membaca file berekstensi jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%menginisialisasi variable ciri uji
ciri_uji = zeros(jumlah_file,4);
%melakukan pengolahan citra terhadap file
for n = 1:jumlah_file
    %membacafile citra rgb
    Img = imread(fullfile(nama_folder,nama_file(n).name));
%     figure, imshow(Img)
    %melakukan konversi citra rgb ke grayscale
    Img_gray = rgb2gray(Img);
%     figure, imshow(Img_gray)
    %melakukan konversi citra grayscale ke biner
    bw = imbinarize(Img_gray);
%     figure, imshow(bw)
    %melkukan operasi komplemen
    bw = imcomplement(bw);
%     figure, imshow(bw)
    %melakukan operasi morfologi filing holes
    bw = imfill(bw,'holes');
%     figure, imshow(bw)
    %ekstrasi ciri
    %melakukan konversi citra rgb ke hsv
    HSV = rgb2hsv(Img);
%     figure, imshow(HSV)
    %melakukan ekstrasi komponen h,s &v pada citra hsv
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    %mengubah nilai pixel bg menjadi 0
    H(~bw)=0;
    S(~bw)=0;
    V(~bw)=0;
    %menghitung nilai rata" h,s,v
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    %menghitung luas objek
    Luas = sum(sum(bw));
    %mengisi variable ciri latih dengan ciri hasil ekstrasi
    ciri_uji(n,1)= Hue;
    ciri_uji(n,2)= Saturation;
    ciri_uji(n,3)= Value;
    ciri_uji(n,4)= Luas;
end

%menyusun kelas uji
kelas_uji = cell(jumlah_file,1);
%mengisi nama" tekstur kelas uji
for k = 1:3
    kelas_uji{k}= 'burik';
end
for k = 4:5
    kelas_uji{k}= 'halus';
end
for k = 6:7
    kelas_uji{k}= 'kasar';
end


%memanggil naive bayes hasil pelatihan
load Mdl

%membaca kelas keluaran hasil pengujian
hasil_uji = predict(Mdl,ciri_uji);

% menghitung akurasi pengujian
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_uji{k},kelas_uji{k})
        jumlah_benar = jumlah_benar+1;
    end
end
akurasi_pengujian = jumlah_benar/jumlah_file*100

