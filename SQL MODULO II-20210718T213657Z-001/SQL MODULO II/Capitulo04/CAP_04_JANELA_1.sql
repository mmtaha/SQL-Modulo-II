/*
    TIPOS DE BLOQUEIO
    -----------------
    
		SHARED (S): 
			.� aplicado quando uma transa��o l� dados do banco de dados.
			.V�rias transa��es podem aplicar shared lock em um mesmo recurso.
		UPDATE (U):
			.Aplicado quando lemos dados que iremos alterar
			.Duas transa��es N�O PODEM colocar update lock em um mesmo recurso
			.No momento em que os dados s�o lidos por um comando UPDATE, por exemplo
			 os registros recebem um UPDATE LOCK.
			.Logo em seguida o UPDATE LOCK � promovido a EXCLUSIVE LOCK     
		EXCLUSIVE (X):
			.O bloqueio exclusivo garante que somente uma transa��o tem acesso ao registro   
			.N�o � compat�vel com outros tipos de bloqueio.
		INTENT (IS, IU, IX): 
			.Marca um determinado recurso sinalizando que nele existem bloqueios.  
        SCHEMA (Sch-M, Sch-S): 
            .Controla atualiza��es de estrutura das tabelas. 
            .Evitam que uma tabela que est� sendo utilizada em produ��o seja alterada 
            (Schema Modification Locks ou Sch-M), ou que algum processo acesse uma tabela 
             cuja estrutura est� em modifica��o (Schema Stability Locks ou Sch-S).
        Key-Range:
            .Bloqueia uma faixa de registros quando usamos n�vel de isolamento SERIALIZABLE 
			  
    
    GRANULARIDADE (recursos)
    ------------------------

         
         Linha (ROW): Uma linha de uma tabela
             RID (Row ID): Identificador de linha de tabela quando esta n�o possui chave prim�ria
             KEY         : Linha da tabela associada ao �ndice chave prim�ria
         P�gina(PAGE): Um bloco de dados contendo 8K
         Bloco de p�ginas (EXTENT): Bloco cont�guo de 8 p�ginas.
         Tabela (TABLE): Uma tabela do banco de dados. 
    
*/

--=====================================================
-- CONCORR�NCIA - JANELA 1
--=====================================================
USE PEDIDOS

-- EXEMPLO 1 ---------------------------------------------------------------------
-- A tabela PRODUTOS_TMP n�o possui chave prim�ria ou nenhum
-- outro �ndice clisterizado
SELECT * INTO PRODUTOS_TMP FROM PRODUTOS
-- Abrir transa��o
BEGIN TRAN
-- Executar update
UPDATE PRODUTOS_TMP SET PRECO_VENDA = 5
WHERE COD_TIPO = 1

-- Consultar bloqueios
-- Observe a coluna RESOURCE_TYPE e veja que o bloquio ocorreu atraves
-- do Row ID das linhas da tabela
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID
                         
-- V� at� a janela 2 e execute o comando correspondente ao EXEMPLO 1...
--
-- Descartar altera��es
ROLLBACK
SELECT *
FROM PRODUTOS_TMP 
ORDER BY COD_TIPO
-- EXEMPLO 2 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PRODUTOS SET PRECO_VENDA = 5
WHERE COD_TIPO = 1
ROLLBACK
-- Observe a coluna RESOURCE_TYPE. Como a tabela possui chave prim�ria
-- o bloqueio ocorreu atraves da chave prim�ria
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID
ORDER BY 2

-- Depois de executar o UPDATE v� para a janela 2 e execute o comando referente
-- ao exemplo 2...
--
-- Descartar altera��es
ROLLBACK

-- EXEMPLO 3 ---------------------------------------------------------------------------
BEGIN TRAN
--ROWLOCK --> TRAVA LINHAS
UPDATE PEDIDOS WITH (ROWLOCK) -- WITH (ROWLOCK) � default
SET SITUACAO = 'E' WHERE NUM_PEDIDO < 1000
--BLOQUEAR PEDIDO <1000
-- Observe o recurso bloqueado (KEY): Bloqueio de linha atraves da chave prim�ria
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- v� at� a janela 2 e exeute o EXEMPLO 3...
--
-- Descartar altera��es
ROLLBACK

-- EXEMPLO 4 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PEDIDOS WITH (PAGLOCK) 
SET SITUACAO = 'X' WHERE NUM_PEDIDO < 1000

-- Observe o recurso bloqueado (PAGE): 
-- BOM  -> Menor n�mero de bloqueios, menos processamento, menor quantidade de mem�ria utilizada
-- RUIM -> Menor concorr�ncia. S�o bloqueados mais registros do que o necess�rio
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- V� at� a janela 2...
--
-- Descartar as altera��es
ROLLBACK


-- EXEMPLO 5 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PEDIDOS WITH (TABLOCK) 
SET SITUACAO = 'X' WHERE NUM_PEDIDO < 1000

-- Observe o recurso bloqueado o o nome do objeto (OBJECT, PEDIDOS): 
-- BOM  -> Menor n�mero de bloqueios, menos processamento, menor quantidade de mem�ria utilizada
-- RUIM -> Menor concorr�ncia. S�o bloqueados mais registros do que o necess�rio
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L 
     JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
     LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
     LEFT JOIN SYS.PARTITIONS P 
                   ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
     LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- Descartar altera��es
ROLLBACK

--------------------------------------------------------
-- N�veis de isolamento entre os processos de transa��o
--------------------------------------------------------
-- O n�vel padr�o � READ COMMITTED 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- EXEMPLO 6 ---------------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRAN
-- V� at� a outra janela e inicie processo de transa��o
-- e fa�a update em produtos.
--
-- Depois volte para c� e execute este SELECT
-- Vai funcionar porque configuramos "Dirty-read" como padr�o
-- Estamos consultando dados n�o confirmados
SELECT * FROM PRODUTOS ORDER BY COD_TIPO
--
ROLLBACK
-- Finalize a transa��o da outra janela

-- EXEMPLO 7 ---------------------------------------------------------------------------
-- Configurar o banco para aceitar o pr�ximo tipo de
-- isolamento de transa��o
ALTER DATABASE PEDIDOS
SET ALLOW_SNAPSHOT_ISOLATION ON
-- Este tipo de isolamento impedide que a trans��o atual
-- enxergue as transa��es "comitadas" por outros usu�rios
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
--
BEGIN TRAN
--
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES
-- V� at� a outra janela e execute o exemplo 6
--
-- Execute o SELECT e note que, apesar das altera��es j� terem
-- sido "comitadas" n�s continuamos enxergando os mesmos dados
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES
-- Finalizar a transa��o
ROLLBACK
-- Voltamos ao mundo real
-- Somente ap�s o t�rmino desta transa��o � que conseguimos
-- enxergar as altera��es do outro processo de transa��o
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES

-- EXEMPLO 8 ---------------------------------------------------------------------------
-- Impede que outros usu�rios alterem dados das tabelas
-- que este processo est� utilizando
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--
BEGIN TRAN
-- Execute este SELECT e depois v� para outra janela
SELECT * FROM PRODUTOS

SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- Na outra janela, tente executar um update em produtos

SELECT * FROM EMPREGADOS 


ROLLBACK
--
SET TRANSACTION ISOLATION LEVEL READ COMMITTED



