--Yê Cầu :
--CSDL Quản lý bán hàng: Phần I - Từ câu 1 đến câu 10.
--CSDL Quản lý giáo vụ: Phần I - Từ câu 1 đến câu 8.


--QLBH
Create database QLBH

--I
--1.	Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.CREATE TABLE KHACHHANG (
	MAKH    char(4) primary key,
	HOTEN	varchar(40),
	DCHI	varchar(50),
	SODT	varchar(20),
	NGSINH	smalldatetime,
	DOANHSO	money,
	NGDK	smalldatetime,
)
Create table NHANVIEN (
	MANV	char(4) primary key,
	HOTEN	varchar(40),
	SODT	varchar(20),
	NGVL		smalldatetime,
)
Create table SANPHAM (
	MASP	char(4) primary key,
	TENSP	varchar(40),
	DVT		varchar(20),
	NUOCSX	varchar(40),
	GIA		money,
)
Create table HOADON (
	SOHD	int primary key,
	NGHD	smalldatetime,
	MAKH	char(4)Foreign key references KHACHHANG (MAKH),
	MANV	char(4) Foreign key references NHANVIEN (MANV),
	TRIGIA	money,
)
Create table CTHD (
	SOHD	int foreign key references HOADON(SOHD) ,
	MASP	char(4) foreign key references SANPHAM(MASP),
	--constraintn FK_CTHD foreign key references HOADON(SOHD)
	SL		int, 
	constraint PK_CTHD primary key (SOHD,MASP),
)


--2.Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM
ADD GHICHU varchar(20)


--3.	Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG
ADD LOAIKH tinyint


--4.	Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM ALTER COLUMN GHICHU
VARCHAR(100)


--5.	Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU


--6.	Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
-- Sửa kiểu dữ liệu lại thành text, ban đầu là int 
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH
varchar(20)


--7.	Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
--Cách 1
ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT CHECK (DVT IN ('cay','hop','cai','quyen','chuc'))
--Cách 2
ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT CHECK (DVT='cay' OR DVT='hop' OR DVT='cai' OR DVT='quyen' OR DVT='chuc')


--8.	Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM ADD CONSTRAINT CK_GIA CHECK (GIA>=500)


--9.	Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD ADD CONSTRAINT CK_SL CHECK (SL>=1)


--10.	Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
alter table KHACHHANG ADD CONSTRAINT CK_NS_NDK  CHECK(NGDK >NGSINH)



--QLGV
--1.	Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
create table KHOA
(
MAKHOA	varchar(4) primary key,
TENKHOA	varchar(40),
NGTLAP	smalldatetime,
TRGKHOA	char(4)
)
create table MONHOC
(
MAMH	varchar(10) primary key,
TENMH	varchar(40),
TCLT	tinyint,
TCTH	tinyint,
MAKHOA	varchar(4) foreign key references KHOA(MAKHOA)
)
create table DIEUKIEN
(
MAMH	varchar(10) foreign key references MONHOC(MAMH),
MAMH_TRUOC	varchar(10) foreign key references MONHOC(MAMH),
constraint PK_DIEUKIEN primary key (MAMH,MAMH_TRUOC)
)
create table GIAOVIEN
(MAGV	char(4) primary key,
HOTEN	varchar(40),
HOCVI	varchar(10),
HOCHAM	varchar(10),
GIOITINH	varchar(3),
NGSINH	smalldatetime,
NGVL	smalldatetime,
HESO	numeric(4,2),
MUCLUONG	money,
MAKHOA	varchar(4) foreign key references KHOA(MAKHOA),
)
--Tạo khóa ngoại cho quan hệ  KHOA
ALTER TABLE KHOA ADD CONSTRAINT FK_TRGKHOA FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN (MAGV);
create table LOP
(
MALOP	char(3) primary key,
TENLOP	varchar(40),
TRGLOP	char(5) ,
SISO	tinyint,
MAGVCN	char(4) foreign key references GIAOVIEN(MAGV),
)

create table HOCVIEN
(
MAHV char(5) primary key,
HO	varchar(40),
TEN	varchar(10),
NGSINH	smalldatetime,
GIOITINH	varchar(3),
NOISINH	varchar(40),
MALOP	char(3) foreign key references LOP(MALOP)
)
--Tạo khóa ngoại TRGLOP cho quan hệ LOP
ALTER TABLE LOP ADD CONSTRAINT FK_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN (MAHV);

create table GIANGDAY
(
MALOP	char(3) foreign key references LOP(MALOP),
MAMH	varchar(10) foreign key references MONHOC(MAMH),
MAGV	char(4) foreign key references GIAOVIEN(MAGV),
HOCKY	tinyint,
NAM	smallint,
TUNGAY	smalldatetime, 
DENNGAY	smalldatetime,
constraint PK_GIANGDAY primary key(MALOP,MAMH)
)
create table KETQUATHI
(
MAHV	char(5) foreign key references HOCVIEN(MAHV),
MAMH	varchar(10) foreign key references MONHOC(MAMH),
LANTHI	tinyint,
NGTHI	smalldatetime,
DIEM	numeric(4,2),
KQUA	varchar(10)
constraint PK_KETQUATHI primary key (MAHV,MAMH,LANTHI)
)
--Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU  varchar(50)
ALTER TABLE HOCVIEN ADD DIEMTB	tinyint
ALTER TABLE HOCVIEN ADD XEPLOAI	text


--2.	Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
alter table HOCVIEN ADD constraint CK_MAHV CHECK(Left(MAHV,3)=MALOP)


--3.	Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
alter table HOCVIEN add constraint CK_GIOITINH CHECK(GIOITINH in('Nam','Nu'))


--4.	Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
alter table KETQUATHI add constraint CK_DIEM check(DIEM>=0 and DIEM <=10) 
select ROUND(DIEM,2) from KETQUATHI


--5.	Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5.
alter table KETQUATHI add constraint CK_KQUA check((KQUA='Dat' and DIEM between 5 and 10) or(KQUA='Khong dat' and DIEM <5))


--6.	Học viên thi một môn tối đa 3 lần.
alter table KETQUATHI add constraint CK_LANTHI check(LANTHI<=3)


--7.	Học kỳ chỉ có giá trị từ 1 đến 3.
alter table GIANGDAY add constraint CK_HOCKY check(HOCKY in ('1','2','3'))


--8.	Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
alter table GIAOVIEN add constraint CK_HOCVI check(HOCVI in ('CN','KS','Ths','TS','PTS'))
