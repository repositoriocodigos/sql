USE PORTOCONECTA_MSCRM
GO
SELECT 
	inc.new_protocoloidName as "Protocolo"
	,inc.new_numerosolicitacao as "N�mero do Registro"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,inc.CreatedOn),103)+ ' ' + CONVERT(VARCHAR(5),dateadd(hh,-3,inc.CreatedOn),108) as "Data de Cria��o"
	,case(inc.casetypecode)
		when 1 then 'Informa��o'
		when 99 then 'N�o Identificado'
		when 3 then 'Reclama��o'
		when 2 then 'Solicita��o'
		when 4 then 'Tratamento' end as "Classifica��o"
	,case(inc.new_sac) 
		when 0 then 'N�o'
		when 1 then 'Sim'
	end as "SAC On Line"
	,inc.new_assuntoidName as "Assunto"
	,inc.new_MotivoIdName as "Motivo"
	,inc.new_SubMotivoIdName as "Detalhe"
	,sm2.Value as "Status de atendimento"
	,ac.Name as "Cliente"
	,inc.new_LinhaTelefonicaIdName as "N�mero conecta / Contrato"
	,sm.value as "Canal de Atendimento"
	,inc.new_solucao as "Solu��o"
	,case(nl.new_ativacaoautomatica)
		when 0 then 'N�o'
		end as "Ativa��o Autom�tica (N�mero conecta / Contrato)"
	,nl.new_transferencia_canalderecebimento as "Canal de recebimento (N�mero conecta / Contrato)"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,nl.new_DataAtivacao),103) as "Data de Ativa��o (N�mero conecta / Contrato)"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,nl.new_DataAtivacaoPlano),103) as "Data de Ativa��o do Plano (N�mero conecta / Contrato)"
	,nl.new_DiaVencimento as "Dia de Vencimento (N�mero conecta / Contrato)"
	,nl.new_planoidName as "(N�mero conecta / Contrato)"
	,inc.OwnerIdName as"Atendente"
	,nl.new_forma_pagamento_atual as "Forma de pagamento atual (N�mero conecta / Contrato)"
	,inc.new_Observacao as "Observa��o"
	,sm3.Value as "Tipo (Cliente)"
	,case(ac.accountclassificationcode)
		when 100000001 then 'Pessoa F�sica'
		when 100000000 then 'Pessoa Jur�dica'
			end as "Tipo do Cliente (Cliente)"
	,ac.new_cnpj_cpf as "CPF/CNPJ(Cliente)"
	,na.new_codigodoassunto as "C�digo do Assunto"
	,nm.new_codigomotivo as "C�digo do Motivo"
	,nd.new_codigosubmotivo as "C�digo do Detalhe"
from
	Incident inc with (nolock)
left join
	Account ac with (nolock)
on
	inc.AccountId = ac.AccountId
left join
	StringMap sm
on
	inc.new_CanalAtendimento = sm.AttributeValue and AttributeName = 'new_canalatendimento'
left join
	StringMap sm2
on
	sm2.AttributeValue = inc.StatusCode and sm2.ObjectTypeCode = 112 and sm2.AttributeName = 'statuscode'
left join
	StringMap sm3
on
	sm3.AttributeValue = ac.new_tipo and sm3.ObjectTypeCode = 2 and sm3.AttributeName = 'new_tipo'
left join
	new_linhatelefonica nl with (nolock)
on
	inc.new_linhatelefonicaid = nl.new_linhatelefonicaid
left join
	new_assunto na with (nolock)
on
	na.new_assuntoid = inc.new_assuntoid
left join
	new_motivo nm with (nolock)
on
	nm.new_motivoid = inc.new_motivoid
left join
	new_submotivo nd with (nolock)
on
	nd.new_submotivoid = inc.new_submotivoid
where 
	dateadd(hh,-3,inc.CreatedOn) >= CAST(DATEADD(hh,-3,GETDATE()-1) AS DATE)
AND
	dateadd(hh,-3,inc.CreatedOn) < CAST(DATEADD(hh,-3,GETDATE()) AS DATE)
order by
	inc.CreatedOn desc
