--CSDL Quản lý bán hàng:
	--Phần III: Từ câu 12 đến câu 19.
--CSDL Quản lý giáo vụ:
	--Phần II: Từ câu 1 đến câu 4.
	--Phần III: Từ câu 6 đến câu 18.

--QLBH
--III
--câu 12
Select Distinct SoHD
From CTHD
Where (MaSP in('BB01','BB02') AND (SL between 10 and 20))
--Câu 13
Select Distinct SoHD
From CTHD
Where (MaSP ='BB01'AND (SL between 10 and 20))
intersect
Select Distinct SoHD
From CTHD
Where (MaSP ='BB02'AND (SL between 10 and 20))
--Câu 14 : 14.	In ra danh sách các sản phẩm (MASP,TENSP)
--do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007
SET DATEFORMAT DMY
Select DISTINCT SP.MaSP, TenSP
FROM SANPHAM SP, HOADON HD, CTHD CT
WHERE SP.MASP=CT.MASP AND HD.SOHD=CT.SOHD
		AND (NUOCSX='Trung Quoc' 
		OR	NgHD='1/1/2007')
--Câu 15.	In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
--Cách 1
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SP.MASP, TENSP
FROM SANPHAM SP,  CTHD CT
WHERE SP.MASP=CT.MASP 
--Cách 2
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN ( SELECT MASP FROM CTHD)
-- Câu 16 :In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
--Cách 1
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SP.MASP, TENSP
FROM SANPHAM SP,  CTHD CT , HOADON HD
WHERE SP.MASP=CT.MASP AND HD.SOHD=CT.SOHD
		AND YEAR(NGHD)=2006
--Cách 2
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN ( SELECT MASP FROM   CTHD CT , HOADON HD WHERE HD.SOHD=CT.SOHD AND YEAR(NGHD)=2006)
-- Câu 17.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX='Trung Quoc' AND MASP NOT IN ( SELECT MASP FROM   CTHD CT , HOADON HD WHERE HD.SOHD=CT.SOHD AND YEAR(NGHD)=2006)
--Câu 18 : Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
Select SoHD
FROM HOADON HD
WHERE not exists ( Select *
					From SANPHAM SP	
					WHERE NUOCSX='Singapore' and Not exists ( Select *	
																From CTHD CT
																WHERE HD.SOHD=CT.SOHD	
																AND SP.MASP=CT.MASP))
--Câu 19 :Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
Select SoHD
FROM HOADON HD
Where Year(NGHD)=2006 and not exists ( SELECT *	
										From SANPHAM SP
										WHERE NUOCSX='Singapore' and Not exists ( Select *	
																					From CTHD CT
																					WHERE HD.SOHD=CT.SOHD	
																					AND SP.MASP=CT.MASP))


--QLGV
--II
--Câu 1.Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
update GIAOVIEN
set HESO = HESO + 0.2
where MAGV in (Select TRGKHOA From KHOA)
--Câu 2.Cập nhật giá trị điểm trung bình tất cả các môn học  (DIEMTB) 
--của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HOCVIEN SET DIEMTB = DTB_HOCVIEN.DTB
FROM HOCVIEN HV LEFT JOIN (SELECT MAHV, AVG(DIEM) AS DTB 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) 
	GROUP BY MAHV
) DTB_HOCVIEN
ON HV.MAHV = DTB_HOCVIEN.MAHV

--Câu 3.Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN SET GHICHU = 'Cam thi'
WHERE MAHV IN (
	SELECT MAHV 
	FROM KETQUATHI 
	WHERE LANTHI = 3 AND DIEM < 5
)
--Câu 4.Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--o	Nếu DIEMTB  9 thì XEPLOAI =”XS”
--o	Nếu  8  DIEMTB < 9 thì XEPLOAI = “G”
--o	Nếu  6.5  DIEMTB < 8 thì XEPLOAI = “K”
--o	Nếu  5    DIEMTB < 6.5 thì XEPLOAI = “TB”
--o	Nếu  DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN 
SET XEPLOAI = 
CASE 
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 THEN 'G'
	WHEN DIEMTB >= 6.5 THEN 'K'
	WHEN DIEMTB >= 5 THEN 'TB'
	ELSE 'Y'
	END

--III
--6.	Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
Select MH.TENMH
from MONHOC MH, GIANGDAY GD, GIAOVIEN GV
where GV.HOTEN = 'Tran Tam Thanh' and HOCKY =1 and NAM =2006 and MH.MAMH = GD.MAMH and GV.MAGV = GD.MAGV
--7.	Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
Select MH.MAMH, TENMH
from MONHOC MH, GIAOVIEN GV, GIANGDAY GD, LOP
where LOP.MALOP= 'K11' and LOP.MAGVCN=GD.MAGV and GD.HOCKY =1 and GD.NAM =2006 and MH.MAMH = GD.MAMH and GV.MAGV = GD.MAGV

