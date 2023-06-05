SELECT * 
FROM dailyActivity

SELECT *
FROM sleepDay

SELECT *
FROM weightInfo

--Total number of steps and calories 
SELECT id,SUM(TotalSteps) AS StepsCovered,SUM(Calories) AS TotalCalories,SUM(TrackerDistance) AS TotalDistance
FROM dailyActivity
GROUP BY id
ORDER BY StepsCovered,TotalCalories ASC

--Average steps and calories
SELECT id,AVG(cast(TotalSteps as int)) AS AvgSteps,AVG(cast(Calories as int)) AS AvgCalories,day_of_week
FROM dailyActivity
GROUP BY id,day_of_week






--Finding type of users
SELECT Id,
avg(cast(TotalSteps as int)) AS Avg_Total_Steps,
CASE
WHEN avg(TotalSteps) < 5000 THEN 'Inactive'
WHEN avg(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Low Active User'
WHEN avg(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Average Active User'
WHEN avg(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Active User'
WHEN avg(TotalSteps) >= 12500 THEN 'Very Active User'
END User_Type
FROM dailyActivity
GROUP BY Id



--ActiveMinutes vs SedentaryMinutes comparing with Calories and totalsteps

SELECT id,SUM(TotalSteps) AS StepsCovered,SUM(Calories) AS TotalCalories,SUM(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes) AS TotalActiveMinutes,SUM(SedentaryMinutes) AS TotalSedantaryMinutes
FROM dailyActivity
GROUP BY id
ORDER BY StepsCovered,TotalCalories ASC

--Relation between BMI and and total active minutes/sedentary minutes
SELECT SUM(TotalSteps) AS StepsCovered,SUM(Calories) AS TotalCalories,SUM(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes) AS TotalActiveMinutes,SUM(SedentaryMinutes) AS TotalSedantaryMinutes,w.BMI,w.WeightKg
FROM dailyActivity d
JOIN weightInfo w
ON d.id = w.id
GROUP BY w.BMI,w.WeightKg
ORDER BY StepsCovered,TotalCalories ASC

--AVG time taken to sleep

SELECT id,AVG(cast(TotalTimeInBed - TotalMinutesAsleep as int)) AS TimeTakenToSleep,daysOfWeek
FROM sleepDay
GROUP BY id,daysOfWeek
--ORDER BY TimeTakenToSleep


--Total time taken to sleep


SELECT id,SUM(TotalTimeInBed - TotalMinutesAsleep ) AS TimeTakenToSleep
FROM sleepDay
GROUP BY id