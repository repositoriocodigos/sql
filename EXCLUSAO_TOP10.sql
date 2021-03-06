DELETE  FROM [BD_COBRANCA].[dbo].[TB_CANAL_AGRUPADO]
WHERE ANO_MES = '201808'

DELETE FROM [BD_COBRANCA].[dbo].[TB_MOTIVO_AGRUPADO]
WHERE ANO_MES = '201808'

DELETE  FROM [BD_COBRANCA].[dbo].[TB_LOG_TOP10]
WHERE NOME_ARQUIVO IN ('Consulta_Ativacao_CRM_20180804','Consulta_Ativacao_CRM_20180805',
'Consulta_Ativacao_CRM_20180806','Consulta_Ativacao_CRM_20180807',
'Consulta_Ativacao_CRM_20180808','Consulta_Ativacao_CRM_20180809',
'Consulta_Ativacao_CRM_20180810','Consulta_Ativacao_CRM_20180811',
'Consulta_Ativacao_CRM_20180812','Consulta_Ativacao_CRM_20180813',
'Consulta_Ativacao_CRM_20180814','Consulta_Ativacao_CRM_20180815',
'Consulta_Ativacao_CRM_20180816','Consulta_Ativacao_CRM_20180817',
'Consulta_Ativacao_CRM_20180818','Consulta_Ativacao_CRM_20180819',
'Consulta_Ativacao_CRM_20180820','Consulta_Ativacao_CRM_20180821',
'Consulta_Ativacao_CRM_20180822','Consulta_Ativacao_CRM_20180823',
'Consulta_Ativacao_CRM_20180824','Consulta_Ativacao_CRM_20180825',
'Consulta_Ativacao_CRM_20180826','Consulta_Ativacao_CRM_20180827',
'Consulta_Ativacao_CRM_20180828','Consulta_Ativacao_CRM_20180829',
'Consulta_Ativacao_CRM_20180830','Consulta_Ativacao_CRM_20180831')

DELETE  FROM [BD_COBRANCA].[dbo].[TB_TOP10]
WHERE NOME_ARQUIVO IN ('Consulta_Ativacao_CRM_20180804','Consulta_Ativacao_CRM_20180805',
'Consulta_Ativacao_CRM_20180806','Consulta_Ativacao_CRM_20180807',
'Consulta_Ativacao_CRM_20180808','Consulta_Ativacao_CRM_20180809',
'Consulta_Ativacao_CRM_20180810','Consulta_Ativacao_CRM_20180811',
'Consulta_Ativacao_CRM_20180812','Consulta_Ativacao_CRM_20180813',
'Consulta_Ativacao_CRM_20180814','Consulta_Ativacao_CRM_20180815',
'Consulta_Ativacao_CRM_20180816','Consulta_Ativacao_CRM_20180817',
'Consulta_Ativacao_CRM_20180818','Consulta_Ativacao_CRM_20180819',
'Consulta_Ativacao_CRM_20180820','Consulta_Ativacao_CRM_20180821',
'Consulta_Ativacao_CRM_20180822','Consulta_Ativacao_CRM_20180823',
'Consulta_Ativacao_CRM_20180824','Consulta_Ativacao_CRM_20180825',
'Consulta_Ativacao_CRM_20180826','Consulta_Ativacao_CRM_20180827',
'Consulta_Ativacao_CRM_20180828','Consulta_Ativacao_CRM_20180829',
'Consulta_Ativacao_CRM_20180830','Consulta_Ativacao_CRM_20180831')