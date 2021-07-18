--=====================================================
-- CONCORR�NCIA - JANELA 2
--=====================================================
USE PEDIDOS

SET LOCK_TIMEOUT 5000 -- 5 segundos

-- EXEMPLO 1 -----------------------------------------------------------------
-- Vai esgotar o temp de TIMEOUT porque existem registros bloqueados
SELECT * FROM PRODUTOS_TMP;
-- A estrutura da tabela tamb�m est� bloqueada
ALTER TABLE PRODUTOS_TMP ADD TESTE INT;

-- Consulta os registros n�o bloqueados
SELECT * FROM PRODUTOS_TMP WITH (READPAST)
ORDER BY COD_TIPO;

-- Consulta inclusive os registros bloqueados
-- "Dirty-read" (leitura suja)
SELECT * FROM PRODUTOS_TMP WITH (NOLOCK)
ORDER BY COD_TIPO;
-- voltar para a janela 1


-- EXEMPLO 2 -----------------------------------------------------------------
SELECT * FROM PRODUTOS ORDER BY COD_TIPO
/* N�o consegue ler porque algumas linhas da tabela est�o bloqueadas
   em outro processo de transa��o. */

-- L� os registros n�o bloqueados. Veja que n�o aparece nenhum registro com 
-- COD_TIPO = 1 
SELECT * FROM PRODUTOS WITH (READPAST)
ORDER BY COD_TIPO 

-- "Dirty-read" (leitura suja)
-- L� os registros ainda n�o "comitados" por outra transa��o
SELECT * FROM PRODUTOS WITH (NOLOCK)
ORDER BY COD_TIPO 
-- voltar para a janela 1


-- EXEMPLO 3 -------------------------------------------------------------------
SELECT * FROM PEDIDOS  WITH (READPAST) 
--ESTUDAR READPAST
-- Os registros at� 999 est�o bloquedos

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
-- Observe que n�o s� os registros at� 1000 est�o bloqueados
-- alguns registros acima de 1000 tamb�m est�o porque fazem 
-- parte da mesma p�gina

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

-- Descartar altera��es
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
-- Registros bloqueados pela outra transa��o
UPDATE PRODUTOS SET PRECO_VENDA = 5;
-- Estrutura da tabela bloqueada pela outra transa��o
ALTER TABLE PRODUTOS ADD TESTE INT;
-- Inclus�o bloqueada
INSERT INTO PRODUTOS
( COD_PRODUTO, DESCRICAO, COD_TIPO, COD_UNIDADE, PRECO_CUSTO)
VALUES ('ABC-123','TESTE', 1, 1, 5)


