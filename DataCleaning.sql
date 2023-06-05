SELECT *
FROM dailyActivity


SELECT * 
FROM sleepDay

SELECT * 
FROM weightInfo


SELECT *
FROM dailyActivity d 
JOIN sleepDay s
ON d.Id = s.Id
JOIN weightInfo w
ON s.Id = w.Id


--Standardizing the dates
UPDATE dailyActivity
SET ActivityDate = CONVERT(Date,ActivityDate)

UPDATE sleepDay
SET SleepDay = CONVERT(Date,SleepDay)

UPDATE weightInfo
SET Date = CONVERT(Date,Date)

--Standardizing Weight
SELECT CAST(WeightKg as int) AS Weight
FROM weightInfo

UPDATE weightInfo
SET WeightKg = CAST(WeightKg as int)

UPDATE weightInfo
SET BMI = CAST(BMI as int)



--Adding day of week
ALTER TABLE dailyActivity
ADD day_of_week Nvarchar(250)

UPDATE dailyActivity
SET day_of_week = DATENAME(WEEKDAY,ActivityDate)



ALTER TABLE weightInfo
ADD day_Of_Week Nvarchar(250)


UPDATE weightInfo
SET day_Of_Week = DATENAME(WEEKDAY,Date)


ALTER TABLE sleepDay
ADD daysOfWeek Nvarchar(250)


UPDATE sleepDay
SET daysOfWeek = DATENAME(WEEKDAY,SleepDay)

--Removing Duplicates
WITH DailyCTE as(
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY
	 id,TotalSteps
	 ORDER BY id) row_num
	 FROM dailyActivity
)
DELETE FROM DailyCTE
WHERE row_num>1


WITH SleepCTE as(
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY
	 LogId
	 ORDER BY id) row_num
	 FROM weightInfo
)
DELETE FROM SleepCTE
WHERE row_num>1

ALTER TABLE dailyActivity
DROP COLUMN SedentaryActiveDistance

ALTER TABLE sleepDay
DROP COLUMN TotalSleepRecords

ALTER TABLE weightInfo
DROP COLUMN WeightPounds,Fat,IsManualReport



