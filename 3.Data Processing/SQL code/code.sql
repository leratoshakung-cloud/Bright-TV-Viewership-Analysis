----------------------------------------------------------------------------
--1 Check table rows
----------------------------------------------------------------------------
select * 
from `brighttv`.`data`.`viewership` 
limit 100;

----------------------------------------------------------------------------
--2.Converting Time from UTC to SAST
----------------------------------------------------------------------------
SELECT 
    UserID0,
    Channel2,
    RecordDate2,
    from_utc_timestamp(RecordDate2, 'Africa/Johannesburg') AS sast_timestamp,
    Duration_2
FROM `brighttv`.`data`.`viewership`;

----------------------------------------------------------------------------
--3.Separate date and duration
----------------------------------------------------------------------------
SELECT 
    UserID0,
    Channel2,
    RecordDate2,
    date_format(Duration_2,'mm:ss') AS Duration
FROM `brighttv`.`data`.`viewership`;

----------------------------------------------------------------------------
--4.Checking the date range
--start date is 01 Jan 2016
--End date is 01 April 2016
----------------------------------------------------------------------------
SELECT 
    MIN(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) AS min_sast_timestamp,
    MAX(from_utc_timestamp(RecordDate2, 'Africa/Johannesburg')) AS max_sast_timestamp
FROM `brighttv`.`data`.`viewership`;

----------------------------------------------------------------------------
--5.Joining 2 tables
----------------------------------------------------------------------------
SELECT A.Channel2,
       A.RecordDate2,
       from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg') AS Record_time_sast,
       A.Duration_2,
       date_format(A.Duration_2,'mm:ss') AS Duration,
       B.UserID,
       B.Gender,
       B.Race,
       B.Age,
       B.Province
FROM `brighttv`.`data`.`viewership` AS A
FULL OUTER JOIN `brighttv`.`data`.`userprofiles` AS B
ON A.UserID0 = B.UserID;

----------------------------------------------------------------------------
--6.Checking the total number of users =10000
----------------------------------------------------------------------------
SELECT COUNT(A.UserID0) AS Total_Users
FROM `brighttv`.`data`.`viewership` AS A
FULL OUTER JOIN `brighttv`.`data`.`userprofiles` AS B
ON A.UserID0 = B.UserID;

----------------------------------------------------------------------------
--7.Checking viewer locations
----------------------------------------------------------------------------
SELECT DISTINCT B.Province,
                 COUNT(B.Province) AS User_count
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID
GROUP BY B.Province
ORDER BY User_count DESC;

----------------------------------------------------------------------------
--8.Checking the total number of users by gender.
---------------------------------------------------------------------------
Select B.Gender,
COUNT(A.UserID0) AS Gender_split
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID
GROUP BY B.Gender;

----------------------------------------------------------------------------
--9.Checking total number of users by race
---------------------------------------------------------------------------
SELECT Race,
COUNT(A.UserID0) AS Race_count
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID
GROUP BY B.Race;

----------------------------------------------------------------------------
--10. Checking  IFNULL AND Replace with values
----------------------------------------------------------------------------
SELECT 
    A.UserID0,
    B.Gender,
    B.Race,
    B.Age,
    B.Province,
    A.Channel2,
    A.RecordDate2,
    from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg') AS Record_time_sast,
    A.Duration_2,
    IFNULL(B.Gender, 'no gender') AS User_Gender,
    IFNULL(B.Race, 'no race') AS User_Race,
    IFNULL(B.Age, 0) AS User_Age,
    IFNULL(B.Province, 'No Province') AS Province2,
    IFNULL(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'No Record') AS Record_time_sast2,
    IFNULL(A.Duration_2, TIMESTAMP '1970-01-01 00:00:00') AS Session_Duration
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID;

----------------------------------------------------------------------------
--11. Adding Date,Day,Month and month for better insight
----------------------------------------------------------------------------

SELECT A.RecordDate2 ,
       from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg') AS Record_time_sast2,
       DAYOFMONTH(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS dateofmonth_time_sast,
       MONTHNAME(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Monthname_time_sast,
       DAYNAME(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Dayname_time_sast 
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID; 

-------------------------------------------------------------------
--12.The consolidated query
------------------------------------------------------------------
SELECT A.UserID0,
       A.Channel2,
       A.RecordDate2,
       from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg') AS Record_time_sast,
       A.Duration_2,
       date_format(A.Duration_2,'mm:ss') AS Duration,
       B.Gender,
       B.Race,
       B.Age,
       B.Province,
    IFNULL(B.Gender, 'no gender') AS User_Gender,
    IFNULL(B.Race, 'no race') AS User_Race,
    IFNULL(B.Age, 0) AS User_Age,
    IFNULL(B.Province, 'No Province') AS Province2,
    IFNULL(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'No Record') AS Record_time_sast2,
    IFNULL(A.Duration_2, TIMESTAMP '1970-01-01 00:00:00') AS Session_Duration,
    DAYOFMONTH(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS dateofmonth_time_sast,
    MONTHNAME(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Monthname_time_sast,
    DAYNAME(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Dayname_time_sast,
CASE 
    WHEN DAYNAME(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) IN ('Sun','Sat') THEN 'Weekend'
    ELSE 'Weekday'
END AS Day_classification,
CASE 
  
    WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '01.Morning viewers'
    WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '02.Mid day viewers'
    WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03.Afternoon viewers'
    WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '16:00:00' AND '17:59:59' THEN '04.Late Afternoon viewers'
    WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN '05.Evening viewers'
ELSE '06.Late night viewers'
END AS Time_buckets,
CASE 
    WHEN B.Age BETWEEN 3 AND 12 THEN 'Kids'
    WHEN B.Age BETWEEN 13 AND 19 THEN 'Teenagers'
    WHEN B.Age BETWEEN 20 AND 59 THEN 'Adults'
    WHEN B.Age BETWEEN 60 AND 114 THEN 'Seniors'
    ELSE 'No age provided'
END AS Age_Group,
CASE 
    WHEN A.Channel2 IN ('ICC Cricket World Cup 2011','SuperSport Blitz','Supersport Live Events','Live on SuperSport','Wimbledon') THEN 'Sport'
    WHEN A.Channel2 IN ('CNN') THEN 'News'
    WHEN A.Channel2 IN ('Cartoon Network','Boomerang') THEN 'Kids Show'
    WHEN A.Channel2 IN ('Channel O','Trace TV','Vuzu') THEN 'Music'
    WHEN A.Channel2 IN ('Africa Magic','M-Net') THEN 'Movies'
    ELSE 'Entertainment'
    END AS Channel_Segment
FROM `brighttv`.`data`.`viewership` A
INNER JOIN `brighttv`.`data`.`userprofiles` B
ON A.UserID0 = B.UserID;
