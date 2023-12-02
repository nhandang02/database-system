CREATE TABLE Khoa (
	MaKhoa varchar(10),
	TenKhoa nvarchar(30)
)

CREATE TABLE SinhVien (
	HoSV nvarchar(20),
	TenSV nvarchar(20),
	MaSV varchar(10),
	NgaySinh datetime,
	Phai nvarchar(10),
	MaKhoa varchar(10)
)

CREATE TABLE MonHoc (
	TenMH nvarchar(20),
	MaMH varchar(10),
	SoTiet int
)

CREATE TABLE KetQua (
	MaSV varchar(10),
	MaMH varchar(10),
	LanThi int,
	Diem float
)

INSERT INTO Khoa (MaKhoa, TenKhoa) VALUES
('CNTT', N'Công Nghệ Thông Tin'),
('KTCT', N'Kĩ Thuật Công Trình')

INSERT INTO SinhVien (HoSV, TenSV, MaSV, NgaySinh, Phai, MaKhoa) VALUES
(N'Đặng', N'Thành Nhân', '522H0006', '2004-02-15','Nam', 'CNTT'),
(N'Võ', N'Nhật Hào', '522H0090', '2004-12-05','Nam', 'CNTT'),
(N'Huỳnh', N'Trọng Trí', '722H005', '2004-01-10','Nam','KTCT')

INSERT INTO MonHoc (TenMH, MaMH, SoTiet) VALUES
(N'Mạng Máy Tính', 'MMT', 40),
(N'Cơ Sở Dữ Liệu', 'CSDL', 40)

INSERT INTO KetQua (MaSV, MaMH, LanThi, Diem) VALUES 
('522H0006', 'MMT', 1, 7.0),
('522H0090', 'CSDL', 1, 7.5),
('522H0006', 'CSDL', 1, 9.0)

--Cau1
CREATE PROCEDURE ThemSinhVien
    @HoSV nvarchar(20),
    @TenSV nvarchar(20),
    @MaSV varchar(10),
    @NgaySinh datetime,
    @Phai nvarchar(10),
    @MaKhoa varchar(10)
AS
BEGIN
    IF EXISTS (SELECT * FROM SinhVien WHERE MaSV = @MaSV)
    BEGIN
        PRINT 'Khoa Chinh Ton Tai'
        RETURN
    END

    INSERT INTO SinhVien (HoSV, TenSV, MaSV, NgaySinh, Phai, MaKhoa)
    VALUES (@HoSV, @TenSV, @MaSV, @NgaySinh, @Phai, @MaKhoa)
END

EXEC ThemSinhVien 
    @HoSV = N'Đặng',
    @TenSV = N'Thành Nhân',
    @MaSV = '522H0006',
    @NgaySinh = '2004-02-15',
    @Phai = N'Nam',
    @MaKhoa = 'CNTT'

--Cau2
CREATE PROCEDURE ThemSinhVien_Cau2
    @HoSV nvarchar(20),
    @TenSV nvarchar(20),
    @MaSV varchar(10),
    @NgaySinh datetime,
    @Phai nvarchar(10),
    @MaKhoa varchar(10)
AS
BEGIN
    IF EXISTS (SELECT * FROM SinhVien WHERE MaSV = @MaSV)
    BEGIN
        PRINT 'Sinh Vien Da Ton Tai'
        RETURN
    END

	IF NOT EXISTS (SELECT * FROM Khoa WHERE MaKhoa = @MaKhoa)
    BEGIN
        PRINT 'Ma Khoa Khong Ton Tai'
        RETURN
    END

	DECLARE @Tuoi INT
    SET @Tuoi = DATEDIFF(YEAR, @NgaySinh, GETDATE())
    
    IF @Tuoi < 18 OR @Tuoi >= 40
		BEGIN
			PRINT ('Tuoi khong phu hop')
        RETURN
    END

    INSERT INTO SinhVien (HoSV, TenSV, MaSV, NgaySinh, Phai, MaKhoa)
    VALUES (@HoSV, @TenSV, @MaSV, @NgaySinh, @Phai, @MaKhoa)
END

EXEC ThemSinhVien_Cau2 
    @HoSV = N'Đặng',
    @TenSV = N'Thành Nhân',
    @MaSV = '522H0008',
    @NgaySinh = '2009-02-15',
    @Phai = N'Nam',
    @MaKhoa = 'TCNH'

--Cau3
CREATE PROCEDURE ThemKetQua
    @MaSV varchar(10),
    @MaMH varchar(10),
    @LanThi int,
    @Diem float
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SinhVien WHERE MaSV = @MaSV)
    BEGIN
        PRINT ('Sinh Khong Ton Tai')
        RETURN
    END

    END IF NOT EXISTS (SELECT * FROM MonHoc WHERE MaMH = @MaMH)
    BEGIN
        PRINT ('Mon Hoc Khong Ton Tai')
        RETURN

    INSERT INTO KetQua (MaSV, MaMH, LanThi, Diem)
    VALUES (@MaSV, @MaMH, @LanThi, @Diem)
END
EXEC ThemKetQua
	@MaSV = '522H0080',
    @MaMH = 'MMT',
    @LanThi = 1,
    @Diem = 9.5

--Cau4 
CREATE PROC DemSinhVien
   @MaKhoa VARCHAR(10)
AS
BEGIN
   DECLARE @sl int
   SET @sl = (SELECT COUNT(MaSV) FROM SinhVien
   WHERE MaKhoa = @MaKhoa)
   PRINT @sl
