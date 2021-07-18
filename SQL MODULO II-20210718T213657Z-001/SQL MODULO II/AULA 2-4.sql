CREATE DATABASE TESTE_UDDT

 USE TESTE_UDDT

 CREATE TYPE TIPO_NOME
FROM VARCHAR(60) NOT NULL;
CREATE TYPE TIPO_ENDERECO
FROM VARCHAR(60) NOT NULL;


---ASSOCIAR O TIPO DE DADOS AO CAMPO DA TABELA

CREATE TABLE PESSOA
(COD INT PRIMARY KEY,
NOME TIPO_NOME,
ENDERECO TIPO_ENDERECO,
CNPJ BIGINT
)

EXEC sp_help PESSOA



CREATE DATABASE TESTE_UDDT_2

 USE TESTE_UDDT_2

CREATE TYPE TYPE_NOME_PESSOA
FROM VARCHAR(40) NOT NULL;
CREATE TYPE TYPE_NOME_EMPRESA
FROM VARCHAR(60) NOT NULL;
CREATE TYPE TYPE_PRECO
FROM NUMERIC(12,2) NOT NULL;
CREATE TYPE TYPE_SN
FROM CHAR(1) NULL;
CREATE TYPE TYPE_DATA_MOVTO
FROM DATETIME NULL;


DROP TYPE TYPE_NOME_PESSOA

SELECT * 
FROM SYSTYPES
WHERE UID=1

GO
CREATE RULE R_PRECOS AS @PRECO >= 0
CREATE RULE R_SN AS @SN IN ('S','N')
CREATE RULE R_DATA_MOVTO AS @DT <= GETDATE()


SELECT * FROM SYSOBJECTS WHERE XTYPE = 'R'

SELECT R.NAME, C.TEXT
FROM SYSOBJECTS R JOIN SYSCOMMENTS C ON C.ID = R.ID
WHERE XTYPE = 'R'


---ASSOCIAR A REGRA AO TIPO DE DADOS---

EXEC sp_bindrule 'R_PRECOS', 'TYPE_PRECO'
EXEC SP_BINDRULE 'R_SN','TYPE_SN'
EXEC SP_BINDRULE 'R_DATA_MOVTO','TYPE_DATA_MOVTO'


---O TIPO DE DADOS S/N DEVE RESERVER POR DEFAULT A LETRA 'S'---

CREATE DEFAULT DEF_SN AS 'S'

----DATA_MOVTO POR DEFAULT RECEBE GETDATE()

CREATE DEFAULT DEF_DATA_MOVTO AS GETDATE()

EXEC SP_BINDEFAULT 'DEF_SN', 'TYPE_SN'
EXEC SP_BINDEFAULT 'DEF_DATA_MOVTO', 'TYPE_DATA_MOVTO'

CREATE TABLE PRODUTOS
( COD_PROD INT IDENTITY (1,1),
 DESCRICAO VARCHAR(80),
 PRECO_CUSTO TYPE_PRECO,
 PRECO_VENDA TYPE_PRECO,
 DATA_CADASTRO TYPE_DATA_MOVTO,
 SN_ATIVO TYPE_SN,
 CONSTRAINT PK_PRODUTOS PRIMARY KEY (COD_PROD) )


 ----TESTAR OS TIPOS DE DADOS-----
 INSERT INTO PRODUTOS
( DESCRICAO, PRECO_CUSTO, PRECO_VENDA )
VALUES( 'TESTE 1', 10.50, 2.58 )

INSERT INTO PRODUTOS
( DESCRICAO, PRECO_CUSTO, PRECO_VENDA, DATA_CADASTRO )
VALUES( 'TESTE 2', 10.50, 2.58, '2019/05/16' )

INSERT INTO PRODUTOS
( DESCRICAO, PRECO_CUSTO, PRECO_VENDA, DATA_CADASTRO, SN_ATIVO )
VALUES( 'TESTE 3', 0.50, 1.50, GETDATE(), 'N ')

SELECT *
FROM PRODUTOS



CREATE SEQUENCE SEQ_ALUNO
START WITH 1000
INCREMENT BY 10
MINVALUE 10
MAXVALUE 10000
CYCLE CACHE 10;


CREATE TABLE T_ALUNO
(COD_ALUNO INT,
NOM_ALUNO VARCHAR(50) )
SELECT * 
FROM T_ALUNO

---CREATE SYNONYM

CREATE SYNONYM


INSERT INTO T_ALUNO (COD_ALUNO, NOM_ALUNO)
VALUES (NEXT VALUE FOR DBO.SEQ_ALUNO, 'TESTE');

INSERT INTO T_ALUNO (COD_ALUNO, NOM_ALUNO)
VALUES (NEXT VALUE FOR DBO.SEQ_ALUNO, 'TESTE2');

USE PEDIDOS
SELECT * 
FROM TB_PRODUTO


 WITH CTE( MES, ANO, MAIOR_PEDIDO )
AS
(
-- Membro �ncora
SELECT MONTH( DATA_EMISSAO ) AS MES,
 YEAR( DATA_EMISSAO ) AS ANO,
 MAX( VLR_TOTAL ) AS MAIOR_PEDIDO
FROM TB_PEDIDO
WHERE YEAR(DATA_EMISSAO) = 2014
GROUP BY MONTH(DATA_EMISSAO), YEAR(DATA_EMISSAO)
)
-- Utiliza��o da CTE fazendo JOIN com a tabela TB_PEDIDO
SELECT CTE.MES, CTE.ANO, CTE.MAIOR_PEDIDO, P.NUM_PEDIDO
FROM CTE JOIN TB_PEDIDO P ON CTE.MES = MONTH(P.DATA_EMISSAO) AND
 CTE.ANO = YEAR(P.DATA_EMISSAO) AND
 CTE.MAIOR_PEDIDO = P.VLR_TOTAL;