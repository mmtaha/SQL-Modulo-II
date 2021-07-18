-- Lab. 1
-- A - Acessando bancos de dados via OLE DB

-- 1. Execute os comandos abaixo para habilitar consultas distribu�das:
-- Habilitar a visibilidade das op��es avan�adas
EXEC sp_configure 'show advanced option', '1';

reconfigure

-- Habilitar a utiliza��o de OPENROWSET

EXEC sp_configure 'Ad Hoc Distributed Queries',1

reconfigure

--B - Consultas distribu�das

--1. Fa�a uma consulta na tabela Produtos do banco ACCESS (Pedidos.accdb) que esta na pasta C:\Dados.
SELECT *
   FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
      'C:\Dados\Pedidos.accdb';
      'admin';'',PRODUTOS) P
  

--2. Utilizando o OPENROWSET, realize um consulta na tabela CLIENTES.
SELECT *
   FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
      'C:\Dados\Pedidos.accdb';
      'admin';'',CLIENTES) C

/*3. Ainda utilizando o OPENROWSET, realize uma consulta na tabela CLIENTES do banco PEDIDOS.ACCDB e 
relacione com a tabela PEDIDOS do banco PEDIDOS. Apresente as informa��es: Num_pedido, Nome, VLR_TOTAL, DATA_EMISSAO, dos pedidos de Janeiro de 2014.*/

SELECT Num_pedido, Nome, VLR_TOTAL, DATA_EMISSAO
   FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
      'C:\Dados\Pedidos.accdb';
      'admin';'',CLIENTES) C
join PEDIDOS.DBO.TB_PEDIDO as P on P.CODCLI = C.codcli
WHERE YEAR(P.DATA_EMISSAO) = 2014 and MONTH(DATA_EMISSAO)=1

--C - Trabalhando com BULK INSERT

--1.	Crie a tabela TESTE_BULK_INSERT

CREATE TABLE TESTE_BULK_INSERT
( CODIGO			INT, 
  NOME			VARCHAR(40),
  DATA_NASCIMENTO 	DATETIME )

--2.	Atrav�s do comando BULK INSERT, fa�a a carga na tabela TESTE_BULK_INSERT com o arquivo BULK_INSERT.txt

BULK INSERT TESTE_BULK_INSERT
   FROM 'C:\DADOS\BULK_INSERT.txt'
   WITH
     (
        FIELDTERMINATOR =';',
        ROWTERMINATOR = '\n',
        codepage = 'acp' 
      )
	  
--3.	Fa�a uma consulta na tabela TESTE_BULK_INSERT e verifique se as informa��es foram carregadas.

SELECT * FROM  TESTE_BULK_INSERT

--Laborat�rio 2

--A � Trabalhando com XML

-- 1. Coloque o Banco PEDIDOS em uso.
USE PEDIDOS

-- 2. Realize uma consulta, apresentando as informa��es: N�mero de pedido, Nome do Cliente, Nome do Vendedor,
-- Data de emiss�o e Valor Total, dos pedidos de Janeiro de 2014 e ordenado pelo n�mero de pedido.
SELECT	p.NUM_PEDIDO , C.NOME AS CLIENTE , V.NOME AS VENDEDOR , P.DATA_EMISSAO, P.VLR_TOTAL
FROM	PEDIDOS		AS P
JOIN	CLIENTES	AS C ON C.CODCLI  = P.CODCLI
JOIN	VENDEDORES	AS V ON V.CODVEN = P.CODVEN 
WHERE YEAR(P.DATA_EMISSAO) = 2014 and MONTH(DATA_EMISSAO)=1
ORDER BY p.NUM_PEDIDO

-- 3. Execute a consulta anterior, exportando para XML conforme modelo a seguir:
SELECT	p.NUM_PEDIDO , C.NOME AS CLIENTE , V.NOME AS VENDEDOR , P.DATA_EMISSAO, P.VLR_TOTAL
FROM	PEDIDOS		AS P
JOIN	CLIENTES	AS C ON C.CODCLI  = P.CODCLI
JOIN	VENDEDORES	AS V ON V.CODVEN = P.CODVEN 
WHERE YEAR(P.DATA_EMISSAO) = 2014 and MONTH(DATA_EMISSAO)=1
ORDER BY p.NUM_PEDIDO
FOR XML RAW 

--Laborat�rio 3

--A � Trabalhando com JSON

--1.	Fa�a uma consulta apresentando o c�digo e nome dos CLIENTES.
SELECT CODCLI, NOME FROM TB_CLIENTE

--2.	Utilizando a consulta anterior execute uma sa�da com JSON.
SELECT CODCLI, NOME FROM TB_CLIENTE FOR JSON AUTO

--3.	Gere um arquivo no padr�o JSON para a consulta do item 1.

DECLARE @CMD VARCHAR(4000)

SET @CMD = 
'BCP "SELECT CODCLI, NOME FROM TB_CLIENTE FOR JSON AUTO" ' + 
' QUERYOUT "C:\DADOS\SAIDAJSON.XML" -SINSTRUTOR -t -w -t -T'

EXEC MASTER..XP_CMDSHELL  @CMD

