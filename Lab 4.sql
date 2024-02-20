--CSDL Quản lý bán hàng:
	--Phần III: Từ câu 20 đến câu 45.
--CSDL Quản lý giáo vụ:
	--Phần III: Từ câu 19 đến câu 31.

--QLBH 
--III
--20.	Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
select count(SOHD) as ' SL Hóa Đơn'
from HOADON HD, KHACHHANG KH
where HD.MAKH=KH.MAKH and NGDK is null
--21.	Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
select   count(distinct MASP) as 'SL sp'
from CTHD, HOADON
where CTHD.SOHD=HOADON.SOHD and year(NGHD)=2006
--22.	Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
select MAX(TRIGIA) as ' GT Cao nhất', MIN(TRIGIA) as ' GT Thấp nhất'
from HOADON
--23.	Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
select AVG(TRIGIA) as 'TGTB trong năm 2006'
from HOADON
where year(NGHD)=2006
--24.	Tính doanh thu bán hàng trong năm 2006.
select SUM(TRIGIA) as 'Doanh thu trong năm 2006'
from HOADON
where year(NGHD)=2006
--25.	Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
	-- Cách 1
select SOHD
from HOADON
where year(NGHD)=2006
and TRIGIA >= all
	( select TRIGIA
	from HOADON
	where year(NGHD)=2006
	)
	--Cách 2
select SOHD
from HOADON
where year(NGHD)=2006
and TRIGIA =
	( select MAX(TRIGIA)
	from HOADON
	where year(NGHD)=2006
	)
--26.	Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
select HOTEN
from KHACHHANG, HOADON
where KHACHHANG.MAKH=HOADON.MAKH and  year(NGHD)=2006 and TRIGIA =
	(select MAX(TRIGIA)
	from HOADON
	where year(NGHD) = 2006
	)
--27.	In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.

select TOP 3 MAKH, HOTEN, DOANHSO
from KHACHHANG
order by DOANHSO DESC

--28.	In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
select MASP, TENSP
from SANPHAM
where GIA in
( select distinct top 3 GIA
from SANPHAM
order by GIA DESC
)
--29.	In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select MASP, TENSP
FROM SANPHAM
where NUOCSX='Thai Lan' and GIA in
( select distinct top 3 GIA
from SANPHAM
order by GIA DESC
)
--30.	In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
select MASP, TENSP
FROM SANPHAM
where NUOCSX='Trung Quoc' and GIA in
( select distinct top 3 GIA
from SANPHAM
where NUOCSX='Trung Quoc'
order by GIA DESC
)
--31.	* In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
select MAKH, HOTEN
from KHACHHANG
where DOANHSO in
(	select distinct top 3 DOANHSO
	from KHACHHANG
	order by DOANHSO DESC
	)
--32.	Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
select count(distinct MASP) as 'Tong SP do TQ sản xuất'
from SANPHAM
where NUOCSX ='Trung Quoc'

--33.	Tính tổng số sản phẩm của từng nước sản xuất.
select NUOCSX, count( MASP) as 'Tong SP '
from SANPHAM
group by NUOCSX
--34.	Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
select NUOCSX, MAX(GIA) as 'GIA_CaoNhat', MIN(GIA) as 'GIA_ThapNhat', AVG(GIA) as' Gia TB'
from SANPHAM
group by NUOCSX
--35.	Tính doanh thu bán hàng mỗi ngày.
select NGHD ,sum(TRIGIA) as ' Doanh thu moi ngay'
from HOADON
group by  NGHD
--36.	Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
select MASP ,SUM(SL) as 'Tong SL bán ra trong 10/2006'
from CTHD, HOADON
where CTHD.SOHD=HOADON.SOHD and month(NGHD)= 10 and year(NGHD)=2006
group by MASP
--37.	Tính doanh thu bán hàng của từng tháng trong năm 2006.
select month(NGHD) as Thang ,SUM(TRIGIA) as 'DOANH THU TUNG THANG'
from HOADON
where  year(NGHD)=2006
group by month(NGHD)
--38.	Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select SOHD
from CTHD
group by SOHD
having count(distinct MASP) >=4
--39.	Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
select SOHD
from SANPHAM, CTHD
where NUOCSX='Viet Nam' and cthd.MASP= SANPHAM.MASP 
group by SOHD
having count(distinct CTHD.MASP)=3
--40.	Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
-- Cách 1
select KHACHHANG.MAKH, HOTEN, count(SOHD) as 'Số Lần mua'
from KHACHHANG, HOADON
where  KHACHHANG.MAKH=HOADON.MAKH 
group by KHACHHANG.MAKH, HOTEN
having count(SOHD) >= all
				(select count(SOHD)
				from HOADON
				group by MAKH
				)
-- Cách 2
select top 1 with ties KHACHHANG.MAKH, HOTEN, count(SOHD) as 'Số Lần Mua'
from KHACHHANG, HOADON
where  KHACHHANG.MAKH=HOADON.MAKH 
group by KHACHHANG.MAKH, HOTEN
order by count(SOHD) DESC

