-- Anexa o banco Pedidos
EXEC sp_attach_db 
 @dbname    = 'PEDIDOS',   
 @filename1 = 'c:\Dados\PEDIDOS_TABELAS.mdf', 
 @filename2 = 'c:\Dados\PEDIDOS_INDICES.ndf', 
 @filename3 = 'c:\Dados\PEDIDOS_log.ldf'


USE PEDIDOS;

 --Exemplo 1
 --c�digo adiante consulta os funcion�rios do departamento de c�digo 2 que ganham acima de 5000 reais:

SELECT * FROM TB_EMPREGADO 
WHERE COD_DEPTO = 2 AND SALARIO > 5000

--Exemplo 2
--o c�digo adiante consulta os funcion�rios do departamento de c�digo 2 ou (OR) aqueles que ganham acima de 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE COD_DEPTO = 2 OR SALARIO > 5000

--Exemplo 3
--O c�digo adiante consulta os funcion�rios com sal�rio entre 3000 e 5000 reais:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO >= 3000 AND SALARIO <= 5000
ORDER BY SALARIO


--O c�digo a seguir pratica a mesma consulta feita pelo c�digo anterior. A diferen�a � que aqui utilizamos a palavra BETWEEN em vez de >= e <=:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO BETWEEN 3000 AND 5000
ORDER BY SALARIO

--Exemplo 4
--A instru��o SELECT a seguir consulta os funcion�rios com sal�rio abaixo de 3000 ou acima de 5000 reais:
SELECT * FROM TB_EMPREGADO
WHERE SALARIO < 3000 OR SALARIO > 5000
ORDER BY SALARIO

--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o SELECT a seguir:

SELECT * FROM TB_EMPREGADO
WHERE SALARIO NOT BETWEEN 3000 AND 5000
ORDER BY SALARIO

--Exemplo 5
--O exemplo a seguir consulta os funcion�rios admitidos no ano 2000:

SELECT * FROM TB_Empregado
WHERE DATA_ADMISSAO BETWEEN '2000.1.1' AND '2000.12.31'
ORDER BY DATA_ADMISSAO

--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o SELECT a seguir:

SELECT * FROM TB_Empregado
WHERE YEAR(DATA_ADMISSAO) = 2000
ORDER BY DATA_ADMISSAO

--Exemplo 6
--A instru��o SELECT adiante consulta os funcion�rios cujo nome seja iniciado por MARIA:
SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE 'MARIA%'

--Exemplo 7
--A instru��o SELECT adiante consulta os funcion�rios cujo nome contenha SOUZA:
SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%SOUZA%'

--Exemplo 8
--A instru��o SELECT a seguir consulta os funcion�rios cujo nome contenha SOUZA ou SOUSA:
SELECT * FROM TB_EMPREGADO
WHERE NOME LIKE '%SOU[SZ]A%'

--Exemplo 9
--A instru��o SELECT a seguir consulta os clientes dos estados do Amazonas, Paran�, Rio de Janeiro e S�o Paulo:
SELECT NOME, ESTADO FROM TB_CLIENTE
WHERE ESTADO IN ('AM', 'PR', 'RJ', 'SP')

--Exemplo 10
--Para sabermos a quantidade de dias desde que cada funcion�rio foi admitido, utilizamos a instru��o SELECT com a fun��o de data GETDATE():
SELECT CODFUN, NOME, 
       CAST(GETDATE() - DATA_ADMISSAO AS INT) AS DIAS_NA_EMPRESA
FROM TB_EMPREGADO

--Exemplo 11
--Vejamos como utilizar o SELECT com outras fun��es de data. No c�digo a seguir, filtramos os funcion�rios admitidos em uma sexta-feira:

SELECT 
  CODFUN, NOME, DATA_ADMISSAO, 
  DATENAME(WEEKDAY,DATA_ADMISSAO) AS DIA_SEMANA,
  DATENAME(MONTH,DATA_ADMISSAO) AS MES
FROM TB_EMPREGADO
WHERE DATEPART(WEEKDAY, DATA_ADMISSAO) = 6

--Exemplo 12
--O c�digo adiante consulta duas tabelas na mesma instru��o SELECT:

SELECT  
  TB_EMPREGADO.CODFUN, TB_EMPREGADO.NOME, 
  TB_EMPREGADO.COD_DEPTO, TB_EMPREGADO.COD_CARGO, 
  TB_DEPARTAMENTO.DEPTO
FROM TB_EMPREGADO
  JOIN TB_DEPARTAMENTO ON TB_EMPREGADO.COD_DEPTO = TB_DEPARTAMENTO.COD_DEPTO

--A escrita do c�digo anterior pode ser simplificada se utilizarmos alias para os nomes das tabelas:

SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO

--Exemplo 13
--O c�digo a seguir consulta tr�s tabelas na mesma instru��o SELECT:
SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO, C.CARGO
FROM TB_EMPREGADO E
  JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO
  JOIN TB_CARGO C ON E.COD_CARGO = C.COD_CARGO;

