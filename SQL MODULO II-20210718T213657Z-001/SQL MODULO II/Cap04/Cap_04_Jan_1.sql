-- EXEMPLO 3 ---------------------------------------------------------------------------
BEGIN TRAN
--ROWLOCK --> TRAVA LINHAS
UPDATE TB_PEDIDO WITH (ROWLOCK) -- WITH (ROWLOCK) é default
SET SITUACAO = 'E' WHERE NUM_PEDIDO < 1000
--BLOQUEAR PEDIDO <1000
-- Observe o recurso bloqueado (KEY): Bloqueio de linha atraves da chave primária
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- vá até a janela 2 e exeute o EXEMPLO 3...
-- Descartar alterações
--ROLLBACK

-- EXEMPLO 4 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PEDIDOS WITH (PAGLOCK) 
SET SITUACAO = 'X' WHERE NUM_PEDIDO < 1000

-- Observe o recurso bloqueado (PAGE): 
-- BOM  -> Menor número de bloqueios, menos processamento, menor quantidade de memória utilizada
-- RUIM -> Menor concorrência. São bloqueados mais registros do que o necessário
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID


-- Vá até a janela 2...
--
-- Descartar as alterações
ROLLBACK

-- EXEMPLO 5 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE TB_PEDIDO WITH (TABLOCK) 
SET SITUACAO = 'X' WHERE NUM_PEDIDO < 1000

-- Observe o recurso bloqueado o o nome do objeto (OBJECT, PEDIDOS): 
-- BOM  -> Menor número de bloqueios, menos processamento, menor quantidade de memória utilizada
-- RUIM -> Menor concorrência. São bloqueados mais registros do que o necessário
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
-- Descartar alterações
ROLLBACK

--------------------------------------------------------
-- Níveis de isolamento entre os processos de transação
--------------------------------------------------------
-- O nível padrão é READ COMMITTED 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- EXEMPLO 6 ---------------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRAN
-- Vá até a outra janela e inicie processo de transação
-- e faça update em produtos.
--
-- Depois volte para cá e execute este SELECT
-- Vai funcionar porque configuramos "Dirty-read" como padrão
-- Estamos consultando dados não confirmados
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO
--
ROLLBACK
-- Finalize a transação da outra janela

-- EXEMPLO 7 ---------------------------------------------------------------------------
-- Configurar o banco para aceitar o próximo tipo de
-- isolamento de transação
ALTER DATABASE PEDIDO
SET ALLOW_SNAPSHOT_ISOLATION ON
-- Este tipo de isolamento impedide que a transção atual
-- enxergue as transações "comitadas" por outros usuários
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
--
BEGIN TRAN
--
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES
-- Vá até a outra janela e execute o exemplo 6
--
-- Execute o SELECT e note que, apesar das alterações já terem
-- sido "comitadas" nós continuamos enxergando os mesmos dados
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES
-- Finalizar a transação
ROLLBACK
-- Voltamos ao mundo real
-- Somente após o término desta transação é que conseguimos
-- enxergar as alterações do outro processo de transação
SELECT * FROM TB_PRODUTO ORDER BY COD_TIPO

SELECT * FROM TB_VENDEDORES

-- EXEMPLO 8 ---------------------------------------------------------------------------
-- Impede que outros usuários alterem dados das tabelas
-- que este processo está utilizando
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--
BEGIN TRAN
-- Execute este SELECT e depois vá para outra janela
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


