--Laborat�rio 1

--Laborat�rio A - �ndices

--1.	Coloque o banco PEDIDOS em uso;
USE PEDIDOS

--2.	Verifique se a tabela TB_CLIENTE possui �ndices;
EXEC SP_HELPINDEX TB_CLIENTE

--3.	Crie os �ndices para a tabela TB_CLIENTE, campos:
--- Nome
CREATE INDEX IX_TB_CLIENTE_NOME ON TB_CLIENTE(NOME)

--- Fantasia
CREATE INDEX IX_TB_CLIENTE_FANTASIA ON TB_CLIENTE(FANTASIA)

--- Estado e Cidade
CREATE INDEX IX_TB_CLIENTE_ESTADO_CIDADE ON TB_CLIENTE(ESTADO, CIDADE)

--- Nome, e inclua os campos: Estado e Cidade
CREATE INDEX IX_TB_CLIENTE_NOME_INCLUDE ON TB_CLIENTE(NOME) INCLUDE (ESTADO, CIDADE)

--4.	Crie os �ndices para a tabela TB_Pedido, campos:
--- Data_emissao
CREATE INDEX IX_TB_Pedido_DATA_EMISSAO ON TB_PEDIDO (DATA_EMISSAO) 

--- CODCLI
CREATE INDEX IX_TB_Pedido_CODCLI ON TB_PEDIDO (CODCLI)

--- CODVEN
CREATE INDEX IX_TB_Pedido_CODVEN ON TB_PEDIDO (CODVEN)



--Laborat�rio B � Customizando consultas

--1.	Execute uma consulta que apresente os clientes. Utilize um HINT que force a utiliza��o de um �ndice criado no laborat�rio anterior;
SELECT CODCLI,NOME FROM TB_CLIENTE WITH (INDEX = IX_TB_CLIENTE_NOME)

--2.	Execute o comando:

--BEGIN TRAN
BEGIN TRAN
--UPDATE TB_PRODUTO SET PRECO_VENDA *=PRECO_VENDA *1.2
--WHERE COD_TIPO=3;

UPDATE TB_PRODUTO SET PRECO_VENDA *=PRECO_VENDA *1.2
WHERE COD_TIPO=3;

--3.	Abra uma nova consulta;

--4.	Execute o comando:

--SET LOCK_TIMEOUT 5000 
SET LOCK_TIMEOUT 5000 

--5.	Fa�a uma consulta apresentando todos os produtos;
SELECT * FROM TB_PRODUTO

--6.	Execute a mesma consulta com um HINT que permita a leitura de dados n�o confirmados;
SELECT * FROM TB_PRODUTO WITH (NOLOCK)

--7.	Apresente os produtos que n�o est�o bloqueados;
SELECT * FROM TB_PRODUTO WITH (READPAST)

--8.	Abra uma nova consulta;

--9.	Customize a se��o para leitura de dados n�o confirmados;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--10.	Sem a utiliza��o de um HINT, realize uma consulta dos produtos;
SELECT * FROM TB_PRODUTO
--11.	 Volte para a primeira consulta e efetue o ROLLBACK da transa��o;
ROLLBACK


