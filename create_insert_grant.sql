--creates, inserts and grants

--1
CREATE TABLE CLASS_TABLE
(
COURSE_CODE VARCHAR(5)PRIMARY KEY,
STAGE_NUM NUMBER(1) NOT NULL
CHECK (STAGE_NUM IN (1,2,3,4)),
STUDENT_NUM NUMBER(2) NOT NULL
);

--2
CREATE TABLE LECTURER (

    LECTURER_ID VARCHAR(5) PRIMARY KEY,
    LECTURER_NAME VARCHAR(30) NOT NULL,
    LECTURER_EMAIL VARCHAR(30) NOT NULL,
    LECTURER_HOURS NUMBER(2)  NOT NULL, CHECK (LECTURER_HOURS < 20)

);
--3
CREATE TABLE MODULE_TABLE
(
CRN VARCHAR(7) PRIMARY KEY,
MOD_NAME VARCHAR(20) NOT NULL,
MODE_TYPE VARCHAR(20) NOT NULL
CHECK (MODE_TYPE IN('Single-Semester','single-semester','single semester','Single Semester','Single semester','Linked-Semester','linked-semester','linked semester','Linked Semester','Linked semester')),
CONTACT_HOUR NUMBER(2) NOT NULL,
NUM_STUDENTS NUMBER(2) NOT NULL,
SEMESTER NUMBER(1) NOT NULL
CHECK(SEMESTER IN('1','2')),
COURSE_CODE VARCHAR(5) NOT NULL,
FOREIGN KEY(COURSE_CODE) REFERENCES CLASS_TABLE(COURSE_CODE),
LECTURER_ID VARCHAR(5) NOT NULL,
FOREIGN KEY (LECTURER_ID) REFERENCES LECTURER(LECTURER_ID) 
);



--4
CREATE TABLE DAY_TABLE
(
DAY_NAME VARCHAR(20) PRIMARY KEY
);


--5
CREATE TABLE SESSION_TABLE
(
SESSION_ID VARCHAR(5) PRIMARY KEY,
CRN VARCHAR(7) NOT NULL,
FOREIGN KEY(CRN) REFERENCES MODULE_TABLE(CRN),
DAY_NAME VARCHAR(20) NOT NULL,
FOREIGN KEY(DAY_NAME) REFERENCES DAY_TABLE(DAY_NAME),
SESSION_TYPE VARCHAR(10) NOT NULL
CHECK (SESSION_TYPE IN ('LECTURE','TUTORIAL','LAB','lecture','tutorial','lab','Lecture','Tutorial','Lab'))
);

--6
CREATE TABLE TIME_TABLE
(
START_TIME VARCHAR(20) NOT NULL,
END_TIME VARCHAR(20)NOT NULL,
ROOM_NUM VARCHAR(7) UNIQUE NOT NULL,
DAY_NAME VARCHAR(20) NOT NULL,
FOREIGN KEY(DAY_NAME) REFERENCES DAY_TABLE(DAY_NAME)
);
--7
CREATE TABLE ROOM_TABLE
(
R_NUM VARCHAR(7) PRIMARY KEY,

R_LOCATION VARCHAR(3) NOT NULL
CHECK(R_LOCATION IN('A','KE','KA')),

ROOM_TYPE VARCHAR(10) NOT NULL
CHECK(ROOM_TYPE IN('Lab','Classroom')),

ROOM_CAPACITY NUMBER(2) NOT NULL,

ROOM_BOOKED VARCHAR(3) NOT NULL
CHECK(ROOM_BOOKED IN('YES','NO','Yes','No','yes','no')),

BLACKBOARD VARCHAR(3) NOT NULL
CHECK(BLACKBOARD IN('YES','NO','Yes','No','yes','no')),

WHITEBOARD VARCHAR(3) NOT NULL
CHECK(WHITEBOARD IN('YES','NO','Yes','No','yes','no')),

DATASCREEN VARCHAR(3) NOT NULL
CHECK(DATASCREEN IN('YES','NO','Yes','No','yes','no')),

DATAPROJECTOR VARCHAR(3) NOT NULL
CHECK(DATAPROJECTOR IN('YES','NO','Yes','No','yes','no'))
);


--DO THE ONE-TO-ONE RELATIONSHIP
--R_NUM AND ROOM_NUM ARE THE SAME
ALTER TABLE TIME_TABLE
ADD CONSTRAINT FK_TIME_ROOM_NUM
FOREIGN KEY(ROOM_NUM)
REFERENCES ROOM_TABLE(R_NUM);


------------------------------------------------------
--inserts

--INSERT DAYS IN DAY_TABLE
INSERT INTO DT2NN3_B2.DAY_TABLE(DAY_NAME) VALUES('MONDAY');
INSERT INTO DT2NN3_B2.DAY_TABLE(DAY_NAME) VALUES('TUESDAY');
INSERT INTO DT2NN3_B2.DAY_TABLE(DAY_NAME) VALUES('WEDNESDAY');
INSERT INTO DT2NN3_B2.DAY_TABLE(DAY_NAME) VALUES('THURSDAY');
INSERT INTO DT2NN3_B2.DAY_TABLE(DAY_NAME) VALUES('FRIDAY');


--lec id 
create sequence lecturerid
minvalue 1
maxvalue 6
start with 1
increment by 1;

DECLARE
    v_lid dt2nn3_b2.lecturer.lecturer_id%TYPE;
    v_lname dt2nn3_b2.lecturer.lecturer_name%TYPE:='&lecturer_name';
    v_lemail dt2nn3_b2.lecturer.lecturer_email%TYPE:='&lecturer_email';
    v_lh dt2nn3_b2.lecturer.lecturer_hours%TYPE:='&lecturer_hours';

