--=====================================================
-- CONCORRÊNCIA - JANELA 2
--=====================================================
USE PEDIDOS

SET LOCK_TIMEOUT 5000 -- 5 segundos

-- EXEMPLO 1 -----------------------------------------------------------------
-- Vai esgotar o temp de TIMEOUT porque existem registros bloqueados
SELECT * FROM PRODUTOS_TMP;
-- A estrutura da tabela também está bloqueada
ALTER TABLE PRODUTOS_TMP ADD TESTE INT;

-- Consulta os registros não bloqueados
SELECT * FROM PRODUTOS_TMP WITH (READPAST)
ORDER BY COD_TIPO;

-- Consulta inclusive os registros bloqueados
-- "Dirty-read" (leitura suja)
SELECT * FROM PRODUTOS_TMP WITH (NOLOCK)
ORDER BY COD_TIPO;
-- voltar para a janela 1


-- EXEMPLO 2 -----------------------------------------------------------------
SELECT * FROM PRODUTOS ORDER BY COD_TIPO
/* Não consegue ler porque algumas linhas da tabela estão bloqueadas
   em outro processo de transação. */

-- Lê os registros não bloqueados. Veja que não aparece nenhum registro com 
-- COD_TIPO = 1 
SELECT * FROM PRODUTOS WITH (READPAST)
ORDER BY COD_TIPO 

-- "Dirty-read" (leitura suja)
-- Lê os registros ainda não "comitados" por outra transação
SELECT * FROM PRODUTOS WITH (NOLOCK)
ORDER BY COD_TIPO 
-- voltar para a janela 1


-- EXEMPLO 3 -------------------------------------------------------------------
SELECT * FROM PEDIDOS  WITH (READPAST) 
--ESTUDAR READPAST
-- Os registros até 999 estão bloquedos

SELECT * FROM PEDIDOS  WITH  (NOLOCK)
ORDER BY NUM_PEDIDO
-- voltar para a janela 1

-- EXEMPLO 4 -------------------------------------------------------------------
SELECT * FROM PEDIDOS  WITH (READPAST) 
--WHERE NUM_PEDIDO > 1000
ORDER BY NUM_PEDIDO DESC
--

SELECT * FROM PEDIDOS  WITH (READPAST) 
WHERE NUM_PEDIDO >= 1079
ORDER BY NUM_PEDIDO DESC
-- Observe que não só os registros até 1000 estão bloqueados
-- alguns registros acima de 1000 também estão porque fazem 
-- parte da mesma página

SELECT * FROM PEDIDOS  WITH  (NOLOCK)
ORDER BY NUM_PEDIDO



-- EXEMPLO 5 --------------------------------------------------------------------------
SELECT * FROM PEDIDOS  WITH (READPAST) 
ORDER BY NUM_PEDIDO DESC
-- Vai falhar porque o bloqueio foi colocado em toda a tabela

SELECT * FROM PEDIDOS  WITH  (NOLOCK)
ORDER BY NUM_PEDIDO


-- EXEMPLO 6 ---------------------------------------------------------------------------
BEGIN TRAN

UPDATE PRODUTOS SET PRECO_VENDA = 5
WHERE COD_TIPO = 1

SELECT * FROM PRODUTOS ORDER BY COD_TIPO

-- Retorne para a janela 1 e consulte os dados de PRODUTOS

-- Descartar alterações
ROLLBACK


-- EXEMPLO 7 ---------------------------------------------------------------------------

BEGIN TRAN

UPDATE PRODUTOS SET PRECO_VENDA = 5
WHERE COD_TIPO = 1

SELECT * FROM PRODUTOS
ORDER BY COD_TIPO

SELECT * FROM VENDEDORES

DELETE FROM VENDEDORES WHERE CODVEN > 5

SELECT * FROM VENDEDORES
-- Retorne para a janela 1 e consulte os dados de PRODUTOS e VENDEDORES

ROLLBACK

-- EXEMPLO 8 ---------------------------------------------------------------------------
-- Registros bloqueados pela outra transação
UPDATE PRODUTOS SET PRECO_VENDA = 5;
-- Estrutura da tabela bloqueada pela outra transação
ALTER TABLE PRODUTOS ADD TESTE INT;
-- Inclusão bloqueada
INSERT INTO PRODUTOS
( COD_PRODUTO, DESCRICAO, COD_TIPO, COD_UNIDADE, PRECO_CUSTO)
VALUES ('ABC-123','TESTE', 1, 1, 5)


