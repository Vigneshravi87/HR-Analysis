SET GLOBAL local_infile=1;

/*
Hypothesis that following factor lead to attrition:
Low Pay
Overtime Work/ work life balance
Lack of promotion
Specific Department
Role
Job level
Age (Low Level)
Marital Status
Years at Company
Performance Rating
Relationship Statisfaction/ Job Satisfaction/ Env Sfn
Hike
Distance from Home
*/

create database if not exists hr_db;

DROP TABLE IF EXISTS hr_db.attrition;
create table hr_db.attrition
(
Attrition varchar(3) not null,
Business_Travel varchar(20) not null,
CF_age_band varchar(20) not null,
CF_attrition_label varchar(20) not null,
Department varchar(20) not null,
Education_Field varchar(20) not null,
emp_no varchar(20) not null,
Employee_Number int,
Gender varchar(6) not null,
Job_Role varchar(40) not null,
Marital_Status varchar(20) not null,
Over_Time varchar(3) not null,
Over18 varchar(1) not null,
Training_Times_Last_Year smallint,
Age smallint,
CF_current_Employee smallint,
Daily_Rate int,
Distance_From_Home smallint,
Education varchar(20) not null,
Employee_Count smallint,
Environment_Satisfaction smallint,
Hourly_Rate smallint,
Job_Involvement smallint,
Job_Level smallint,
Job_Satisfaction smallint,
Monthly_Income bigint,
Monthly_Rate bigint,
Num_Companies_Worked smallint,
Percent_Salary_Hike float,
Performance_Rating smallint,
Relationship_Satisfaction smallint,
Standard_Hours smallint,
Stock_Option_Level smallint,
Total_Working_Years smallint,
Work_Life_Balance smallint,
Years_At_Company smallint,
Years_In_Current_Role smallint,
Years_Since_Last_Promotion smallint,
Years_With_Curr_Manager smallint
)
;
-- Load CSV into SQL Table
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_Data.csv"
INTO TABLE hr_db.attrition
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- display first 10 rows
select * from hr_db.attrition
limit 10
;

-- check numbers of rows
select count(*) from hr_db.attrition
;

-- low pay leads to attrition
select attrition, avg(Monthly_Income)
from hr_db.attrition
group by 1
;

-- attrt people on an avg have relatively low income
-- Job level 1 and 5 - attrt people have relatively high income
select attrition, Job_Level,avg(Monthly_Income)
from hr_db.attrition
group by 1,2
;

-- Health Rep, Manfac Dir, Research Dir, Sales Executive - Pay doesn't matter for these roles
select attrition, Job_Role,avg(Monthly_Income), count(emp_no) as total_emp
from hr_db.attrition
group by 1,2
;

-- attrition rate by Job Level
-- people at entry level have more attrition rate
select Job_Level, round(100*sum(case when attrition = 'Yes' then 1 else 0 end)/count(emp_no),2) attrition_rate
from hr_db.attrition
group by 1
;

-- attrition rate by Age
-- people at young age have more attrition rate
select CF_age_band, round(100*sum(case when attrition = 'Yes' then 1 else 0 end)/count(emp_no),2) attrition_rate
from hr_db.attrition
group by 1
;

-- age and job band correlation
select CF_age_band, Job_Level, count(emp_no)
from hr_db.attrition
group by 1,2
;

select CF_age_band, Job_Level, count(emp_no)/ avg(employee_age_band)
from (
select CF_age_band, Job_Level, emp_no, count(emp_no) over(partition by CF_age_band order by null) employee_age_band
from hr_db.attrition 
) a
group by 1,2
;

