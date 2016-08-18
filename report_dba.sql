--18/08/2016
--Ralf Silva

SET SERVEROUTPUT ON
BEGIN

	FOR C_INSTANCE_DATA IN (SELECT HOST_NAME , VERSION  FROM V$INSTANCE)
		LOOP
			DBMS_OUTPUT.PUT_LINE('+REPORT DATABASE-----------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('HOST NAME: ' || C_INSTANCE_DATA.HOST_NAME || chr(10) || 
								 ' VERSION: ' || C_INSTANCE_DATA.VERSION);
			DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');

		END LOOP C_INSTANCE_DATA;

	FOR C_DATABASE_DATA IN (SELECT NAME ,DB_UNIQUE_NAME , LOG_MODE , FORCE_LOGGING , DATABASE_ROLE , DATAGUARD_BROKER  FROM V$DATABASE)
		LOOP
		
			DBMS_OUTPUT.PUT_LINE('+INFO DATABASE-------------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('NAME:' || C_DATABASE_DATA.NAME || chr(10) ||
								'   UNIQUE NAME: ' || C_DATABASE_DATA.DB_UNIQUE_NAME || chr(10) ||
								'   LOG MODE: ' || C_DATABASE_DATA.LOG_MODE || chr(10) ||
								'   FORCE LOGGING: ' || C_DATABASE_DATA.FORCE_LOGGING || chr(10) ||
								'   DATABASE_ROLE: ' || C_DATABASE_DATA.DATABASE_ROLE || chr(10) ||
								'   DATAGUARD BROKER: ' || C_DATABASE_DATA.DATAGUARD_BROKER );
			DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('+INFO TABLESPACE/DATAFILE -------------------------------+');
			DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
	
	END LOOP C_DATABASE_DATA;



	FOR C_TBS_DATA IN ( SELECT SUM(DDF.BYTES)/1024/1024 AS "SIZEMB",DDF.TABLESPACE_NAME TABLESPACENAME, DDF.FILE_NAME "FILENAME", DDF.STATUS , TBS.INCLUDED_IN_DATABASE_BACKUP IIDB, TBS.FLASHBACK_ON FBON FROM DBA_DATA_FILES DDF, V$TABLESPACE TBS WHERE DDF.TABLESPACE_NAME = TBS.NAME GROUP BY DDF.TABLESPACE_NAME, DDF.FILE_NAME, DDF.STATUS, TBS.INCLUDED_IN_DATABASE_BACKUP,TBS.FLASHBACK_ON)
		LOOP
	
			DBMS_OUTPUT.PUT_LINE('TABLESPACE: ' ||C_TBS_DATA.TABLESPACENAME || chr(10) ||
			'   SIZE(MB):        ' ||C_TBS_DATA.SIZEMB || chr(10) ||
			'   FILE NAME:       '''|| C_TBS_DATA.FILENAME ||'''' ||chr(10) ||
			'   STATUS:          ' || C_TBS_DATA.STATUS || chr(10) ||
			'   INCLUDED BACKUP: ' || C_TBS_DATA.IIDB || chr(10) ||
			'   FLASHBACK ON:    ' || C_TBS_DATA.FBON || chr(10));


	END LOOP C_TBS_DATA;

DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
DBMS_OUTPUT.PUT_LINE('+INFO LOG------------------------------------------------+');

	FOR C_LOG_DATA IN (SELECT LG.GROUP# , SUM(LG.BYTES)/1024/1024 "SIZEMB", LGF.MEMBER  FROM V$LOG LG, V$LOGFILE LGF WHERE LG.GROUP# = LGF.GROUP# GROUP BY LG.GROUP#, LGF.MEMBER, LGF.STATUS ORDER BY LG.GROUP#)
		LOOP

			DBMS_OUTPUT.PUT_LINE('GROUP: ' || C_LOG_DATA.GROUP# || chr(10) ||
								'   SIZE(MB):  ' || C_LOG_DATA.SIZEMB || chr(10) ||
								'   MEMBER:    ''' || C_LOG_DATA.MEMBER || '''');
			
		END LOOP C_LOG_DATA;

	FOR C_CONTROL_DATA IN (SELECT NAME FROM V$CONTROLFILE)
		LOOP

			DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('+INFO CONTROL FILE-------------------------------------------+');
			DBMS_OUTPUT.PUT_LINE('CONTROL FILE: ' || C_CONTROL_DATA.NAME);

	END LOOP C_CONTROL_DATA;
	DBMS_OUTPUT.PUT_LINE('+--------------------------------------------------------+');
	DBMS_OUTPUT.PUT_LINE('+END-----------------------------------------------------+');

END;
/




















