'USE [master]
GO


EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO


EXEC sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO


USE [master]
GO
--ADICIONANDO OS DRIVERS NA INSTÂNCIA SQL
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0; Database=\\fscorp\Porto_Conecta\Indicadores Relacionamento\001_PLANEJAMENTO_PROCESSO\002_PLANEJAMENTO\001_COLLECTION\014_INADIMPLENCIA\2016\inadimplencia 23.10.XLSX; HDR=YES; IMEX=1',
'SELECT * FROM [Plan1$]') 
GO

select *
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=Database=\\fscorp\Porto_Conecta\Indicadores Relacionamento\001_PLANEJAMENTO_PROCESSO\002_PLANEJAMENTO\001_COLLECTION\014_INADIMPLENCIA\2016\inadimplencia 23.10.XLSX;', 
'SELECT * from [Dados$]') A

