--COLOCAR EM USO O BANCO DE DADOS PEDIDOS
USE PEDIDOS


--COPIA DA TABELA EMPREGADOS

SELECT * INTO EMP_TEMP

FROM TB_EMPREGADO

SELECT * FROM EMP_TEMP

-- APAGAR OS REGISTROS COM COD_CARGO=3

DELETE FROM EMP_TEMP
OUTPUT DELETED.*
WHERE COD_CARGO = 3

UPDATE EMP_TEMP
SET SALARIO = SALARIO * 1.1
OUTPUT DELETED.*
WHERE COD_DEPTO = 2

SET IDENTITY_INSERT EMP_TEMP ON
SELECT COUNT (*)
FROM EMP_TEMP
SELECT COUNT (*)
FROM TB_EMPREGADO

-- ASTABELAS EMP_TEMP E TB_EMPREGADO DEVEM SER
--IGUAIS, OU SEJA, TER A MESMA QUANTIDADE DE 
--REGISTOS E O MESMO CONTEUDO PARA OS CAMPOS
--TB_EMPREGADO � A TABELA FONTE

MERGE EMP_TEMP AS EMP
USING TB_EMPREGADO AS TB_EMP
ON EMP.CODFUN=TB_EMP.CODFUN
WHEN MATCHED AND EMP.SALARIO<>TB_EMP.SALARIO THEN
UPDATE
SET EMP.SALARIO=TB_EMP.SALARIO

WHEN NOT MATCHED THEN

 INSERT (CODFUN,NOME,COD_DEPTO,COD_CARGO,DATA_ADMISSAO,
 DATA_NASCIMENTO,
 SALARIO, NUM_DEPEND, SINDICALIZADO, OBS, FOTO)
 VALUES (CODFUN,NOME,COD_DEPTO,COD_CARGO,DATA_ADMISSAO,
 DATA_NASCIMENTO,
 SALARIO, NUM_DEPEND, SINDICALIZADO, OBS, FOTO);

 SELECT * FROM TB_EMPREGADO
 WHERE COD_CARGO =3

 SET IDENTITY_INSERT EMP_TEMP OFF

 SELECT *
 FROM SYSOBJECTS
 WHERE XTYPE='U'

  SELECT *
 FROM SYS.OBJECTS
 WHERE OBJECT_ID = 958626458

 --APAGAR EMP_TEMP
IF OBJECT_ID('EMP_TEMP','U') IS NOT NULL
 DROP TABLE EMP_TEMP;
SELECT * INTO EMP_TEMP FROM TB_EMPREGADO;

--MERGE COM OUTPUT
--PREPARAR A TABELA EMP_TEMP

DELETE 
FROM EMP_TEMP
WHERE COD_CARGO IN (3,5,7)

UPDATE EMP_TEMP SET SALARIO *= 1.2
WHERE COD_DEPTO = 2

INSERT INTO EMP_TEMP
(NOME, COD_DEPTO, COD_CARGO, SALARIO, DATA_ADMISSAO)
VALUES ('MARIA ANTONIA',1,2,2000,GETDATE()),
	   ('ANTONIA MARIA',2,1,3000,GETDATE());
SELECT * 
FROM EMP_TEMP

SET IDENTITY_INSERT EMP_TEMP ON
-- Faz com que a tabela EMP_TEMP fique igual � tabela TB_EMPREGADO
MERGE EMP_TEMP AS EMPT -- Tabela alvo
USING TB_EMPREGADO AS EMP -- Tabela fonte
ON EMPT.CODFUN = EMP.CODFUN -- Condi��o de compara��o
-- Quando o registro existir nas 2 tabelas e o SALARIO for
-- diferente...
WHEN MATCHED AND EMPT.SALARIO <> EMP.SALARIO THEN
 -- ...Alterar o campo sal�rio de EMP_TEMP
 UPDATE SET EMPT.SALARIO = EMP.SALARIO
-- Quando o registro n�o existir em EMP_TEMP...
WHEN NOT MATCHED THEN
-- ...Inserir o registro em EMP_TEMP
 INSERT (CODFUN,NOME,COD_DEPTO
		,COD_CARGO,DATA_ADMISSAO
		, DATA_NASCIMENTO, SALARIO, NUM_DEPEND
		, SINDICALIZADO, OBS, FOTO)
 VALUES (CODFUN,NOME,COD_DEPTO,COD_CARGO,
		DATA_ADMISSAO, DATA_NASCIMENTO
		, SALARIO, NUM_DEPEND, SINDICALIZADO, OBS, FOTO)
WHEN NOT MATCHED BY SOURCE THEN
 -- Excluir o que existe na tabela alvo mas n�o existe
 -- na tabela fonte
 DELETE
 OUTPUT $ACTION AS ACAO
		, INSERTED.CODFUN AS [C�digo Ap�s]
		, DELETED.CODFUN AS [C�digo Antes]
		, INSERTED.NOME AS [Nome Ap�s]
		, DELETED.NOME AS [Nome Antes]
		, INSERTED.SALARIO AS [Sal�rio Ap�s]
		, DELETED.SALARIO AS [Sal�rio Antes];
