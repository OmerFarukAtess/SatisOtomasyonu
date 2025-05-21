create database denemelik2


-- 1. IL
CREATE TABLE IL (
    ilID INT PRIMARY KEY,
    ad VARCHAR(100) NOT NULL,
	adresID INT,
);

-- 2. ILCE
CREATE TABLE ILCE (
    ilceID INT PRIMARY KEY,
    ilID INT,
    ad VARCHAR(100) NOT NULL,
    FOREIGN KEY (ilID) REFERENCES IL(ilID)
);

-- 3. MAHALLE
CREATE TABLE MAHALLE (
    mahalleID INT PRIMARY KEY,
    ilceID INT,
    ad VARCHAR(100) NOT NULL,
    FOREIGN KEY (ilceID) REFERENCES ILCE(ilceID)
);

-- 4. CADDE_SOKAK
CREATE TABLE CADDE_SOKAK (
    caddeSokakID INT PRIMARY KEY,
    mahalleID INT,
    ad VARCHAR(100) NOT NULL,
    FOREIGN KEY (mahalleID) REFERENCES MAHALLE(mahalleID)
);

-- 5. ADRES
CREATE TABLE ADRES (
    adresID INT PRIMARY KEY identity(1,1),
    ilID INT,
    ilceID INT,
    mahalleID INT,
    caddeSokakID INT,
    disKapiNo VARCHAR(20) not null,
    icKapiNo VARCHAR(20) not null,
    adresAciklamasi VARCHAR(200),
    FOREIGN KEY (ilID) REFERENCES IL(ilID),
    FOREIGN KEY (ilceID) REFERENCES ILCE(ilceID),
    FOREIGN KEY (mahalleID) REFERENCES MAHALLE(mahalleID),
    FOREIGN KEY (caddeSokakID) REFERENCES CADDE_SOKAK(caddeSokakID)
);

-- 6. VERGI_DAIRESI
CREATE TABLE VERGI_DAIRESI (
    vergiDairesiID INT PRIMARY KEY,
    ad VARCHAR(100) NOT NULL
);

-- 7. SEVKIYAT_YONTEMI
CREATE TABLE SEVKIYAT_YONTEMI (
    sevkiyatYontemiID INT PRIMARY KEY,
    aciklama VARCHAR(200)
);

-- 8. BANKA
CREATE TABLE BANKA (
    bankaID INT PRIMARY KEY,
    bankaAdi VARCHAR(100) not null,
    hesapNo VARCHAR(50) unique not null
);

-- 9. BOLUM
CREATE TABLE BOLUM (
    bolumID INT PRIMARY KEY,
    bolumAdi VARCHAR(100) not null
);

-- 10. GOREV
CREATE TABLE GOREV (
    gorevID INT PRIMARY KEY,
	bolumID INT,
    gorevAdi VARCHAR(100) not null,
	FOREIGN KEY (bolumID) REFERENCES BOLUM(bolumID)
);

-- 11. PERSONEL
CREATE TABLE PERSONEL (
    personelID INT PRIMARY KEY identity(1,1),
    tcNo CHAR(11) not null,
    adi VARCHAR(50) not null,
    soyadi VARCHAR(50) not null,
    cinsiyet varchar(6) check (cinsiyet in ('erkek','kadin')) not null,
    dogumTarihi DATE not null,
    yas as datediff(year,dogumTarihi,getdate()),
    iseGirisTarihi DATE not null,
    istenAyrilmaTarihi DATE,
    maas DECIMAL(10,2) not null,
    telefon char(11) not null,
    eposta varchar(100), check (eposta like '%_@_%._%'),
	adresID INT,
    bolumID INT,
    gorevID INT,
    FOREIGN KEY (bolumID) REFERENCES BOLUM(bolumID),
    FOREIGN KEY (gorevID) REFERENCES GOREV(gorevID),
	FOREIGN KEY (adresID) REFERENCES ADRES(adresID)
);

-- 12. MUSTERI
CREATE TABLE MUSTERI (
    musteriID INT PRIMARY KEY identity(1,1),
    cariHesapKodu VARCHAR(30) unique not null,
    cariHesapUnvani VARCHAR(30) not null,
	cariHesapTuru VARCHAR(30) not null,
	vergiNumarasi VARCHAR(20) unique not null,
	yetkiliKisiAdi VARCHAR(50) not null,
    yetkiliKisiSoyadi VARCHAR(50) not null,
    telefon char(11) not null,
    web_sitesi varchar(255), check (web_sitesi like 'http%://%'),
    fax VARCHAR(30),
    eposta varchar(100), check (eposta like '%_@_%._%'),
    aktifRiskToplami DECIMAL(18,2)not null,
    tanimliRiskLimiti DECIMAL(18,2)not null,
    kullanilabilirRiskLimiti as (tanimliRiskLimiti - aktifRiskToplami),
	satici_ziyaret_gunu int, check (satici_ziyaret_gunu between 1 and 7),
    vergiDairesiID INT,
    sevkiyatYontemiID INT,
    personelID INT,
    bankaID INT,
    FOREIGN KEY (vergiDairesiID) REFERENCES VERGI_DAIRESI(vergiDairesiID),
    FOREIGN KEY (sevkiyatYontemiID) REFERENCES SEVKIYAT_YONTEMI(sevkiyatYontemiID),
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID),
    FOREIGN KEY (bankaID) REFERENCES BANKA(bankaID)
);

