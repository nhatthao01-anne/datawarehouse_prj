INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
SELECT
cst_id,
cst_key,
--hàm TRIM() để cắt bỏ các khoảng trắng thừa ở hai bên
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END cst_marital_status, ---> Normalize marital status values to readable format
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr, ---> Normalize gender values to readable format
cst_create_date
FROM (
--sub query
--CHECK FOR DUPLICATION AND NULL VALUESS
SELECT
*,
--ROW NUMBER là hàm để đánh số thứ tự
--Partition by: yêu cầu sql gom nhóm mã khách hàng 
--ORDER BY cst_create_date DESC -> sắp xếp từ lớn tới nhỏ theo ngày tạo
--gọi cột đánh số này là flag_last
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC ) as flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t -- bảng tạm t
WHERE flag_last =1

