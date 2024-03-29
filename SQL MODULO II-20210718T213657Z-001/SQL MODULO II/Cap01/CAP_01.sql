SELECT * FROM sys.objects;

USE PEDIDOS

-- TABELAS DE SISTEMA
-- Armazena todos os objetos do banco de dados
SELECT * FROM SYSOBJECTS
-- Tabelas de usu�rios
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'U'
-- Chaves prim�rias
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'PK'
-- Tabelas e suas chaves prim�rias
SELECT T.NAME AS TABELA, PK.NAME AS CHAVE_PRIMARIA
FROM SYSOBJECTS T JOIN SYSOBJECTS PK ON T.id = PK.parent_obj
WHERE T.xtype = 'U'

-- Colunas existentes nas tabelas do banco de dados
SELECT * FROM SYSCOLUMNS -- Observe a coluna ID
-- Colunas das tabelas do banco de dados
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
WHERE T.XTYPE = 'U'

-- Colunas de uma tabela do banco de dados
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
WHERE T.XTYPE = 'U' AND T.name = 'TB_PEDIDO'

-- Mostrar tamb�m o tipo de cada coluna
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS, C.xtype, DT.NAME
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
                  JOIN SYSTYPES DT ON C.xtype = DT.xtype
WHERE T.XTYPE = 'U' AND T.name = 'TB_PEDIDO'

-- Mais informa��es sobre a estrutura da tabela
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS, C.xtype, DT.NAME,
      C.length AS BYTES, C.xprec AS PRECISAO, C.xscale AS DECIMAIS
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
                  JOIN SYSTYPES DT ON C.xtype = DT.xtype
WHERE T.XTYPE = 'U' AND T.name = 'TB_PEDIDO'


-- Exemplo de views de cat�logo

-- VIEWS DE CAT�LOGO
-- tabelas de usu�rio
SELECT * FROM sys.tables
-- colunas de cada tabela
SELECT * FROM sys.columns
-- tipos de dados
SELECT * FROM sys.types
-- �ndices
SELECT * FROM SYS.indexes
-- campos identidade
SELECT * FROM sys.identity_columns 
-- chaves �nicas e chaves prim�rias
SELECT * FROM sys.key_constraints


-- Exemplo de procedures de cat�logo

-- PROCEDURES DE CAT�LOGO
-- tabelas do banco de dados
exec sp_tables
-- colunas de uma tabela
exec sp_columns tb_pedido
-- Campos que formam a chave prim�ria de uma tabela
exec sp_pkeys TB_ITENSPEDIDO
-- Estrutura de uma tabela
exec sp_help TB_PEDIDO
