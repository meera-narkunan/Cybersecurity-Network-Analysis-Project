
--Most Frequent Types of Network Attacks

SELECT 
    CAST([Timestamp] AS DATE) AS AttackDate,
    Label,
    COUNT(*) AS AttackCount
FROM TrafficLabelling
WHERE Label <> 'Benign'
GROUP BY CAST([Timestamp] AS DATE), Label
ORDER BY AttackCount DESC;

--Top Source IPs Responsible for Attacks

SELECT
    CAST([Timestamp] AS DATE) AS AttackDate,
    [Source IP],
    Label,
    COUNT(*) AS AttackFlows
FROM TrafficLabelling
WHERE Label <> 'Benign'
GROUP BY CAST([Timestamp] AS DATE), [Source IP], Label
ORDER BY AttackFlows DESC;

--Targeted Ports

SELECT
    CAST([Timestamp] AS DATE) AS AttackDate,
    [Destination Port],
    Label,
    COUNT(*) AS AttackCount
FROM TrafficLabelling
WHERE Label <> 'Benign'
GROUP BY CAST([Timestamp] AS DATE), [Destination Port], Label
ORDER BY AttackCount DESC;

--Attack Timeline (per day & hour)

SELECT
    CAST([Timestamp] AS DATE) AS AttackDate,
    DATEPART(HOUR, [Timestamp]) AS AttackHour,
    Label,
    COUNT(*) AS AttackCount
FROM TrafficLabelling
WHERE Label <> 'Benign'
GROUP BY CAST([Timestamp] AS DATE), DATEPART(HOUR, [Timestamp]), Label
ORDER BY AttackDate, AttackHour;

--Benign vs Attack Traffic Characterisitcs

SELECT
    CASE 
        WHEN Label = 'BENIGN' THEN 'BENIGN'
        ELSE 'ATTACK'
    END AS TrafficType,
    AVG([Flow Duration]) AS AvgDuration,
    AVG([Packet Length Mean]) AS AvgPktLen,
    AVG([Total Fwd Packets] + [Total Backward Packets]) AS AvgTotalPackets,
    AVG(TRY_CAST([Flow Bytes/s] AS FLOAT)) AS AvgBytesPerSec,
    AVG(TRY_CAST([Flow Packets/s] AS FLOAT)) AS AvgPacketsPerSec
FROM TrafficLabelling
GROUP BY
    CASE 
        WHEN Label = 'BENIGN' THEN 'BENIGN'
        ELSE 'ATTACK'
    END;
