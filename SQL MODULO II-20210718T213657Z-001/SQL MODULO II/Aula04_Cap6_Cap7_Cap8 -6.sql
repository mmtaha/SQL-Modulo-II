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

-- 4. Criar VIEW (VIE_MAIOR_PEDIDO) para mostrar valor do maior pedido (MAX de TB_PEDIDO.VLR_TOTAL)
-- vendido em cada mês do ano. Deve mostrar o mês, o ano e o maior pedido
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
-- 6. Faça um JOIN, utilizando VIE_MAIOR_PEDIDO e PEDIDOS que mostre também o número
-- do pedido (TB_PEDIDO.NUM_PEDIDO) de maior valor em cada mês. Deve filtrar o ano
-- de 2014 e ordernar por mês.
-- Resp.:
SELECT V.MES, V.ANO, V.MAIOR_PEDIDO, P.NUM_PEDIDO
FROM VW_MAIOR_PEDIDO V 
     JOIN TB_PEDIDO P ON V.MES = MONTH(P.DATA_EMISSAO) AND
                       V.ANO = YEAR(P.DATA_EMISSAO) AND
                       V.MAIOR_PEDIDO = P.VLR_TOTAL
WHERE V.ANO = 2014                       
ORDER BY MES

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--CAP7
--VARIAVEIS (@-->VARIAVEL LOCAL
--                       @@--> VARIAVEL GLOBAL)
--SOMAR DOIS NUMEROS INTEIROS
--DECLARACOA DE VARIAVEIS
DECLARE @P_VALOR INT
                   ,@S_VALOR INT
                   ,@SOMA INT
--ATRIBUIR VALORES
SET @P_VALOR=10
SET @S_VALOR=32
SET @SOMA=@P_VALOR + @S_VALOR
PRINT @SOMA
IF @P_VALOR > @S_VALOR
  BEGIN
    PRINT 'MAIOR:'+CAST(@P_VALOR AS CHAR(2))
    PRINT 'FIM'
END
ELSE
   PRINT CONCAT('MAIOR:',@S_VALOR)
-----------------------------------------------------------------------------------------------------------
--CONCATENAÇÃO (+)
SELECT ENDERECO + ' - '+CIDADE
FROM TB_CLIENTE

SELECT  NOME+' : '+ CAST(COD_DEPTO AS CHAR(3))
FROM TB_EMPREGADO

--CONCAT
SELECT CONCAT(NOME,' :',COD_DEPTO)
FROM TB_EMPREGADO
----------------------------------------------------------------------------------------------------------
--FAZER UM PROGRAMA PARA RECEBER UMA DATA E RETORNAR O DIA
--DA SEMANA POR EXTENSO(USAR IF/ELSE)

DECLARE @DATA DATETIME
                  ,@DIA INT
SET @DATA='2018/12/25'
SET @DIA=DATEPART(WEEKDAY,@DATA)

IF @DIA=1
	PRINT 'DOMINGO'
ELSE IF @DIA=2
	PRINT 'SEGUNDA-FEIRA'
ELSE IF @DIA=3
	PRINT 'TERÇA-FEIRA'
ELSE IF @DIA=4
	PRINT 'QUARTA-FEIRA'
ELSE IF @DIA=5
	PRINT 'QUNTA-FEIRA'
ELSE IF @DIA=6
	PRINT 'SEXTA-FEIRA'
ELSE IF @DIA=7
	PRINT 'SABADO'


--WHILE(ENQUANTO)

	DECLARE @CONT INT
	SET @CONT =0
	WHILE @CONT < 5
	BEGIN
	SET @CONT= @CONT + 1
	PRINT @CONT
	END

--FAZER UM PROGRAMA PARA EXIBIR O CODIGO DO FUNCIONARIO E O NOME
--NO INTERVALO DE 1 A 7

DECLARE @CONT INT
	SET @CONT =1
	WHILE @CONT < 5
	BEGIN
	SELECT CODFUN, NOME
	FROM TB_EMPREGADO
	SET @CONT= @CONT + 1
	PRINT @CONT
	END


------------------------------------
CREATE PROCEDURE SP_CONSULTA_EMP @COD INT
AS
BEGIN
SELECT CODFUN, NOME
FROM TB_EMPREGADO
WHERE CODFUN=@COD
END
EXEC SP_CONSULTA_EMP 5

-- CRIAR UMA PROC PARA RETORNAR OS PEDIDOS E DATA_EMISSAO
--NO PERIODO DE JANEIRO/2014

CREATE PROCEDURE SP_CONSULTA_PEDIDOS @DATAINI DATETIME, @DATAFIM DATETIME
AS
BEGIN
SELECT NUM_PEDIDO, DATA_EMISSAO
FROM TB_PEDIDO
WHERE DATA_EMISSAO BETWEEN @DATAINI AND @DATAFIM
END
EXEC SP_CONSULTA_PEDIDOS '2014/01/01','2014/01/31'
PRINT SP_CONSULTA_PEDIDOS
SELECT *
FROM SP_CONSULTA_PEDIDOS


--CRIAR TABELA MEGA SENA

CREATE TABLE SP_MEGA_SENA

------CRIAR UM PROGRAMA PARA GERAR 6 NUMEROS ALEATORIOS 
--GERAR NUMERO ALEATORIO

DECLARE @DEZENA INT, @CONT INT = 1;
IF OBJECT_ID('TBL_MEGASENA') IS NOT NULL
   DROP TABLE TBL_MEGASENA;
   
CREATE TABLE TBL_MEGASENA( NUM_DEZENA INT );
   
WHILE @CONT <= 6
   BEGIN
   SET @DEZENA = 1 + 60 * RAND();
   IF EXISTS( SELECT * FROM TBL_MEGASENA 
              WHERE NUM_DEZENA = @DEZENA )
      CONTINUE;           
   INSERT INTO TBL_MEGASENA VALUES (@DEZENA);
   SET @CONT += 1;
   END
SELECT * FROM TBL_MEGASENA