--8.Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
Select HO, TEN
From HOCVIEN HV, LOP, GIAOVIEN GV, MONHOC MH, GIANGDAY GD
Where GV.HOTEN='Nguyen To Lan' and MH.TENMH='Co So Du Lieu' and LOP.TRGLOP=HV.MAHV and GD.MAMH = MH.MAMH and GV.MAGV=GD.MAGV
--9.	In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
Select MH.MAMH, MH.TENMH
From MONHOC MH, DIEUKIEN DK
Where MH.MAMH=DK.MAMH_TRUOC AND DK.MAMH IN ( Select MAMH
												from MONHOC
												where MONHOC.TENMH='Co So Du Lieu')
--10.	Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
Select MH.MAMH, MH.TENMH
FROM MONHOC MH, DIEUKIEN DK
WHERE MH.MAMH=DK.MAMH and DK.MAMH_TRUOC in ( select MAMH from MONHOC where MONHOC.TENMH='Cau Truc Roi Rac')

--11.	Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
select HOTEN
from GIAOVIEN GV, GIANGDAY GD
where GD.MAMH='CTRR' and GD.MALOP='K11' and GD.HOCKY=1 and GD.NAM=2006 and  GV.MAGV=GD.MAGV 
union
select HOTEN
from GIAOVIEN GV, GIANGDAY GD
where GD.MAMH='CTRR' and GD.MALOP='K12' and GD.HOCKY=1 and GD.NAM=2006 and GV.MAGV=GD.MAGV 
--12.	Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
select distinct HV.MAHV, HV.HO, HV.TEN
from HOCVIEN HV, KETQUATHI KQ
where KQ.KQUA='Khong Dat' and KQ.LANTHI=1 and HV.MAHV=KQ.MAHV and HV.MAHV in
( Select HOCVIEN.MAHV
from HOCVIEN, KETQUATHI
where KETQUATHI.MAMH='CSDL' and HOCVIEN.MAHV=KETQUATHI.MAHV
group by HOCVIEN.MAHV
having count(KETQUATHI.LANTHI)=1)

--13.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
--Cách 1
(SELECT GV.MAGV, GV.HOTEN
FRom GIAOVIEN GV
EXCEPT
SELECT GV.MAGV, GV.HOTEN
FRom GIAOVIEN GV,GIANGDAY GD
where GV.MAGV=GD.MAGV)
--Cách 2:
SELECT MAGV,HOTEN
FROM GIAOVIEN 
WHERE  NOT EXISTS 
(
 SELECT MAGV 
 FROM GIANGDAY WHERE  GIAOVIEN.MAGV=GIANGDAY.MAGV
)
--14.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT MAGV,HOTEN
FROM GIAOVIEN 
WHERE  NOT EXISTS 
(
 SELECT MAGV
 FROM GIANGDAY,MONHOC  
 WHERE  GIAOVIEN.MAGV=GIANGDAY.MAGV AND GIANGDAY.MAMH=MONHOC.MAMH AND MONHOC.MAKHOA=GIAOVIEN.MAKHOA
)
--15.	Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO + ' ' + TEN AS HOTEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI A
	WHERE LEFT(MAHV, 3) = 'K11' AND ((
		NOT EXISTS (
			SELECT 1 FROM KETQUATHI B 
			WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
		)  AND LANTHI = 3 AND KQUA = 'Khong Dat'
	) OR MAMH = 'CTRR' AND LANTHI = 2 AND DIEM = 5)
)
--16.	Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN FROM GIAOVIEN 
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY 
	WHERE MAMH = 'CTRR'
	GROUP BY MAGV, HOCKY, NAM 
	HAVING COUNT(MALOP) >= 2
)
--17.	Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, DIEM 
FROM HOCVIEN HV INNER JOIN (
	SELECT MAHV, DIEM 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND MAMH = 'CSDL'
) DIEM_CSDL
ON HV.MAHV = DIEM_CSDL.MAHV
--18.	Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, DIEM 
FROM HOCVIEN HV INNER JOIN (
	SELECT MAHV, MAX(DIEM) AS DIEM FROM KETQUATHI 
	WHERE MAMH IN (
		SELECT MAMH FROM MONHOC 
		WHERE TENMH = 'Co So Du Lieu'
	) 
	GROUP BY MAHV, MAMH
) DIEM_CSDL_MAX
ON HV.MAHV = DIEM_CSDL_MAX.MAHV