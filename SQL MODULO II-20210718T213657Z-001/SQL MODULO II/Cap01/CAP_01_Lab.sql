--Laborat�rio 1

--A � Cria��o de banco de dados


--3.	Crie um banco de dados de nome DB_Aula_Impacta;
CREATE DATABASE DB_Aula_Impacta

--4.	Coloque o banco de dados em uso;

USE DB_Aula_Impacta


--B � Consulta de objetos do Servidor

--1.	Atrav�s de fun��es, procedures, views ou tabelas, retorne as informa��es abaixo:
--- Nome do banco
SELECT DB_NAME() AS NOME_DO_BANCO

--- Lista dos arquivos do banco de dados
EXEC SP_HELPFILE

--- Liste os objetos do banco de dados 
SELECT * FROM SYSOBJECTS

--- Lista dos logins
EXEC SP_HELPLOGINS


--Laborat�rio 3

--A � Utilizando os objetos de cat�logo

--1.	Atrav�s de fun��es, procedures, views ou tabelas, retorne as informa��es abaixo:
--- Liste as tabelas de usu�rio do banco de dados
SELECT * FROM SYSOBJECTS WHERE XTYPE ='U'
--OU
SELECT * FROM SYS.TABLES


--- Liste os campos da tabela TB_CLIENTE
SELECT * FROM SYSCOLUMNS WHERE OBJECT_NAME(ID) = 'TB_CLIENTE'
--ou
EXEC SP_HELP TB_CLIENTE

-- Apresente os objetos do Tipo = �V�
SELECT * FROM SYSOBJECTS WHERE XTYPE='V'

-- Verifique a estrutura da tabela TB_Pedido
EXEC SP_HELP TB_Pedido
