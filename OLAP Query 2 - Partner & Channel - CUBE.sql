/*Note - If implemented in OLAP enabled environment, the below queries would use ROLLUP or CUBE 
functions rather than unioned queries with different group by conditions.*/

    SELECT
          partner, 
          channel,
          count(*) as Total,
          SUM(converted) AS Converted,
          SUM(converted)/COUNT(*) AS ConversionRate,
          AVG(raw_score) as AvgRawScore
    FROM lead_view
    GROUP BY partner, channel

UNION

    SELECT 
          partner,
          "" AS channel, 
          count(*) as Total,
          SUM(converted) AS Converted, 
          SUM(converted)/COUNT(*) AS ConversionRate,
          AVG(raw_score) as AvgRawScore
    FROM lead_view
    GROUP BY partner

UNION

    SELECT 
          "" as partner,
          channel, 
          count(*) as Total,
          SUM(converted) AS Converted, 
          SUM(converted)/COUNT(*) AS ConversionRate,
          AVG(raw_score) as AvgRawScore
    FROM lead_view
    GROUP BY channel
    ;