--A mesma consulta do c�digo anterior pode ser feita da maneira mostrada a seguir:
SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO, C.CARGO
FROM TB_DEPARTAMENTO D
  JOIN TB_EMPREGADO E ON E.COD_DEPTO = D.COD_DEPTO
  JOIN TB_CARGO C ON E.COD_CARGO = C.COD_CARGO;

--Tamb�m podemos utilizar uma terceira maneira para realizar a mesma consulta anterior:
SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO, C.CARGO
FROM TB_CARGO C
  JOIN TB_EMPREGADO E ON E.COD_CARGO = C.COD_CARGO
  JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO;

--Exemplo 14
--A instru��o SELECT a seguir consulta os funcion�rios que n�o constam em departamento algum:
SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO
FROM TB_EMPREGADO E 
     LEFT JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO  
WHERE D.COD_DEPTO IS NULL

--Exemplo 15
--A instru��o SELECT a seguir consulta os departamentos sem funcion�rios:
SELECT  
  E.CODFUN, E.NOME, E.COD_DEPTO, E.COD_CARGO, D.DEPTO
FROM TB_EMPREGADO E 
     RIGHT JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO  
WHERE E.COD_DEPTO IS NULL

--O mesmo resultado do c�digo anterior pode ser obtido com a instru��o a seguir:
SELECT * FROM TB_DEPARTAMENTO
WHERE COD_DEPTO NOT IN (SELECT DISTINCT COD_DEPTO FROM TB_EMPREGADO WHERE COD_DEPTO IS NOT NULL)

--Exemplo 16
--A instru��o a seguir consulta os clientes que compraram em janeiro de 2015:
SELECT * FROM TB_CLIENTE
WHERE CODCLI IN (SELECT CODCLI FROM TB_PEDIDO
                 WHERE CODCLI = TB_CLIENTE.CODCLI AND
                       DATA_EMISSAO BETWEEN '2015.1.1' AND 
                                            '2015.1.31')  

--Exemplo 17
--O c�digo a seguir soma os sal�rios de cada departamento:
SELECT E.COD_DEPTO, D.DEPTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO
GROUP BY E.COD_DEPTO, D.DEPTO
ORDER BY TOT_SAL

--Exemplo 18
--A instru��o a seguir consulta os departamentos que gastam mais de 15000 reais em sal�rios:
SELECT E.COD_DEPTO, D.DEPTO, SUM( SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO
GROUP BY E.COD_DEPTO, D.DEPTO
   HAVING SUM(E.SALARIO) > 15000
ORDER BY TOT_SAL

--Exemplo 19
--A instru��o SELECT a seguir consulta os cinco departamentos que mais gastam com sal�rios:
SELECT TOP 5 E.COD_DEPTO, D.DEPTO, SUM( E.SALARIO ) AS TOT_SAL
FROM TB_EMPREGADO E
     JOIN TB_DEPARTAMENTO D ON E.COD_DEPTO = D.COD_DEPTO
GROUP BY E.COD_DEPTO, D.DEPTO
ORDER BY TOT_SAL DESC


--2.2.	IIF/CHOOSE

DECLARE @a INT = 15, @b INT = 10;
SELECT IIF( @a>@b, 'VERDADEIRO', 'FALSO') AS Resultado


DECLARE @indice INT = 4;
SELECT CHOOSE (@indice/2, 1, 2, 3) AS Resultado


USE PEDIDOS

SELECT CODFUN, NOME, DATA_ADMISSAO,
-- Substitui o S por SIM e o N por N�O
       IIF(SINDICALIZADO = 'S', 'SIM', 'N�O') AS SINDICALIZADO,
	-- Pega o n�mero do dia da semana e devolve o nome que 
     -- est� na posi��o correspondente
	   CHOOSE(DATEPART(WEEKDAY, DATA_ADMISSAO),
                'DOMINGO', 'SEGUNDA','TER�A','QUARTA','QUINTA','SEXTA','S�BADO')
 AS DIA_SEMANA
FROM TB_EMPREGADO


--2.3.	LAG e LEAD

SELECT CODFUN, NOME, SALARIO, 
LAG(SALARIO,1, 0) OVER (ORDER BY CODFUN) AS SALARIO_ANTERIOR,
LEAD(SALARIO,1, 0) OVER (ORDER BY CODFUN) AS PROXIMO_SALARIO
FROM TB_EMPREGADO
ORDER BY CODFUN

--2.4. Pagina��o (FETCH e OFFSET)

SELECT * FROM TB_CLIENTE
ORDER BY CODCLI
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;

-- seleciona os pr�ximos 20 clientes
SELECT * FROM TB_CLIENTE
ORDER BY CODCLI
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY;


DECLARE @OFFSET INT = 0, @FETCH INT = 20;
SELECT * FROM TB_CLIENTE
ORDER BY CODCLI
OFFSET @OFFSET ROWS FETCH NEXT @FETCH ROWS ONLY;
