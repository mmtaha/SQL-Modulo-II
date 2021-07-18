USE PEDIDOS
-- TABELAS DE SISTEMA
-- Armazena todos os objetos do banco de dados
SELECT * FROM SYSOBJECTS
-- Tabelas de usuários
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'U'
-- Chaves primárias
SELECT * FROM SYSOBJECTS WHERE XTYPE = 'PK'
-- Tabelas e suas chaves primárias
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
-- Mostrar também o tipo de cada coluna
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS, C.xtype, DT.NAME
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
 JOIN SYSTYPES DT ON C.xtype = DT.xtype
WHERE T.XTYPE = 'U' AND T.name = 'TB_PEDIDO'
-- Mais informações sobre a estrutura da tabela
SELECT T.NAME AS TABELA, C.NAME AS COLUNAS, C.xtype, DT.NAME,
 C.length AS BYTES, C.xprec AS PRECISAO, C.xscale AS DECIMAIS
FROM SYSOBJECTS T JOIN SYSCOLUMNS C ON T.id = C.id
 JOIN SYSTYPES DT ON C.xtype = DT.xtype
WHERE T.XTYPE = 'U' AND T.name = 'TB_PEDIDO'