-- Desabilita a inser��o de dados no campo identidade
SET IDENTITY_INSERT EMP_TEMP OFF;

--PIVOT ( TABELA DINAMICA )

SELECT CODVEN, MONTH(DATA_EMISSAO) AS MES
			 , YEAR(DATA_EMISSAO) AS ANO
			 , SUM(VLR_TOTAL) AS TOT_VENDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY
 CODVEN , MONTH(DATA_EMISSAO)
		, YEAR(DATA_EMISSAO)
ORDER BY 1,2,3
-------------------------------------------------------


SELECT CODVEN, [1] AS JAN, [2] AS FEV, [3] AS MAR,
 [4] AS ABRI, [5] AS MAI, [6] AS JUN,
 [7] AS JUL, [8] AS AGO, [9] AS [SET],
 [10] AS [OUT], [11] AS NOV, [12] AS DEZ
FROM (SELECT CODVEN, VLR_TOTAL, MONTH(DATA_EMISSAO) AS MES
 FROM TB_PEDIDO AS PED
 WHERE YEAR(DATA_EMISSAO) = 2014) AS DADOS
 PIVOT( SUM(VLR_TOTAL) FOR MES IN ([1], [2], [3], [4], [5], [6],
 [7], [8], [9], [10], [11], [12]) ) AS GIRO
ORDER BY 1 


--EXERCICIO
-- ACRESCENTAR O CAMPO NOME DO VENDEDOR

SELECT CODVEN, NOME, [1] AS JAN, [2] AS FEV, [3] AS MAR,
 [4] AS ABRI, [5] AS MAI, [6] AS JUN,
 [7] AS JUL, [8] AS AGO, [9] AS [SET],
 [10] AS [OUT], [11] AS NOV, [12] AS DEZ
