select PED.NUM_PEDIDO,
CLI.NOME AS NOME_CLI,
NOME AS NOME_VEND,
QUANTIDADE,
PR_UNITARIO,
DESCRICAO,
FROM TB_PEDIDO AS PED
INNER JOIN TB_CLIENTE AS CLI
ON CLI.CODCLI=PED.CODCLI
INNER JOIN TB_VENDEDOR AS VEND
ON PROD.ID_PRODUTO=ITEM.ID_PRODUTO
INNER JOIN TB_PRODUTO AS PROD
ON PROD.ID_PRODUTO=ITEM.ID_PRODUTO

SELECT *
FROM PESSOA