END
EXEC DemSinhVien
	@MaKhoa = 'CNTT'

--Cau5
CREATE FUNCTION DanhSachSinhVienTheoKhoa(@MaKhoa NVARCHAR(20))
RETURNS TABLE
AS
RETURN (
    SELECT HOSV, TENSV, MASV, NGAYSINH, PHAI
    FROM SINHVIEN
    WHERE MAKHOA = @MaKhoa
)

SELECT * FROM DanhSachSinhVienTheoKhoa('CNTT')

--6
CREATE FUNCTION Soluongsinhvien()
RETURNS TABLE
AS
RETURN (
    SELECT KHOA.MAKHOA, KHOA.TENKHOA, COUNT(SINHVIEN.MASV) AS SoLuongSinhVien
    FROM KHOA
    LEFT JOIN SINHVIEN ON KHOA.MAKHOA = SINHVIEN.MAKHOA
    GROUP BY KHOA.MAKHOA, KHOA.TENKHOA
)

SELECT * FROM Soluongsinhvien()

--7
CREATE FUNCTION XemKetQuaHocTap(@MaSV NVARCHAR(20))
RETURNS TABLE
AS
RETURN (
    SELECT MAMH, LANTHI, DIEM
    FROM KETQUA
    WHERE MASV = @MaSV
)

SELECT * FROM XemKetQuaHocTap('522H0006')

--8
CREATE FUNCTION DEM_SO_SV_THEO_KHOA (@MAKHOA VARCHAR(10))
RETURNS INT
AS
    BEGIN
      IF NOT EXISTS (SELECT * FROM KHOA WHERE MAKHOA = @MAKHOA)
        RETURN -1;
      DECLARE @count INT;
      SET @count = (SELECT COUNT(*) FROM SINHVIEN WHERE MAKHOA = @MAKHOA);
      RETURN @count;
    END
PRINT dbo.DEM_SO_SV_THEO_KHOA('CNTT')


--5 BTVN
--a
CREATE FUNCTION PhatSinhSoHoaDon()
RETURNS varchar(10)
AS
BEGIN
    DECLARE @SoHD varchar(10)
    DECLARE @NgayLap date
    SET @NgayLap = GETDATE()

    SET @SoHD = FORMAT(@NgayLap, 'yyMMdd') + 
                CAST(ISNULL((SELECT MAX(CAST(SUBSTRING(sohd, 7, LEN(sohd)) AS int)) FROM Hoadon WHERE CONVERT(date, ngaylap) = @NgayLap), 0) + 1 AS varchar(10))

    RETURN @SoHD
END

--b
DECLARE @SoHD varchar(10)

SET @SoHD = dbo.PhatSinhSoHoaDon()

INSERT INTO Hoadon (sohd, ngaylap)
VALUES (@SoHD, GETDATE())

--c
CREATE FUNCTION ThemNGKMoi(@Maloai varchar(10), @TenLoai nvarchar(20), DVT varchar(10), soluong)
RETURNS varchar(10)
AS
BEGIN
    DECLARE @SoThuTu int

    SELECT @SoThuTu = ISNULL(MAX(CAST(SUBSTRING(MaNGK, LEN(@Maloai) + 1, LEN(MaNGK) - LEN(@Maloai)) AS int)), 0)
    FROM NGK
    WHERE MaNGK LIKE @Maloai + '%'

    -- Tạo mã NGK mới
    SET @SoThuTu = @SoThuTu + 1
    DECLARE @MaNGK varchar(10)
    SET @MaNGK = @Maloai + RIGHT('000' + CAST(@SoThuTu AS varchar(3)), 3)

    INSERT INTO NGK (MaNGK, TenNGK, DVT, soluong, dongia, Maloai)
    VALUES (@MaNGK, 'Tên NGK Mới', 'DVT Mới', 0, 0, @Maloai)

    RETURN @MaNGK
END

--d
CREATE FUNCTION ThemCTHDMoi(@SoHD varchar(10), @MaNGK varchar(10), @SoLuong int)
RETURNS int
AS
BEGIN
    DECLARE @DonGia float

    SELECT @DonGia = dongia
    FROM NGK
    WHERE MaNGK = @MaNGK

    IF @SoLuong > (SELECT soluong FROM NGK WHERE MaNGK = @MaNGK)
    BEGIN
        RETURN -1
    END

    INSERT INTO CTHD (sohd, MaNGK, soluong, dongia)
    VALUES (@SoHD, @MaNGK, @SoLuong, @DonGia)

    UPDATE NGK
    SET soluong = soluong - @SoLuong
    WHERE MaNGK = @MaNGK

    RETURN @@ROWCOUNT
END

--e
CREATE FUNCTION TinhTongTienHoaDon(@SoHD varchar(10))
RETURNS float
AS
BEGIN
    DECLARE @TongTien float

    SELECT @TongTien = SUM(soluong * dongia)
    FROM CTHD
    WHERE sohd = @SoHD

    RETURN @TongTien
END

--f
CREATE FUNCTION LayDSNGKDauVaoThang3Nam2016()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT CTHD.MaNGK, NGK.TenNGK
    FROM CTHD
    INNER JOIN Hoadon ON CTHD.sohd = Hoadon.sohd
    INNER JOIN NGK ON CTHD.MaNGK = NGK.MaNGK
    WHERE Hoadon.ngaylap >= '2016-03-01' AND Hoadon.ngaylap <= '2016-03-31'
)