SELECT * FROM BD_SCORE
DROP TABLE BD_INADIMPLENCIA

CREATE TABLE BD_INADIMPLENCIA
(CPF numeric(30,10),
VENCIMENTO varchar(255),
ANO integer,
MES integer,
DIA integer,
STATUS_CONTRATO varchar(255),
FATURA integer,
VALOR_ABERTO numeric(30,10),
TEMPO_EM_ATRASO integer,
NOME varchar(255),
CONTRATO integer,
MOTIVO_SUSPENSAO varchar(255),
DDI varchar(255),
DDD varchar(255),
FONE varchar(255),
PHONE_CONECTA varchar(255),
ENDERECO varchar(255),
COMPLEMENTO varchar(255),
BAIRRO_CIDADE varchar(255),
BAIRRO varchar(255),
CEP integer,
CIDADE varchar(255),
UF varchar(255),
EMAIL varchar(255),
PORTADO varchar(255),
TIPO_CLIENTE varchar(255),
TIPO_PAGAMENTO varchar(255),
PLANO varchar(255),
SUSP_P varchar(255),
SUSP_T varchar(255),
MES_PDD varchar(255),
MES_CHURN varchar(255),
NOME_ARQUIVO varchar(255),
ITERATION integer,
FAIXA_ATRASO varchar (20),
FOTO varchar (20),)


ALTER TABLE BD_INADIMPLENCIA ALTER COLUMN VALOR_ABERTO money;


SELECT COUNT(NOME_ARQUIVO) AS NOME_ARQUIVO FROM BD_INADIMPLENCIA
GROUP BY NOME_ARQUIVO

DELETE FROM BD_INADIMPLENCIA
204359
287685

ALTER TABLE BD_INADIMPLENCIA ADD FOTO date


SELECT TOP 1 DATA ,CPF, CREDIT_BUREAU, FAIXA_SCORE, FAIXA_COLLECTION , GETDate() AS DT_ATUAL
FROM BD_SCORE


SELECT DISTINCT(TQ.[COD_VENDEDOR]), TQ.[VAL_META], TQ.[DAT_ATIVACAO]
            FROM 
                [dbo].[TB_META] TQ
            WHERE 
                TQ.DAT_ATIVACAO = (SELECT MAX(DAT_ATIVACAO) 
                                   FROM TB_META 
                                   WHERE COD_VENDEDOR = TQ.COD_VENDEDOR 
                                   GROUP BY COD_VENDEDOR)


SELECT DISTINCT TQ.DATA, TQ.CPF, TQ.CREDIT_BUREAU, TQ.FAIXA_SCORE, TQ.FAIXA_COLLECTION
            FROM 
                BD_SCORE TQ
            WHERE 
                TQ.DATA = (SELECT MAX(DATA) 
                                   FROM BD_SCORE 
                                   WHERE CPF = TQ.CPF 
                                   GROUP BY CPF)
                                    ORDER BY DATA DESC
                                    
CREATE TABLE BD_SCORE
(DATA DATE,
CPF VARCHAR(18),
[CREDIT BUREAU] INT,
FAIXA_SCORE VARCHAR(10),
FAIXA_COLLECTION VARCHAR(10)

SELECT * FROM BD_INADIMPLENCIA
WHERE FOTO = '2017-01-30'
AND MES_PDD ='PDD - FEV/17'   

SELECT * FROM BD_INADIMPLENCIA 
WHERE MES_PDD ='PDD - FEV/17' 

--GROUP BY VENCIMENTO ORDER BY VENCIMENTO ASC 

SELECT * FROM BD_INADIMPLENCIA




                                                