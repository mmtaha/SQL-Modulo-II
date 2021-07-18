DECLARE @MAQ VARCHAR(200);
SET @MAQ = HOST_NAME();
DECLARE @COMANDO VARCHAR(1000);
SET @COMANDO = 'CREATE LOGIN ['+ @MAQ + '\ADMINISTRATOR] FROM WINDOWS WITH DEFAULT_DATABASE=[master],
DEFAULT_LANGUAGE=[us_english]';
exec(@comando);
set @comando = 'exec sp_addsrvrolemember ''' + @MAQ +
'\Administrator'',sysadmin;'
exec(@comando);

