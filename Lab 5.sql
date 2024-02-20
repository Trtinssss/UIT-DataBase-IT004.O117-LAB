--CSDL Quản lý bán hàng:
	--Phần I: Từ câu 11 đến câu 13.
-- I
--Câu 11
CREATE TRIGGER Trgg_NGHD
ON HOADON
for INSERT
AS
BEGIN
    DECLARE @MAKH VARCHAR(20), @NGHD DATE, @NGDK DATE;
    SELECT @MAKH = MAKH, @NGHD = NGHD FROM inserted;
    SELECT @NGDK = NGDK FROM KHACHHANG WHERE MAKH = @MAKH;
    IF (@NGHD >= @NGDK)
        PRINT N'Thành Công'
    ELSE
		PRINT (N'Ngày mua hàng phải lớn hơn hoặc bằng ngày đăng ký thành viên.')
        ROLLBACK TRAN
END;
GO
--Câu 12
CREATE TRIGGER Trgg_CheckNGHD
on HOADON
for insert,update
as
begin
	DECLARE @NGHD DATE, @NGVL DATE, @MANV varchar(20);
	select @MANV=MANV , @NGHD=NGHD from inserted;
	select @NGVL=@NGVL from HOADON WHERE @MANV=MANV
	if @NGVL>=@NGHD
	 print (N'Thêm mới một hóa đơn thành công.');
	ELSE
	 PRINT (N'Ngày mua hàng phải lớn hơn hoặc bằng ngày đăng ký thành viên')
	 rollback TRAN;
end;
go
--Câu 13
Create TRIGGER check_HOADON_CTHD
on HOADON
FOR insert
as
begin
	DECLARE @SOHD VARCHAR(20), @COUNT_SOHD INT
	SELECT @SOHD = SOHD from inserted;
	SELECT @COUNT_SOHD = COUNT (SOHD) FROM CTHD WHERE SOHD=@SOHD
	if (@COUNT_SOHD >= 1)
		PRINT N'Thêm mới một hóa đơn thành công.'
	ELSE
		PRINT N'Lỗi: Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.'
		ROLLBACK TRANSACTION

end;
go
--Câu 14
Create TRIGGER TRGG_HOADON_TRIGIA
on CTHD
for insert, DELETE
as
begin 
	DECLARE @SOHD varchar(20), @TONGTRIGIA int
	SELECT @TONGTRIGIA=SUM(SL*GIA), @SOHD=SOHD FROM inserted INNER JOIN SANPHAM
	ON INSERTED.MASP = SANPHAM.MASP
	GROUP BY SOHD
	update HOADON set TRIGIA = @TONGTRIGIA where @SOHD=SOHD;
end;
go
--Câu 15
CREATE TRIGGER TRGG_KH_DOANHSO
on HOADON
for insert,update
as
begin
		DECLARE @DOANHSO int, @MAKH varchar(20)
		select @MAKH=MAKH from inserted;
		select @DOANHSO=SUM(TRIGIA) from HOADON where MAKH=@MAKH;
		update KHACHHANG set DOANHSO= @DOANHSO where @MAKH=KHACHHANG.MAKH;
end;
go