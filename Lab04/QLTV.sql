CREATE TABLE Sach
(
	MaSach varchar(10) CONSTRAINT PK_MS PRIMARY KEY,
	TenSach nvarchar(20),
	NXB nvarchar(20),
	TacGia nvarchar(20),
	SL int
)

CREATE TABLE DocGia
(
	MaDG varchar(10) CONSTRAINT PK_MaDG PRIMARY KEY,
	TenDG nvarchar(20),
	NgayDK date,
	SDT int
)

CREATE TABLE PhieuMuon
(
	MaDG varchar(10),
	MaSach varchar(10),
	NgayMuon date,
	NgayTra date,
	PRIMARY KEY(MaDG, MaSach, NgayMuon),
	CONSTRAINT FK_MaDG FOREIGN KEY (MaDG) REFERENCES DocGia (MaDG),
	CONSTRAINT FK_MS FOREIGN KEY (MaSach) REFERENCES Sach (MaSach)
)

INSERT INTO Sach(MaSach, TenSach, NXB, TacGia, SL) VALUES
('B001', N'Toán', N'Bộ Giáo Dục', N'TG01', 1),
('B002', N'Lý', N'Bộ Giáo Dục', N'TG02', 3),
('B003', N'Hóa', N'Bộ Giáo Dục', N'TG03', 4),
('B004', N'Sinh', N'Bộ Giáo Dục', N'TG04', 2),
('B005', N'Anh', N'Bộ Giáo Dục', N'TG05', 5)

INSERT INTO DocGia(MaDG, TenDG, NgayDK, SDT) VALUES
('DG001', N'Đặng Thành Nhân', '02/15/2013', 0982717527),
('DG002', N'Nguyễn Thành Nhân', '08/08/2008', 0982717526),
('DG003', N'Võ Nhật Hào', '05/02/2010', 0982717525),
('DG004', N'Từ Gia Bảo', '05/04/2013', 0982717524),
('DG005', N'Huỳnh Trọng Trí', '02/09/2013', 0982717523)

INSERT INTO PhieuMuon(MaDG, MaSach, NgayMuon, NgayTra) VALUES
('DG001', 'B005', '05/01/2022', '05/01/2022'),
('DG001', 'B002', '04/01/2022', '04/01/2022'),
('DG002', 'B001', '02/26/2022', '03/10/2022'),
('DG001', 'B005', '07/01/2022', '05/15/2022'),
('DG001', 'B002', '04/20/2022', '04/29/2022')

SELECT * FROM Sach
SELECT * FROM DocGia
SELECT * FROM PhieuMuon

--2
SELECT COUNT(*) FROM Sach

--3
INSERT INTO Sach(MaSach, TenSach, NXB, TacGia, SL) VALUES
('B006', N'Lập Trình Cơ Bản', N'Bộ Giáo Dục', N'TG06', 4)

SELECT * FROM Sach 
WHERE TenSach like N'Lập Trình%'

--4
SELECT * FROM Sach 
WHERE MaSach in (SELECT MaSach FROM PhieuMuon
				WHERE NgayMuon = NgayTra)

--5
SELECT NXB, SUM(SL) AS SOLuongSach FROM Sach
GROUP BY NXB

--6
SELECT TacGia, SUM(SL) AS SOLuongSach FROM Sach
GROUP BY TacGia

--7
SELECT * FROM DocGia WHERE MaDG in( SELECT MaDG FROM PhieuMuon
									WHERE NgayDK = getDATE())

--8
SELECT * FROM DocGia WHERE MaDG in (SELECT MaDG FROM PhieuMuon
									WHERE DATEDIFF(day, NgayTra, NgayMuon) <= 10)

--9
SELECT DocGia.MaDG, TenDG, COUNT(*) AS SoLanTreHen
FROM DocGia
INNER JOIN PhieuMuon ON DocGia.MaDG = PhieuMuon.MaDG
WHERE DATEDIFF(day, NgayTra, NgayMuon) > 10
GROUP BY DocGia.MaDG, TenDG
HAVING COUNT(*) >= 3


