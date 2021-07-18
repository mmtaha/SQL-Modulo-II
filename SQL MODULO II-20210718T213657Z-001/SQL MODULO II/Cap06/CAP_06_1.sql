--================================================
-- Cap. 6 - VIEWS
-- Uma view serve para armazenar uma instru��o SELECT.
-- Para que utilizar uma VIEW?
--    .Centralizar a instru��o SELECT para que n�o
--     seja necess�rio digit�-la repetidas vezes.
--    .Proteger informa��es (colunas e/ou linhas)
--    .Simplifica��o de c�digo no caso de SELECTs
--     muito complexos.
--------------------------------------------------- 

-- SYSCOMMENTS
SELECT TEXT FROM SYSCOMMENTS


USE PEDIDOS
-- 1. Criando a VIEW
GO
CREATE VIEW VIE_EMP1 AS
SELECT CODFUN, NOME, DATA_ADMISSAO, 
       COD_DEPTO, COD_CARGO, SALARIO
FROM TB_EMPREGADO
-- Testando a VIEW
SELECT * FROM VIE_EMP1
--
SELECT CODFUN, NOME FROM VIE_EMP1


-- Testando a VIEW
SELECT * FROM VIE_EMP1

--
SELECT CODFUN, NOME FROM VIE_EMP1
-- Procure esta view no Object Explorer e 
-- d� um click direito sobre ela


-- 2. Utilizando ENCRYPTION
GO
-- 1. Utilizando ENCRYPTION
CREATE VIEW VIE_EMP2_A WITH ENCRYPTION
AS
SELECT TOP 100 CODFUN, NOME, DATA_ADMISSAO, 
       COD_DEPTO, COD_CARGO, SALARIO
FROM TB_EMPREGADO
ORDER BY NOME
-- Procurar esta view no Object Explorer e 
-- dar um clique com o bot�o direito sobre ela

--=============================================
-- Para que uma VIEW possa ser indexada, ela deve 
-- ser criada da seguinte forma:
GO
CREATE VIEW VIE_EMP3 
WITH ENCRYPTION, SCHEMABINDING
AS
SELECT CODFUN, NOME, DATA_ADMISSAO, 
       COD_DEPTO, COD_CARGO, SALARIO, NUM_DEPEND
FROM DBO.TB_EMPREGADO
GO
-- Testando a VIEW
SELECT * FROM VIE_EMP3
-- N�o � poss�vel apagar a coluna da tabela
GO
ALTER TABLE TB_EMPREGADO DROP COLUMN NUM_DEPEND
GO
-- Criando �ndices para a view
CREATE UNIQUE CLUSTERED INDEX IX_VIE_EMP3_CODFUN
ON VIE_EMP3(CODFUN)
GO
--
CREATE INDEX IX_VIE_EMP3_NOME
ON VIE_EMP3(NOME)



GO
-- VIEW com condi��o de filtro
CREATE VIEW VIE_EMP4 WITH ENCRYPTION
AS
SELECT CODFUN, NOME, DATA_ADMISSAO, 
       COD_DEPTO, COD_CARGO, SALARIO
FROM TB_EMPREGADO
WHERE COD_DEPTO = 2
GO
-- Testando
SELECT * FROM VIE_EMP4

--
INSERT INTO VIE_EMP4 ( NOME, DATA_ADMISSAO, COD_DEPTO, 
                      COD_CARGO, SALARIO)
VALUES ('TESTE INCLUS�O', GETDATE(), 1, 1, 1000)

-- 
SELECT * FROM EMPREGADOS
--
SELECT * FROM VIE_EMP4
--
GO
ALTER VIEW VIE_EMP4 WITH ENCRYPTION
AS
SELECT CODFUN, NOME, DATA_ADMISSAO, 
       COD_DEPTO, COD_CARGO, SALARIO
FROM TB_EMPREGADO
WHERE COD_DEPTO = 2
WITH CHECK OPTION

