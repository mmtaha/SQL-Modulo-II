use pedidos

create view vw_relat_emp
with schemabinding
as
select CODFUN, NOME, COD_CARGO, NUM_DEPEND, SALARIO

from dbo.TB_EMPREGADO

select *

from vw_relat_emp

**apagar a coluna num_depend

alter table tb_empregado
drop column num_depend