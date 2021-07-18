use master

create database teste

exec sp_databases

use master 
create database Empresa3
on ( name = 'Empresa3_Cadastros',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Empresa3_Cadastro.mdf',
		size = 5,
		maxsize = 100,
		filegrowth = 5),
filegroup Vendas
( name = 'Empresa3_Vendas',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Empresa3_Vendas.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5),
filegroup Compras
 ( name = 'Empresa3_Compras',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Empresa3_Compras.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5),
filegroup Financeiro
 ( name = 'Empresa3_Financeiro',
		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Empresa3_Financeiro.ndf',
		size = 5,
		maxsize = unlimited,
		filegrowth = 5)
Log on
	(name = Empresa3_log,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Empresa3_log.ldf')

exec sp_databases

select * from SysObjects
select * from Sys.Objects
select * from sysobjects where type='U'
select * from syscolumns

select * from sys.tables
select * from sys.columns
select * from sys.types
select * from sys.indexes
select * from sys.identity_columns

exec sp_tables
exec sp_columns tb_Pedido
exec sp_pkeys tb_ItensPedido
exec sp_Help tb_Pedido

select 
	host_name() as NomeServidorRede, 
	host_id() as IdServidor, 
	current_user as UsuarioAtual,
	@@servername as NomeInstancia

select @@version as VersaoSQL, @@language as Linguagem, @@max_connections as QtdMaxConn

select @@datefirst -- Define qual será o primeiro dia da semana, de 1 a 7
select 
	sysdatetime() as [Formato datetime(2)],
    sysdatetimeoffset()  as [Formato datetimeoffset(7)],
    sysUTCdatetime() as  [Formato datetime2 UTC],
    current_timestamp as [Formato datetime],
    getdate() as [Formato datetime sem UTC], 
    getUTCdate() as [Formato datetime com UTC] 

-- UTC time: Coordinated Universal Time

select * from information_schema.tables
select * from information_schema.columns 
select * from information_schema.tables -- Lista todas as tabelas do banco
select * from information_schema.columns -- Lista todas as colunas (campos) das tabelas

-- Exemplos de composição entre as views de catálogo
select * from sys.sql_modules
select * from sys.objects

SELECT	O.name, 
	M.definition, 
	O.type_desc, 
	O.type
FROM sys.sql_modules M INNER JOIN sys.objects O 
ON M.object_id=O.object_id
WHERE O.type IN ('IF','TF','FN')

---
Select Name,type,Type_Desc From sys.objects Where type IN ('P','U','V')

-- Tabelas e suas chaves primárias
select 
	t.name as tabela, 
	pk.name as chave_primaria
from sysobjects as t inner join sysobjects as pk 
on t.id = pk.parent_obj
where t.xtype = 'u' 

-- Tabelas e suas colunas
select 
	t.name as tabela, 
	c.name as colunas
from sysobjects as t inner join syscolumns as c 
on t.id = c.id
where t.xtype = 'u'

-- Colunas da tabela tb_pedido
select 
	t.name as tabela, 
	c.name as colunas
from sysobjects as t inner join syscolumns as c 
on t.id = c.id
where t.xtype = 'u' and t.name = 'tb_pedido'