--10
SELECT * FROM Sach WHERE MaSach NOT IN (SELECT DISTINCT MaSach FROM PhieuMuon)

--11
SELECT 

--12
INSERT INTO Sach (MaSach, TenSach, NXB, TacGia, SL)
VALUES ('B007', N'Tin Học Cơ Bản', N'Bộ Giáo Dục', N'TG07', 5)

--13
INSERT INTO Sach (MaSach, TenSach, NXB, TacGia, SL)
VALUES ('B009', N'Tin Học Cơ Bản02', N'Lao Động', N'TG09', 5)

UPDATE Sach
SET SL = 5
WHERE NXB = N'Lao dong'

--14
DELETE FROM Sach
WHERE TacGia = N'nqt'

--15
DELETE FROM DocGia
WHERE DATEDIFF(year, NgayDK, GETDATE()) >= 4


-----View-----
--1 
CREATE VIEW VCau3_1 AS
SELECT * FROM Sach
WHERE TacGia LIKE N'%Phước'
SELECT * FROM VCau3_1

--2
CREATE VIEW VCau3_2 AS
SELECT * FROM DocGia
WHERE SDT IS NULL
SELECT * FROM Vcau3_2

--3 
CREATE VIEW VCau3_3 AS
SELECT Sach.TenSach, COUNT(*) AS SoLanMuon FROM Sach
INNER JOIN PhieuMuon ON Sach.MaSach = PhieuMuon.MaSach
GROUP BY Sach.TenSach
HAVING COUNT(*) >= 3
SELECT * FROM Vcau3_3

--4 
CREATE VIEW VCau3_4 AS
SELECT TOP (10) Sach.TenSach, COUNT(*) AS SoLanMuon FROM Sach
INNER JOIN PhieuMuon ON Sach.MaSach = PhieuMuon.MaSach
GROUP BY Sach.TenSach
ORDER BY COUNT(*) DESC
SELECT * FROM VCau3_4

--5
CREATE VIEW VCau3_5 AS
SELECT * FROM DocGia
WHERE YEAR(GETDATE()) - YEAR(NgayDK) > 4
SELECT * FROM VCau3_5

CREATE VIEW VCau3_6 AS
SELECT * FROM Sach WHERE SL = (SELECT MAX(SL) FROM Sach);
--7
create view VCAU3_7 as
select distinct Sach.Masach, Sach.Tensach, Sach.nxb, Sach.Tacgia, Sach.SL, count(*) as 'Số lượng sách được mượn nhiều nhất' from Phieumuon, Sach
where Sach.Masach = Phieumuon.Masach
group by Sach.Masach, Sach.Tensach, Sach.nxb, Sach.Tacgia, Sach.SL
having count(*) =
(
  select top 1 count(*) from Phieumuon
  group by Madg
  order by count(*) desc
)
--8
CREATE VIEW VCau3_8 AS
SELECT madg, tendg FROM DocGia 
WHERE madg IN (
  SELECT madg FROM PhieuMuon 
  GROUP BY madg 
  HAVING COUNT(*) > 10) 
AND madg NOT IN (
  SELECT madg FROM PhieuMuon 
  WHERE ngaytra > ngaymuon);
--9
CREATE VIEW VCau3_9 AS
SELECT * FROM Sach 
WHERE masach IN (
  SELECT masach FROM PhieuMuon 
  WHERE ngaytra IS NULL);
--10
CREATE VIEW VCau3_10 AS
SELECT phieumuon.masach, sach.tensach, phieumuon.madg, phieumuon.ngaymuon
FROM phieumuon JOIN sach ON phieumuon.masach = sach.masach
WHERE MONTH(phieumuon.ngaymuon) BETWEEN 7 AND 9 AND YEAR(phieumuon.ngaymuon) = 2019
ORDER BY COUNT(*) DESC;
