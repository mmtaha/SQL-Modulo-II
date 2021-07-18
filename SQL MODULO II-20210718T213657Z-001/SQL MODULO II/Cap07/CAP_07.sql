-- 1. Declara��o de vari�veis
DECLARE @A INT = 10;
DECLARE @B INT = 20;
PRINT @A + @B
-- OU ENT�O
DECLARE @A INT = 10, @B INT = 20;
PRINT @A + @B

-- 2. Atribui��o com SET
DECLARE @A INT = 10, @B INT = 20, @C INT;
SET @C = @A + @B;
PRINT @C;
-- OU ENT�O
DECLARE @A INT, @B INT, @C INT;
SET @A = 10;
SET @B = 20;
SET @C = @A + @B;
PRINT @C;

--Tamb�m � poss�vel realizar a opera��o a partir da instru��o SELECT

DECLARE @A INT

SELECT @A = 3

SELECT @A AS Valor

-- Instru��o IF
DECLARE @A INT = 10, @B INT = 15;
-- Neste caso, como @A N�O � MAIOR que @B, as instru��es contidas no IF 
-- n�o ser�o executadas e somente o �ltimo PRINT funcionar�   
IF @A > @B
   BEGIN
   PRINT @A;
   PRINT '� MAIOR QUE';
   PRINT @B;
   END
PRINT 'CONTINUA��O DO C�DIGO'


DECLARE @A INT = 15, @B INT = 10;
-- Neste caso, como @A � MAIOR que @B, as instru��es contidas no IF 
-- ser�o executadas e tamb�m o �ltimo PRINT funcionar� porque est� fora do IF  
IF @A > @B
   BEGIN
   PRINT @A;
   PRINT '� MAIOR QUE';
   PRINT @B;
   END
PRINT 'CONTINUA��O DO C�DIGO'


DECLARE @A INT = 15, @B INT = 10;
-- Neste caso, temos um bloco tanto para o caso verdadeiro quanto
-- para o caso falso  
IF @A > @B
   BEGIN
   PRINT @A;
   PRINT '� MAIOR QUE';
   PRINT @B;
   END
ELSE
   BEGIN
   PRINT @A;
   PRINT 'N�O � MAIOR QUE';
   PRINT @B;
   END   
PRINT 'CONTINUA��O DO C�DIGO'

-- 4. LOOPS WHILE
-- 4.1. N�meros inteiros de 0 at� 100
DECLARE @CONT INT = 0;
WHILE @CONT <= 100
   BEGIN
   PRINT @CONT;
   SET @CONT += 1; -- OU SET @CONT = @CONT + 1
   END
PRINT 'FIM'

-- 4.2. N�meros inteiros de 100 at� 0
DECLARE @CONT INT = 100;
WHILE @CONT >= 0
   BEGIN
   PRINT @CONT;
   SET @CONT -= 1; -- OU SET @CONT = @CONT - 1
   END
PRINT 'FIM'

-- 4.3. Tabuadas do 1 ao 10 (Loops encadeados)
DECLARE @T INT = 1, @N INT;
WHILE @T <= 10
   BEGIN
   PRINT 'TABUADA DO ' + CAST(@T AS VARCHAR(2));
   PRINT '';
   SET @N = 1;   
   WHILE @N <= 10
      BEGIN
      PRINT CAST(@T AS VARCHAR(2)) + ' x ' +
            CAST(@N AS VARCHAR(2)) + ' = ' +
            CAST(@T*@N AS VARCHAR(3));
      SET @N += 1;       
      END -- WHILE @N 
   SET @T += 1;
   PRINT '';   
   END -- WHILE @T

-- 4.4. Palpites para a mega-sena
DECLARE @DEZENA INT, @CONT INT = 1;
WHILE @CONT <= 6
   BEGIN
   SET @DEZENA = 1 + 60 * RAND();
   PRINT @DEZENA;
   SET @CONT += 1;
   END
PRINT 'BOA SORTE';

-- 4.5. Palpites para a mega-sena (vers�o 2 para n�o repetir a mesma dezena)
DECLARE @DEZENA INT, @CONT INT = 1;
IF OBJECT_ID('TBL_MEGASENA') IS NOT NULL
   DROP TABLE TBL_MEGASENA;
   
CREATE TABLE TBL_MEGASENA( NUM_DEZENA INT );
   
WHILE @CONT <= 6
   BEGIN
   SET @DEZENA = 1 + 60 * RAND();
   IF EXISTS( SELECT * FROM TBL_MEGASENA 
              WHERE NUM_DEZENA = @DEZENA )
      CONTINUE;           
   INSERT INTO TBL_MEGASENA VALUES (@DEZENA);
   SET @CONT += 1;
   END
SELECT * FROM TBL_MEGASENA ORDER BY NUM_DEZENA;   


-- 5. GOTO
A:
PRINT 'AGORA ESTOU NO PONTO "A"'
GOTO C
B:
PRINT 'AGORA ESTOU NO PONTO "B"'
GOTO D
C:
PRINT 'AGORA ESTOU NO PONTO "C"'
GOTO B
D:
PRINT 'AGORA ESTOU NO PONTO "D"'
PRINT 'FIM. QUE BAGUN�A!'


-- 7. RETURN
PRINT 'AGORA ESTOU NO PONTO "A"'
PRINT 'AGORA ESTOU NO PONTO "B"'
RETURN
PRINT 'AGORA ESTOU NO PONTO "C"'
PRINT 'AGORA ESTOU NO PONTO "D"'

-- 8. WAITFOR
WAITFOR DELAY '00:00:05'
PRINT 'ESPEREI 5 SEGUNDOS'


-- 9 EXISTS

IF EXISTS (SELECT * FROM PEDIDOS.DBO.TB_CLIENTE WHERE CODCLI=43)
	BEGIN
		PRINT 'C�digo existe'
	END
ELSE
	BEGIN
		PRINT 'C�digo n�o existe'
	END


--10.	Atribui��o de valor de uma consulta

 

DECLARE @SOMA DECIMAL(10,2)

SET @SOMA = (SELECT SUM(VLR_TOTAL) FROM PEDIDOS.DBO.tb_PEDIDO WHERE VLR_TOTAL IS NOT NULL)

PRINT @SOMA

   