--===============================================
----------------------------------------------------
--- Devolvendo dado tabular com VIEW
----------------------------------------------------
GO
CREATE  VIEW VIE_MAIOR_PEDIDO AS
SELECT TOP 12 MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
-- N�O ACEITA PAR�METRO. Trabalha somente com constantes
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
ORDER BY MES
GO
----------------------------------------------------
-- Consulta com SELECT
SELECT * FROM VIE_MAIOR_PEDIDO
-- Ordenando consulta com ORDER BY
SELECT * FROM VIE_MAIOR_PEDIDO
ORDER BY MAIOR_PEDIDO DESC
-- Filtrando consulta com WHERE
SELECT * FROM VIE_MAIOR_PEDIDO
WHERE MES > 6
-- Exemplo da instru��o JOIN em uma VIEW
SELECT V.*, P.NUM_PEDIDO, C.NOME AS CLIENTE
FROM VIE_MAIOR_PEDIDO V JOIN TB_PEDIDO P
             ON V.MES = MONTH( P.DATA_EMISSAO ) AND
                V.ANO = YEAR( P.DATA_EMISSAO ) AND
                V.MAIOR_PEDIDO = P.VLR_TOTAL
     JOIN TB_CLIENTE C ON P.CODCLI = C.CODCLI   


-- Consulta com SELECT
SELECT * FROM VIE_MAIOR_PEDIDO WHERE ANO=2014;


----------------------------------------------------
--- Devolvendo dado tabular com STORED PROCEDURE
----------------------------------------------------
GO
CREATE PROCEDURE STP_MAIOR_PEDIDO @ANO INT
AS BEGIN
SELECT MONTH( DATA_EMISSAO ) AS MES,
       YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
-- Aceita par�metro. Trabalha com dados vari�veis
WHERE YEAR(DATA_EMISSAO) = @ANO
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
ORDER BY MES
END
GO
----------------------------------------------------
-- Executa com EXEC
-- N�o aceita ORDER BY
-- N�o aceita WHERE
-- N�o aceita JOIN etc...
EXEC STP_MAIOR_PEDIDO 2012
EXEC STP_MAIOR_PEDIDO 2013
EXEC STP_MAIOR_PEDIDO 2014
GO


----------------------------------------------------
--- Devolvendo dado tabular com FUN��O TABULAR
----------------------------------------------------
CREATE FUNCTION FN_MAIOR_PEDIDO( @DT1 DATETIME,
                                 @DT2 DATETIME )
RETURNS TABLE
AS
RETURN ( SELECT MONTH( DATA_EMISSAO ) AS MES, 
                YEAR( DATA_EMISSAO ) AS ANO, 
                MAX( VLR_TOTAL ) AS MAIOR_VALOR
                FROM TB_PEDIDO
                -- Aceita par�metros. Trabalha com vari�veis
                WHERE DATA_EMISSAO BETWEEN @DT1 AND @DT2
                GROUP BY MONTH( DATA_EMISSAO ), 
                         YEAR( DATA_EMISSAO ) )
GO
----------------------------------------------------
-- Executa com SELECT
SELECT * FROM DBO.FN_MAIOR_PEDIDO( '2014.1.1','2014.12.31')
ORDER BY ANO, MES
-- Aceita filtro
SELECT * FROM DBO.FN_MAIOR_PEDIDO( '2014.1.1','2014.12.31')
WHERE MES > 6
ORDER BY ANO, MES
-- Aceita JOIN
SELECT F.MES, F.ANO, F.MAIOR_VALOR, P.NUM_PEDIDO
FROM FN_MAIOR_PEDIDO( '2014.1.1','2014.12.31') F
     JOIN TB_PEDIDO P 
     ON F.MES = MONTH( P.DATA_EMISSAO ) AND
        F.ANO = YEAR( P.DATA_EMISSAO ) AND
        F.MAIOR_VALOR = P.VLR_TOTAL
ORDER BY F.ANO, F.MES

