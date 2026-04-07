-- 4. Creating Trigger

 -- create a table in which changes like insert, delete and update in the table t_stInstalService are inserted to it
CREATE TABLE t_stInstalService_delet_update(
	stid int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	stCod char(4) NULL,
	lastDateServ date NULL,
	personFulName1 nvarchar(50) NULL,
	personFulName2 nvarchar(50) NULL,
	sensorTyp nvarchar(30) null,
	GPSStatus nvarchar(3) null,
	nrGPSSat int null,
	issues nvarchar(50) default 'no issues'
) 
GO
-- create a trigger to insert changes of the table t_stInstalService into t_stInstalService_delet_update 
CREATE OR ALTER TRIGGER dbo.tr_stInstalService_delet_update
ON dbo.t_stInstalService
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    INSERT INTO t_stInstalService_delet_update (
        stCod,
        lastDateServ,
        personFulName1,
        personFulName2,
        sensorTyp,
        GPSStatus,
        nrGPSSat,
        issues
    )
    SELECT 
        stCod,
        lastDateServ,
        personFulName1,
        personFulName2,
        sensorTyp,
        GPSStatus,
        nrGPSSat,
        issues
    FROM deleted;
END
GO
--  test if trigger works correct after altering the table t_stInstalService using update, delete and insert
SELECT * FROM t_stInstalService;

UPDATE t_stInstalService SET lastDateServ = '2020-01-12' WHERE stid = 1;
UPDATE t_stInstalService SET lastDateServ = '2020-01-13' WHERE stid = 4;
UPDATE t_stInstalService SET lastDateServ = '2022-05-20' WHERE stid = 8;
UPDATE t_stInstalService SET lastDateServ = '2024-08-02' WHERE stid = 12;
DELETE FROM t_stInstalService WHERE stid = 13;

SET IDENTITY_INSERT t_stInstalService on;
insert into t_stInstalService(stid,stCod,lastDateServ,personFulName1,personFulName2,sensorTyp,GPSStatus,nrGPSSat,issues) 
values(13,'DE13','2025-03-12','Joachim Ritter','Konun Koushesh','STS2','on',6,'the sensore is switched from Mark-3D to STS2');
SET IDENTITY_INSERT t_stInstalService off;

SELECT * FROM t_stInstalService_delet_update;
SELECT * FROM t_stInstalService;
-- to disable or again enable the trigger use unmute the one of the followings:

--DISABLE TRIGGER dbo.tr_stInstalService_delet_update
--ON dbo.t_stInstalService
--GO

--ENABLE TRIGGER dbo.tr_stInstalService_delet_update
--ON dbo.t_stInstalService
--GO
