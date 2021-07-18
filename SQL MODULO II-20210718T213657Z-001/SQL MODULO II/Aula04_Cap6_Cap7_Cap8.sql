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
