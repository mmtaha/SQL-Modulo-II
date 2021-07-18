USE PEDIDOS

EXEC SP_HELPINDEX TB_EMPREGADO


--Criando um �ndice para o campo NOME:

CREATE INDEX IX_TB_EMPREGADO_NOME ON TB_EMPREGADO (NOME)


--Criando um �ndice para o campo DATA_NASCIMENTO:

CREATE INDEX IX_TB_EMPREGADO_DATA_NASCIMENTO ON TB_EMPREGADO (DATA_NASCIMENTO)

--Na tabela de fornecedores existe apenas o �ndice clusterizado da tabela TB_FORNECEDOR

EXEC SP_HELPINDEX TB_FORNECEDOR

--A cria��o de um �ndice composto pelas colunas: ESTADO e CIDADE

CREATE INDEX IX_TB_FORNECEDOR_ESTADO_CIDADE ON TB_FORNECEDOR (ESTADO, CIDADE)


--Uma consulta que � realizada diversas vezes com os campos: C�digo do Cliente, Nome e Estado.  

SELECT CODCLI, NOME, ESTADO FROM TB_CLIENTE


CREATE INDEX IX_CLIENTE_INCLUDE ON TB_CLIENTE (NOME) INCLUDE (ESTADO)


DROP INDEX TB_CLIENTE.IX_CLIENTE_INCLUDE


SELECT * FROM TB_CLIENTE WHERE ESTADO='SP'


EXEC SP_HELPINDEX TB_CLIENTE


SELECT * FROM TB_CLIENTE WITH (INDEX = IX__CLIENTES_ESTADO) WHERE ESTADO='SP'

UPDATE TB_CLIENTE WITH (ROWLOCK) SET ESTADO = ESTADO

UPDATE TB_CLIENTE WITH (PAGLOCK) SET ESTADO = ESTADO

UPDATE TB_CLIENTE WITH (TABLOCK) SET ESTADO = ESTADO

UPDATE TB_CLIENTE WITH (UPDLOCK) SET ESTADO = ESTADO

UPDATE TB_CLIENTE WITH (TABLOCKX) SET ESTADO = ESTADO

SELECT * FROM TB_CLIENTE WITH (NOLOCK)

SELECT * FROM TB_CLIENTE WITH (READPAST)

--Consulta sem HINT que utiliza o paralelismo padr�o do Servidor

SELECT * 
FROM TB_ITENSPEDIDO  AS P
WHERE NUM_PEDIDO IN (SELECT NUM_PEDIDO FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) =2014)
ORDER BY 1,2

--Consulta com HINT que define que ser� utilizado somente 1 processador para a consulta

SELECT * 
FROM TB_ITENSPEDIDO  AS P
WHERE NUM_PEDIDO IN (SELECT NUM_PEDIDO FROM TB_PEDIDO WHERE YEAR(DATA_EMISSAO) =2014)
ORDER BY 1,2
OPTION (MAXDOP 1)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

