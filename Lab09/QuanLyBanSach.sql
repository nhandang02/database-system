CREATE TABLE NhomSach (
  MaNhom char(5),
  TenNhom nvarchar(25)
)

CREATE TABLE NhanVien (
  MaNV char(5),
  HoLot nvarchar(25),
  TenNV nvarchar(10),
  Phai nvarchar(3),
  NgaySinh smalldatetime,
  DiaChi nvarchar(40)
)

CREATE TABLE DanhMucSach (
  MaSach char(5),
  TenSach nvarchar(40),
  TacGia nvarchar(20), 
  MaNhom char(5),
  DonGia numeric(5),
  SLTon numeric(5)
)

CREATE TABLE HoaDon (
  MaHD char(5),
  NgayBan smalldatetime,
  MaNV char(5)
)

CREATE TABLE ChiTietHoaDon (
  MaHD char(5),
  MaSach char(5),
  SoLuong numeric(5)
)

INSERT INTO NhomSach 
VALUES ('NS001', 'Truyện tranh')

INSERT INTO NhanVien
VALUES ('NV001', 'Nguyen', 'Van', 'A', '2004-02-15', 'Hồ Chí Minh')

INSERT INTO DanhMucSach
VALUES ('S001', 'Doraemon', 'Fujiko Fujio', 'NS001', 20000, 10)

INSERT INTO HoaDon
VALUES ('HD001', '2023-01-01', 'NV001')

INSERT INTO ChiTietHoaDon
VALUES ('HD001', 'S001', 1)


--Cau1
CREATE TRIGGER Cau1 ON NhomSach
FOR INSERT 
AS
BEGIN
  DECLARE @count int;

  SELECT @count = COUNT(*) FROM NhomSach

  PRINT 'Co ' + CAST(@count AS varchar(10)) + ' dong da duoc them'
END

INSERT INTO NhomSach VALUES ('NS002', 'Toán')
INSERT INTO NhomSach VALUES ('NS003', 'Lý')
INSERT INTO NhomSach VALUES ('NS004', 'Hóa')
INSERT INTO NhomSach VALUES ('NS005', 'Sinh')


--Cau2
CREATE TABLE HoaDon_Luu (
  MaHD char(5),
  NgayBan smalldatetime,
  MaNV char(5)
)

CREATE TRIGGER Cau2 ON HoaDon
FOR INSERT
AS
BEGIN
  INSERT INTO HoaDon_Luu 
  SELECT * FROM inserted
END

INSERT INTO HoaDon
VALUES ('HD002', '2023-02-01', 'NV001')
SELECT * FROM HoaDon
SELECT * FROM HoaDon_Luu


--Cau3
ALTER table HOADON add Tongtrigia float
ALTER table CHITIETHOADON add dongia numeric

CREATE TRIGGER Cau3 on CHITIETHOADON
for INSERT, UPDATE, DELETE
as
    DECLARE @mahd varchar(10), @tongtg int
    if exists (select * from inserted)
    begin
        select @mahd = mahd from INSERTed
        select @tongtg = sum (soluong * dongia) from CHITIETHOADON where mahd = @mahd
        UPDATE HOADON set tongtrigia = @tongtg where mahd = @mahd
    end
    else if exists (select * from Deleted)
    begin
        select @mahd = mahd from Deleted
        select @tongtg = sum (soluong * dongia) from CHITIETHOADON where mahd = @mahd
        UPDATE HOADON set tongtrigia = @tongtg where mahd = @mahd
    end

select * from HOADON
select * from CHITIETHOADON where mahd = 'HD001'
INSERT into CHITIETHOADON values ('HD001', 'S002', 3, 10)
UPDATE CHITIETHOADON set dongia = 10 where mahd = 'HD001' and Masach = 'S001'


--Cau4
CREATE TRIGGER Cau4 ON ChiTietHoaDon
FOR INSERT, UPDATE
AS
	IF EXISTS ( SELECT * FROM INSERTED WHERE MaSach IN 
			  ( SELECT MaSach FROM DanhMucSach WHERE inserted.dongia != DanhMucSach.DonGia))
	BEGIN
    PRINT N'Gia ban khong hop le voi DanhMucSach'
    ROLLBACK TRANSACTION
  END

SELECT * FROM DanhMucSach
INSERT into CHITIETHOADON values ('HD001', 'S001', 3, 12)
UPDATE CHITIETHOADON set dongia = 12 where mahd = 'HD001' and Masach = 'S001'


--Cau5
CREATE TRIGGER Cau5 
ON HoaDon
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT *
    FROM inserted 
    WHERE NgayBan < GetDate()
  )
  BEGIN
    PRINT N'Ngày bán phải lớn hơn hoặc bằng ngày lập hóa đơn'; 
    ROLLBACK TRANSACTION;
  END
END