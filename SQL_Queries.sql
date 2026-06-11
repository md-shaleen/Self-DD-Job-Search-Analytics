CREATE DATABASE JobSearchAnalytics;
use JobSearchAnalytics;
SELECT *
FROM Fact_Applications
LIMIT 5;

SELECT *
FROM Fact_Applications
WHERE Application_ID IS NULL;

SELECT COUNT(*) AS Total_Records
FROM Fact_Applications;

SELECT
MIN(Application_ID) AS Min_ID,
MAX(Application_ID) AS Max_ID
FROM Fact_Applications;

SELECT COUNT(*) AS Total_Applications
FROM Fact_Applications;

SELECT
MIN(Date_Applied) AS Start_Date,
MAX(Date_Applied) AS End_Date
FROM Fact_Applications;
 
 #Applications by Month
SELECT
MONTH(Date_Applied) AS Month_No,
MONTHNAME(Date_Applied) AS Month_Name,
COUNT(*) AS Applications
FROM Fact_Applications
GROUP BY
MONTH(Date_Applied),
MONTHNAME(Date_Applied)
ORDER BY Month_No;

#ATS Score Analysis
SELECT
MIN(ATS_Score) AS Min_ATS,
MAX(ATS_Score) AS Max_ATS,
AVG(ATS_Score) AS Avg_ATS
FROM Fact_Applications;

#Application Funnel
SELECT
SUM(Applied) AS Applied,
SUM(Viewed) AS Viewed,
SUM(Shortlisted) AS Shortlisted,
SUM(Assessment) AS Assessment,
SUM(Interview) AS Interview,
SUM(Offer) AS Offer
FROM Fact_Applications;

SELECT
r.Job_Title,
COUNT(*) AS Total_Applications
FROM Fact_Applications f
INNER JOIN Dim_Role r
ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title
ORDER BY Total_Applications DESC;

SELECT
    r.Job_Title,
    COUNT(*) AS Total_Applications,
    ROUND(AVG(f.ATS_Score),2) AS Avg_ATS_Score,
    ROUND(AVG(f.Match_Score),2) AS Avg_Match_Score
FROM Fact_Applications f
JOIN Dim_Role r
    ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title
ORDER BY Total_Applications DESC;

SELECT
    r.Job_Title,
    ROUND(AVG(f.ATS_Score),2) AS Avg_ATS,
    RANK() OVER(
        ORDER BY AVG(f.ATS_Score) DESC
    ) AS ATS_Rank
FROM Fact_Applications f
JOIN Dim_Role r
    ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title;

SELECT
    COUNT(*) AS Total_Applications,
    COUNT(DISTINCT Company_ID) AS Companies_Applied,
    COUNT(DISTINCT Country_ID) AS Countries_Targeted,
    ROUND(AVG(ATS_Score),2) AS Avg_ATS_Score,
    ROUND(AVG(Match_Score),2) AS Avg_Match_Score
FROM Fact_Applications;

# Applications by Country
SELECT
    c.Country,
    COUNT(*) AS Total_Applications
FROM Fact_Applications f
JOIN Dim_Country c
    ON f.Country_ID = c.Country_ID
GROUP BY c.Country
ORDER BY Total_Applications DESC;

#Applications by Platform
SELECT
    p.Platform_Name,
    COUNT(*) AS Total_Applications
FROM Fact_Applications f
JOIN Dim_Platform p
    ON f.Platform_ID = p.Platform_ID
GROUP BY p.Platform_Name
ORDER BY Total_Applications DESC;

#Resume Performance
SELECT
    r.Resume_Name,
    COUNT(*) AS Applications,
    ROUND(AVG(f.ATS_Score),2) AS Avg_ATS,
    ROUND(AVG(f.Match_Score),2) AS Avg_Match
FROM Fact_Applications f
JOIN Dim_Resume r
    ON f.Resume_ID = r.Resume_ID
GROUP BY r.Resume_Name
ORDER BY Avg_ATS DESC;

#Networking Effectiveness
SELECT
    SUM(HR_Email_Sent) AS HR_Emails,
    SUM(LinkedIn_DM_Sent) AS LinkedIn_DMs,
    SUM(Recruiter_Connection) AS Recruiter_Connections,
    SUM(Recruiter_Replied) AS Recruiter_Replies
FROM Fact_Outreach;

#Monthly Trend
SELECT
    YEAR(Date_Applied) AS Year_No,
    MONTH(Date_Applied) AS Month_No,
    COUNT(*) AS Applications
FROM Fact_Applications
GROUP BY
    YEAR(Date_Applied),
    MONTH(Date_Applied)
ORDER BY
    Year_No,
    Month_No;
    
    WITH MonthlyApplications AS
(
    SELECT
        MONTH(Date_Applied) AS Month_No,
        COUNT(*) AS Applications
    FROM Fact_Applications
    GROUP BY MONTH(Date_Applied)
)
SELECT *
FROM MonthlyApplications;

