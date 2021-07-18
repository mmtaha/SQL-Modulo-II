--  Anexar (ou registrar um banco de dados)
use master
exec sp_attach_db
@dbname		='Pedidos',
@filename1='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_tabelas.mdf',
@filename2='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_indices.ndf',
@filename3='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_log.ldf'


-- Verificação
exec sp_databases
exec sp_helpdb
select * from sys.databases
use pedidos


--Desanexar por script
use master
exec sp_detach_db 'Pedidos', 'true'
