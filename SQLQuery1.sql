create database SatisOtomasyonu

use SatisOtomasyonu

create table Musteri(
	yetkili_kisi_adi nvarchar(30) not null,
	yetkili_kiþi_soyadi nvarchar(30) not null,
	cari_hesap_kodu varchar(20) unique not null,
	cari_hesap_turu nvarchar(30) not null,
	cari_hesap_unvani nvarchar(30) not null,
	telefon char(11) not null,
	fax varchar(20),
	eposta varchar(100), check (eposta like '%_@_%._%'),
	web_sitesi varchar(255), check (web_sitesi like 'http%://%'),
	vergi_no varchar(15) unique not null,
	tanimli_risk_limiti decimal (15,2) default 0,
	aktif_risk_toplami decimal (15,2) default 0,
	satici_ziyaret_gunu int, check (satici_ziyaret_gunu between 1 and 7),
	durum varchar(6) check (durum in ('aktif','pasif')) not null,
	);



insert into Musteri(yetkili_kisi_adi,yetkili_kiþi_soyadi,cari_hesap_kodu,cari_hesap_turu, cari_hesap_unvani,
telefon, fax,eposta,web_sitesi,vergi_no,tanimli_risk_limiti,aktif_risk_toplami,satici_ziyaret_gunu,durum)
values
('omar','ates',12,'bireysel','yalova','11111111111','111154t4757546','omar@gmail.com','https://www.google.com','12312',2123.23,1234.22,5,'pasif');

select * from Musteri

delete from Musteri
where yetkili_kisi_adi = 'omar';


create table personel(
	tc_no varchar(11) unique not null,
	personel_adi varchar(30) not null,
	personel_soyadi varchar(30) not null,
	telefon char(11) not null,
	eposta varchar(100), check (eposta like '%_@_%._%'),
	dogum_tarihi date not null,
	cinsiyet varchar(6)check (cinsiyet in ('erkek','kadin')),
	ise_giri_tarihi date not null,
	isten_ayrilma_tarihi date,
	maas decimal (10,2) not null
	);

select * from urun

create table urun(
	urun_kodu varchar(20) primary key not null,
	urun_adi varchar(100) not null,
	kdv_orani decimal (4,2) not null,
	durum varchar(6) check (durum in ('aktif','pasif')) not null,
	);
	

create table depo(
	depo_kodu varchar(20) primary key not null,
	depo_adi varchar(100) not null,
	aciklama text,
	telefon char(11) not null,
	kapasite int not null,
	doluluk int not null,
	);

select * from depo

create table siparis(
	turu varchar(10) check (turu in ('alinan','verilen')),
	numarasi int primary key identity(1,1),
	tarih date,
	brut_toplam  decimal(10,2) not null,
	indirim_toplami decimal(10,2) not null,
	toplam_KDV decimal(10,2),
	odenen_toplam decimal(10,2) default 0.00,
	onay_bilgisi varchar(15) check (onay_bilgisi in ('öneri','onaylandý','reddedildi')) not null,
	aciklama text,
	faturalandi_mi varchar(6) check (faturalandi_mi in ('evet','hayýr')) not null,
	siparis_durumu varchar(20) check (siparis_durumu in ('alýndý','hazýrlanýyor','sevk ediliyor','tamýmý sevk edildi','kýsmi sevk edildi'))
	);

select * from siparis

create table il(
	il_id int identity(1,1) primary key,
	ad varchar(30) not null
	);

create table ilce(
	ilce_id int identity(1,1) primary key,
	ad varchar(30) not null
	);

create table mahalle(
	mahalle_id int identity(1,1) primary key,
	ad varchar(30) not null
	);

create table cadde_sokak(
	cadde_sokak_id int identity(1,1) primary key,
	ad varchar(30) not null
	);

create table dis_kapi_no(
	dis_kapi_no_id int identity(1,1) primary key,
	ad varchar(30) not null
	);

create table ic_kapi_no(
	ic_kapi_no_id int identity(1,1) primary key,
	ad varchar(30) not null
	);



create table tahsilat(
	tahsilat_numarasi varchar(30) primary key,
	tutar decimal (10,2) not null
	);

create table tahsilat_turu(
	tahsilat_id int identity(1,1) primary key,
	tahsilat_aciklamasi text
	);

create table bolum(
	bolum_id int identity(1,1) primary key,
	bolum_adi varchar(30) not null
	);

create table gorev(
	gorev_id int identity(1,1) primary key,
	gorev_adi varchar(30) not null
	);


