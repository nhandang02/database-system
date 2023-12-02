--Cau1
CREATE TABLE San 
(
    MaSan varchar(10),
    TenSan nvarchar(100),
    GiaTienMotGio float
)

CREATE TABLE KhachHang
(
    SoDienThoai char(10),
    HoTen nvarchar(100)
)

CREATE TABLE DichVu
(
    MaDichVu varchar(10),
    TenDichVu nvarchar(100),
    SoLuong int,
    DonGia float
)

CREATE TABLE PhieuDatSan
(
    MaDatSan varchar(10),
    SoDienThoaiKhachHang char(10),
    NgayDat date,
    NgayThiDau date,
    GioBatDau time,
    GioKetThuc time,
    MaSan varchar(10)
)

CREATE TABLE HoaDon
(
    SoHoaDon varchar(10),
    NgayLap date,
    MaDatSan varchar(10)
)

CREATE TABLE ChiTietHoaDon
(
    SoHoaDon varchar(10),
    MaDichVu varchar(10),
    SoLuong int,
    DonGia float
)

INSERT INTO San (MaSan, TenSan, GiaTienMotGio)
VALUES ('S1', 'San so 1', 500000),
       ('S2', 'San so 2', 1000000);
       
INSERT INTO KhachHang (SoDienThoai, HoTen) 
VALUES ('0123456781', 'Nguyen Van A'),
       ('0123456782', 'Tran Thi B')

INSERT INTO DichVu (MaDichVu, TenDichVu, SoLuong, DonGia)
VALUES ('DV1', 'Do uong', 10, 20000),
       ('DV2', 'Banh kem', 5, 50000)
       
INSERT INTO PhieuDatSan (MaDatSan, SoDienThoaiKhachHang, NgayDat, NgayThiDau, GioBatDau, GioKetThuc, MaSan)
VALUES ('PDS1', '0123456781', '2023-11-20', '2023-11-21', '08:00', '10:00', 'S1'),  
       ('PDS2', '0123456782', '2023-11-19', '2023-11-22', '14:00', '17:00', 'S2')

INSERT INTO HoaDon (SoHoaDon, NgayLap, MaDatSan) 
VALUES ('HD1', '2023-11-21', 'PDS1'),
       ('HD2', '2023-11-20', 'PDS2')

INSERT INTO ChiTietHoaDon (SoHoaDon, MaDichVu, SoLuong, DonGia)
VALUES ('HD1', 'DV1', 5, 20000),
       ('HD2', 'DV2', 2, 50000)

--Cau2
---a
CREATE FUNCTION Caua(@MaDichVu varchar(10))
RETURNS varchar(10) 
AS
BEGIN
	DECLARE @TongSoLuong varchar(10)
	SELECT @TongSoLuong = SUM(SoLuong) FROM ChiTietHoaDon
	WHERE MaDichVu = @MaDichVu
	RETURN @TongSoLuong
END
print dbo.Caua('DV1')

DROP FUNCTION Caub
CREATE FUNCTION Caub()
RETURNS varchar(20)
AS
BEGIN
	DECLARE @NgayHienTai varchar(20)
	DECLARE @MaSanHienTai varchar(20)

	SET @NgayHienTai = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 112), '-', '')

	SELECT @MaSanHienTai = MAX(MaDatSan) FROM PhieuDatSan
	WHERE MaDatSan LIKE @NgayHienTai + '%'

	IF @MaSanHienTai IS NULL
		SET @MaSanHienTai = @NgayHienTai + '0001'
	ELSE
		SET @MaSanHienTai = @NgayHienTai + RIGHT('000'+ CAST(CAST(RIGHT(@MaSanHienTai, 4) AS INT) + 1 AS VARCHAR(3)), 4)
	RETURN @MaSanHienTai
END

print dbo.Caub()

--Cau3
CREATE PROC Cau3_a
@MaSan varchar(10),
@TenSan nvarchar(100), 
@GiaTienMotGio float
AS
BEGIN
  IF @GiaTienMotGio <= 0 
  BEGIN
     print N'Số tiền 1 giờ không thể nhỏ hơn hoặc bằng 0'
     RETURN
  END
  ELSE 
		INSERT INTO San values(@MaSan, @TenSan, @GiaTienMotGio)
END

EXEC Cau3_a 'S1','San so 1',100000

CREATE PROC Cau3_b
@MaDichVu varchar(10)
AS 
BEGIN
  IF EXISTS (SELECT * FROM ChiTietHoaDon WHERE MaDichVu = @MaDichVu)
  BEGIN
     Print ('Dich vu da duoc su dung') 
     RETURN
  END  

  DELETE FROM DichVu WHERE MaDichVu = @MaDichVu
END

EXEC Cau3_b'DV1'


--Cau4
CREATE TRIGGER Cau4_a 
ON PhieuDatSan
FOR INSERT 
AS
BEGIN
  DECLARE @GioBatDau time
  DECLARE @GioKetThuc time
  
  SELECT @GioBatDau = GioBatDau, @GioKetThuc = GioKetThuc
  FROM inserted
  
  IF (@GioBatDau >= @GioKetThuc) 
  BEGIN
    Print ('giờ bắt đầu phải nhỏ hơn giờ kết thúc')
    ROLLBACK TRANSACTION  
  END
END
INSERT INTO PhieuDatSan (MaDatSan, GioBatDau, GioKetThuc)
  VALUES ('PDS10', '10:00', '09:00')

CREATE TRIGGER Cau4_b
ON ChiTietHoaDon 
FOR INSERT
AS  
BEGIN
  DECLARE @MaDichVu varchar(10)
  DECLARE @SoLuongTon int
  DECLARE @SoLuong int
  
  SELECT @MaDichVu = MaDichVu, @SoLuong = SoLuong FROM inserted

  SELECT @SoLuongTon = SoLuong 
  FROM DichVu
  WHERE MaDichVu = @MaDichVu

  IF (@SoLuong > @SoLuongTon)
  BEGIN
    Print ('So luong khong phu hop')
    ROLLBACK TRANSACTION
  END

  UPDATE DichVu 
  SET SoLuong = SoLuong - @SoLuong
  WHERE MaDichVu = @MaDichVu
END

  INSERT INTO ChiTietHoaDon(SoHoaDon, MaDichVu, SoLuong)
  VALUES ('HD01', @maDichVu, 10)