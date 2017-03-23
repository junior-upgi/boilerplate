SELECT
    a.workingYear
	,a.workingMonth
	,a.CUS_NO
	,c.SNM AS CUST_SNM
	,a.PRD_NO
	,d.SNM AS PRDT_SNM
	,a.totalRequestWeight
	,IFNULL(b.totalReceivedWeight,0) AS totalReceivedWeight
	,a.shipmentCount
	,IFNULL(b.receivedCount,0) AS receivedCount
FROM (
	SELECT workingYear ,workingMonth ,CUS_NO ,PRD_NO ,SUM(requestWeight) AS totalRequestWeight ,COUNT(*) AS shipmentCount
    FROM rawMaterial.dbo.receivingRecord
    GROUP BY workingYear,workingMonth,CUS_NO,PRD_NO) a
    LEFT JOIN (
	SELECT workingYear ,workingMonth ,CUS_NO ,PRD_NO ,SUM(receivedWeight) AS totalReceivedWeight ,COUNT(*) AS receivedCount
    FROM rawMaterial.dbo.receivingRecord
    WHERE receivedWeight > 0
    GROUP BY workingYear,workingMonth,CUS_NO,PRD_NO) b ON a.workingYear=b.workingYear AND a.workingMonth=b.workingMonth AND a.CUS_NO=b.CUS_NO AND a.PRD_NO=b.PRD_NO
    INNER JOIN rawMaterial.dbo.CUST c ON a.CUS_NO=c.CUS_NO
    INNER JOIN rawMaterial.dbo.knownRawMatDetail d ON a.PRD_NO=d.PRD_NO;
