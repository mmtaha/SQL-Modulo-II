--1. Complete o c�digo a seguir de modo a mostrar o maior dos tr�s n�meros sorteados: 

DECLARE @A INT, @B INT, @C INT;
DECLARE @MAIOR INT;
SET @A = 50 * RAND();
SET @B = 50 * RAND();
SET @C = 50 * RAND();
-- Aqui voc� colocar� os IFs ---


-- SOLU��O 1
IF @A > @B
   IF @A > @C
      SET @MAIOR = @A
   ELSE
      SET @MAIOR = @C
ELSE
   IF @B > @C
      SET @MAIOR = @B
   ELSE
      SET @MAIOR = @C            
-- SOLU��O 2

/*IF @A > @B AND @A > @C
      SET @MAIOR = @A
ELSE
   IF @B > @C
      SET @MAIOR = @B
   ELSE
      SET @MAIOR = @C      
*/
-- SOLU��O 3

/*SET @MAIOR = @A;
IF @B > @MAIOR SET @MAIOR = @B;      
IF @C > @MAIOR SET @MAIOR = @C;
*/
--------------------------------

PRINT @A;
PRINT @B;
PRINT @C;
PRINT 'MAIOR = ' + CAST(@MAIOR AS VARCHAR(2));

/*
2. Complete o c�digo a seguir (que sortear� quatro n�meros no intervalo de 0 a 10, 
   os quais representar�o as quatro notas de um aluno) de acordo com o que o 
   coment�rio pede:
*/

DECLARE @N1 NUMERIC(4,2), @N2 NUMERIC(4,2), @N3 NUMERIC(4,2), @N4 NUMERIC(4,2);
DECLARE @MEDIA NUMERIC(4,2);
SET @N1 = 10*RAND();
SET @N2 = 10*RAND();
SET @N3 = 10*RAND();
SET @N4 = 10*RAND();
-- Imprimir as 4 notas
PRINT 'Nota 1: ' + CAST( @N1 AS VARCHAR(5) );
PRINT 'Nota 2: ' + CAST( @N2 AS VARCHAR(5) );
PRINT 'Nota 3: ' + CAST( @N3 AS VARCHAR(5) );
PRINT 'Nota 4: ' + CAST( @N4 AS VARCHAR(5) );
-- Calcular e imprimir a m�dia das 4 notas
SET @MEDIA = (@N1 + @N2 + @N3 + @N4) / 4;
PRINT 'M�dia: ' + CAST( @MEDIA AS VARCHAR(5) );
-- Imprimir REPROVADO se m�dia menor que 5, caso contr�rio APROVADO
IF @MEDIA < 5 
   PRINT 'REPROVADO'
ELSE
   PRINT 'APROVADO'   
-- Dependendo da m�dia, imprimir uma das classifica��es abaixo
--             M�dia at� 2..................P�SSIMO
--             Acima de 2 at� 4.............RUIM
--             Acima de 4 at� 6.............REGULAR
--             Acima de 6 at� 8.............BOM
--             Acima de 8...................�TIMO
IF @MEDIA <= 2 PRINT 'P�SSIMO'
ELSE IF @MEDIA <= 4 PRINT 'RUIM'
ELSE IF @MEDIA <= 6 PRINT 'REGULAR'
ELSE IF @MEDIA <= 8 PRINT 'BOM'
ELSE PRINT '�TIMO'
-------------------------------------------------------------------

-- 3. Escreva um c�digo que gere e imprima os n�meros pares de 0 at� 100;
DECLARE @CONT INT = 0;
WHILE @CONT <= 100
   BEGIN
   PRINT @CONT;
   SET @CONT += 2
   END
PRINT 'FIM'

-- 4. Escreva um c�digo que gere e imprima os n�meros �mpares entre 0 e 100;
DECLARE @CONT INT = 1;
WHILE @CONT <= 100
   BEGIN
   PRINT @CONT;
   SET @CONT += 2
   END
PRINT 'FIM'

/*
5. Complete o c�digo de modo a calcular a soma de todos os n�meros inteiros de 0 at� @N;
*/

DECLARE @N INT, @CONT INT = 1, @SOMA INT = 0;
SET @N = CAST( 20 * RAND() AS INT );
-- Complete o c�digo -----------------------

WHILE @CONT <= @N
   BEGIN
   SET @SOMA += @CONT;
   SET @CONT += 1;
   END
--------------------------------------------
PRINT 'A SOMA DE 1 AT� ' + CAST(@N AS VARCHAR(2)) +
      ' � ' + CAST(@SOMA AS VARCHAR(4));
      
/*
6. Complete o c�digo de modo a calcular o fatorial de @N. Por exemplo, o 
fatorial de 5 � 1 * 2 * 3 * 4 * 5 = 120;
*/
DECLARE @N INT, @CONT INT = 1, @FAT INT = 1;
SET @N = CAST( 10 * RAND() AS INT );
-- Complete o c�digo -----------------------
WHILE @CONT <= @N
   BEGIN
   SET @FAT *= @CONT;
   SET @CONT += 1;
   END
--------------------------------------------
PRINT 'O FATORIAL DE ' + CAST(@N AS VARCHAR(2)) +
      ' � ' + CAST(@FAT AS VARCHAR(10));
      
/*
7. Insira os comandos de acordo com os coment�rios adiante, de modo que o c�digo
   gere todos os n�meros primos de 1 at� 1000.
   
   N�meros primos s�o n�meros inteiros divis�veis apenas por 1 e por ele pr�prio. 
*/

-- 1. Declarar as vari�veis @N, @I (inteiras) e @SN_PRIMO do tipo CHAR(1) 
DECLARE @N INT, @I INT, @SN_PRIMO CHAR(1);
-- 2. Imprimir os n�meros 1, 2 e 3 que j� sabemos serem primos
PRINT 1;
PRINT 2;
PRINT 3;      
-- 3. Iniciar a vari�vel @N com 4
SET @N = 4;
-- 4. Enquanto @N for menor ou igual a 1000
WHILE @N <= 1000
   BEGIN
   -- 4.1. Iniciar a vari�vel @I com 2
   SET @I = 2;
   -- 4.2. Iniciar a vari�vel @SN_PRIMO com 'S'
   SET @SN_PRIMO = 'S';
   -- 4.3. Enquanto @I for menor ou igual a @N / 2
   WHILE @I <= @N/2
      BEGIN
      -- 4.3.1. Se o resto da divis�o de @N por @I for zero (� divis�vel)
      IF @N % @I = 0
         BEGIN
         -- 4.3.1.1. Colocar 'N' na vari�vel @SN_PRIMO sinalizando assim
         -- que @N n�o � um n�mero primo
         SET @SN_PRIMO = 'N';
         -- 4.3.1.2. Abandonar este Loop (4.3)
         BREAK;
         END
      -- 4.3.2. Somar 1 na vari�vel @I   
      SET @I += 1;   
      -- Final do loop 4.3.
      END
   -- 4.4. Se @SN_PRIMO for 'S', imprimir @N porque ele � primo  
   IF @SN_PRIMO = 'S' PRINT @N;
   -- 4.5. Somar 1 na vari�vel @N
   SET @N = @N + 1;   
   -- Final do loop (4)
   END
      
         