SELECT
    c.Country,
    COUNT(*) AS Applications,
    RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS Country_Rank
FROM Fact_Applications f
JOIN Dim_Country c
    ON f.Country_ID = c.Country_ID
GROUP BY c.Country;

#Application Funnel Conversion %
SELECT
    SUM(Applied) AS Applied,
    SUM(Viewed) AS Viewed,
    ROUND((SUM(Viewed) * 100.0 / SUM(Applied)),2) AS View_Rate,
    
    SUM(Shortlisted) AS Shortlisted,
    ROUND((SUM(Shortlisted) * 100.0 / SUM(Applied)),2) AS Shortlist_Rate,
    
    SUM(Interview) AS Interviews,
    ROUND((SUM(Interview) * 100.0 / SUM(Applied)),2) AS Interview_Rate,
    
    SUM(Offer) AS Offers,
    ROUND((SUM(Offer) * 100.0 / SUM(Applied)),2) AS Offer_Rate
FROM Fact_Applications;

#Top 5 Companies Applied To
SELECT
    c.Company_Name,
    COUNT(*) AS Applications
FROM Fact_Applications f
JOIN Dim_Company c
    ON f.Company_ID = c.Company_ID
GROUP BY c.Company_Name
ORDER BY Applications DESC
LIMIT 5;

#ATS Score Categories
SELECT
    CASE
        WHEN ATS_Score >= 85 THEN 'Excellent'
        WHEN ATS_Score >= 70 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS ATS_Category,
    COUNT(*) AS Applications
FROM Fact_Applications
GROUP BY ATS_Category;

#Best Performing Resume
SELECT
    r.Resume_Name,
    ROUND(AVG(f.ATS_Score),2) AS Avg_ATS,
    ROUND(AVG(f.Match_Score),2) AS Avg_Match
FROM Fact_Applications f
JOIN Dim_Resume r
    ON f.Resume_ID = r.Resume_ID
GROUP BY r.Resume_Name
ORDER BY Avg_ATS DESC
LIMIT 1;

#Country vs ATS Score
SELECT
    c.Country,
    COUNT(*) AS Applications,
    ROUND(AVG(f.ATS_Score),2) AS Avg_ATS
FROM Fact_Applications f
JOIN Dim_Country c
    ON f.Country_ID = c.Country_ID
GROUP BY c.Country
ORDER BY Avg_ATS DESC;

SELECT *
FROM Fact_Applications
WHERE ATS_Score >
(
    SELECT AVG(ATS_Score)
    FROM Fact_Applications
);

SELECT
    d.Company_Name,
    COUNT(*) AS Applications
FROM Fact_Applications f
JOIN Dim_Company d
ON f.Company_ID = d.Company_ID
GROUP BY d.Company_Name
ORDER BY Applications DESC;

SELECT
COUNT(*) AS Total_Applications,
COUNT(DISTINCT Company_ID) AS Total_Companies,
COUNT(DISTINCT Country_ID) AS Countries_Targeted,
ROUND(AVG(ATS_Score),2) AS Avg_ATS,
ROUND(AVG(Match_Score),2) AS Avg_Match
FROM Fact_Applications;

CREATE VIEW vw_ApplicationsByRole AS
SELECT
r.Job_Title,
COUNT(*) AS Total_Applications
FROM Fact_Applications f
JOIN Dim_Role r
ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title;

CREATE VIEW vw_ApplicationsByCountry AS
SELECT
c.Country,
COUNT(*) AS Total_Applications
FROM Fact_Applications f
JOIN Dim_Country c
ON f.Country_ID = c.Country_ID
GROUP BY c.Country;

CREATE VIEW vw_ResumePerformance AS
SELECT
r.Resume_Name,
COUNT(*) AS Applications,
ROUND(AVG(f.ATS_Score),2) AS Avg_ATS,
ROUND(AVG(f.Match_Score),2) AS Avg_Match
FROM Fact_Applications f
JOIN Dim_Resume r
ON f.Resume_ID = r.Resume_ID
GROUP BY r.Resume_Name;

SELECT
r.Job_Title,
COUNT(*) AS Applications
FROM Fact_Applications f
JOIN Dim_Role r
ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title
ORDER BY Applications DESC;

SELECT
r.Job_Title,
COUNT(*) AS Applications,
ROUND(AVG(f.ATS_Score),2) AS Avg_ATS,
ROUND(AVG(f.Match_Score),2) AS Avg_Match
FROM Fact_Applications f
JOIN Dim_Role r
ON f.Role_ID = r.Role_ID
GROUP BY r.Job_Title
ORDER BY Applications DESC;

SELECT
d.Company_Name,
COUNT(*) AS Applications
FROM Fact_Applications f
JOIN Dim_Company d
ON f.Company_ID = d.Company_ID
GROUP BY d.Company_Name
ORDER BY Applications DESC
LIMIT 15;