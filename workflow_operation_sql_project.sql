CREATE database logistics_ops;
create database workflow_ops;
use workflow_ops;
select * from ai_workflow_optimization_project; 
describe ai_workflow_optimization_project;
select count(*) as total_rows
from ai_workflow_optimization_project;

#1 department delay rate
select Department,
count(*) as total_tasks,
sum(Delay_Flag) as delayed_tasks,
round(avg(Delay_Flag)*100,2) as delay_rate
from ai_workflow_optimization_project
group by Department
order by delay_rate desc;
#2 most expensive process
select Process_name,
round(avg(Cost_Per_Task),2) as total_cost
from ai_workflow_optimization_project
group by Process_name
order by total_cost desc; 
# 3 priority level performance
select Priority_Level,
round(avg(Actual_Time_Minutes),2) as avg_completion_time
from ai_workflow_optimization_project
group by Priority_Level
order by avg_completion_time desc ; 
#4 top employees by workload
select Assigned_Employee_ID ,
round(avg(Employee_Workload),2) as avg_workload
from ai_workflow_optimization_project
group by  Assigned_Employee_ID 
order by avg_workload desc
limit 10;
#5 cost efficiency by department
select Department,
round(avg(Cost_Per_Task),2) as avg_cost
from ai_workflow_optimization_project
group by Department
order by avg_cost desc;
#6 delay rate by process
select Process_Name,
round(avg(Delay_Flag),2) as delay_rate
from ai_workflow_optimization_project
group by process_Name
order by delay_rate desc;
# 7 approval level analysis
select Approval_Level,
round(avg(Actual_Time_Minutes),2) as avg_time
from ai_workflow_optimization_project
group by Approval_Level
order by avg_time desc; 
#8 monthly workload trend
select 
substring(Task_Start_Time,4,2) as month_no,
count(*) as total_tasks
from ai_workflow_optimization_project
group by substring(Task_Start_Time,4,2)
order by month_no;

 #9 time varince analysis
 select Department,
 round(avg(Actual_Time_Minutes-Estimated_Time_Minutes),2) as avg_variance
 from ai_workflow_optimization_project
 group by Department
 order by avg_variance desc;
#10 bottleneck department
select Department,
round(avg(Actual_Time_Minutes),2) as avg_completion_time
from ai_workflow_optimization_project
group by Department
order by avg_completion_time;
#11 department bottleneck risk classification
create view department_risk as 
with department_performance as (
select 
Department ,
count(*) as total_tasks,
round(avg(Actual_Time_Minutes),2) as avg_time,
round(avg(Delay_Flag),2) as delay_rate,
round(avg(Cost_Per_Task),2) as total_cost
from ai_workflow_optimization_project
group by Department)
select Department,
total_tasks,
avg_time,
delay_rate,
total_cost,
case 
when avg_time >= 183
and delay_rate >=0.95 then 'high bottleneck risk'
when avg_time between 180 and 183 
and delay_rate >= 0.94 then 'mid bottleneck risk' 
else 'low bottleneck risk'
end as bottleneck_risk
from department_performance
order by avg_time desc;
show tables;
CREATE VIEW department_performance_rank AS
WITH department_performance AS (
    SELECT
        Department,
        COUNT(*) AS total_tasks,
        ROUND(AVG(Actual_Time_Minutes), 2) AS avg_completion_time,
        ROUND(AVG(Delay_Flag) * 100, 2) AS delay_rate
    FROM ai_workflow_optimization_project
    GROUP BY Department
)

SELECT
    Department,
    total_tasks,
    avg_completion_time,
    delay_rate,
    RANK() OVER (
        ORDER BY avg_completion_time DESC
    ) AS performance_rank
FROM department_performance;
