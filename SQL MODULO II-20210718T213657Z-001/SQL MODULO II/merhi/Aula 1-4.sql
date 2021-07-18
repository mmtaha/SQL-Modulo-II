use master
exec sp_attach_db
@dbname		='Pedidos',
@filename1='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_tabelas.mdf',
@filename2='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_indices.ndf',
@filename3='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Pedidos_log.ldf'

exec sp_databases
exec sp_helpdb
select * from sys.databases
use pedidos

use pedidos
select * from tb_empregado where cod_depto=2 and salario>5000
select * from tb_empregado where cod_depto=2 or salario>5000
select * from tb_empregado where salario>=3000 and  salario<=5000 order by Salario
select * from tb_empregado where salario between 3000 and 5000 order by Salario
select * from tb_empregado where salario<3000 or salario>5000 order by Salario
select * from tb_empregado where salario not between 3000 and 5000 order by Salario
select * from tb_empregado where data_admissao between '2000.1.1' and '2000.12.31'
select * from tb_empregado where year(data_admissao)=2000 order by data_admissao
select * from tb_empregado where nome like 'Maria%'
select * from tb_empregado where nome like '%souza%'
select * from tb_empregado where nome like '%sou[sz]a%'
select nome, estado from tb_cliente where estado in ('am','pr','rj','sp')
select codfun, nome, cast(getdate()-data_admissao as int) as DiasNaEmpresa from tb_empregado
----------------------------
select	codfun, nome,data_admissao,
		datename(weekday,data_admissao) as DiaSemana,
		datename(month,data_admissao) as MesAdmissao
from tb_empregado 
where datepart(weekday,data_admissao)=6
--------------------------------------------
select
	tb_empregado.codfun,
	tb_empregado.cod_depto,
	tb_empregado.cod_cargo,
	tb_departamento.depto
from tb_empregado inner join tb_departamento 
     on tb_empregado.cod_depto=tb_departamento.cod_depto
--------------------------------------------
select
	e.codfun,
	e.cod_depto,
	e.cod_cargo,
	d.depto
from tb_empregado E inner join tb_departamento D
     on e.cod_depto=d.cod_depto
--------------------------------------------
select
	e.codfun,
	e.cod_depto,
	e.cod_cargo,
	d.depto,
	c.cargo

	select * into #empre from TB_EMPREGADO

select Nome,Data_Admissao,Salario into EmpreCopia
From Pedidos.dbo.TB_EMPREGADO

insert into EmpreCopia Select Nome,Data_admissao,Salario
From Pedidos.dbo.TB_EMPREGADO

Use Teste
Select * into CopiaTeste From Pedidos.dbo.TB_CLIENTE
Use Pedidos
Select * From Teste.dbo.CopiaTeste

select
codfun,
nome,
data_admissao,
	iif (sindicalizado='s','SIM','NAO') AS Sindicalizado
from TB_EMPREGADO

select
	Num_depend,
	Choose(num_depend,'Um Só','Dois','tres','Exagero') as Situaçao
from TB_EMPREGADO where NUM_DEPEND <>0

Select DATEPART (WEEKDAY,data_emissao) From TB_PEDIDO
Select
	   Choose (DATEPART (WEEKDAY,data_emissao),
	   'Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sabado') as Dia_Semana
From TB_PEDIDO

SELECT CODFUN, NOME, SALARIO,
LAG(SALARIO,1, 0) OVER (ORDER BY CODFUN) AS SALARIO_ANTERIOR,
LEAD(SALARIO,1, 0) OVER (ORDER BY CODFUN) AS PROXIMO_SALARIO
FROM TB_EMPREGADO
ORDER BY CODFUN


Select 
	year(data_emissao) as Ano, 
	sum(Vlr_total) as Faturamento 
	into FaturamentoAnual
from tb_Pedido
group by year(data_emissao) 
------
select	Ano, 
		Faturamento, 
		lag(faturamento,1,0) over (order by ano) As AnoAnterior,
		Faturamento/iif(lag(faturamento,1,0) over (order by ano)=0,null,lag(faturamento,1,0) over (order by ano)) as Indice
from faturamentoanual order by ano 

-- 1) A partir do 10º registro, selecione 
--    os próximos 15 clientes
select * from tb_cliente order by codcli 
offset 10 rows fetch next 15 rows only

-- 2)
declare @Deslocamento int = 0
declare @Qtlinhas int = 10
select * from tb_cliente order by codcli
offset @Deslocamento rows fetch next @Qtlinhas rows only

-- 3)
DECLARE @OFFSET INT = 0, @FETCH INT = 20;
SELECT * FROM TB_CLIENTE
ORDER BY CODCLI
OFFSET @OFFSET ROWS FETCH NEXT @FETCH ROWS ONLY;



SELECT * FROM TB_EMPREGADO
WHERE SALARIO < 3000 AND SALARIO > 5000
ORDER BY SALARIO