select * from dbo.ARRECADACAO

ALTER TABLE dbo.ARRECADACAO ADD FOTO NUMERIC(20) ; 

UPDATE dbo.ARRECADACAO
SET FOTO = DAY


   INSERT INTO dbo.ARRECADACAO (FOTO, DATA) VALUES (1, '2012-05-28')
 