--A – Trabalhando com opções adicionais e com o comando MERGE
--1. Coloque em uso o banco de dados PEDIDOS;
--2. Gere uma cópia da tabela TB_PRODUTO chamada PRODUTOS_COPIA;
--3. Exclua da tabela PRODUTOS_COPIA os produtos que sejam do tipo ‘CANETA’,
--exibindo os registros que foram excluídos (OUTPUT);
--4. Aumente em 10% os preços de venda dos produtos do tipo REGUA, mostrando com
--OUTPUT as seguintes colunas: ID_PRODUTO, DESCRICAO, PRECO_VENDA_ANTIGO
--e PRECO_VENDA_NOVO;
--5. Utilizando o comando MERGE, faça com que a tabela PRODUTOS_COPIA volte
--a ser idêntica à tabela TB_PRODUTO, ou seja, o que foi deletado de PRODUTOS_
--COPIA deve ser reinserido, e os produtos que tiveram seus preços alterados devem
--ser alterados novamente para que voltem a ter o preço anterior. O MERGE deve
--possuir uma cláusula OUTPUT que mostre as seguintes colunas: ação executada
--pelo MERGE (DELETE, INSERT, UPDATE), ID_PRODUTO, PRECO_VENDA_ANTIGO,
--PRECO_VENDA_NOVO.


--
--1. Coloque em uso o banco de dados PEDIDOS;
--2. Gere uma cópia da tabela TB_PRODUTO chamada PRODUTOS_COPIA;
USE TB_PEDIDOS

SELECT * INTO PRODUTOS_COPIA

FROM TB_PRODUTO

SELECT * FROM PRODUTOS_COPIA

--3. Exclua da tabela PRODUTOS_COPIA os produtos que sejam do tipo ‘CANETA’,

DELETE FROM PRODUTOS_COPIA
OUTPUT DELETED.*
WHERE DESCRICAO LIKE ' CANETA'

WHERE TB_TIPOPRODUTO T ON P.COD_TIPO
WHEW T.TIPO = 'CANETA'

SELECT * 
FROM TB_PRODUTO


--4. Aumente em 10% os preços de venda dos produtos do tipo REGUA, mostrando com
--OUTPUT as seguintes colunas: ID_PRODUTO, DESCRICAO, PRECO_VENDA_ANTIGO
--e PRECO_VENDA_NOVO;



--5. Utilizando o comando MERGE, faça com que a tabela PRODUTOS_COPIA volte
--a ser idêntica à tabela TB_PRODUTO, ou seja, o que foi deletado de PRODUTOS_
--COPIA deve ser reinserido, e os produtos que tiveram seus preços alterados devem
--ser alterados novamente para que voltem a ter o preço anterior. O MERGE deve
--possuir uma cláusula OUTPUT que mostre as seguintes colunas: ação executada
--pelo MERGE (DELETE, INSERT, UPDATE), ID_PRODUTO, PRECO_VENDA_ANTIGO,
--PRECO_VENDA_NOVO


MERGE PRODUTOS_COPIA AS PC
USING TB_PRODUTO AS P
ON PC.ID_PRODUTO=P.ID_PRODUTO
WHEN MATCHED AND PC.PRECO_VENDA<>P.PRECO_VENDA THEN
UPDATE SET PC.PRECO_VENDA=P.PRECO_VENDA

WHEN NOT MATCHED THEN

 INSERT (ID_PRODUTO, COD_PRODUTO,DESCRICAO,COD_UNIDADE,
		  COD_TIPO, PRECO_CUSTO,PRECO_VENDA,QTD_ESTIMADA,
		  QTD_REAL, QTD_MINIMA,CLAS_FISC, IPI)
 VALUES (ID_PRODUTO, COD_PRODUTO,DESCRICAO,COD_UNIDADE,
		  COD_TIPO, PRECO_CUSTO,PRECO_VENDA,QTD_ESTIMADA,
		  QTD_REAL, QTD_MINIMA,CLAS_FISC, IPI);

 SELECT * FROM TB_PRODUTO
 WHERE COD_CARGO =3

 SET IDENTITY_INSERT EMP_TEMP OFF


 