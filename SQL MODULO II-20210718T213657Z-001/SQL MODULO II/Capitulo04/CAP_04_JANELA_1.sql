/*
    TIPOS DE BLOQUEIO
    -----------------
    
		SHARED (S): 
			.É aplicado quando uma transação lê dados do banco de dados.
			.Várias transações podem aplicar shared lock em um mesmo recurso.
		UPDATE (U):
			.Aplicado quando lemos dados que iremos alterar
			.Duas transações NÃO PODEM colocar update lock em um mesmo recurso
			.No momento em que os dados são lidos por um comando UPDATE, por exemplo
			 os registros recebem um UPDATE LOCK.
			.Logo em seguida o UPDATE LOCK é promovido a EXCLUSIVE LOCK     
		EXCLUSIVE (X):
			.O bloqueio exclusivo garante que somente uma transação tem acesso ao registro   
			.Não é compatível com outros tipos de bloqueio.
		INTENT (IS, IU, IX): 
			.Marca um determinado recurso sinalizando que nele existem bloqueios.  
        SCHEMA (Sch-M, Sch-S): 
            .Controla atualizações de estrutura das tabelas. 
            .Evitam que uma tabela que está sendo utilizada em produção seja alterada 
            (Schema Modification Locks ou Sch-M), ou que algum processo acesse uma tabela 
             cuja estrutura está em modificação (Schema Stability Locks ou Sch-S).
        Key-Range:
            .Bloqueia uma faixa de registros quando usamos nível de isolamento SERIALIZABLE 
			  
    
    GRANULARIDADE (recursos)
    ------------------------

         
         Linha (ROW): Uma linha de uma tabela
             RID (Row ID): Identificador de linha de tabela quando esta não possui chave primária
             KEY         : Linha da tabela associada ao índice chave primária
         Página(PAGE): Um bloco de dados contendo 8K
         Bloco de páginas (EXTENT): Bloco contíguo de 8 páginas.
         Tabela (TABLE): Uma tabela do banco de dados. 
    
*/

--=====================================================
-- CONCORRÊNCIA - JANELA 1
--=====================================================
USE PEDIDOS

-- EXEMPLO 1 ---------------------------------------------------------------------
-- A tabela PRODUTOS_TMP não possui chave primária ou nenhum
-- outro índice clisterizado
SELECT * INTO PRODUTOS_TMP FROM PRODUTOS
-- Abrir transação
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
                         
-- Vá até a janela 2 e execute o comando correspondente ao EXEMPLO 1...
--
-- Descartar alterações
ROLLBACK
SELECT *
FROM PRODUTOS_TMP 
ORDER BY COD_TIPO
-- EXEMPLO 2 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PRODUTOS SET PRECO_VENDA = 5
WHERE COD_TIPO = 1
ROLLBACK
-- Observe a coluna RESOURCE_TYPE. Como a tabela possui chave primária
-- o bloqueio ocorreu atraves da chave primária
SELECT 
  L.RESOURCE_TYPE, L.REQUEST_MODE, L.REQUEST_TYPE, L.REQUEST_STATUS, 
  D.NAME AS BANCO_DADOS, O.NAME NOME_OBJETO, O2.NAME NOME_OBJETO_RELAC
FROM SYS.DM_TRAN_LOCKS L JOIN SYS.DATABASES D ON L.RESOURCE_DATABASE_ID = D.DATABASE_ID
                         LEFT JOIN SYSOBJECTS O ON O.ID = L.RESOURCE_ASSOCIATED_ENTITY_ID
                         LEFT JOIN SYS.PARTITIONS P ON L.RESOURCE_ASSOCIATED_ENTITY_ID = P.HOBT_ID
                         LEFT JOIN SYSOBJECTS O2 ON P.OBJECT_ID = O2.ID
ORDER BY 2

-- Depois de executar o UPDATE vá para a janela 2 e execute o comando referente
-- ao exemplo 2...
--
-- Descartar alterações
ROLLBACK

-- EXEMPLO 3 ---------------------------------------------------------------------------
BEGIN TRAN
--ROWLOCK --> TRAVA LINHAS
UPDATE PEDIDOS WITH (ROWLOCK) -- WITH (ROWLOCK) é default
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
--
-- Descartar alterações
ROLLBACK

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

UPDATE PEDIDOS WITH (TABLOCK) 
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
SELECT * FROM PRODUTOS ORDER BY COD_TIPO
--
ROLLBACK
-- Finalize a transação da outra janela

-- EXEMPLO 7 ---------------------------------------------------------------------------
-- Configurar o banco para aceitar o próximo tipo de
-- isolamento de transação
ALTER DATABASE PEDIDOS
SET ALLOW_SNAPSHOT_ISOLATION ON
-- Este tipo de isolamento impedide que a transção atual
-- enxergue as transações "comitadas" por outros usuários
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
--
BEGIN TRAN
--
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES
-- Vá até a outra janela e execute o exemplo 6
--
-- Execute o SELECT e note que, apesar das alterações já terem
-- sido "comitadas" nós continuamos enxergando os mesmos dados
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES
-- Finalizar a transação
ROLLBACK
-- Voltamos ao mundo real
-- Somente após o término desta transação é que conseguimos
-- enxergar as alterações do outro processo de transação
SELECT * FROM PRODUTOS ORDER BY COD_TIPO

SELECT * FROM VENDEDORES

-- EXEMPLO 8 ---------------------------------------------------------------------------
-- Impede que outros usuários alterem dados das tabelas
-- que este processo está utilizando
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--
BEGIN TRAN
-- Execute este SELECT e depois vá para outra janela
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



