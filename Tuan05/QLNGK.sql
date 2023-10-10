CREATE TABLE LoaiNGK (
	Maloai varchar(10) PRIMARY KEY,
	TenLoai nvarchar(20) not null UNIQUE
)

CREATE TABLE NGK (
	MaNGK varchar (10) primary key,
	TenNGK nvarchar (20) not null unique ,
	DVT nvarchar (10) not null check (DVT in (N'chai', N'lon',N'thung',N'ket')),
	SL int CHECK (SL>0),
	Dongia int CHECK (Dongia>0),
	MaLoaiNGK varchar (10),
	FOREIGN KEY (MaLoaiNGK) REFERENCES LoaiNGK(MaLoai) ,
)


CREATE TABLE KhachHang (
	MsKH varchar(10) PRIMARY KEY,
	HoTen nvarchar(20) not null ,
	DiaChi varchar(20),
	SDT int DEFAULT'chưa có'
)

CREATE TABLE HoaDon (
	SoHD varchar(10) PRIMARY KEY,
	MsKH varchar(10) FOREIGN KEY REFERENCES KhachHang(MsKH),
	NhanVien varchar(50),
	NgayLap datetime DEFAULT CURRENT_TIMESTAMP,
)

CREATE TABLE CTHD (
	SoHD varchar(10),
	MANGK varchar(10),
	SL int CHECK(SL > 0),
	DonGia int CHECK(DonGia > 1000),
	PRIMARY KEY(SoHD, MaNGK),
	FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD),
	FOREIGN KEY (MaNGK) REFERENCES NGK(MaNGK) 
)

--f
ALTER TABLE CTHD ADD ThanhTien int 
ALTER TABLE CTHD ADD CONSTRAINT FK_soHD FOREIGN KEY (soHD) REFERENCES HoaDon(soHD)
ALTER TABLE CTHD ADD CONSTRAINT FK_MaNGK FOREIGN KEY (MaNGK) REFERENCES NGK(MaNGK)
ALTER TABLE NGK ADD Check (Dongia > 1000)

--g 
ALTER TABLE CTHD DROP CONSTRAINT FK_soHD
ALTER TABLE CTHD DROP CONSTRAINT FK_MaNGK

--h
ALTER TABLE CTHD ADD CHECK (ThanhTien > 0)

--Cau2
--a
INSERT INTO LoaiNGK (MaLoai, TenLoai ) VALUES
('NGK0001', N'A'),
('NGK0002', N'B'),
('NGK0003', N'C')

INSERT INTO NGK (MaNGK, TenNGK, DVT, SL, Dongia, MaLoaiNGK) VALUES 
('N0001', N'NGK1','lon', 40, 5000, 'NGK0001'), 
('N0002', N'NGK2','chai', 20, 6000, 'NGK0002'), 
('N0003', N'NGK3','thung', 10, 7000, 'NGK0003') 

INSERT INTO khachHang(MsKH, HoTen, DiaChi, SDT ) VALUES 
('Q001', N'TC1', 'TPHCM', 0393514981),
('Q002', N'TC2', 'HN', 0393514982),
('Q003', N'TC3', 'DN', 0393514983)

INSERT INTO HoaDon(SoHD, MsKH, NgayLap) VALUES 
('B001','Q002','2023-01-04'),
('B002','Q001','2023-02-05'),
('B003','Q003','2023-03-06')

INSERT INTO CTHD (soHD, MaNGK, SL) VALUES  
('B002', 'N0001', 4),
('B003', 'N0002', 8),
('B001', 'N0003', 2)


--b 
UPDATE NGK SET Dongia = Dongia + 10000 
WHERE DVT like N'lon'

--c 
DELETE khachHang 
WHERE MsKH IN ( SELECT MsKH FROM HoaDon WHERE YEAR(NgayLap) < 2010 )

--d 
DELETE NGK WHERE SL = 0 

--e 
UPDATE NGK
SET Dongia = CASE
    WHEN DVT = 'thung' THEN
        CASE
            WHEN (Dongia + 100000) <= 500000 THEN (Dongia + 100000)
            ELSE 500000
        END
    ELSE Dongia
END

--3 
--a
SELECT * FROM NGK 
WHERE DVT like N'lon'

--b 
SELECT * FROM KhachHang 
WHERE diaChi like N'TPHCM'

--c 
SELECT * FROM NGK 
WHERE MaNGK IN ( SELECT MaNGK FROM CTHD WHERE SoHD IN
				( SELECT SoHD FROM HoaDon WHERE MONTH(NgayLap) between 7 and 9 AND YEAR(NgayLap) = 2018))

--d
SELECT TenNGK , SL FROM NGK 

--e 
SELECT DISTINCT cthd.SoHD
FROM CTHD cthd
JOIN loaiNGK lngk1 ON cthd.MaNGK = lngk1.MaLoai
JOIN loaiNGK lngk2 ON cthd.MaNGK = lngk2.MaLoai
WHERE lngk1.TenLoai = N'Nước Có Ga' OR lngk2.TenLoai = N'Nước Ngọt'

--f 
SELECT * FROM NGK
WHERE MaNGK NOT IN ( SELECT MaNGK FROM CTHD )
