--COLOCAR EM USO O BANCO PEDIDOS
USE PEDIDOS
--SCHEMABINDING --> PROTEGE A ESTRUTURA DA TABELA
--NA CONSTRUÇÃO DA VIEW É NECESSARIO INFORMAR O SCHEMA DA 
--TABELA
CREATE VIEW VW_RELAT_EMP 
WITH SCHEMABINDING
AS
SELECT CODFUN
              , NOME
             , COD_DEPTO
             , COD_CARGO
             , NUM_DEPEND
             , SALARIO
FROM DBO.TB_EMPREGADO
-----------------------------------------------------------------------------------------------------------
SELECT *
FROM VW_RELAT_EMP
--APAGAR A COLUNA NUM_DEPEND
ALTER TABLE TB_EMPREGADO 
DROP COLUMN NUM_DEPEND
GO
------------------------------------------------------------------------------------------------------------
SELECT *
FROM TB_EMPREGADO
------------------------------------------------------------------------------------------------------------
--APAGAR A COLUNA FOTO
ALTER TABLE TB_EMPREGADO
DROP COLUMN FOTO
-----------------------------------------------------------------------------------------------------------
--CRIAR INDICE NA VISAO(VIEW)
--CRIAR UM INDICE PARA O CAMPO CODFUN
CREATE UNIQUE CLUSTERED INDEX NDX_CODFUN
ON VW_RELAT_EMP(CODFUN)

CREATE NONCLUSTERED INDEX NDX_NOME 
ON VW_RELAT_EMP(NOME)

SELECT NOME
              ,SALARIO
FROM VW_RELAT_EMP
WHERE NOME LIKE 'C%'
----------------------------------------------------------------------------------------------------------------
--INSERIR DADOS NA TABELA EMPREGADO POR MEIO DA VISAO
CREATE VIEW VW_INSERE_EMP
AS
SELECT CODFUN
              , NOME
              , DATA_ADMISSAO
							,COD_DEPTO
							, COD_CARGO
							, SALARIO
FROM TB_EMPREGADO
WHERE COD_DEPTO = 2

--INSERT NA TABELA EMPREGADO 
INSERT INTO TB_EMPREGADO(NOME,DATA_ADMISSAO
                                                           ,COD_DEPTO,COD_CARGO,SALARIO)
VALUES('TURMA SABADO','2019/05/18',1,5,8.500)
--------------------------------------------------------------------------------------------------------
--INSERIR REGISTRO POR MEIO DA VISAO
INSERT INTO VW_INSERE_EMP(NOME,DATA_ADMISSAO
                                                           ,COD_DEPTO,COD_CARGO,SALARIO)
VALUES('TURMA DOMINGO','2019/05/19',1,7,7755)

SELECT *
FROM TB_EMPREGADO
SELECT *
FROM VW_INSERE_EMP
------------------------------------------------------------------------------------------------------
ALTER VIEW VW_INSERE_EMP
AS
SELECT CODFUN
              , NOME
              , DATA_ADMISSAO
							,COD_DEPTO
							, COD_CARGO
							, SALARIO
FROM TB_EMPREGADO
WHERE COD_DEPTO = 2
WITH CHECK OPTION

INSERT INTO VW_INSERE_EMP(NOME,DATA_ADMISSAO
                                                           ,COD_DEPTO,COD_CARGO,SALARIO)
VALUES('TURMA SEMANA','2019/05/20',2,2,3000)
-----------------------------------------------------------------------------------

--exercicio1 criar uma view para retornar o numero do pedido
--o numero do item, o id_produto, cod_tipo pr_unitario
--filtro:cod_tipo=5
CREATE VIEW VW_PED_3
AS
 SELECT NUM_PEDIDO,
    	NUM_ITEM,
		ID_PRODUTO, 
		PR_UNITARIO
FROM TB_ITENSPEDIDO
WHERE ID_PRODUTO=5
WITH CHECK OPTION

SELECT * 
FROM  VW_PED_3

--exercicio 2: eserir dadis por meio da view na tabela
--tb_itenspedido

SELECT *
FROM VW_PED_3
INSERT TB_PEDIDO 
VALUES (108,5,GETDATE(),1000,'P',NULL)
-----------------------------------------------------------
INSERT INTO VW_PED_3(NUM_PEDIDO,
    				 NUM_ITEM,
					 ID_PRODUTO, 
					 PR_UNITARIO)
VALUES(11323,2,5,500)
------------------------------------------------
-- 2. Criar VIEW (VIE_TOT_VENDIDO) para mostrar o total vendido (soma de TB_PEDIDO.VLR_TOTAL)
-- em cada mês do ano. Deve mostrar o mês, o ano e o total vendido
-- Resp.:
GO
CREATE VIEW VW_TOT_VENDIDO AS
SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       SUM( VLR_TOTAL ) AS TOT_VENDIDO
FROM TB_PEDIDO
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)

SELECT *
FROM VW_TOT_VENDIDO


SELECT * 
FROM SYSCOMMENTS

CREATE VIEW VW_MAIOR_PEDIDO AS
SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
GO
SELECT *
FROM VW_TOT_VENDIDO
-----------------------------------------------------

SELECT V.MES, V.ANO, V.MAIOR_PEDIDO, P.NUM_PEDIDO
FROM VIE_MAIOR_PEDIDO V 
     JOIN TB_PEDIDO P ON V.MES = MONTH(P.DATA_EMISSAO) AND
                       V.ANO = YEAR(P.DATA_EMISSAO) AND
                       V.MAIOR_PEDIDO = P.VLR_TOTAL
WHERE V.ANO = 2014                       
ORDER BY MES



