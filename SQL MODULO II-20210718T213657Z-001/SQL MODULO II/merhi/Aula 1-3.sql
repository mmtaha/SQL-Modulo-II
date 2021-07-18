-- 2.1) Select (pág 38)
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
from tb_empregado E 
	inner join tb_departamento D on e.cod_depto=d.cod_depto
	inner join tb_cargo C on e.cod_cargo=c.cod_cargo
--------------------------------------------
select	e.codfun,
		e.nome,
		e.cod_depto,
		e.cod_cargo,
		d.depto 
from tb_empregado E right join tb_departamento D 
		on e.cod_depto=d.cod_depto where e.cod_depto is null
--------------------------------------------
select * from tb_departamento where cod_depto not in 
	(select distinct cod_depto from tb_empregado where cod_depto is not null)
--------------------------------------------
set dateformat YMD
select * from tb_cliente where codcli in
	(select codcli from tb_pedido where codcli=tb_cliente.codcli and 
										data_emissao between '2005.1.1' 
										and '2015.1.31')
--------------------------------------------
select	e.cod_depto,
		d.depto,
		sum(salario) as TotSal
from tb_empregado E inner join tb_departamento D 
on e.cod_depto=d.cod_depto 
group by e.cod_depto, d.Depto 
having sum(e.salario)>15000 order by TotSal
--------------------------------------------
select top 5 
	e.cod_depto,
	d.depto,
	sum(e.salario) as TotSal 
from tb_empregado e inner join tb_departamento D 
on e.cod_depto=d.cod_depto 
group by e.cod_depto,d.depto 
order by TotSal desc