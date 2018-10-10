USE PORTOCONECTA_MSCRM
GO
SELECT 
	inc.new_protocoloidName as "Protocolo"
	,inc.new_numerosolicitacao as "Número do Registro"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,inc.CreatedOn),103)+ ' ' + CONVERT(VARCHAR(5),dateadd(hh,-3,inc.CreatedOn),108) as "Data de Criação"
	,case(inc.casetypecode)
		when 1 then 'Informação'
		when 99 then 'Não Identificado'
		when 3 then 'Reclamação'
		when 2 then 'Solicitação'
		when 4 then 'Tratamento' end as "Classificação"
	,case(inc.new_sac) 
		when 0 then 'Não'
		when 1 then 'Sim'
	end as "SAC On Line"
	,inc.new_assuntoidName as "Assunto"
	,inc.new_MotivoIdName as "Motivo"
	,inc.new_SubMotivoIdName as "Detalhe"
	,sm2.Value as "Status de atendimento"
	,ac.Name as "Cliente"
	,inc.new_LinhaTelefonicaIdName as "Número conecta / Contrato"
	,sm.value as "Canal de Atendimento"
	,inc.new_solucao as "Solução"
	,case(nl.new_ativacaoautomatica)
		when 0 then 'Não'
		end as "Ativação Automática (Número conecta / Contrato)"
	,nl.new_transferencia_canalderecebimento as "Canal de recebimento (Número conecta / Contrato)"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,nl.new_DataAtivacao),103) as "Data de Ativação (Número conecta / Contrato)"
	,CONVERT(VARCHAR(10),dateadd(hh,-3,nl.new_DataAtivacaoPlano),103) as "Data de Ativação do Plano (Número conecta / Contrato)"
	,nl.new_DiaVencimento as "Dia de Vencimento (Número conecta / Contrato)"
	,nl.new_planoidName as "(Número conecta / Contrato)"
	,inc.OwnerIdName as"Atendente"
	,nl.new_forma_pagamento_atual as "Forma de pagamento atual (Número conecta / Contrato)"
	,inc.new_Observacao as "Observação"
	,sm3.Value as "Tipo (Cliente)"
	,case(ac.accountclassificationcode)
		when 100000001 then 'Pessoa Física'
		when 100000000 then 'Pessoa Jurídica'
			end as "Tipo do Cliente (Cliente)"
	,ac.new_cnpj_cpf as "CPF/CNPJ(Cliente)"
	,na.new_codigodoassunto as "Código do Assunto"
	,nm.new_codigomotivo as "Código do Motivo"
	,nd.new_codigosubmotivo as "Código do Detalhe"
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
