CREATE TABLE Khoa
(
	MaKhoa varchar(10) CONSTRAINT PK_MK PRIMARY KEY,
	TenKhoa varchar(30)
)

CREATE TABLE SinhVien 
(
	HoSV nvarchar(15),
	TenSV nvarchar(15),
	MaSV varchar(10) CONSTRAINT PK_MaSV PRIMARY KEY,
	NgaySinh date,
	Phai varchar(10),
	MaKhoa varchar(10) CONSTRAINT PK_MK1 FOREIGN KEY (MaKhoa) REFERENCES Khoa (MaKhoa)
)

CREATE TABLE MonHoc
(
	TenMH varchar(30),
	MaMH varchar(10) CONSTRAINT PK_MaMH PRIMARY KEY,
	SoTiet int
)

CREATE TABLE KetQua 
(
	MaSV varchar(10),
	MaMH varchar(10),
	LanThi int ,
	Diem float,
	PRIMARY KEY (MaSV, MaMH, LanThi),
	CONSTRAINT PK_MSV1 FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
	CONSTRAINT PK_MMH1 FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
)

INSERT INTO SinhVien VALUES(N'Đặng Thành', N'Nhân', 'S001', '2004/02/15', 'Nam', 'CNTT')
INSERT INTO SinhVien VALUES(N'Nguyễn Thành', N'Nhân', 'S002', '2004/03/15', 'Nam', 'CNTT')
INSERT INTO SinhVien VALUES(N'Võ Thành', N'Hưng', 'S003', '2004/04/15', 'Nam', 'QTKD')
INSERT INTO SinhVien VALUES(N'Đặng Thụy Ánh', N'Dương', 'S004', '2004/05/15', 'Nu', 'QTKD')
INSERT INTO SinhVien VALUES(N'Nguyễn Thị Hồng', N'Nhung', 'S005', '2004/06/15', 'Nu', 'DTVT')
INSERT INTO SinhVien VALUES(N'Trương', N'Nhi', 'S006', '2004/07/15', 'Nu', 'DTVT')
INSERT INTO SinhVien VALUES(N'Bành Gia', N'Bảo', 'S007','2004/08/15', 'Nam', 'CNTT')
INSERT INTO SinhVien VALUES(N'Nguyễn Tấn', N'Tài', 'S008', '2004/09/15', 'Nam', 'CNTT')



INSERT INTO MonHoc VALUES('Anh Van', 'AV', 45)
INSERT INTO MonHoc VALUES('Co So Du Lieu', 'CSDL', 45)
INSERT INTO MonHoc VALUES('Ky Thuat Lap Trinh', 'KTLT', 60)
INSERT INTO MonHoc VALUES('Ke Toan Tai Chinh', 'KTTC', 45)
INSERT INTO MonHoc VALUES('Toan Cao Cap', 'TCC', 60)
INSERT INTO MonHoc VALUES('Tin Hoc Van Phong', 'THVP', 30)
INSERT INTO MonHoc VALUES('Tri Tue Nhan Tao', 'TTNT', 45)

INSERT INTO Khoa VALUES('AVAN', 'Khoa Anh Van')
INSERT INTO Khoa VALUES('CNTT', 'Cong Nghe Thong Tin')
INSERT INTO Khoa VALUES('DTVT', 'Dien Tu Vien Thong')
INSERT INTO Khoa VALUES('QTKD', 'Quan Tri Kinh Doanh')

INSERT INTO KetQua VALUES('S001', 'CSDL', 1, 4)
INSERT INTO KetQua VALUES('S001', 'TCC', 1, 6)
INSERT INTO KetQua VALUES('S002', 'CSDL', 1, 3)
INSERT INTO KetQua VALUES('S002', 'CSDL', 2, 6)
INSERT INTO KetQua VALUES('S003', 'KTTC', 1, 5)
INSERT INTO KetQua VALUES('S004', 'AV', 1, 8)
INSERT INTO KetQua VALUES('S004', 'THVP', 1, 4)
INSERT INTO KetQua VALUES('S004', 'THVP', 2, 8)
INSERT INTO KetQua VALUES('S006', 'TCC', 1, 5)
INSERT INTO KetQua VALUES('S007', 'AV', 1, 2)
INSERT INTO KetQua VALUES('S007', 'AV', 2, 9)
INSERT INTO KetQua VALUES('S007', 'KTLT', 1, 6)
INSERT INTO KetQua VALUES('S008', 'AV', 1, 7)

--Câu 2
ALTER TABLE KetQua 
DROP CONSTRAINT PK_MSV1 
ALTER TABLE KetQua
DROP CONSTRAINT PK_MMH1


--Câu 3
ALTER TABLE SinhVien 
DROP CONSTRAINT PK_MK1
DROP TABLE Khoa
DROP TABLE MonHoc

--Câu 4
ALTER TABLE KetQua
ADD CONSTRAINT PK_PK_MSV1 FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV)
ALTER TABLE KetQua
ADD CONSTRAINT PK_MMH1 FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)


--Câu 6
UPDATE MonHoc Set SoTiet = 30 
WHERE TenMH = 'Tri Tue Nhan Tao'

--Câu 7
DELETE FROM KetQua WHERE MaSV ='S001'
-- Câu 9 
UPDATE SinhVien Set HoSV = N'Nguyễn Văn Lam', Phai = 'Nam'
WHERE HoSV = N'Đặng Thành Nhân', and TenSV = N'Nhân' 

--Câu 10
UPDATE SinhVien SET MaKhoa = 'CNTT'
WHERE HoSV = 'Đặng Thành Nhân'