--41.	Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
-- c1
select Month(NGHD) THANG
from HOADON
where year(NGHD) = 2006
group by MONTH(NGHD)
having sum(TRIGIA) >= ALL ( Select SUM(TRIGIA)
							from HOADON
							where year(NGHD) = 2006
							group by MONTH(NGHD)
							)
-- c2
select top 1 with ties Month(NGHD) THANG
from HOADON
where year(NGHD) = 2006
group by MONTH(NGHD)
order by sum(TRIGIA) DESC
--42.	Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
select SANPHAM.MASP, TENSP
from SANPHAM, CTHD, HOADON
where SANPHAM.MASP=CTHD.MASP and CTHD.SOHD=HOADON.SOHD and YEAR(NGHD)=2006
group by SANPHAM.MASP, TENSP
having sum(SL)<= all
		(select SUM(SL)
		from HOADON, CTHD
		where HOADON.SOHD=CTHD.SOHD and YEAR(NGHD)=2006
		group by MASP)
--43.	*Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
--44.	Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
select NUOCSX
from SANPHAM
group by NUOCSX
having count (distinct GIA)>=3
--45.	*Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
CREATE TRIGGER trg_Bai1a ON KHACHHANG 
FOR INSERT
AS 
BEGIN 
 Print ('Khach hang da them thanh cong')
END;
INSERT INTO KHACHHANG(MAKH) VALUES('KH50')

CREATE TRIGGER trg_Kiemtra_NhapHD ON HOADON 
FOR INSERT
AS 
BEGIN 
 -- Dùng từ khoá để khai báo biến 
DECLARE @MAKH CHAR(4)
DECLARE @HOTEN VARCHAR(40) 
 -------------------------------- 
 SELECT @MAKH=MAKH FROM INSERTED 
 SELECT @HOTEN=HOTEN FROM KHACHHANG 
 WHERE MAKH=@MAKH 
 PRINT 'Hoa don cua khach hang '+@HOTEN+' da duoc them thanh cong' 
END
insert into HOADON(SOHD,MAKH,MANV) values(1099,'KH01','NV01')





--QLGV
--III
--19.	Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
select top 1 with ties MAKHOA, TENKHOA, NGTLAP
from KHOA
group by NGTLAP,MAKHOA, TENKHOA
order by NGTLAP ASC

--20.	Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
select HOCHAM, count(MAGV) SLGV
from GIAOVIEN
where HOCHAM in ('GS', 'PGS')
group by HOCHAM

--21.	Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
select  MAKHOA,HOCVI, count(MAGV) SLGV
from  GIAOVIEN
group by HOCVI,MAKHOA
having HOCVI in('CN','KS','Ths','TS','PTS')

--22.	Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
select MAMH, KQUA, count(MAHV) SLHV
from  KETQUATHI
group by MAMH, KQUA
order by MAMH
--23.	Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
select MAGV,HOTEN
from GIAOVIEN
where MAGV in
	( select MAGV
	from GIANGDAY, LOP
	where GIAOVIEN.MAGV=LOP.MAGVCN and LOP.MALOP=GIANGDAY.MALOP
	)


--24.	Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
select HO, TEN
from HOCVIEN, LOP
where HOCVIEN.MAHV=LOP.TRGLOP and SISO >= ALL ( select SISO
from LOP)

--25.	* Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
--26.	Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
select top 1 with ties HOCVIEN.MAHV, HO, TEN, count(DIEM) SLDIEM
from HOCVIEN, KETQUATHI
where HOCVIEN.MAHV=KETQUATHI.MAHV and (DIEM between 9 and 10)
group by HOCVIEN.MAHV, HO, TEN
order by count(DIEM) DESC

--27.	Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT LEFT(A.MAHV, 3) MALOP, A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, RANK () OVER (ORDER BY COUNT(MAMH) DESC) RANK_MH FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
WHERE RANK_MH = 1
GROUP BY LEFT(A.MAHV, 3), A.MAHV, HO, TEN
--28.	Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
select MAGV, count(MAMH) as SLMON, count(MALOP) SLLOP
from GIANGDAY
group by HOCKY, NAM, MAGV

--29.	Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT HOCKY, NAM, A.MAGV, HOTEN FROM (
	SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) RANK_SOMH FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A INNER JOIN GIAOVIEN GV 
ON A.MAGV = GV.MAGV
WHERE RANK_SOMH = 1

--30.	Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
select top 1 with ties MONHOC.MAMH, TENMH, count(MAHV) SLSV
from MONHOC, KETQUATHI
where MONHOC.MAMH=KETQUATHI.MAMH and KQUA='Khong Dat' and LANTHI=1
group by MONHOC.MAMH, TENMH
order by COUNT(MAHV) DESC

--31.	Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
select HOCVIEN.MAHV, HO, TEN
from HOCVIEN, KETQUATHI
where HOCVIEN.MAHV=KETQUATHI.MAHV and LANTHI=1
except
select HOCVIEN.MAHV, HO, TEN
from HOCVIEN, KETQUATHI
where HOCVIEN.MAHV=KETQUATHI.MAHV and KQUA='Khong Dat' and LANTHI=1