ALTER TABLE ADRES 
ADD musteriID INT FOREIGN KEY REFERENCES MUSTERI(musteriID);

-- [Diðer tablolar ayný þekilde devam eder...]
-- 13. UST_KATEGORI
CREATE TABLE UST_KATEGORI (
    ustKategoriID INT PRIMARY KEY,
    aciklama TEXT 
);

-- 14. ALT_KATEGORI
CREATE TABLE ALT_KATEGORI (
    altKategoriID INT PRIMARY KEY,
    ustKategoriID INT,
    aciklama TEXT,
    FOREIGN KEY (ustKategoriID) REFERENCES UST_KATEGORI(ustKategoriID)
);

-- 15. URUN
CREATE TABLE URUN (
    urunID INT PRIMARY KEY identity(1,1),
    ad VARCHAR(100)not null,
    kod VARCHAR(50) unique not null,
    durum varchar(6) check (durum in ('aktif','pasif')) not null,
    kdvOrani DECIMAL(5,2) not null,
    altKategoriID INT,
	ustKategoriID INT,
	FOREIGN KEY (ustKategoriID) REFERENCES UST_KATEGORI(ustKategoriID),
    FOREIGN KEY (altKategoriID) REFERENCES ALT_KATEGORI(altKategoriID)
);

-- 16. BIRIM_SETI
CREATE TABLE BIRIM_SETI (
    birimSetiID INT PRIMARY KEY identity(1,1),
    birimAdi VARCHAR(50) not null,
	birimFiyati int not null,
    anaBirimMi varchar(6) check (anaBirimMi in ('hayýr','evet')) not null,
    cevrimKatsayisi DECIMAL(10,4) not null,
	urunID INT,
	FOREIGN KEY (urunID) REFERENCES URUN(urunID)
);

-- 17. BARKOD
CREATE TABLE BARKOD (
    barkodID INT PRIMARY KEY identity(1,1),
    barkodNo VARCHAR(100) unique not null,
    birimSetiID INT,
    FOREIGN KEY (birimSetiID) REFERENCES BIRIM_SETI(birimSetiID)
);

-- 18. DEPO
CREATE TABLE DEPO (
    depoID INT PRIMARY KEY identity(1,1),
    depoAdi VARCHAR(100) not null,
    depoKodu VARCHAR(50) unique not null,
	personelID int unique not null,
	adresID int,
    depoAciklamasi TEXT,
    kapasite INT not null,
    doluluk INT not null,
	dolulukOraný as (doluluk / kapasite) * 100,
    telefon char(11),
	foreign key (personelID) references PERSONEL(personelID),
	foreign key (adresID) references ADRES(adresID)
);

CREATE TABLE DEPO_URUN (
	DepoUrunID INT PRIMARY KEY identity(1,1),
	Miktar INT not null,
	UrunID INT,
	DepoID INT,
	FOREIGN KEY (urunID) REFERENCES URUN(urunID),
	FOREIGN KEY (depoID) REFERENCES DEPO(depoID)
);

-- 19. SIPARIS
CREATE TABLE SIPARIS (
    siparisID INT PRIMARY KEY identity(1,1),
    musteriID INT,
    personelID INT,
	depoID INT,
	adresID INT,
    siparisNo VARCHAR(50) not null,
    siparisTarihi DATE not null,
    siparisTuru VARCHAR(50)  not null,
    brütToplam DECIMAL(10,2) not null,
    indirimToplami DECIMAL(10,2) not null,
    netToplam as (brütToplam - indirimToplami),
    toplamKDV DECIMAL(10,2)not null,
    genelToplam as (netToplam + toplamKDV),
    odemeToplami DECIMAL(10,2) not null,
    kalanTutar as (genelToplam - odemeToplami),
    aciklama TEXT,
    faturalandirildiMi varchar(6) check (faturalandirildiMi in ('hayýr','evet')) not null,
    FOREIGN KEY (musteriID) REFERENCES MUSTERI(musteriID),
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID),
	FOREIGN KEY (depoID) REFERENCES DEPO(depoID),
	FOREIGN KEY (adresID) REFERENCES ADRES(adresID)
);

-- 20. SIPARIS_URUN
CREATE TABLE SIPARIS_URUN (
    siparisUrunID INT PRIMARY KEY,
    siparisID INT,
    urunID INT,
    miktar INT,
    toplamSevkMiktar INT,
    birimFiyat DECIMAL(10,2),
    indirimTutari DECIMAL(10,2),
    netTutar DECIMAL(10,2),
    kdvTutari DECIMAL(10,2),
    brütTutar DECIMAL(10,2),
    FOREIGN KEY (siparisID) REFERENCES SIPARIS(siparisID),
    FOREIGN KEY (urunID) REFERENCES URUN(urunID)
);

