CREATE TABLE Lop(
	malop varchar(10) PRIMARY KEY,
	tenlop nvarchar(20)
)
ALTER TABLE Lop ADD makhoa nvarchar(10)
INSERT INTO Lop(malop, tenlop) VALUES
('L01', N'Lop 01 '),
('L02', N'Lop 02'),
('L03', N'Lop 03')
SELECT * FROM Lop

CREATE TABLE SinhVien(
	masv varchar(10) PRIMARY KEY,
	hoten nvarchar(50),
	ngaysinh datetime,
	malop varchar(10) FOREIGN KEY REFERENCES Lop(malop)
)
INSERT INTO SinhVien(masv, hoten, ngaysinh, malop) VALUES
('522H0006', N'Dang Thanh Nhan', '2004-02-15', 'L01'),
('522H0090', N'Vo Nhat Hao', '2004-12-05', 'L02'),
('522H0007', N'Nguyen Thanh Nhan', '2004-01-20', 'L03')
SELECT * FROM SinhVien

CREATE TABLE MonHoc(
	mamh varchar(10) PRIMARY KEY,
	tenmh nvarchar(50) 
)
INSERT INTO MonHoc(mamh, tenmh) VALUES
('CTDL', N'Cấu Trúc Dữ Liệu'),
('HCS', N'Hệ Cơ Sở Dữ Liệu'),
('MMT', N'Mạng Máy Tính')
SELECT * FROM MonHoc

CREATE TABLE KetQua(
	masv varchar(10),
	mamh varchar(10),
	diem float,
	PRIMARY KEY(masv, mamh),
	FOREIGN KEY (masv) REFERENCES SinhVien(masv),
	FOREIGN KEY (mamh) REFERENCES MonHoc(mamh)
)
INSERT INTO KetQua(masv, mamh, diem) VALUES
('522H0006', 'CTDL', 8.0),
('522H0090', 'HCS', 8.7),
('522H0007', 'MMT', 9.0)


go
--3. Bai tap co huong dan
--3a.
Create function caua (@ml varchar(10))
Returns table
As

    Return (select (Upper(left(hoten,1)) +
    substring(hoten,2,len(hoten)-1)) as hoten, CONVERT(VARCHAR(10),
    ngaysinh,103) as Ngaysinh
        From sinhvien Where malop = @ml)
go
--drop function caua
select * from caua ('TH01')

go
--3b.
create function caub()
returns table
as
return (select masv, mamh, str(diem,5,2) as diem from ketqua)
go
select * from caub()

go
--3c.
Create function cauc()
Returns table
As
    Return (select hoten, ngaysinh, datename(dw,ngaysinh) as
Thu from sinhvien)
go
select * from cauc()