BEGIN
    v_lid := 'L'||lecturerid.nextval;
    insert into dt2nn3_b2.lecturer(lecturer_id, lecturer_name,lecturer_email, lecturer_hours)
    values(v_lid,v_lname,v_lemail,v_lh);
END;

-- module table
create sequence MODID
minvalue 1
start with 1
increment by 1;

DECLARE
    v_mcrn dt2nn3_b2.module_table.crn%TYPE;
    v_mname dt2nn3_b2.module_table.mod_name%TYPE:='&module_name';
    v_mtype dt2nn3_b2.module_table.mode_type%TYPE:='&mod_type';
    v_mcontact_hour dt2nn3_b2.module_table.contact_hour%TYPE:='&contact_hour';
    v_course_code dt2nn3_b2.class_table.course_code%TYPE:='&course_code';
    v_msemester dt2nn3_b2.module_table.semester%TYPE:='&semester';
    v_lecturer_id dt2nn3_b2.lecturer.lecturer_id%TYPE:='&lecturer_id';

BEGIN
    v_mcrn := 'crn'||modid.nextval;
    insert into dt2nn3_b2.module_table(crn, mod_name, mode_type,contact_hour,course_code,semester,lecturer_id)values(v_mcrn,v_mname, v_mtype, v_mcontact_hour, v_course_code, v_msemester, v_lecturer_id);
END;

--room table
DECLARE
    V_Rno dt2nn3_b2.ROOM_TABLE.R_NUM%TYPE :='&ROOMno';
    V_loc dt2nn3_b2.ROOM_TABLE.R_LOCATION%TYPE :='&LOC';
    V_Rtype dt2nn3_b2.ROOM_TABLE.ROOM_TYPE%TYPE :='&R_TYPE';
    V_Rcap  dt2nn3_b2.ROOM_TABLE.ROOM_CAPACITY%TYPE :='&cap';
    V_Rbook  dt2nn3_b2.ROOM_TABLE.ROOM_BOOKED%TYPE :='&booked';
    V_blackbd  dt2nn3_b2.ROOM_TABLE.BLACKBOARD%TYPE :='&blackbd';
    V_whitebd  dt2nn3_b2.ROOM_TABLE.WHITEBOARD%TYPE :='&whitebd';
    V_datasc  dt2nn3_b2.ROOM_TABLE.DATASCREEN%TYPE :='&dataScreen';
    V_datapro  dt2nn3_b2.ROOM_TABLE.DATAPROJECTOR%TYPE :='&dataProjecter';  
BEGIN
    insert into dt2nn3_b2.ROOM_TABLE VALUES(V_Rno, V_loc, V_Rtype, V_Rcap, V_Rbook, V_blackbd, V_whitebd, V_datasc, V_datapro);

END;

-- session table
create sequence sessionid
minvalue 1
start with 1
increment by 1;

DECLARE
    v_sid dt2nn3_b2.session_table.session_id%TYPE;
    v_stype dt2nn3_b2.session_table.session_type%TYPE:='&Session_Type';
    v_crn dt2nn3_b2.session_table.crn%TYPE:='&CRN';
    v_dn dt2nn3_b2.day_table.day_name%TYPE:='&Day_name';
    

BEGIN
    v_sid := 'S'||sessionid.nextval;
    insert into dt2nn3_b2.session_table(session_id, crn, day_name, session_type)
    values(v_sid,v_crn,v_dn,v_stype);
END;

--time table
DECLARE
    V_STARTT dt2nn3_b2.TIME_TABLE.START_TIME%TYPE :='&START_TIME';
    V_ENDT dt2nn3_b2.TIME_TABLE.END_TIME%TYPE :='&END_TIME';
    V_ROOMN dt2nn3_b2.TIME_TABLE.ROOM_NUM%TYPE :='&ROOM_NUM';
    V_DAYN dt2nn3_b2.TIME_TABLE.DAY_NAME%TYPE :='&DAY_NAME';
    
BEGIN
    insert into dt2nn3_b2.TIME_TABLE VALUES(V_STARTT, V_ENDT, V_ROOMN, V_DAYN);

END;

--INSERT COURSES
INSERT INTO DT2NN3_B2.CLASS_TABLE(COURSE_CODE, STAGE_NUM, STUDENT_NUM) VALUES('DT211','3','40');
INSERT INTO DT2NN3_B2.CLASS_TABLE(COURSE_CODE, STAGE_NUM) VALUES('DT282','3', '60');


-----------------------------------------
--grants
GRANT SELECT, INSERT,DELETE,UPDATE ON CLASS_TABLE TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON LECTURER TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON MODULE_TABLE TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON SESSION_TABLE TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON DAY_TABLE TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON TIME_TABLE TO JDUGGAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON ROOM_TABLE TO JDUGGAN;

GRANT SELECT, INSERT,DELETE,UPDATE ON CLASS_TABLE TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON LECTURER TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON MODULE_TABLE TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON SESSION_TABLE TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON DAY_TABLE TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON TIME_TABLE TO JDOYLE;
GRANT SELECT, INSERT,DELETE,UPDATE ON ROOM_TABLE TO JDOYLE;


GRANT SELECT, INSERT,DELETE,UPDATE ON CLASS_TABLE TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON LECTURER TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON MODULE_TABLE TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON SESSION_TABLE TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON DAY_TABLE TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON TIME_TABLE TO BGITCHAMNAN;
GRANT SELECT, INSERT,DELETE,UPDATE ON ROOM_TABLE TO BGITCHAMNAN;

