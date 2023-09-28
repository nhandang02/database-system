CREATE TABLE KhachHang
(
	MaKH varchar(10) CONSTRAINT PK_MaKH PRIMARY KEY,
	TenCTy nvarchar(30), 
	TenGD nvarchar(10),
	DiaChi nvarchar(30),
	Emai varchar(20),
	DT int,
	Fax varchar(10)
)

CREATE TABLE NhanVien 
(
	MaNV varchar(10) CONSTRAINT PK_MaNV PRIMARY KEY,
	Ho nvarchar(10),
	Ten nvarchar(10),
	NS date,
	NgayLamViec date,
	DiaChi nvarchar(20),
	DT int,
	LuongCB float,
	PhuCap float
)

CREATE TABLE DonDatHang 
(
	SoHD varchar(10) CONSTRAINT PK_SoHD PRIMARY KEY,
	MaKH varchar(10),
	MaNV varchar(10),
	NgayDatHang date,
	NgayGiaoHang date,
	NgayChuyenHang date,
	NoiGiaoHang nvarchar(20),
	CONSTRAINT FK_MaKH FOREIGN KEY (MaKH) REFERENCES KhachHang (MaKH),
	CONSTRAINT FK_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV)
)

CREATE TABLE NhaCungCap 
(
	MaCTy varchar(10) CONSTRAINT PK_MaCTy PRIMARY KEY,
	TenCty nvarchar(20),
	TenGD nvarchar(20),
	DiaChi nvarchar(20),
	DT int,
	Fax varchar(10),
	Email varchar(20)
)

CREATE TABLE LoaiHang
(
	MaLH varchar(10) CONSTRAINT PK_MaLH PRIMARY KEY,
	TenLoaiHang nvarchar(20) 
)

CREATE TABLE MatHang 
(
	MaHang varchar(10) CONSTRAINT PK_MaHang PRIMARY KEY,
	TenHang nvarchar(20),
	MaCTY varchar(10)CONSTRAINT FK_MaCTy FOREIGN KEY(MaCTy) REFERENCES NhaCungCap(MaCTy),
	MaLH varchar(10) CONSTRAINT FK_MaLH FOREIGN KEY(MaLH) REFERENCES LoaiHang(MaLH),
	SL int,
	DonViTinh varchar(10),
	GiaHang float
)

CREATE TABLE ChiTietDatHang
(
	SoHD varchar(10),
	MaHang varchar(10),
	GiaBan float,
	SL int,
	MucGiamGia varchar(10),
	PRIMARY KEY(SoHD, MaHang),
	CONSTRAINT FK_SoHD FOREIGN KEY(SoHD) REFERENCES DonDatHang(SoHD),
	CONSTRAINT FK_MaHang FOREIGN KEY(MaHang) REFERENCES MatHang(MaHang)
)
-- Cau1
ALTER TABLE ChiTietDatHang
ADD CONSTRAINT DF_SLCOLUMN DEFAULT 1 FOR SL

SELECT * FROM ChiTietDatHang

--Cau2
ALTER TABLE DonDatHang
ADD CONSTRAINT CheckNgayGiaoChuyenHang
CHECK (NgayGiaoHang >= NgayDatHang AND NgayChuyenHang >= NgayDatHang)


--Cau3
ALTER TABLE NhanVien
ADD CONSTRAINT CheckTuoi
CHECK (Year(getDate()) - Year(NS) >= 18 AND Year(getDate()) - Year(NS) <= 60)

DROP TABLE ChiTietDatHang
DROP TABLE MatHang
DROP TABLE NhaCungCap