FROM (SELECT P.CODVEN, V.NOME, P.VLR_TOTAL, MONTH(P.DATA_EMISSAO) AS
MES
 FROM TB_PEDIDO P JOIN TB_VENDEDOR V ON P.CODVEN = V.CODVEN
 WHERE YEAR(P.DATA_EMISSAO) = 2014) P
 PIVOT( SUM(VLR_TOTAL) FOR MES IN ([1],[2],[3],[4],[5],[6],[7],
[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1


  SELECT * 
 FROM TB_ITENSPEDIDO
 --CRIAR UMA CONSULTA PARA RETORNAR O TOTAL PEDIDO (VLR_TOTAL) POR CLIENTE
 --NO ANO DE 2014 NOS DESES DE JAN A DEZ

 SELECT CODCLI, NOME, [1] AS JAN, [2] AS FEV, [3] AS MAR,
							 [4] AS ABRI, [5] AS MAI, [6] AS JUN,
                             [7] AS JUL, [8] AS AGO, [9] AS [SET],
                             [10] AS [OUT], [11] AS NOV, [12] AS DEZ
FROM (SELECT CLI.CODCLI, CLI.NOME, PED.VLR_TOTAL, PED.DATA_EMISSAO AS MES
 FROM TB_PEDIDO AS PED
 INNER JOIN TB_VENDEDOR AS VEND
 ON VEND.CODVEN = PED.CODVEN
 WHERE YEAR(DATA_EMISSAO) = 2014) AS DADOS
 PIVOT( SUM (VLR_TOTAL) FOR MES IN ([1], [2], [3], [4], [5], [6],
									[7], [8], [9], [10], [11], [12]) ) AS GIRO;



--que frequentam o cinema, em diferentes sess�es (hor�rios), em cada dia da semana:
CREATE TABLE FREQ_CINEMA
( DIA_SEMANA TINYINT,
 SEC_14HS INT,
 SEC_16HS INT,
 SEC_18HS INT,
 SEC_20HS INT,
 SEC_22HS INT )


 INSERT FREQ_CINEMA VALUES ( 1, 80, 100, 130, 90, 70 )
INSERT FREQ_CINEMA VALUES ( 2, 20, 34, 75, 50, 30 )
INSERT FREQ_CINEMA VALUES ( 3, 25, 40, 80, 70, 25 )
INSERT FREQ_CINEMA VALUES ( 4, 30, 45, 70, 50, 30 )
INSERT FREQ_CINEMA VALUES ( 5, 35, 40, 60, 60, 40 )
INSERT FREQ_CINEMA VALUES ( 6, 25, 34, 70, 90, 110 )
INSERT FREQ_CINEMA VALUES ( 7, 30, 80, 130, 150, 180 )
SELECT * FROM FREQ_CINEMA

SELECT DIA_SEMANA, HORARIO, QTD_PESSOAS
FROM
(
SELECT DIA_SEMANA, SEC_14HS, SEC_16HS, SEC_18HS, SEC_20HS, SEC_22HS
FROM FREQ_CINEMA
) P
UNPIVOT ( QTD_PESSOAS FOR HORARIO IN (SEC_14HS, SEC_16HS, SEC_18HS,
SEC_20HS, SEC_22HS)) AS UP


SELECT NUM_PEDIDO, MONTH( DATA_EMISSAO ) AS MES,
	   YEAR( DATA_EMISSAO ) AS ANO,
       MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO), NUM_PEDIDO
ORDER BY 1;
----------------------------------

WITH CTE( MES, ANO, MAIOR_PEDIDO )
AS
(
-- Membro �ncora
SELECT MONTH( DATA_EMISSAO ) AS MES,
 YEAR( DATA_EMISSAO ) AS ANO,
 MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
)
-- Utiliza��o da CTE fazendo JOIN com a tabela TB_PEDIDO
SELECT CTE.MES, CTE.ANO, CTE.MAIOR_PEDIDO, P.NUM_PEDIDO
FROM CTE JOIN TB_PEDIDO P ON CTE.MES = MONTH(P.DATA_EMISSAO) AND
 CTE.ANO = YEAR(P.DATA_EMISSAO) AND
 CTE.MAIOR_PEDIDO = P.VLR_TOTAL; ----------------------------------------------------- ------CTE----------- WITH BUSCAPED( MES, ANO, MAIOR_PEDIDO ) AS (SELECT MONTH( DATA_EMISSAO ) AS MES,
		 YEAR( DATA_EMISSAO ) AS ANO,
		 MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
)SELECT BUSCAPED.MES,	   BUSCAPED.ANO,	   BUSCAPED.MAIOR_PEDIDO,		TB_PEDIDO.NUM_PEDIDOFROM BUSCAPEDINNER JOIN TB_PEDIDO AS PEDON BUSCAPED.MES=MONTH(TB_PEDIDO.DATA_EMISSAO)AND BUSCAPED.ANO=YEAR(TB_PEDIDO.DATA_EMISSAO)AND BUSCAPED.MAIOR_PEDIDO=TB_PEDIDO.VLR_TOTALSELECT * FROM TB_PEDIDO------------CTE RECURSIVO----------------------------------------WITH CONTADOR ( N )
AS
(
-- Membro �ncora
 SELECT 1
 UNION ALL
 -- Membro recursivo
 SELECT N+1 FROM CONTADOR WHERE N < 100
)
-- Execu��o da CTE
SELECT * FROM CONTADOR;--------------------CROSS APPLY----------SELECT C.CODCLI, C.NOME,P.NUM_PEDIDO,P.VLR_TOTAL, P.DATA_EMISSAO,
(SELECT COUNT(*) FROM TB_PEDIDO
WHERE CODCLI = C.CODCLI) AS QTD_PED,	(SELECT MAX(VLR_TOTAL) FROM TB_PEDIDO
WHERE CODCLI = C.CODCLI) AS MAIOR_VALOR,
(SELECT MIN(VLR_TOTAL) FROM TB_PEDIDO
WHERE CODCLI = C.CODCLI) AS MENOR_VALOR,
(SELECT MAX(DATA_EMISSAO) FROM TB_PEDIDO
WHERE CODCLI = C.CODCLI) AS ULTIMA_COMPRA
FROM TB_CLIENTE AS C
JOIN TB_PEDIDO AS P ON P.CODCLI = C.CODCLI
ORDER BY C.CODCLI,P.NUM_PEDIDO


------


SELECT C.CODCLI,C.NOME,P.NUM_PEDIDO,P.VLR_TOTAL, P.DATA_EMISSAO,
 CR.QTD_PED, CR.MAIOR_VALOR , CR.MENOR_VALOR ,
 CR.DATAMAXIMA
FROM TB_CLIENTE AS C
 JOIN TB_PEDIDO AS P ON P.CODCLI = C.CODCLI
CROSS APPLY
( SELECT COUNT(*) AS QTD_PED,
 MAX(VLR_TOTAL) AS MAIOR_VALOR,
 MIN(VLR_TOTAL) AS MENOR_VALOR,
 MAX(DATA_EMISSAO) AS DATAMAXIMA
FROM TB_PEDIDO AS P
WHERE C.CODCLI = P.CODCLI ) AS CR
ORDER BY C.CODCLI,P.NUM_PEDIDO



-----------OUTER APPLY----------

SELECT D.DEPTO , E.NOME
FROM TB_DEPARTAMENTO AS D
LEFT JOIN TB_EMPREGADO AS E ON E.COD_DEPTO = D.COD_DEPTO
ORDER BY 2


SELECT D.DEPTO , CA.NOME
FROM TB_DEPARTAMENTO AS D
OUTER APPLY
(SELECT E.NOME FROM TB_EMPREGADO AS E WHERE E.COD_DEPTO = D.COD_DEPTO ) AS CA
ORDER BY 2