-- 21. KARGO_FIRMASI
CREATE TABLE KARGO_FIRMASI (
    kargoFirmasiID INT PRIMARY KEY,
    ad VARCHAR(100),
    aciklama TEXT
);

-- 22. IRSALIYE_FISI
CREATE TABLE IRSALIYE_FISI (
    irsaliyeID INT PRIMARY KEY,
    siparisID INT,
    kargoFirmasiID INT,
    depoID INT,
    sevkTarihiSaat TIMESTAMP,
    teslimatTarihiSaat TIMESTAMP,
    irsaliyeTarihiSaat TIMESTAMP,
    teslimAlanAdi VARCHAR(50),
    teslimAlanSoyadi VARCHAR(50),
    kargoTakipNo VARCHAR(100),
    miktar INT,
    netTutar DECIMAL(10,2),
    fisNo VARCHAR(50),
    FOREIGN KEY (siparisID) REFERENCES SIPARIS(siparisID),
    FOREIGN KEY (kargoFirmasiID) REFERENCES KARGO_FIRMASI(kargoFirmasiID),
    FOREIGN KEY (depoID) REFERENCES DEPO(depoID)
);

-- 23. TAHSILAT_TURU
CREATE TABLE TAHSILAT_TURU (
    tahsilatTuruID INT PRIMARY KEY,
    ad VARCHAR(100),
    aciklama TEXT
);

-- 24. TAHSILAT
CREATE TABLE TAHSILAT (
    tahsilatID INT PRIMARY KEY,
    musteriID INT,
    tahsilatTarihi DATE,
    tahsilatNo VARCHAR(50),
    tutar DECIMAL(10,2),
    tahsilatTuruID INT,
    FOREIGN KEY (musteriID) REFERENCES MUSTERI(musteriID),
    FOREIGN KEY (tahsilatTuruID) REFERENCES TAHSILAT_TURU(tahsilatTuruID)
);

-- INSERT örnek verileri

-- IL
INSERT INTO IL (ilID, ad) VALUES (1, 'Ýstanbul');

-- ILCE
INSERT INTO ILCE (ilceID, ilID, ad) VALUES (1, 1, 'Kadýköy');

-- MAHALLE
INSERT INTO MAHALLE (mahalleID, ilceID, ad) VALUES (1, 1, 'Moda');

-- CADDE_SOKAK
INSERT INTO CADDE_SOKAK (caddeSokakID, mahalleID, ad) VALUES (1, 1, 'Bahariye Caddesi');

-- ADRES
INSERT INTO ADRES (adresID, ilID, ilceID, mahalleID, caddeSokakID, disKapiNo, icKapiNo, adresAciklamasi) 
VALUES (1, 1, 1, 1, 1, '12', '3B', 'Ofis katý');

-- VERGI_DAIRESI
INSERT INTO VERGI_DAIRESI (vergiDairesiID, ad) VALUES (2, 'Kadýköy VD');

-- SEVKIYAT_YONTEMI
INSERT INTO SEVKIYAT_YONTEMI (sevkiyatYontemiID, aciklama) 
VALUES (1, 'Standart kargo sevkiyatý');

-- BANKA
INSERT INTO BANKA (bankaID, bankaAdi, hesapNo) VALUES (2, 'vakýf Bankasý', 'TR5000000001');

-- BOLUM
INSERT INTO BOLUM (bolumID, bolumAdi) VALUES (2, 'Satýþ');

-- GOREV
INSERT INTO GOREV (gorevID, gorevAdi) VALUES (2, 'Satýþ Temsilcisi');

-- PERSONEL
INSERT INTO PERSONEL (personelID, tcNo, adi, soyadi, cinsiyet, dogumTarihi, yas, iseGirisTarihi, istenAyrilmaTarihi, maas, telefon, eposta, bolumID, gorevID)
VALUES (2, '1234567551', 'ilker', 'Yýlmaz', 'K', '1980-05-10', 34, '2024-01-15', NULL, 180502.00, '055201234567', 'i.yilmaz@example.com', 2, 2);

-- MUSTERI
INSERT INTO MUSTERI (musteriID, cariHesapKodu, cariHesapUnvani, webSitesi, fax, telefon, eposta, aktifRiskToplami, tanimliRiskLimiti, kullanilabilirRiskLimiti, vergiNumarasi, yetkiliAdi, yetkiliSoyadi, adresID, vergiDairesiID, sevkiyatYontemiID, personelID, bankaID)
VALUES (1, 'CHK123', 'Pýrpýr Patapim A.Þ.', 'www.pirpýr.com', '02165554433', '02165554422', 'info@pirpir.com', 30000.00, 50000.00, 20000.00, '1234567890', 'Ayþe', 'Kara', 1, 1, 1, 1, 1);

-- [Devamý: ÜRÜN, KATEGORÝLER, BÝRÝM_SETÝ, SÝPARÝÞ vb. tablolar için örnek veriler eklenebilir]

-- Devam etmek istersen hangi tabloya veri ekleneceðini belirt, örneðin: SIPARIS, URUN, IRSALIYE_FISI

select * from MUSTERI


select ad from ADRES
inner join IL on IL.ilID = ADRES.ilID 

select * from PERSONEL
where adi = 'ilker'
