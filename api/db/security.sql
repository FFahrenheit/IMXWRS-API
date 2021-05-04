CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = '<complex password>';

CREATE CERTIFICATE IMXWRSCERT
	WITH SUBJECT = 'IMXWRS password certificate'

CREATE SYMMETRIC KEY IMXWRS_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE IMXWRSCERT; 

ALTER TABLE users
ADD encPassword varbinary(128);

OPEN SYMMETRIC KEY IMXWRS_Key_01  
   DECRYPTION BY CERTIFICATE IMXWRSCERT;  

UPDATE users
SET encPassword = EncryptByKey(Key_GUID('IMXWRS_Key_01'), password);  

SELECT * , 
CONVERT(VARCHAR(30), DecryptByKey(encPassword)) as 'pass'
FROM users;

CREATE OR ALTER PROCEDURE dbo.getUser @Username VARCHAR(30)
AS

OPEN SYMMETRIC KEY IMXWRS_Key_01  
   DECRYPTION BY CERTIFICATE IMXWRSCERT;

SELECT username, name, email, temporal, position , password,  
CONVERT(VARCHAR(30), DecryptByKey(encPassword)) as 'pass'
FROM users WHERE username = @Username OR email = @Username;
GO