go
--3d.
Create function caud ()
Returns table
As
    Return (select masv,
reverse(substring(reverse(hoten),charindex(' ',reverse(hoten))+1,
len(hoten)- len(left(reverse(hoten),charindex('
',reverse(hoten)))) )) as Holot,
reverse(left(reverse(hoten),charindex(' ',reverse(hoten)))) as
ten from sinhvien)
go
select * from caud()

go
--3e.
Create function caue (@ml varchar(10))
Returns varchar(10)
As
Begin
    return(select top 1 masv from sinhvien where malop = @ml
order by masv desc)
End
go
--drop function cau1
print dbo.caue('TH01')

go
--3f.
Create proc cauf @ht nvarchar(30), @ns datetime, @ml varchar(10)
As
    declare @masv varchar(10)
    set @masv = dbo.caue(@ml)
    declare @stt int
    set @stt = cast(right(@masv,3) as int) + 1
    if @stt < 10
    begin
    set @masv = @ml + '00' + cast (@stt as varchar(1))
    end
    else if @stt < 100
    begin
    set @masv = @ml + '0' + cast (@stt as varchar(2))
    end
    else
    begin
        set @masv = @ml + cast (@stt as varchar(3))
    end
    insert into sinhvien values (@masv, @ht, @ns, @ml)
Go
--drop proc cauf
exec cauf N'Nguyễn Lâm', '3/30/1990', 'TH01'

go
--3g.
create function caug()
returns table
as
    return (select sinhvien.masv, hoten, str(avg(diem),5,2) as
dtb
    from sinhvien, ketqua where sinhvien.masv = ketqua.masv
    group by sinhvien.masv, hoten
    having avg(diem) >=5)
go
select * from caug()

--BaiTapTuLam
--a
-- Lây ra họ
CREATE FUNCTION layHo(@ten nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
    DECLARE @vt int
    DECLARE @h nvarchar(50)
    SET @vt = CHARINDEX(' ', @ten)
    SET @h = SUBSTRING(@ten, 1, @vt - 1)
    RETURN @h
END
print dbo.layHo(N'Nguyễn Văn Tài Em')

-- Lấy ra tên
CREATE FUNCTION layTen(@ten nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
    DECLARE @vt int
    DECLARE @name nvarchar(30)
    SET @vt = CHARINDEX(' ', REVERSE(@ten))
    SET @name = RIGHT(@ten, @vt - 1)
    RETURN @name
END
print dbo.layTen(N'Nguyễn Văn Tài Em')

-- Lấy ra họ lót
CREATE FUNCTION layHoLot(@ten NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @vt int
    DECLARE @hoLot nvarchar(30)
    SET @vt = CHARINDEX(' ', REVERSE(@ten))
    SET @hoLot = SUBSTRING(@ten, len(dbo.layHo(@ten)) + 2, len(@ten) - len(dbo.layHo(@ten)) - 1 - len(dbo.layTen(@ten)) - 1)
    RETURN @hoLot
END
print dbo.layholot(N'Nguyễn Văn Tài Em')

--b
CREATE FUNCTION getDayOfWeek(@mssv varchar(10))
RETURNS @result TABLE 
(
    hoten NVARCHAR(50),
    ngaysinh DATE, 
    thu NVARCHAR(10)
)
AS
BEGIN
  INSERT INTO @result
  SELECT sv.hoten, sv.ngaysinh, 
  CASE DATEPART(WEEKDAY, sv.ngaysinh)
       WHEN 1 THEN N'Chủ nhật'  
       WHEN 2 THEN N'Thứ hai'
       WHEN 3 THEN N'Thứ ba'
       WHEN 4 THEN N'Thứ tư'
       WHEN 5 THEN N'Thứ năm'
       WHEN 6 THEN N'Thứ sáu'
       WHEN 7 THEN N'Thứ bảy'
     END
  FROM Sinhvien sv
  WHERE sv.masv = @mssv
  
  RETURN 
END
SELECT * FROM dbo.getDayOfWeek('522H0006')

--c
CREATE FUNCTION SinhVienDuoi5()
RETURNS @BangSinhVien TABLE 
(
    masv varchar(10),
    hoten nvarchar(50), 
    namsinh datetime,
    dtb DECIMAL(3,1)
)
AS
BEGIN
  INSERT INTO @BangSinhVien
  SELECT sv.masv, sv.hoten, YEAR(sv.ngaysinh) AS namsinh, ROUND(AVG(kq.diem), 1) AS dtb
  FROM SinhVien sv
  JOIN KetQua kq ON sv.masv = kq.masv
  GROUP BY sv.masv, sv.hoten, sv.ngaysinh
  HAVING AVG(kq.diem) < 5

  RETURN 
END

SELECT * FROM dbo.SinhVienDuoi5()

--d
CREATE FUNCTION GetLop(@masv varchar(10))  
RETURNS @Lop TABLE 
(
    malop varchar(10),
    tenlop NVARCHAR(50)
)
AS
BEGIN
  INSERT INTO @Lop 
  SELECT l.malop, l.tenlop
  FROM Lop l
  JOIN SinhVien sv ON l.malop = sv.malop
  WHERE sv.masv = @masv

  RETURN 
END 

SELECT * FROM dbo.GetLop('522H0006')

--e
CREATE FUNCTION GetDiemTB(@mamh varchar(10))
RETURNS float
AS
BEGIN
  DECLARE @dtb float

  SELECT @dtb = AVG(diem) FROM KetQua
  WHERE mamh = @mamh
  
  RETURN @dtb
END

SELECT dbo.GetDiemTB('CTDL') AS 'Điểm TB'


--f
CREATE FUNCTION DiemTBMax(@malop varchar(10))
RETURNS float
AS
BEGIN
  DECLARE @dtbMax float

  SELECT @dtbMax = MAX(dtb)
  FROM
  (
    SELECT sv.masv, ROUND(AVG(kq.diem), 2) AS dtb 
    FROM SinhVien sv
    JOIN KetQua kq ON sv.masv = kq.masv
    WHERE sv.malop = @malop
    GROUP BY sv.masv
  ) AS bangTam

  RETURN @dtbMax

END

print dbo.DiemTBMax('L01')


