CREATE TABLE Phong
(
	MaPhong varchar(3) CONSTRAINT PK_MP PRIMARY KEY,
	TenPhong nvarchar(40),
	DiaChi nvarchar(40),
	Tel  char(10)
)

CREATE TABLE DMNN
(
	MaNN char(2) CONSTRAINT PK_MaNN PRIMARY KEY,
	TenNN nvarchar(20)
)


CREATE TABLE NhanVien
(
	MaNV char(5) CONSTRAINT PK_MaNV PRIMARY KEY,
	HoTen nvarchar(40),
	GioiTinh char(3),
	NgaySinh date,
	Luong int,
	MaPhong char(3),
	SDT char(10),
	NgayBC date
)


CREATE TABLE TDNN 
(
	MaNV char(5),
	MaNN char(2),
	TDO char(1),
	PRIMARY KEY (MaNV, MaNN),
	CONSTRAINT FK_MaNV FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV),
	CONSTRAINT FK_MaNN FOREIGN KEY (MaNN) REFERENCES DMNN (MaNN)
)


INSERT INTO Phong VALUES ('HCA', N'Hành chính tổ hợp', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8585793')
INSERT INTO Phong VALUES ('KDA', N'Kinh Doanh', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8574943')
INSERT INTO Phong VALUES ('KTA', N'Kỹ thuật', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 9480485')
INSERT INTO Phong VALUES ('QTA', N'Quản trị', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8508585')


INSERT INTO DMNN VALUES ('01',N'Anh')
INSERT INTO DMNN VALUES ('02',N'Nga')
INSERT INTO DMNN VALUES ('03',N'Pháp')
INSERT INTO DMNN VALUES ('04',N'Nhật')
INSERT INTO DMNN VALUES ('05',N'Trung Quốc')
INSERT INTO DMNN VALUES ('06',N'Hàn Quốc')


INSERT INTO NHANVIEN(MANV, HOTEN, GIOITINH, NGAYSINH, LUONG, MAPHONG, SDT, NGAYBC) VALUES
('HC001', N'Nguyễn Thị Hà', 'Nu', '1950-08-27', 2500000, 'HCA', NULL,'1975-08-02'),
('HC002', N'Trần Văn Nam', 'Nam', '1975-06-12', 3000000, 'HCA', NULL,'1997-06-08'),
('HC003', N'Nguyễn Thanh Huyền', 'Nu', '1978-07-03', 1500000, 'HCA',NULL,'1999-09-24'),
('KD001', N'Lê Tuyết Anh', 'Nu', '1977-02-03', 2500000, 'KDA', NULL,'2001-10-02'),
('KD002', N'Nguyễn Anh Tú', 'Nam', '1942-07-04', 2600000, 'KDA', NULL, '1999-09-24'),
('KD003', N'Phạm An Thái', 'Nam', '1977-05-09', 1600000, 'KDA', NULL, '1999-09-24'),
('KD004', N'Lê Văn Hải', 'Nam', '1976-01-02', 2700000, 'KDA', NULL,'1997-06-08'),
('KD005', N'Nguyễn Phương Minh', 'Nam', '1980-01-02', 2000000,'KDA', NULL,'2001-10-02'),
('KT001', N'Trần Đình Khâm', 'Nam', '1981-12-02', 2700000, 'KTA', NULL, '2005-01-01'),
('KT002', N'Nguyễn Mạnh Hùng', 'Nam', '1980-08-16', 2300000, 'KTA', NULL, '2005-01-01'),
('KT003', N'Phạm Thanh Sơn', 'Nam', '1984-08-20', 2000000, 'KTA', NULL,'2005-01-01'),
('KT004', N'Vũ Thị Hoài', 'Nu', '1980-12-05', 2500000, 'KTA', NULL, '2001-10-02'),
('KT005', N'Nguyễn Thu Lan', 'Nu', '1977-10-05', 3000000, 'KTA', NULL, '2001-10-02'),
('KT006', N'Trần Hoài Nam', 'Nam', '1978-07-02', 2800000, 'KTA', NULL, '1997-06-08'),
('KT007', N'Hoàng Nam Sơn', 'Nam', '1940-12-03', 3000000, 'KTA', NULL, '1965-07-02'),
('KT008', N'Lê Thu Trang', 'Nu', '1950-07-06', 2500000, 'KTA', NULL, '1968-08-02'),
('KT009', N'Khúc Nam Hải', 'Nam', '1980-07-22', 2000000, 'KTA', NULL, '2005-01-01'),
('KT010', N'Phùng Trung Dũng', 'Nam', '1978-08-28', 2200000, 'KTA', NULL, '1999-09-24')



INSERT INTO TDNN(MANV, MANN, TDO) VALUES
('HC001', '01', 'A'),
('HC001', '02', 'B'),
('HC002', '01', 'C'),
('HC002', '03', 'C'),
('HC003', '01', 'D'),
('KD001', '01', 'C'),
('KD001', '02', 'B'),
('KD002', '01', 'D'),
('KD002', '02', 'A'),
('KD003', '01', 'B'),
('KD003', '02', 'C'),
('KD004', '01', 'C'),
('KD004', '04', 'A'),
('KD004', '05', 'A'),
('KD005', '01', 'B'),
('KD005', '02', 'D'),
('KD005', '03', 'B'),
('KD005', '04', 'B'),
('KT001', '01', 'D'),
('KT001', '04', 'E'),
('KT002', '01', 'C'),
('KT002', '02', 'B'),
('KT003', '01', 'D'),
('KT003', '03', 'C'),
('KT004', '01', 'D'),
('KT005', '01', 'C')

--Cau1
SELECT * FROM NhanVien
WHERE MaNV = 'KT001'

--Cau2


--Cau3
SELECT * FROM NhanVien
WHERE GioiTinh = N'Nu'

--Cau4
SELECT * FROM NhanVien
WHERE HoTen like N'Nguyễn%'

--Cau5
SELECT * FROM NhanVien
WHERE HoTen like N'%Văn%'

--Cau6
SELECT *, YEAR(GETDATE()) - YEAR(NGAYSINH) AS TUOI
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(NGAYSINH) < 30;

--Cau7
SELECT *, YEAR(GETDATE()) - YEAR(NGAYSINH) AS TUOI
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(NGAYSINH) BETWEEN 25 AND 30

--Cau8
SELECT MANV FROM TDNN 
WHERE MANN = '01' AND (TDO = 'C' OR TDO = 'D')

--Cau9
SELECT * FROM NhanVien 
WHERE YEAR(NgayBC) < 2000

--Cau10
SELECT * FROM NhanVien 
WHERE YEAR(GETDATE()) - YEAR(NgayBC) > 10

--Cau11
SELECT * FROM NhanVien 
WHERE (YEAR(GETDATE()) - YEAR(NgaySinh) >= 60 AND GioiTinh = N'Nam') 
OR (YEAR(GETDATE()) - YEAR(NgaySinh) >= 55 AND GioiTinh = N'Nu')

--Cau12
SELECT MaPhong, TenPhong, Tel FROM Phong

--Cau13
SELECT TOP 2 HoTen, NgaySinh, NgayBC FROM NhanVien

--Cau14
SELECT MaNV, HoTen, NgaySinh, Luong FROM NhanVien
WHERE Luong BETWEEN 2000000 AND 30000000

--Cau15
SELECT * FROM NhanVien
WHERE SDT IS NULL

--Cau16
SELECT * FROM NhanVien
WHERE MONTH(NgaySinh) = 3

--Cau17
SELECT * FROM NhanVien
ORDER BY Luong ASC

--Cau18
SELECT AVG(Luong) AS LuongTrungBinh FROM NhanVien 
WHERE MaPhong in(SELECT MaPhong FROM Phong 
WHERE TenPhong like N'Kinh Doanh')

--Cau19
SELECT COUNT(Luong) AS SNhanVien, AVG(Luong) AS LuongTrungBinh FROM NhanVien 
WHERE MaPhong in(SELECT MaPhong FROM Phong 
WHERE TenPhong like N'Kinh Doanh')

--Cau20
SELECT MaPhong, SUM(Luong) AS TONGLUONG FROM NhanVien 
GROUP BY MaPhong

--Cau21
SELECT MaPhong, SUM(Luong) AS TONGLUONG FROM NhanVien
GROUP BY MaPhong
HAVING SUM(Luong) > 5000000

--Cau22
CREATE VIEW NV
AS 
SELECT NhanVien.MaNV, NhanVien.HoTen, NhanVien.MaPhong, Phong.TenPhong FROM NhanVien, Phong
WHERE NhanVien.MaPhong = Phong.MaPhong
SELECT * FROM NV

--Cau23
SELECT NhanVien.*, Phong.TenPhong FROM NhanVien, Phong
WHERE NhanVien.MaPhong = Phong.MaPhong

--Cau24
SELECT Phong.*, NhanVien.MaNV, NhanVien.HoTen, NhanVien.GioiTinh, NhanVien.NgaySinh, NhanVien.Luong
FROM NhanVien, Phong
WHERE NhanVien.MaPhong = Phong.MaPhong
