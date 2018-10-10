CREATE TABLE BD_SMS
(PHONE VARCHAR (15))

bulk insert FATURA FROM 'D:\Meus Documentos\default (1).csv' WITH (fieldterminator = '\,' )

bulk insert RA_ATENDIMENTO FROM 'D:\Meus Documentos\TB_RA.txt' WITH (  FIRSTROW = 2, fieldterminator = '\;' )

BULK INSERT FATURA FROM 'D:\Meus Documentos\default (1).csv'
WITH
(   FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK)

BULK INSERT FATURA
    FROM 'D:\Meus Documentos\default (1).csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    ERRORFILE = 'D:\Meus Documentos\FATURAErrorRows.csv',
    TABLOCK
    )

select TOP 2000 * FROM BD_SMS   

Drop table RA_ATENDIMENTO


select Z62.* from Z62010 Z62, Z61010 Z61, SE1010 SE1 
  where Z62.D_E_L_E_T_ = ' ' and Z62_FLGPRC in( 'I','E') and Z62_QTDPRC < 5
  and Z61.D_E_L_E_T_ = ' ' and Z61_EVENTO = Z62_EVENTO and Z61_REGUA = Z62_REGUA and Z61_TIPO = '3'
  and SE1.D_E_L_E_T_ = ' ' and SE1.E1_PREFIXO||E1_NUM = Z62.Z62_FATURA and E1_BAIXA = ' '


 CREATE TABLE RA_ATENDIMENTO	
(CLASSIFICAÇÃO            VARCHAR(300),
SAC_ON_LINE               VARCHAR(300),
ASSUNTO                   VARCHAR(300),
MOTIVO                    VARCHAR(300),
DETALHE                   VARCHAR(300),
STATUS_DE_ATENDIMENTO     VARCHAR(300),
CLIENTE                   VARCHAR(300),
NÚMERO_CONECT_CONTRA      VARCHAR(300),
DATA_FOLLOW_UP            VARCHAR(300),
FILA_DE_ATENDIMENTO       VARCHAR(300),
SLA_TÉRMINO_DO_PRAZO      VARCHAR(300),
CANAL_DE_ATENDIMENTO      VARCHAR(300),
SOLUÇÃO                   VARCHAR(300),
ATIVAÇÃO_AUTOMÁTICA       VARCHAR(300),
CANAL_DE_RECEBIMENTO      VARCHAR(300), 
DATA_DE_ATIVAÇÃO          VARCHAR(300),
DATA_DE_ATIVAÇÃO_DO_PLANO VARCHAR(300),
DIA_DE_VENCIMENTO         VARCHAR(300),
PLANO                     VARCHAR(300),
ATENDENTE                 VARCHAR(300),
FORMA_DE_PAGAMENTO_ATUAL  VARCHAR(300),)


select * from RA_ATENDIMENTO
where SAC_ON_LINE = '' and ASSUNTO <> 42614


CREATE TABLE FATURA (
FATURA  VARCHAR (60),
CLIENTE VARCHAR (60),
DATA_VENCIMENTO VARCHAR (60),
DATA_BAIXA_PAGAMENTO VARCHAR (60),
VALOR_FATURADO VARCHAR (60),
VALOR_ARRECADADO VARCHAR (60),
VALOR_COBRADO VARCHAR (60),)

SELECT *FROM RA_ATENDIMENTO

DROP TABLE RA_ATENDIMENTO

SELECT * FROM RA_ATENDIMENTO
WHERE CLASSIFICAÇÃO = 'PROTOCOLO'

DELETE from RA_ATENDIMENTO  WHERE CLASSIFICAÇÃO = 'PROTOCOLO'








