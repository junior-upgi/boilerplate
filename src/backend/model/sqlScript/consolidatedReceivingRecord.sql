SELECT
    CONVERT(CHAR(10),c.workingDate,126) AS 'workingDate'
    ,DATEPART(year,c.workingDate) AS workingYear
    ,DATEPART(month,c.workingDate) AS workingMonth
    ,DATEPART(day,c.workingDate) AS workingDay
    ,c.CUS_NO
    ,d.SNM AS CUST_SNM
    ,c.PRD_NO
    ,e.SNM AS PRDT_SNM
    ,c.requestWeight
    ,c.receivedWeight
FROM (
	-- 以每日資料集結
	SELECT
        f.CUS_NO
		,f.PRD_NO
		,f.workingDate
		,SUM(f.requestWeight) AS requestWeight
		,SUM(f.receivedWeight) AS receivedWeight
    FROM (
		-- 以客戶/原料列舉進貨車次以及未來排程列表
		SELECT
            a.CUS_NO
			,a.PRD_NO
			,CASE
				WHEN a.receivedDate IS NOT NULL THEN a.receivedDate
				ELSE a.requestDate
				END AS workingDate
			,a.requestWeight
			,CASE
				WHEN a.supplierWeight IS NULL AND a.actualWeight IS NULL THEN 0
				WHEN ISNULL(a.supplierWeight,0) <= ISNULL(a.actualWeight,0) THEN ISNULL(a.supplierWeight,0)
				WHEN ISNULL(a.supplierWeight,0) > ISNULL(a.actualWeight,0) THEN ISNULL(a.actualWeight,0)
				END AS receivedWeight
        FROM rawMaterial.dbo.shipment a
            INNER JOIN rawMaterial.dbo.purchaseOrder b ON a.pOId=b.id
        -- 僅篩選未取消、已下單並訂單仍有效之進貨記錄
        WHERE a.deprecated IS NULL AND a.pOId IS NOT NULL AND b.deprecated IS NULL) f
    GROUP BY f.CUS_NO, f.PRD_NO, f.workingDate) c
    INNER JOIN rawMaterial.dbo.CUST d ON c.CUS_NO=d.CUS_NO
    INNER JOIN rawMaterial.dbo.knownRawMatDetail e ON c.PRD_NO=e.PRD_NO;
