SELECT
    f.CUS_NO
    ,g.SNM AS CUST_SNM
    ,f.contractType
    ,f.workingYear
    ,f.workingMonth
    ,f.newRequestCount
FROM (
    SELECT
        e.CUS_NO
        ,e.contractType
        ,e.workingYear
        ,e.workingMonth
        ,COUNT(*) AS newRequestCount
    FROM (
        SELECT
            d.CUS_NO
            ,d.contractType
            ,CASE
                WHEN d.contractType='annual' THEN DATEPART(year,d.workingDate)
                WHEN d.contractType='monthly' THEN DATEPART(year,d.workingDate)
                ELSE NULL
                END AS workingYear
            ,CASE
                WHEN d.contractType='annual' THEN NULL
                WHEN d.contractType='monthly' THEN DATEPART(month,d.workingDate)
                ELSE NULL
                END AS workingMonth
        FROM (
            SELECT
                a.CUS_NO
                ,b.contractType
                ,CASE
                    WHEN a.receivedDate IS NULL THEN CONVERT(CHAR(10),a.requestDate,126)
                    ELSE CONVERT(CHAR(10),a.receivedDate,126)
                    END AS 'workingDate'
            FROM rawMaterial.dbo.shipment a
                LEFT JOIN rawMaterial.dbo.supplier b ON a.CUS_NO=b.CUS_NO
            WHERE a.pOId IS NULL AND a.deprecated IS NULL AND a.receivedDate IS NULL) d) e
    GROUP BY e.CUS_NO,e.contractType,e.workingYear,e.workingMonth) f
    LEFT JOIN rawMaterial.dbo.CUST g ON f.CUS_NO=g.CUS_NO;

