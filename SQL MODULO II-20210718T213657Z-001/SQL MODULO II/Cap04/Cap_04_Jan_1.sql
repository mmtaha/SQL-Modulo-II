-- EXEMPLO 3 ---------------------------------------------------------------------------
BEGIN TRAN
--ROWLOCK --> TRAVA LINHAS
UPDATE TB_PEDIDO WITH (ROWLOCK) -- WITH (ROWLOCK) � default
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
-- Descartar altera��es
--ROLLBACK

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

UPDATE TB_PEDIDO WITH (TABLOCK) 
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

--Alternar para a janela 2...
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
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO
--
ROLLBACK
-- Finalize a transa��o da outra janela

-- EXEMPLO 7 ---------------------------------------------------------------------------
-- Configurar o banco para aceitar o pr�ximo tipo de
-- isolamento de transa��o
ALTER DATABASE PEDIDO
SET ALLOW_SNAPSHOT_ISOLATION ON
-- Este tipo de isolamento impedide que a trans��o atual
-- enxergue as transa��es "comitadas" por outros usu�rios
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
--
BEGIN TRAN
--
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES
-- V� at� a outra janela e execute o exemplo 6
--
-- Execute o SELECT e note que, apesar das altera��es j� terem
-- sido "comitadas" n�s continuamos enxergando os mesmos dados
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES
-- Finalizar a transa��o
ROLLBACK
-- Voltamos ao mundo real
-- Somente ap�s o t�rmino desta transa��o � que conseguimos
-- enxergar as altera��es do outro processo de transa��o
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES

-- EXEMPLO 8 ---------------------------------------------------------------------------
-- Impede que outros usu�rios alterem dados das tabelas
-- que este processo est� utilizando
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--
BEGIN TRAN
-- Execute este SELECT e depois v� para outra janela
SELECT * FROM TB_PRODUTO

SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- Na outra janela, tente executar um update em produtos

SELECT * FROM TB_EMPREGADO


ROLLBACK
--
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


