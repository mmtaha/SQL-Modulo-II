create database  DB_Aula_Impacta
use DB_Aula_Impacta
create database DB_Aula_Impacta
on ( name = 'Aula_Impacta_Cadastros',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Aula_Impacta_Cadastro.mdf',
		size = 5,
		maxsize = 100,
		filegrowth = 5),
filegroup Vendas
( name = 'Aula_Impacta_Vendas',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Aula_Impacta_Vendas.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5),
filegroup Compras
 ( name = 'Aula_Impacta_Compras',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Aula_Impacta_Compras.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5),
filegroup Financeiro
 ( name = 'Aula_Impacta_Financeiro',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Aula_Impacta_Financeiro.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5)
Log on
	(name = Aula_Impacta_log,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Aula_Impacta_log.ldf')

	select * from SysObjects
	select * from sysobjects where type='U'
	select * from syscolumns
	select * from sys.tables
	select * from sys.columns
	select * from sys.types
	select * from sys.indexes
	select * from sys.identity_columns

	--A – Criação de banco de dados
--3. Crie um banco de dados de nome DB_Aula_Impacta;
CREATE DATABASE DB_Aula_Impacta
--4. Coloque o banco de dados em uso;
USE DB_Aula_Impacta
--B – Consulta de objetos do Servidor
--1. Através de funções, procedures, views ou tabelas,
retorne as informações abaixo:
--- Nome do banco
SELECT DB_NAME() AS NOME_DO_BANCO
--- Lista dos arquivos do banco de dados
EXEC SP_HELPFILE
--- Liste os objetos do banco de dados
SELECT * FROM SYSOBJECTS
--- Lista dos logins
EXEC SP_HELPLOGINS

Laboratório 3 do Capítulo 1
--A – Utilizando os objetos de catálogo
--1. Através de funções, procedures, views ou tabelas,
retorne as informações abaixo:
--- Liste as tabelas de usuário do banco de dados
SELECT * FROM SYSOBJECTS WHERE XTYPE ='U'
--OU
SELECT * FROM SYS.TABLES
--- Liste os campos da tabela TB_CLIENTE
SELECT * FROM SYSCOLUMNS WHERE OBJECT_NAME(ID) = 'TB_CLIENTE'
--ou
EXEC SP_HELP TB_CLIENTE
-- Apresente os objetos do Tipo = 'V'
SELECT * FROM SYSOBJECTS WHERE XTYPE='V'
-- Verifique a estrutura da tabela TB_Pedido
EXEC SP_HELP TB_Pedido

select * from tb_empregado where cod_depto=2 and salario>5000 AND
 (DATA_EMISSAO BETWEEN '2014.1.1' AND
 '2014.1.31')
 
 SELECT * FROM TB_ITENSPEDIDO
WHERE DESCONTO > 7 AND DATA_ENTREGA BETWEEN '2013.1.1' AND
 '2013.1.31'
ORDER BY DESCONTO

--6. Calcule o valor total vendido (soma de TB_PEDIDO.VLR_TOTAL) e o valor da
--comissão (soma de TB_PEDIDO.VLR_TOTAL * TB_VENDEDOR.PORC_COMISSAO
--/100) de cada vendedor em janeiro de 2014;

SELECT * FROM TB_PEDIDO


/*
6. Calcule o valor total vendido (soma de PEDIDOS.VLR_
TOTAL) e o valor da comissão
(soma de PEDIDOS.VLR_TOTAL * VENDEDORES.PORC_COMISSAO/100)
de cada vendedor em janeiro de 2014;
*/
SELECT V.CODVEN, V.NOME,
SUM(P.VLR_TOTAL) AS TOT_VENDIDO,
SUM(P.VLR_TOTAL * V.PORC_COMISSAO / 100) AS COMISSAO
FROM TB_PEDIDO P
JOIN TB_VENDEDOR V ON P.CODVEN = V.CODVEN
WHERE P.DATA_EMISSAO BETWEEN '2014.1.1' AND '2014.1.31'
GROUP BY V.CODVEN, V.NOME
-- 7. Liste os nomes e o total comprado pelos 10 clientes que
mais compraram em janeiro de 2014;
SELECT TOP 10
C.CODCLI, C.NOME, SUM(P.VLR_TOTAL) AS TOT_COMPRADO
FROM TB_PEDIDO P
JOIN TB_CLIENTE C ON P.CODCLI = C.CODCLI
WHERE P.DATA_EMISSAO BETWEEN '2014.1.1' AND '2014.1.31'
GROUP BY C.CODCLI, C.NOME
ORDER BY TOT_COMPRADO DESC
-- 8. Liste os nomes dos clientes que não compraram em janeiro
de 2014;
SELECT * FROM TB_CLIENTE
WHERE CODCLI NOT IN
(
SELECT DISTINCT CODCLI FROM TB_PEDIDO
WHERE DATA_EMISSAO BETWEEN '2014.1.1' AND '2014.1.31'
)
ORDER BY NOME


Laboratório 1 do Capítulo 2
-- 9. Reajuste os preços de venda de todos os produtos com
COD_TIPO = 5 de modo que fiquem 20% acima do preço de custo;
UPDATE TB_PRODUTO SET PRECO_VENDA = PRECO_CUSTO * 1.2
WHERE COD_TIPO = 5
/*
10. Reajuste os preços de venda de todos os produtos com
descrição do tipo igual a REGUA,
de modo que fiquem 40% acima do preço de custo;
*/
UPDATE TB_PRODUTO SET PRECO_VENDA = PRECO_CUSTO * 1.4
FROM TB_PRODUTO P JOIN TB_TIPOPRODUTO T ON P.COD_TIPO = T.COD_
TIPO
WHERE T.TIPO = 'REGUA'
-- OU
UPDATE TB_PRODUTO SET PRECO_VENDA = PRECO_CUSTO * 1.4
WHERE COD_TIPO = (SELECT COD_TIPO FROM TB_TIPOPRODUTO
WHERE TIPO = 'REGUA')



