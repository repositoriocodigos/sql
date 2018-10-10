INSERT INTO dbo.RECEBIMENTO (
VENCIMENTO, 
VALOR_PAGO)
SELECT sql.VENCIMENTO, sql.VALOR_PAGO
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;Database=D:\Meus Documentos\sql.xlsx;HDR=Yes', 'Select * from [sql]')  AS sql

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO