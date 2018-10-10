select * from dbo.BD_SMS
where phone = '12988629600;'

CREATE TABLE dbo.RECEBIMENTO (
VENCIMENTO NUMERIC (10), 
VALOR_PAGO FLOAT (15),
CI NUMERIC (10),
DATA_PROCE NUMERIC(10))


INSERT INTO dbo.RECEBIMENTO (
VENCIMENTO, 
VALOR_PAGO)
SELECT sql.VENCIMENTO, sql.VALOR_PAGO
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;Database=D:\Meus Documentos\sql.xlsx;HDR=Yes', 'Select * from [sql]')  AS sql
