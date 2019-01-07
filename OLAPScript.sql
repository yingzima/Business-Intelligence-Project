SELECT 
lead_status,
	lead_sub_status,
	ROUND(AVG(raw_score),2) AS AvgRawScore,
	COUNT(*) AS NumberOfLeads,
       	SUM(AssignedToAgent) AS NumberAssigned,
       	ROUND(SUM(AssignedToAgent) / count(*),3) AS RateAssigned
FROM lead_view
GROUP BY  
	lead_status,
	Lead_sub_status

UNION

SELECT 
	lead_status,
	null AS lead_sub_status,
	ROUND(AVG(raw_score),2) AS AvgRawScore,
	COUNT(*) AS NumberOfLeads,
   	SUM(AssignedToAgent) AS NumberAssigned,
    	SUM(AssignedToAgent) / count(*) AS RateAssigned
FROM lead_view
GROUP BY  lead_status;
